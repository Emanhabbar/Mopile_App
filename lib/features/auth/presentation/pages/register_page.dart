import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../data/models/registration_request.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  static const String _logoPath =
      'assets/brand/dawaai-icon-foreground.png';

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

  String get _pageTitle {
    if (_step == 0) {
      return 'اختر نوع الحساب';
    }

    if (_step == 1) {
      return 'بيانات الحساب';
    }

    switch (_type) {
      case RegistrationType.pharmacy:
        return 'بيانات الصيدلية';

      case RegistrationType.organization:
        return 'بيانات المنظمة';

      case RegistrationType.warehouse:
        return 'بيانات المستودع';

      case RegistrationType.user:
        return 'بيانات الحساب';
    }
  }

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
    if (_type == type) {
      return;
    }

    ref.read(authControllerProvider.notifier).clearError();

    setState(() {
      _type = type;
      _coordinateError = null;
    });
  }

  void _continueFromType() {
    ref.read(authControllerProvider.notifier).clearError();

    setState(() {
      _step = 1;
    });
  }

  void _continue() {
    FocusScope.of(context).unfocus();

    final isAccountValid =
        _accountFormKey.currentState?.validate() ?? false;

    if (!isAccountValid) {
      return;
    }

    if (_isBusiness) {
      setState(() {
        _step = 2;
      });

      return;
    }

    _submit();
  }

  void _goBack() {
    ref.read(authControllerProvider.notifier).clearError();

    if (_step > 0) {
      setState(() {
        _step--;
      });

      return;
    }

    context.go('/login');
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    ref.read(authControllerProvider.notifier).clearError();

    if (!_isBusiness) {
      final isAccountValid =
          _accountFormKey.currentState?.validate() ?? false;

      if (!isAccountValid) {
        return;
      }
    }

    if (_isBusiness) {
      final isBusinessValid =
          _businessFormKey.currentState?.validate() ?? false;

      if (!isBusinessValid) {
        return;
      }
    }

    (double?, double?)? coordinates;

    if (_type == RegistrationType.pharmacy) {
      coordinates = _readCoordinates();

      if (coordinates == null) {
        return;
      }
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
                _minimumOrderAmount.text
                    .trim()
                    .replaceAll(',', '.'),
              ) ??
              0
          : 0,
      deliveryFee: _type == RegistrationType.warehouse
          ? double.tryParse(
                _deliveryFee.text
                    .trim()
                    .replaceAll(',', '.'),
              ) ??
              0
          : 0,
    );

    await ref
        .read(authControllerProvider.notifier)
        .register(request);
  }

  (double?, double?)? _readCoordinates() {
    final latitudeText =
        _latitude.text.trim().replaceAll(',', '.');

    final longitudeText =
        _longitude.text.trim().replaceAll(',', '.');

    if (latitudeText.isEmpty && longitudeText.isEmpty) {
      setState(() {
        _coordinateError = null;
      });

      return (null, null);
    }

    if (latitudeText.isEmpty || longitudeText.isEmpty) {
      setState(() {
        _coordinateError = 'أدخل خط العرض وخط الطول معًا.';
      });

      return null;
    }

    final latitude = double.tryParse(latitudeText);
    final longitude = double.tryParse(longitudeText);

    final invalidCoordinates =
        latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180;

    if (invalidCoordinates) {
      setState(() {
        _coordinateError = 'تحقق من قيم الإحداثيات المدخلة.';
      });

      return null;
    }

    setState(() {
      _coordinateError = null;
    });

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9F9),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 95,
          titleSpacing: 0,
          title: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 95,
            ),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: 0,
                  child: Material(
                    color: const Color(0xFFF4F9F9),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: authState.isLoading ? null : _goBack,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFD4E2E4),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF153F45),
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: SizedBox(
                    width: 60,
                    height: 48,
                    child: Image.asset(
                      _logoPath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.local_pharmacy_rounded,
                          color: Color(0xFF076A73),
                          size: 42,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        child: Text(
                          _pageTitle,
                          key: ValueKey(_pageTitle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF153F45),
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _step == 0
                            ? 'اختر نوع الحساب المناسب لاحتياجاتك.'
                            : _step == 1
                                ? 'أدخل بيانات حسابك للمتابعة.'
                                : 'أكمل بيانات الجهة لإنشاء الحساب.',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF7C9397),
                          fontSize: 12,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border,
            ),
          ),
        ),

        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
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
                            onTogglePassword: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            isBusiness: _isBusiness,
                          ),

                        _ => _BusinessStep(
                            key: const ValueKey('business'),
                            formKey: _businessFormKey,
                            type: _type,
                            entityName: _entityName,
                            registrationNumber:
                                _registrationNumber,
                            city: _city,
                            area: _area,
                            address: _address,
                            description: _description,
                            latitude: _latitude,
                            longitude: _longitude,
                            minimumOrderAmount:
                                _minimumOrderAmount,
                            deliveryFee: _deliveryFee,
                            hasDeliveryService:
                                _hasDeliveryService,
                            coordinateError: _coordinateError,
                            onDeliveryChanged: (value) {
                              setState(() {
                                _hasDeliveryService = value;
                              });
                            },
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
                      _ => () {
                          _submit();
                        },
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(14, 24, 14, 30),
      children: [
        Text(
          'لكل حساب مساحة عمل وخدمات مصممة حسب احتياجاته.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF7C9397),
                fontSize: 14,
                height: 1.6,
              ),
        ),

        const SizedBox(height: 26),

        _AccountTypeSelector(
          selected: selected,
          onChanged: onChanged,
        ),
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
        padding: const EdgeInsets.fromLTRB(14, 24, 14, 28),
        children: [
          Text(
            'أدخل معلومات صحيحة لنجهز حسابك بالشكل المناسب.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF7C9397),
                  fontSize: 14,
                  height: 1.6,
                ),
          ),

          const SizedBox(height: 26),

          _FormSurface(
            child: Column(
              children: [
                AppTextField(
                  label: 'الاسم الكامل',
                  hint: 'الاسم كما يظهر في الحساب',
                  controller: fullName,
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.name,
                  ],
                  validator: _required(
                    'أدخل الاسم الكامل.',
                  ),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: isBusiness
                      ? 'رقم الهاتف'
                      : 'رقم الهاتف (اختياري)',
                  hint: '+963 ...',
                  controller: phoneNumber,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.telephoneNumber,
                  ],
                  validator: isBusiness
                      ? _required('أدخل رقم الهاتف.')
                      : null,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'البريد الإلكتروني',
                  hint: 'name@example.com',
                  controller: email,
                  icon: Icons.alternate_email_rounded,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.email,
                  ],
                  validator: (value) {
                    final emailValue =
                        value?.trim() ?? '';

                    final validEmail = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(emailValue);

                    if (emailValue.isEmpty ||
                        !validEmail) {
                      return 'أدخل بريدًا إلكترونيًا صحيحًا.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'كلمة المرور',
                  controller: password,
                  icon: Icons.lock_outline_rounded,
                  obscureText: !showPassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.newPassword,
                  ],
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

                    final hasUpperCase =
                        RegExp('[A-Z]').hasMatch(text);

                    final hasLowerCase =
                        RegExp('[a-z]').hasMatch(text);

                    final hasNumber =
                        RegExp(r'\d').hasMatch(text);

                    final hasSymbol = RegExp(
                      r'[^a-zA-Z0-9]',
                    ).hasMatch(text);

                    if (text.length < 8 ||
                        !hasUpperCase ||
                        !hasLowerCase ||
                        !hasNumber ||
                        !hasSymbol) {
                      return 'استخدم 8 محارف مع حرف كبير وصغير ورقم ورمز.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'تأكيد كلمة المرور',
                  controller: confirmPassword,
                  icon: Icons.lock_reset_rounded,
                  obscureText: !showPassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [
                    AutofillHints.newPassword,
                  ],
                  validator: (value) {
                    if (value != password.text) {
                      return 'كلمتا المرور غير متطابقتين.';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'تساعد بيانات الحساب الصحيحة في تقديم تجربة مناسبة وآمنة.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: const Color(0xFF7C9397),
                  fontSize: 12,
                ),
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

  bool get isPharmacy =>
      type == RegistrationType.pharmacy;

  bool get isWarehouse =>
      type == RegistrationType.warehouse;

  String get entityTitle {
    if (isPharmacy) {
      return 'الصيدلية';
    }

    if (isWarehouse) {
      return 'المستودع';
    }

    return 'المنظمة';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 24, 14, 28),
        children: [
          Text(
            'أدخل بيانات $entityTitle، وسيتم مراجعتها قبل تفعيل خدمات الحساب.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF7C9397),
                  fontSize: 14,
                  height: 1.6,
                ),
          ),

          const SizedBox(height: 26),

          _FormSurface(
            child: Column(
              children: [
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

                const SizedBox(height: 16),

                AppTextField(
                  label: isPharmacy || isWarehouse
                      ? 'رقم الترخيص'
                      : 'رقم التسجيل',
                  controller: registrationNumber,
                  icon: Icons.badge_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required(
                    isPharmacy || isWarehouse
                        ? 'أدخل رقم الترخيص.'
                        : 'أدخل رقم التسجيل.',
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'المدينة',
                        controller: city,
                        icon:
                            Icons.location_city_outlined,
                        textInputAction:
                            TextInputAction.next,
                        validator:
                            _required('أدخل المدينة.'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: AppTextField(
                        label: 'المنطقة',
                        controller: area,
                        icon: Icons.map_outlined,
                        textInputAction:
                            TextInputAction.next,
                        validator:
                            _required('أدخل المنطقة.'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'العنوان',
                  controller: address,
                  icon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _required(
                    'أدخل العنوان.',
                  ),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'وصف مختصر (اختياري)',
                  controller: description,
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                  minLines: 3,
                  textInputAction:
                      TextInputAction.newline,
                ),

                if (isPharmacy) ...[
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: SwitchListTile(
                      value: hasDeliveryService,
                      onChanged: onDeliveryChanged,
                      activeColor: AppColors.primary,
                      secondary: const Icon(
                        Icons.delivery_dining_rounded,
                        color: Color(0xFF076A73),
                      ),
                      title: const Text(
                        'خدمة توصيل',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: const Text(
                        'حددها إذا كانت الصيدلية توفر التوصيل',
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Align(
                    alignment:
                        AlignmentDirectional.centerStart,
                    child: Text(
                      'موقع الصيدلية (اختياري)',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Align(
                    alignment:
                        AlignmentDirectional.centerStart,
                    child: Text(
                      'يمكن حفظ الموقع الآن أو إضافته لاحقًا من ملف الصيدلية.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: const Color(0xFF7C9397),
                          ),
                    ),
                  ),

                  const SizedBox(height: 13),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'خط العرض',
                          hint: '33.5138',
                          controller: latitude,
                          icon: Icons.north_rounded,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction:
                              TextInputAction.next,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: AppTextField(
                          label: 'خط الطول',
                          hint: '36.2765',
                          controller: longitude,
                          icon: Icons.east_rounded,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction:
                              TextInputAction.done,
                        ),
                      ),
                    ],
                  ),

                  if (coordinateError != null) ...[
                    const SizedBox(height: 10),

                    Align(
                      alignment:
                          AlignmentDirectional.centerStart,
                      child: Text(
                        coordinateError!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],

                if (isWarehouse) ...[
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'الحد الأدنى للطلب',
                          controller:
                              minimumOrderAmount,
                          icon: Icons.payments_outlined,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),
                          validator:
                              _nonNegativeNumber,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: AppTextField(
                          label: 'رسوم التوصيل',
                          controller: deliveryFee,
                          icon:
                              Icons.local_shipping_outlined,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),
                          validator:
                              _nonNegativeNumber,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  const _AccountTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final RegistrationType selected;
  final ValueChanged<RegistrationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeCard(
          selected:
              selected == RegistrationType.user,
          icon: Icons.person_outline_rounded,
          label: 'مستخدم',
          description:
              'ابحث عن دوائك وتابع طلباتك ومعلوماتك الصحية.',
          onTap: () {
            onChanged(RegistrationType.user);
          },
        ),

        const SizedBox(height: 13),

        _TypeCard(
          selected:
              selected == RegistrationType.pharmacy,
          icon: Icons.local_pharmacy_outlined,
          label: 'صيدلية',
          description:
              'أدر المخزون وساعات العمل وطلبات المستخدمين.',
          onTap: () {
            onChanged(RegistrationType.pharmacy);
          },
        ),

        const SizedBox(height: 13),

        _TypeCard(
          selected:
              selected == RegistrationType.organization,
          icon: Icons.apartment_outlined,
          label: 'منظمة',
          description:
              'نظّم الحملات واستقبل عروض التبرع وطلبات المساعدة.',
          onTap: () {
            onChanged(RegistrationType.organization);
          },
        ),

        const SizedBox(height: 13),

        _TypeCard(
          selected:
              selected == RegistrationType.warehouse,
          icon: Icons.warehouse_outlined,
          label: 'مستودع أدوية',
          description:
              'أدر التشغيلات وطلبات الصيدليات والشحن والفواتير.',
          onTap: () {
            onChanged(RegistrationType.warehouse);
          },
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

  static const Color _selectedColor = Color(0xFF167A83);
  static const Color _selectedIconBackground = Color(0xFFF5CF6A);
  static const Color _primary = Color(0xFF076A73);
  static const Color _border = Color(0xFFD4E2E4);
  static const Color _surfaceSoft = Color(0xFFF2FAFA);
  static const Color _text = Color(0xFF153F45);
  static const Color _muted = Color(0xFF7C9397);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(23),
          overlayColor: WidgetStatePropertyAll(
            _selectedColor.withValues(alpha: 0.055),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            constraints: const BoxConstraints(minHeight: 108),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 22,
            ),
            decoration: BoxDecoration(
              color: selected ? _selectedColor : Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: selected ? _selectedColor : _border,
                width: 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: selected
                        ? _selectedIconBackground
                        : _surfaceSoft,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? const Color(0xFF153F45) : _primary,
                    size: 34,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: selected ? Colors.white : _text,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        description,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.78)
                                  : _muted,
                              height: 1.45,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 33,
                  height: 33,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? const Color(0xFFF5CF6A) : Colors.transparent,
                    border: Border.all(
                      color: selected ? Colors.white : _border,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 17,
                          color: const Color(0xFF153F45),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        16,
      ),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null) ...[
            _InlineError(
              message: errorMessage!,
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            height: 60,
            child: FilledButton(
              onPressed: isLoading ? null : onPrimary,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: const Color(0xFF076A73),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF076A73).withValues(alpha: 0.55),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      step == 0 || (step == 1 && isBusiness)
                          ? 'متابعة'
                          : 'إنشاء الحساب',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSurface extends StatelessWidget {
  const _FormSurface({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;

  static const Color _primary = Color(0xFF076A73);
  static const Color _border = Color(0xFFD4E2E4);
  static const Color _text = Color(0xFF153F45);
  static const Color _muted = Color(0xFF7C9397);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: _text,
            fontSize: 14,
            height: 1.3,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          validator: validator,
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? 1 : minLines,
          cursorColor: _primary,
          cursorWidth: 1.4,
          style: const TextStyle(
            color: _text,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: _muted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              icon,
              color: _primary,
              size: 24,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 60,
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 60,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: _border.withValues(alpha: 0.78),
                width: 0.9,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: _primary.withValues(alpha: 0.34),
                width: 1.05,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: AppColors.danger.withValues(alpha: 0.55),
                width: 0.95,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: AppColors.danger.withValues(alpha: 0.68),
                width: 1.05,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(
          alpha: 0.08,
        ),
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

String? Function(String?) _required(
  String message,
) {
  return (value) {
    return value?.trim().isEmpty ?? true
        ? message
        : null;
  };
}

String? _nonNegativeNumber(
  String? value,
) {
  final text =
      value?.trim().replaceAll(',', '.') ?? '';

  final number = double.tryParse(text);

  if (number == null || number < 0) {
    return 'أدخل قيمة صحيحة.';
  }

  return null;
}