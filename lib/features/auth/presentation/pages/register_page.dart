import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/location/device_location_service.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/registration_request.dart';
import '../widgets/auth_widgets.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _accountFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _entityName = TextEditingController();
  final _registrationNumber = TextEditingController();
  final _city = TextEditingController();
  final _area = TextEditingController();
  final _address = TextEditingController();
  final _description = TextEditingController();

  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  final _minimumOrderAmount = TextEditingController(text: '0');
  final _deliveryFee = TextEditingController(text: '0');

  RegistrationType _type = RegistrationType.user;
  int _step = 0;
  bool _showPassword = false;
  bool _hasDeliveryService = false;
  String? _coordinateError;

  bool get _isBusiness => _type != RegistrationType.user;

  String get _pageTitle => switch (_step) {
        0 => AppLocalizations.of(context).registerTypeAccount,
        1 => AppLocalizations.of(context).registerAccountData,
        _ => switch (_type) {
            RegistrationType.pharmacy =>
              AppLocalizations.of(context).registerPharmacyData,
            RegistrationType.organization =>
              AppLocalizations.of(context).registerOrganizationData,
            RegistrationType.warehouse =>
              AppLocalizations.of(context).registerWarehouseData,
            RegistrationType.user =>
              AppLocalizations.of(context).registerAccountData,
          },
      };

  String get _pageSubtitle => switch (_step) {
        0 => AppLocalizations.of(context).registerTypeSubtitle,
        1 => AppLocalizations.of(context).registerAccountSubtitle,
        _ => AppLocalizations.of(context).registerEntitySubtitle,
      };

  @override
  void dispose() {
    for (final c in [
      _fullName,
      _phoneNumber,
      _email,
      _password,
      _confirmPassword,
      _entityName,
      _registrationNumber,
      _city,
      _area,
      _address,
      _description,
      _latitude,
      _longitude,
      _minimumOrderAmount,
      _deliveryFee,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectType(RegistrationType type) {
    if (_type == type) return;
    ref.read(authControllerProvider.notifier).clearError();
    setState(() {
      _type = type;
      _coordinateError = null;
    });
  }

  void _continueFromType() {
    ref.read(authControllerProvider.notifier).clearError();
    setState(() => _step = 1);
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (!(_accountFormKey.currentState?.validate() ?? false)) return;
    if (_isBusiness) {
      setState(() => _step = 2);
      return;
    }
    _submit();
  }

  void _goBack() {
    ref.read(authControllerProvider.notifier).clearError();
    if (_step > 0) {
      setState(() => _step--);
      return;
    }
    context.go('/login');
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    ref.read(authControllerProvider.notifier).clearError();

    if (!_isBusiness) {
      if (!(_accountFormKey.currentState?.validate() ?? false)) return;
    }
    if (_isBusiness) {
      if (!(_businessFormKey.currentState?.validate() ?? false)) return;
    }

    (double?, double?)? coordinates;
    if (_type == RegistrationType.pharmacy) {
      coordinates = _readCoordinates();
      if (coordinates == null) return;
    }

    final request = RegistrationRequest(
      type: _type,
      fullName: _fullName.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      phoneNumber: _phoneNumber.text.trim(),
      entityName: _isBusiness ? _entityName.text.trim() : null,
      registrationNumber:
          _isBusiness ? _registrationNumber.text.trim() : null,
      city: _isBusiness ? _city.text.trim() : null,
      area: _isBusiness ? _area.text.trim() : null,
      address: _isBusiness ? _address.text.trim() : null,
      description: _isBusiness ? _description.text.trim() : null,
      hasDeliveryService:
          _type == RegistrationType.pharmacy && _hasDeliveryService,
      latitude: coordinates?.$1,
      longitude: coordinates?.$2,
      minimumOrderAmount: _type == RegistrationType.warehouse
          ? double.tryParse(
                  _minimumOrderAmount.text.trim().replaceAll(',', '.')) ??
              0
          : 0,
      deliveryFee: _type == RegistrationType.warehouse
          ? double.tryParse(
                  _deliveryFee.text.trim().replaceAll(',', '.')) ??
              0
          : 0,
    );

    await ref.read(authControllerProvider.notifier).register(request);
  }

  (double?, double?)? _readCoordinates() {
    final latText = _latitude.text.trim().replaceAll(',', '.');
    final lngText = _longitude.text.trim().replaceAll(',', '.');

    if (latText.isEmpty && lngText.isEmpty) {
      setState(() => _coordinateError = null);
      return (null, null);
    }

    if (latText.isEmpty || lngText.isEmpty) {
      setState(() => _coordinateError =
          AppLocalizations.of(context).registerCoordsTogether);
      return null;
    }

    final lat = double.tryParse(latText);
    final lng = double.tryParse(lngText);

    if (lat == null ||
        lng == null ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      setState(
          () => _coordinateError =
              AppLocalizations.of(context).registerCoordsInvalid);
      return null;
    }

    setState(() => _coordinateError = null);
    return (lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final colors = context.appColors;

    final errorMessage = authState.hasError
        ? authState.error is ApiException
            ? (authState.error! as ApiException).message
            : AppLocalizations.of(context).registerFailed
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(
                onBack: _goBack,
                isLoading: authState.isLoading,
                title: _pageTitle,
                subtitle: _pageSubtitle,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: switch (_step) {
                    0 => _AccountTypeStep(
                        key: const ValueKey('type'),
                        selected: _type,
                        onChanged: _selectType,
                      ),
                    1 => _AccountStep(
                        key: const ValueKey('account'),
                        formKey: _accountFormKey,
                        fullName: _fullName,
                        phoneNumber: _phoneNumber,
                        email: _email,
                        password: _password,
                        confirmPassword: _confirmPassword,
                        showPassword: _showPassword,
                        onTogglePassword: () =>
                            setState(() => _showPassword = !_showPassword),
                        isBusiness: _isBusiness,
                      ),
                    _ => _BusinessStep(
                        key: const ValueKey('business'),
                        formKey: _businessFormKey,
                        type: _type,
                        entityName: _entityName,
                        registrationNumber: _registrationNumber,
                        city: _city,
                        area: _area,
                        address: _address,
                        description: _description,
                        latitude: _latitude,
                        longitude: _longitude,
                        minimumOrderAmount: _minimumOrderAmount,
                        deliveryFee: _deliveryFee,
                        hasDeliveryService: _hasDeliveryService,
                        coordinateError: _coordinateError,
                        onDeliveryChanged: (v) =>
                            setState(() => _hasDeliveryService = v),
                      ),
                  },
                ),
              ),
              _BottomActionArea(
                step: _step,
                isBusiness: _isBusiness,
                isLoading: authState.isLoading,
                errorMessage: errorMessage,
                onPrimary: switch (_step) {
                  0 => _continueFromType,
                  1 => _continue,
                  _ => _submit,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.title,
    required this.subtitle,
    this.isLoading = false,
  });

  final VoidCallback onBack;
  final String title;
  final String subtitle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: isLoading ? null : onBack,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.text,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              title,
              key: ValueKey(title),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.text,
                    fontSize: 26,
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textMuted,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeStep extends StatelessWidget {
  const _AccountTypeStep({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final RegistrationType selected;
  final ValueChanged<RegistrationType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        Text(
          l10n.registerIntro,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textMuted,
                fontSize: 14,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 22),
        IntrinsicHeight(
          child: Column(
            children: [
              _TypeCard(
                selected: selected == RegistrationType.user,
                icon: Icons.person_outline_rounded,
                label: l10n.registerTypeUser,
                description: l10n.registerTypeUserDesc,
                onTap: () => onChanged(RegistrationType.user),
              ),
              const SizedBox(height: 14),
              _TypeCard(
                selected: selected == RegistrationType.pharmacy,
                icon: Icons.local_pharmacy_outlined,
                label: l10n.registerTypePharmacy,
                description: l10n.registerTypePharmacyDesc,
                onTap: () => onChanged(RegistrationType.pharmacy),
              ),
              const SizedBox(height: 14),
              _TypeCard(
                selected: selected == RegistrationType.organization,
                icon: Icons.apartment_outlined,
                label: l10n.registerTypeOrganization,
                description: l10n.registerTypeOrganizationDesc,
                onTap: () => onChanged(RegistrationType.organization),
              ),
              const SizedBox(height: 14),
              _TypeCard(
                selected: selected == RegistrationType.warehouse,
                icon: Icons.warehouse_outlined,
                label: l10n.registerTypeWarehouse,
                description: l10n.registerTypeWarehouseDesc,
                onTap: () => onChanged(RegistrationType.warehouse),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.selected,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            decoration: BoxDecoration(
              color: selected
                  ? colors.primary.withValues(alpha: 0.05)
                  : colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? colors.primary : colors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: colors.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? colors.primary : Colors.transparent,
                    border: Border.all(
                      color: selected ? colors.primary : colors.border,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountStep extends StatelessWidget {
  const _AccountStep({
    required this.formKey,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.showPassword,
    required this.onTogglePassword,
    required this.isBusiness,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullName;
  final TextEditingController phoneNumber;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final bool showPassword;
  final VoidCallback onTogglePassword;
  final bool isBusiness;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          Text(
            l10n.registerAccountInfo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: l10n.registerFullName,
            hint: l10n.registerFullNameHint,
            controller: fullName,
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            validator: _required(l10n.registerFullNameRequired),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: isBusiness
                ? l10n.registerPhoneLabel
                : l10n.registerPhoneOptionalLabel,
            hint: '+963 ...',
            controller: phoneNumber,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
            ],
            validator:
                isBusiness ? _required(l10n.registerPhoneRequired) : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.registerEmailLabel,
            hint: 'name@example.com',
            controller: email,
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty ||
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(v)) {
                return l10n.registerEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.registerPasswordLabel,
            controller: password,
            icon: Icons.lock_outline_rounded,
            obscureText: !showPassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
            ),
            validator: (value) {
              final t = value ?? '';
              if (t.length < 8 ||
                  !RegExp('[A-Z]').hasMatch(t) ||
                  !RegExp('[a-z]').hasMatch(t) ||
                  !RegExp(r'\d').hasMatch(t) ||
                  !RegExp(r'[^a-zA-Z0-9]').hasMatch(t)) {
                return l10n.registerPasswordHint;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.registerConfirmPasswordLabel,
            controller: confirmPassword,
            icon: Icons.lock_reset_rounded,
            obscureText: !showPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) {
              if (value != password.text) {
                return l10n.registerPasswordsMismatch;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Text(
            l10n.registerAccountHelp,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BusinessStep extends ConsumerStatefulWidget {
  const _BusinessStep({
    required this.formKey,
    required this.type,
    required this.entityName,
    required this.registrationNumber,
    required this.city,
    required this.area,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.minimumOrderAmount,
    required this.deliveryFee,
    required this.hasDeliveryService,
    required this.coordinateError,
    required this.onDeliveryChanged,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final RegistrationType type;
  final TextEditingController entityName;
  final TextEditingController registrationNumber;
  final TextEditingController city;
  final TextEditingController area;
  final TextEditingController address;
  final TextEditingController description;
  final TextEditingController latitude;
  final TextEditingController longitude;
  final TextEditingController minimumOrderAmount;
  final TextEditingController deliveryFee;
  final bool hasDeliveryService;
  final String? coordinateError;
  final ValueChanged<bool> onDeliveryChanged;

  @override
  ConsumerState<_BusinessStep> createState() => _BusinessStepState();
}

class _BusinessStepState extends ConsumerState<_BusinessStep> {
  bool _fetchingLocation = false;

  bool get isPharmacy => widget.type == RegistrationType.pharmacy;
  bool get isWarehouse => widget.type == RegistrationType.warehouse;

  String get _entityNameLabel => isPharmacy
      ? AppLocalizations.of(context).registerPharmacyName
      : isWarehouse
          ? AppLocalizations.of(context).registerWarehouseName
          : AppLocalizations.of(context).registerOrgName;

  String get _licenseLabel =>
      isPharmacy || isWarehouse
          ? AppLocalizations.of(context).registerLicenseNumber
          : AppLocalizations.of(context).registerRegNumber;

  String get _entityHint => isPharmacy
      ? AppLocalizations.of(context).registerPharmacyNameHint
      : isWarehouse
          ? AppLocalizations.of(context).registerWarehouseNameHint
          : AppLocalizations.of(context).registerOrgNameHint;

  String get _licenseHint => isPharmacy || isWarehouse
      ? AppLocalizations.of(context).registerLicenseHint
      : AppLocalizations.of(context).registerRegNumberHint;

  String get _entityWord => isPharmacy
      ? AppLocalizations.of(context).registerPharmacyWord
      : isWarehouse
          ? AppLocalizations.of(context).registerWarehouseWord
          : AppLocalizations.of(context).registerOrgWord;

  IconData get _entityIcon => isPharmacy
      ? Icons.local_pharmacy_outlined
      : isWarehouse
          ? Icons.warehouse_outlined
          : Icons.apartment_outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);

    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          Text(
            l10n.registerBusinessIntro(_entityWord),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: _entityNameLabel,
            controller: widget.entityName,
            icon: _entityIcon,
            textInputAction: TextInputAction.next,
            validator: _required(_entityHint),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: _licenseLabel,
            controller: widget.registrationNumber,
            icon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            validator: _required(_licenseHint),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: l10n.registerCity,
                  controller: widget.city,
                  icon: Icons.location_city_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required(l10n.registerCityRequired),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: l10n.registerArea,
                  controller: widget.area,
                  icon: Icons.map_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required(l10n.registerAreaRequired),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.registerAddress,
            controller: widget.address,
            icon: Icons.location_on_outlined,
            textInputAction: TextInputAction.next,
            validator: _required(l10n.registerAddressRequired),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.registerDescription,
            controller: widget.description,
            icon: Icons.notes_rounded,
            maxLines: 3,
            minLines: 3,
            textInputAction: TextInputAction.newline,
          ),
          if (isPharmacy) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
              ),
              child: SwitchListTile(
                value: widget.hasDeliveryService,
                onChanged: widget.onDeliveryChanged,
                activeThumbColor: colors.primary,
                secondary: Icon(
                  Icons.delivery_dining_rounded,
                  color: colors.primary,
                ),
                title: Text(
                  l10n.registerDeliveryService,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(l10n.registerDeliveryServiceSub),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.registerLocationTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.registerLocationHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.registerLatitude,
                    hint: '33.5138',
                    controller: widget.latitude,
                    icon: Icons.north_rounded,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: l10n.registerLongitude,
                    hint: '36.2765',
                    controller: widget.longitude,
                    icon: Icons.east_rounded,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _fetchingLocation ? null : _fetchCurrentLocation,
                icon: _fetchingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded, size: 18),
                label: Text(_fetchingLocation ? l10n.registerLocating : l10n.registerLocateAuto),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
                  foregroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (widget.coordinateError != null) ...[
              const SizedBox(height: 10),
              Text(
                widget.coordinateError!,
                style: TextStyle(
                  color: colors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
          if (isWarehouse) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.registerMinOrder,
                    controller: widget.minimumOrderAmount,
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegativeNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: l10n.registerDeliveryFee,
                    controller: widget.deliveryFee,
                    icon: Icons.local_shipping_outlined,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegativeNumber,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _fetchingLocation = true);
    try {
      final location = ref.read(deviceLocationServiceProvider);
      final result = await location.determineCurrent();
      widget.latitude.text = result.latitude.toStringAsFixed(6);
      widget.longitude.text = result.longitude.toStringAsFixed(6);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).registerLocationFailed),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _fetchingLocation = false);
    }
  }

  String? _nonNegativeNumber(String? value) {
    final number = double.tryParse(
      value?.trim().replaceAll(',', '.') ?? '',
    );
    if (number == null || number < 0) {
      return AppLocalizations.of(context).registerInvalidValue;
    }
    return null;
  }
}

class _BottomActionArea extends StatelessWidget {
  const _BottomActionArea({
    required this.step,
    required this.isBusiness,
    required this.isLoading,
    required this.errorMessage,
    required this.onPrimary,
  });

  final int step;
  final bool isBusiness;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            ErrorBanner(message: errorMessage!),
            const SizedBox(height: 12),
          ],
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isLoading ? null : onPrimary,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      step == 0 || (step == 1 && isBusiness)
                          ? l10n.continueAction
                          : l10n.registerCreate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

String? Function(String?) _required(String message) {
  return (value) => value?.trim().isEmpty ?? true ? message : null;
}
