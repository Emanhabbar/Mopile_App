import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/registration_request.dart';
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

  @override
  void dispose() {
    for (final controller in [
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
      controller.dispose();
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
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_accountFormKey.currentState?.validate() ?? false)) {
      setState(() => _step = 1);
      return;
    }
    if (_isBusiness && !(_businessFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final coordinates = _readCoordinates();
    if (_type == RegistrationType.pharmacy && coordinates == null) return;

    final request = RegistrationRequest(
      type: _type,
      fullName: _fullName.text,
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      phoneNumber: _phoneNumber.text,
      entityName: _isBusiness ? _entityName.text : null,
      registrationNumber: _isBusiness ? _registrationNumber.text : null,
      city: _isBusiness ? _city.text : null,
      area: _isBusiness ? _area.text : null,
      address: _isBusiness ? _address.text : null,
      description: _isBusiness ? _description.text : null,
      hasDeliveryService: _hasDeliveryService,
      latitude: coordinates?.$1,
      longitude: coordinates?.$2,
      minimumOrderAmount: double.tryParse(_minimumOrderAmount.text.trim()) ?? 0,
      deliveryFee: double.tryParse(_deliveryFee.text.trim()) ?? 0,
    );
    await ref.read(authControllerProvider.notifier).register(request);
  }

  (double?, double?)? _readCoordinates() {
    final latitudeText = _latitude.text.trim().replaceAll(',', '.');
    final longitudeText = _longitude.text.trim().replaceAll(',', '.');

    if (latitudeText.isEmpty && longitudeText.isEmpty) {
      setState(() => _coordinateError = null);
      return (null, null);
    }
    if (latitudeText.isEmpty || longitudeText.isEmpty) {
      setState(() => _coordinateError = 'أدخل خط العرض وخط الطول معًا.');
      return null;
    }

    final latitude = double.tryParse(latitudeText);
    final longitude = double.tryParse(longitudeText);
    if (latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      setState(() => _coordinateError = 'تحقق من قيم الإحداثيات المدخلة.');
      return null;
    }
    setState(() => _coordinateError = null);
    return (latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final errorMessage = authState.hasError
        ? authState.error is ApiException
              ? (authState.error! as ApiException).message
              : 'تعذر إنشاء الحساب حاليًا.'
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: authState.isLoading
              ? null
              : () {
                  if (_step > 0) {
                    setState(() => _step--);
                  } else {
                    ref.read(authControllerProvider.notifier).clearError();
                    context.go('/login');
                  }
                },
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'رجوع',
        ),
        title: const AppBrand(compact: true),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                _RegistrationProgress(
                  currentStep: _step,
                  totalSteps: _isBusiness ? 3 : 2,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
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
                        onDeliveryChanged: (value) =>
                            setState(() => _hasDeliveryService = value),
                      ),
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (errorMessage != null) ...[
                        _InlineError(message: errorMessage),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          if (_step > 0) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () => setState(() => _step--),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text('السابق'),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : switch (_step) {
                                      0 => _continueFromType,
                                      1 => _continue,
                                      _ => _submit,
                                    },
                              child: authState.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _step == 0 || (_step == 1 && _isBusiness)
                                          ? 'متابعة'
                                          : 'إنشاء الحساب',
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationProgress extends StatelessWidget {
  const _RegistrationProgress({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final active = index <= currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              height: 5,
              margin: EdgeInsetsDirectional.only(
                end: index == totalSteps - 1 ? 0 : 7,
              ),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 52,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'اختر نوع الحساب',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontSize: 27),
        ),
        const SizedBox(height: 7),
        Text(
          'لكل حساب مساحة عمل وخدمات مصممة حسب احتياجاته.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 26),
        _AccountTypeSelector(selected: selected, onChanged: onChanged),
      ],
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
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Text(
            'بيانات الحساب',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 7),
          Text(
            'أدخل معلومات صحيحة لنجهز حسابك بالشكل المناسب.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 26),
          AppTextField(
            label: 'الاسم الكامل',
            hint: 'الاسم كما يظهر في الحساب',
            controller: fullName,
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            validator: _required('أدخل الاسم الكامل.'),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: isBusiness ? 'رقم الهاتف' : 'رقم الهاتف (اختياري)',
            hint: '+963 ...',
            controller: phoneNumber,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            validator: isBusiness ? _required('أدخل رقم الهاتف.') : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'البريد الإلكتروني',
            hint: 'name@example.com',
            controller: email,
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              final emailValue = value?.trim() ?? '';
              if (emailValue.isEmpty ||
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(emailValue)) {
                return 'أدخل بريدًا إلكترونيًا صحيحًا.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'كلمة المرور',
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
              ),
            ),
            validator: (value) {
              final text = value ?? '';
              if (text.length < 8 ||
                  !RegExp('[A-Z]').hasMatch(text) ||
                  !RegExp('[a-z]').hasMatch(text) ||
                  !RegExp(r'\d').hasMatch(text) ||
                  !RegExp(r'[^a-zA-Z0-9]').hasMatch(text)) {
                return 'استخدم 8 محارف مع حرف كبير وصغير ورقم ورمز.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'تأكيد كلمة المرور',
            controller: confirmPassword,
            icon: Icons.lock_reset_rounded,
            obscureText: !showPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) {
              if (value != password.text) {
                return 'كلمتا المرور غير متطابقتين.';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Text(
            'تساعد بيانات الحساب الصحيحة في تقديم تجربة مناسبة وآمنة.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _BusinessStep extends StatelessWidget {
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

  bool get isPharmacy => type == RegistrationType.pharmacy;
  bool get isWarehouse => type == RegistrationType.warehouse;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isPharmacy
                      ? Icons.local_pharmacy_rounded
                      : isWarehouse
                      ? Icons.warehouse_outlined
                      : Icons.apartment_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPharmacy
                          ? 'بيانات الصيدلية'
                          : isWarehouse
                          ? 'بيانات المستودع'
                          : 'بيانات المنظمة',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'تُراجع البيانات قبل تفعيل خدمات الحساب.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          AppTextField(
            label: isPharmacy
                ? 'اسم الصيدلية'
                : isWarehouse
                ? 'اسم المستودع'
                : 'اسم المنظمة',
            controller: entityName,
            icon: isPharmacy
                ? Icons.local_pharmacy_outlined
                : isWarehouse
                ? Icons.warehouse_outlined
                : Icons.apartment_outlined,
            textInputAction: TextInputAction.next,
            validator: _required(
              isPharmacy
                  ? 'أدخل اسم الصيدلية.'
                  : isWarehouse
                  ? 'أدخل اسم المستودع.'
                  : 'أدخل اسم المنظمة.',
            ),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: isPharmacy || isWarehouse ? 'رقم الترخيص' : 'رقم التسجيل',
            controller: registrationNumber,
            icon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            validator: _required(
              isPharmacy || isWarehouse
                  ? 'أدخل رقم الترخيص.'
                  : 'أدخل رقم التسجيل.',
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'المدينة',
                  controller: city,
                  icon: Icons.location_city_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required('أدخل المدينة.'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: 'المنطقة',
                  controller: area,
                  icon: Icons.map_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required('أدخل المنطقة.'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'العنوان',
            controller: address,
            icon: Icons.location_on_outlined,
            textInputAction: TextInputAction.next,
            validator: _required('أدخل العنوان.'),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'وصف مختصر (اختياري)',
            controller: description,
            icon: Icons.notes_rounded,
            maxLines: 3,
            minLines: 3,
            textInputAction: TextInputAction.newline,
          ),
          if (isPharmacy) ...[
            const SizedBox(height: 18),
            Card(
              child: SwitchListTile(
                value: hasDeliveryService,
                onChanged: onDeliveryChanged,
                secondary: const Icon(Icons.delivery_dining_rounded),
                title: const Text('خدمة توصيل'),
                subtitle: const Text('حددها إذا كانت الصيدلية توفر التوصيل'),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'موقع الصيدلية (اختياري)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'يمكن حفظ الموقع الآن أو إضافته لاحقًا من ملف الصيدلية.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 13),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'خط العرض',
                    hint: '33.5138',
                    controller: latitude,
                    icon: Icons.north_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'خط الطول',
                    hint: '36.2765',
                    controller: longitude,
                    icon: Icons.east_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            if (coordinateError != null) ...[
              const SizedBox(height: 10),
              Text(
                coordinateError!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
          if (isWarehouse) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'الحد الأدنى للطلب',
                    controller: minimumOrderAmount,
                    icon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _nonNegativeNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'رسوم التوصيل',
                    controller: deliveryFee,
                    icon: Icons.local_shipping_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
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
}

class _AccountTypeSelector extends StatelessWidget {
  const _AccountTypeSelector({required this.selected, required this.onChanged});

  final RegistrationType selected;
  final ValueChanged<RegistrationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeCard(
          selected: selected == RegistrationType.user,
          icon: Icons.person_outline_rounded,
          label: 'مستخدم',
          description: 'ابحث عن دوائك وتابع طلباتك ومعلوماتك الصحية.',
          onTap: () => onChanged(RegistrationType.user),
        ),
        const SizedBox(height: 13),
        _TypeCard(
          selected: selected == RegistrationType.pharmacy,
          icon: Icons.local_pharmacy_outlined,
          label: 'صيدلية',
          description: 'أدر المخزون وساعات العمل وطلبات المستخدمين.',
          onTap: () => onChanged(RegistrationType.pharmacy),
        ),
        const SizedBox(height: 13),
        _TypeCard(
          selected: selected == RegistrationType.organization,
          icon: Icons.apartment_outlined,
          label: 'منظمة',
          description: 'نظّم الحملات واستقبل عروض التبرع وطلبات المساعدة.',
          onTap: () => onChanged(RegistrationType.organization),
        ),
        const SizedBox(height: 13),
        _TypeCard(
          selected: selected == RegistrationType.warehouse,
          icon: Icons.warehouse_outlined,
          label: 'مستودع أدوية',
          description: 'أدر التشغيلات وطلبات الصيدليات والشحن والفواتير.',
          onTap: () => onChanged(RegistrationType.warehouse),
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
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: 17,
              vertical: selected ? 20 : 16,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryDeep : AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected ? AppColors.primaryDeep : AppColors.border,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 11),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: selected ? 58 : 52,
                  height: selected ? 58 : 52,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.secondary
                        : AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? AppColors.primaryDeep : AppColors.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selected ? Colors.white : AppColors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.68)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.secondary : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.secondary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 17,
                          color: AppColors.primaryDeep,
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

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? Function(String?) _required(String message) {
  return (value) => (value?.trim().isEmpty ?? true) ? message : null;
}

String? _nonNegativeNumber(String? value) {
  final number = double.tryParse(value?.trim() ?? '');
  return number == null || number < 0 ? 'أدخل قيمة صحيحة.' : null;
}
