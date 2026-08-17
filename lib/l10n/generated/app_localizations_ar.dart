// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دوائي';

  @override
  String get home => 'الرئيسية';

  @override
  String get services => 'الخدمات';

  @override
  String get account => 'حسابي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get sessionExpired => 'انتهت جلستك، سجّل دخولك مجدداً.';

  @override
  String get loadingDefault => 'جاري تحميل البيانات...';

  @override
  String get loadFailedTitle => 'تعذر إكمال التحميل';

  @override
  String get loadFailedMessage => 'تعذر تحميل البيانات حاليًا.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get appTagline => 'دواؤك أقرب';

  @override
  String get loginFailed => 'تعذر تسجيل الدخول. تحقق من البيانات وحاول مجددًا.';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'أدخل بيانات حسابك للوصول إلى خدماتك.';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginShowPassword => 'إظهار كلمة المرور';

  @override
  String get loginHidePassword => 'إخفاء كلمة المرور';

  @override
  String get loginPasswordRequired => 'أدخل كلمة المرور.';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get orDivider => 'أو';

  @override
  String get loginTermsPrefix => 'بالمتابعة، أنت توافق على ';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get andWord => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get noAccountYet => 'ليس لديك حساب بعد؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String welcomeName(Object name) {
    return 'مرحبًا $name';
  }

  @override
  String get accountCreatedTitle => 'تم إنشاء حسابك';

  @override
  String get goToHome => 'الانتقال إلى الرئيسية';

  @override
  String get splashAppLogoLabel => 'شعار تطبيق دوائي';

  @override
  String get splashTagline => 'دواؤك أقرب، ورعايتك أسهل';

  @override
  String get splashPreparing => 'نجهّز تجربتك';

  @override
  String get splashTopCaption => 'رعاية دوائية أقرب إليك';

  @override
  String get splashLoadingLabel => 'جاري تجهيز التطبيق';

  @override
  String splashPercent(Object percent) {
    return '$percent بالمئة';
  }

  @override
  String get forgotOperationFailed => 'تعذر إكمال العملية الآن. حاول مجددًا.';

  @override
  String get forgotBack => 'العودة';

  @override
  String get forgotTitle => 'استعادة الحساب';

  @override
  String get forgotSubtitle =>
      'أدخل بريدك الإلكتروني وسنساعدك على تعيين كلمة مرور جديدة بأمان.';

  @override
  String get forgotEmailLabel => 'البريد الإلكتروني';

  @override
  String get forgotVerifying => 'جاري التحقق...';

  @override
  String get forgotContinue => 'متابعة';

  @override
  String get forgotSetNewTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get forgotResetSubtitle =>
      'أدخل الرمز المرسل إلى بريدك ثم اختر كلمة مرور جديدة.';

  @override
  String get forgotTokenLabel => 'رمز الاستعادة';

  @override
  String get forgotTokenRequired => 'أدخل رمز الاستعادة.';

  @override
  String get forgotNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get forgotConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get forgotPasswordsMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get forgotPasswordHint =>
      'استخدم 8 أحرف على الأقل مع حرف كبير وصغير ورقم ورمز.';

  @override
  String get forgotSaving => 'جاري الحفظ...';

  @override
  String get forgotSavePassword => 'حفظ كلمة المرور';

  @override
  String get forgotSendNewCode => 'إرسال رمز جديد';

  @override
  String get forgotSuccessTitle => 'تم تحديث كلمة المرور';

  @override
  String get forgotSuccessSubtitle =>
      'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.';

  @override
  String get forgotBackToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get forgotEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get forgotPasswordRequirements => 'كلمة المرور لا تحقق المتطلبات.';

  @override
  String get registerTypeAccount => 'اختر نوع الحساب';

  @override
  String get registerAccountData => 'بيانات الحساب';

  @override
  String get registerPharmacyData => 'بيانات الصيدلية';

  @override
  String get registerOrganizationData => 'بيانات المنظمة';

  @override
  String get registerWarehouseData => 'بيانات المستودع';

  @override
  String get registerTypeSubtitle => 'اختر نوع الحساب المناسب لاحتياجاتك.';

  @override
  String get registerAccountSubtitle => 'أدخل بيانات حسابك للمتابعة.';

  @override
  String get registerEntitySubtitle => 'أكمل بيانات الجهة لإنشاء الحساب.';

  @override
  String get registerFailed => 'تعذر إنشاء الحساب حاليًا.';

  @override
  String get registerCoordsTogether => 'أدخل خط العرض وخط الطول معًا.';

  @override
  String get registerCoordsInvalid => 'تحقق من قيم الإحداثيات المدخلة.';

  @override
  String get registerIntro => 'لكل حساب مساحة عمل وخدمات مصممة حسب احتياجه.';

  @override
  String get registerTypeUser => 'مستخدم';

  @override
  String get registerTypeUserDesc =>
      'ابحث عن دوائك وتابع طلباتك ومعلوماتك الصحية.';

  @override
  String get registerTypePharmacy => 'صيدلية';

  @override
  String get registerTypePharmacyDesc =>
      'أدر المخزون وساعات العمل وطلبات المستخدمين.';

  @override
  String get registerTypeOrganization => 'منظمة';

  @override
  String get registerTypeOrganizationDesc =>
      'نظّم الحملات واستقبل عروض التبرع وطلبات المساعدة.';

  @override
  String get registerTypeWarehouse => 'مستودع أدوية';

  @override
  String get registerTypeWarehouseDesc =>
      'أدر التشغيلات وطلبات الصيدليات والشحن والفواتير.';

  @override
  String get registerAccountInfo =>
      'أدخل معلومات صحيحة لنجهز حسابك بالشكل المناسب.';

  @override
  String get registerFullName => 'الاسم الكامل';

  @override
  String get registerFullNameHint => 'الاسم كما يظهر في الحساب';

  @override
  String get registerFullNameRequired => 'أدخل الاسم الكامل.';

  @override
  String get registerPhoneLabel => 'رقم الهاتف';

  @override
  String get registerPhoneOptionalLabel => 'رقم الهاتف (اختياري)';

  @override
  String get registerPhoneRequired => 'أدخل رقم الهاتف.';

  @override
  String get registerEmailLabel => 'البريد الإلكتروني';

  @override
  String get registerEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get registerPasswordLabel => 'كلمة المرور';

  @override
  String get registerPasswordHint =>
      'استخدم 8 محارف مع حرف كبير وصغير ورقم ورمز.';

  @override
  String get registerConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get registerPasswordsMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get registerAccountHelp =>
      'تساعد بيانات الحساب الصحيحة في تقديم تجربة مناسبة وآمنة.';

  @override
  String get registerPharmacyName => 'اسم الصيدلية';

  @override
  String get registerWarehouseName => 'اسم المستودع';

  @override
  String get registerOrgName => 'اسم المنظمة';

  @override
  String get registerLicenseNumber => 'رقم الترخيص';

  @override
  String get registerRegNumber => 'رقم التسجيل';

  @override
  String get registerPharmacyNameHint => 'أدخل اسم الصيدلية.';

  @override
  String get registerWarehouseNameHint => 'أدخل اسم المستودع.';

  @override
  String get registerOrgNameHint => 'أدخل اسم المنظمة.';

  @override
  String get registerLicenseHint => 'أدخل رقم الترخيص.';

  @override
  String get registerRegNumberHint => 'أدخل رقم التسجيل.';

  @override
  String registerBusinessIntro(Object entityType) {
    return 'أدخل بيانات $entityType، وسيتم مراجعتها قبل تفعيل خدمات الحساب.';
  }

  @override
  String get registerPharmacyWord => 'الصيدلية';

  @override
  String get registerWarehouseWord => 'المستودع';

  @override
  String get registerOrgWord => 'المنظمة';

  @override
  String get registerCity => 'المدينة';

  @override
  String get registerCityRequired => 'أدخل المدينة.';

  @override
  String get registerArea => 'المنطقة';

  @override
  String get registerAreaRequired => 'أدخل المنطقة.';

  @override
  String get registerAddress => 'العنوان';

  @override
  String get registerAddressRequired => 'أدخل العنوان.';

  @override
  String get registerDescription => 'وصف مختصر (اختياري)';

  @override
  String get registerDeliveryService => 'خدمة توصيل';

  @override
  String get registerDeliveryServiceSub =>
      'حددها إذا كانت الصيدلية توفر التوصيل';

  @override
  String get registerLocationTitle => 'موقع الصيدلية (اختياري)';

  @override
  String get registerLocationHint =>
      'يمكن حفظ الموقع الآن أو إضافته لاحقًا من ملف الصيدلية.';

  @override
  String get registerLatitude => 'خط العرض';

  @override
  String get registerLongitude => 'خط الطول';

  @override
  String get registerLocating => 'جارٍ تحديد الموقع...';

  @override
  String get registerLocateAuto => 'تحديد الموقع تلقائيًا';

  @override
  String get registerLocationFailed => 'تعذر تحديد الموقع. حاول مجددًا.';

  @override
  String get registerMinOrder => 'الحد الأدنى للطلب';

  @override
  String get registerDeliveryFee => 'رسوم التوصيل';

  @override
  String get registerInvalidValue => 'أدخل قيمة صحيحة.';

  @override
  String get continueAction => 'متابعة';

  @override
  String get registerCreate => 'إنشاء الحساب';

  @override
  String get settingsProfileSubtitle => 'بياناتك وتفضيلات استخدام التطبيق';

  @override
  String get settingsPrefsSection => 'التفضيلات والحساب';

  @override
  String get settingsPrefsSubtitle => 'إدارة بياناتك وطريقة استخدام التطبيق';

  @override
  String get settingsProfile => 'الملف الشخصي';

  @override
  String get settingsProfileDesc => 'الاسم ورقم الهاتف والصورة';

  @override
  String get settingsLanguage => 'لغة التطبيق';

  @override
  String get settingsLanguageAr => 'العربية';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsAppearanceDesc => 'فاتح أو داكن أو حسب إعداد الجهاز';

  @override
  String get settingsNotifications => 'تفضيلات الإشعارات';

  @override
  String get settingsNotificationsDesc => 'الطلبات والتذكيرات والحملات';

  @override
  String get settingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get settingsChangePasswordDesc => 'تحديث كلمة مرور حسابك';

  @override
  String get settingsPrivacyHelpSection => 'الخصوصية والمساعدة';

  @override
  String get settingsPrivacyHelpSubtitle =>
      'الصلاحيات والمعلومات المهمة عن استخدام دوائي';

  @override
  String get settingsNotificationCenter => 'مركز الإشعارات';

  @override
  String get settingsNotificationCenterDesc => 'عرض التنبيهات الواردة وحالتها';

  @override
  String get settingsPermissions => 'صلاحيات الجهاز';

  @override
  String get settingsPermissionsDesc => 'الموقع والكاميرا والملفات';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsPrivacyDesc => 'بياناتك الآمنة وخصوصيتك';

  @override
  String get settingsTermsDesc => 'البنود والأحكام العامة';

  @override
  String get settingsHelp => 'المساعدة';

  @override
  String get settingsHelpDesc => 'الدعم الفني والأسئلة الشائعة';

  @override
  String get settingsAbout => 'عن دوائي';

  @override
  String get settingsVersion => 'الإصدار 1.0.0';

  @override
  String get logoutConfirm => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get roleRepresentative => 'مندوب مستودع';

  @override
  String get roleAdmin => 'إدارة المنصة';

  @override
  String get verifiedAccount => 'حساب موثّق';

  @override
  String get unverifiedAccount => 'حساب غير موثّق';

  @override
  String get accountProfileTitle => 'الملف الشخصي';

  @override
  String get accountProfileSubtitle => 'بيانات حسابك وصورتك';

  @override
  String get accountLoadingProfile => 'جاري تحميل بياناتك...';

  @override
  String get accountBasicData => 'البيانات الأساسية';

  @override
  String get accountFullName => 'الاسم الكامل';

  @override
  String get accountFullNameRequired => 'أدخل الاسم الكامل';

  @override
  String get accountFullNameTooLong => 'يجب ألا يتجاوز الاسم 150 حرفًا';

  @override
  String get accountEmailLabel => 'البريد الإلكتروني';

  @override
  String get accountPhoneLabel => 'رقم الهاتف';

  @override
  String get accountOptionalHint => 'اختياري';

  @override
  String get accountPhoneTooLong => 'يجب ألا يتجاوز الرقم 30 محرفًا';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get accountSaved => 'تم حفظ بيانات الحساب';

  @override
  String get accountImagesGroup => 'صور';

  @override
  String get accountImageTooLarge => 'حجم الصورة يجب ألا يتجاوز 5 ميغابايت';

  @override
  String get accountAvatarUpdated => 'تم تحديث الصورة الشخصية';

  @override
  String get deleteImageTitle => 'حذف الصورة';

  @override
  String get deleteImageConfirm => 'هل تريد إزالة صورتك الشخصية؟';

  @override
  String get delete => 'حذف';

  @override
  String get accountAvatarDeleted => 'تم حذف الصورة الشخصية';

  @override
  String get accountOperationFailed => 'تعذر إكمال العملية حاليًا.';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get removePhoto => 'إزالة';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle => 'حافظ على أمان حسابك';

  @override
  String get changePasswordCurrent => 'كلمة المرور الحالية';

  @override
  String get changePasswordCurrentRequired => 'أدخل كلمة المرور الحالية';

  @override
  String get changePasswordNew => 'كلمة المرور الجديدة';

  @override
  String get changePasswordMinLength => 'يجب ألا تقل عن 8 أحرف';

  @override
  String get changePasswordMaxLength => 'يجب ألا تتجاوز 128 حرفًا';

  @override
  String get changePasswordConfirm => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get changePasswordDone => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get changePasswordFailed => 'تعذر تغيير كلمة المرور حاليًا.';

  @override
  String get changePasswordHeroTitle => 'تحديث كلمة المرور';

  @override
  String get changePasswordHeroSubtitle =>
      'اختر كلمة مختلفة وقوية لا تقل عن 8 أحرف.';

  @override
  String get appearanceIntroTitle => 'مظهر مريح لك';

  @override
  String get appearanceIntroSubtitle =>
      'اختر مظهر التطبيق أو اجعله يتبع إعداد جهازك.';

  @override
  String get themeSystem => 'إعداد الجهاز';

  @override
  String get themeSystemDesc => 'يتغير تلقائيًا مع مظهر الهاتف';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeLightDesc => 'ألوان واضحة ومضيئة';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeDarkDesc => 'أكثر راحة في الإضاءة المنخفضة';

  @override
  String get notifIntroTitle => 'ابقَ على اطلاع';

  @override
  String get notifIntroSubtitle =>
      'تحكم بأنواع التنبيهات التي يعرضها التطبيق لك. صلاحية الإشعارات تُدار من إعدادات الهاتف.';

  @override
  String get notifInApp => 'الإشعارات داخل التطبيق';

  @override
  String get notifInAppDesc => 'تشغيل أو إيقاف عرض التنبيهات';

  @override
  String get notifRequestUpdates => 'تحديثات الطلبات';

  @override
  String get notifRequestUpdatesDesc => 'حالة طلب الدواء والتجهيز والاستجابة';

  @override
  String get notifHealthReminders => 'التذكيرات الصحية';

  @override
  String get notifHealthRemindersDesc =>
      'مواعيد الدواء والتنبيهات المرتبطة بصحتك';

  @override
  String get notifCampaigns => 'الحملات والمبادرات';

  @override
  String get notifCampaignsDesc => 'المستجدات المتعلقة بالتبرعات والحملات';

  @override
  String get permIntroTitle => 'أنت المتحكم';

  @override
  String get permIntroSubtitle =>
      'يطلب دوائي الصلاحية عند الحاجة فقط، ويمكنك تعديلها من إعدادات هاتفك.';

  @override
  String get permLocation => 'الموقع';

  @override
  String get permLocationAllowed => 'مسموح أثناء استخدام التطبيق';

  @override
  String get permLocationServiceOff => 'الصلاحية متاحة، وخدمة الموقع متوقفة';

  @override
  String get permLocationNotAllowed => 'غير مسموح حاليًا';

  @override
  String get permAllow => 'سماح';

  @override
  String get permCameraFiles => 'الكاميرا والملفات';

  @override
  String get permCameraFilesDesc =>
      'تُطلب فقط عند اختيار صورة أو مستند لإرساله';

  @override
  String get permOpenLocationSettings => 'فتح إعدادات الموقع';

  @override
  String get permOpenAppSettings => 'فتح إعدادات التطبيق في الهاتف';

  @override
  String get infoAccountData => 'بيانات الحساب';

  @override
  String get infoAccountDataDesc =>
      'نستخدم بيانات الحساب لتقديم الخدمات المرتبطة بدورك داخل النظام.';

  @override
  String get infoLocation => 'الموقع';

  @override
  String get infoLocationDesc =>
      'يُستخدم موقعك عند طلب البحث عن الصيدليات القريبة أو حساب المسار، ويمكنك إيقاف الصلاحية من هاتفك.';

  @override
  String get infoHealthData => 'البيانات الصحية';

  @override
  String get infoHealthDataDesc =>
      'تُرسل البيانات التي تدخلها إلى الخادم لتقديم المزايا الصحية المطلوبة، ولا ينبغي مشاركة بيانات الدخول مع أي شخص.';

  @override
  String get infoControl => 'التحكم';

  @override
  String get infoControlDesc =>
      'يمكنك تعديل بياناتك وكلمة مرورك وصلاحيات الجهاز من صفحات الحساب والإعدادات.';

  @override
  String get infoInfoAccuracy => 'دقة المعلومات';

  @override
  String get infoInfoAccuracyDesc =>
      'اعتمد على العبوة والصيدلي أو الطبيب في القرارات الطبية؛ المعلومات داخل التطبيق مساندة وليست بديلًا عن المختص.';

  @override
  String get infoResponsibleUse => 'الاستخدام المسؤول';

  @override
  String get infoResponsibleUseDesc =>
      'يجب إدخال بيانات صحيحة وعدم إساءة استخدام الطلبات أو التبرعات أو حسابات الجهات.';

  @override
  String get infoEmergency => 'الطوارئ';

  @override
  String get infoEmergencyDesc =>
      'لا يُستخدم التطبيق لطلب إسعاف أو معالجة حالة طارئة؛ تواصل مع خدمات الطوارئ المحلية فورًا.';

  @override
  String get infoAccount => 'الحساب';

  @override
  String get infoAccountDesc =>
      'أنت مسؤول عن الحفاظ على سرية بيانات الدخول والإبلاغ عن أي استخدام غير معتاد.';

  @override
  String get infoMapNotShown => 'الخريطة لا تظهر';

  @override
  String get infoMapNotShownDesc =>
      'تأكد من تشغيل خدمة الموقع ومنح التطبيق صلاحية الموقع، ثم أعد تحميل الصفحة.';

  @override
  String get infoConnectionFailed => 'تعذر الاتصال';

  @override
  String get infoConnectionFailedDesc =>
      'تأكد أن الهاتف والخادم على الشبكة نفسها وأن عنوان الخادم صحيح ومتاح.';

  @override
  String get infoRecoveryCodeMissing => 'لم يصل رمز الاستعادة';

  @override
  String get infoRecoveryCodeMissingDesc =>
      'تحقق من البريد غير المرغوب فيه ثم اطلب رمزًا جديدًا. أثناء التطوير المحلي يظهر الرمز داخل صفحة الاستعادة.';

  @override
  String get infoAccountIssue => 'مشكلة في الحساب';

  @override
  String get infoAccountIssueDesc =>
      'جرّب تسجيل الخروج والدخول مجددًا، وتأكد من اعتماد حساب الجهة إن كان يتطلب موافقة الإدارة.';

  @override
  String get infoDawaaiDesc =>
      'منصة تربط المستخدم بالصيدليات والمنظمات وسلسلة توريد الدواء ضمن تجربة موحدة.';

  @override
  String get infoProjectGoal => 'هدف المشروع';

  @override
  String get infoProjectGoalDesc =>
      'تسهيل العثور على الدواء، متابعة الطلبات، دعم المبادرات الدوائية، وتنظيم عمل الجهات المشاركة.';

  @override
  String get infoMedicalNotice => 'تنبيه طبي';

  @override
  String get infoMedicalNoticeDesc =>
      'لا يقدم التطبيق تشخيصًا طبيًا، ويجب الرجوع إلى الطبيب أو الصيدلي عند الحاجة.';

  @override
  String get searchHistoryTitle => 'سجل البحث';

  @override
  String get searchClearing => 'جاري المسح';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String get searchLoading => 'جاري تحميل سجل البحث...';

  @override
  String get searchNearbyPharmacy => 'بحث عن صيدليات قريبة';

  @override
  String searchResultCount(Object count) {
    return '$count نتيجة';
  }

  @override
  String get searchDelete => 'حذف';

  @override
  String get searchEmptyTitle => 'لا يوجد سجل بحث';

  @override
  String get searchEmptySubtitle => 'ستظهر عمليات البحث التي تجريها هنا.';

  @override
  String get searchClearTitle => 'مسح سجل البحث؟';

  @override
  String get searchClearConfirm =>
      'سيتم حذف جميع عمليات البحث المحفوظة في حسابك.';

  @override
  String get searchClearAction => 'مسح السجل';

  @override
  String get searchClearFailed => 'تعذر حذف سجل البحث حاليًا.';

  @override
  String distanceMeters(String value) {
    return '$value م';
  }

  @override
  String distanceKm(String value) {
    return '$value كم';
  }

  @override
  String get statusAll => 'الكل';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusAvailable => 'متوفر';

  @override
  String get statusUnavailable => 'غير متوفر';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get requestsTitle => 'طلباتي';

  @override
  String get requestsLoading => 'جاري تحميل طلباتك...';

  @override
  String get requestsIntroTitle => 'تابع طلبات أدويتك';

  @override
  String get requestsIntroSubtitle => 'اطّلع على رد الصيدلية وحالة كل طلب.';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get requestNumber => 'رقم الطلب';

  @override
  String get requestQuantity => 'الكمية';

  @override
  String get requestDate => 'التاريخ';

  @override
  String get requestsEmptyTitle => 'لا توجد طلبات ضمن هذا التصنيف';

  @override
  String get requestsEmptySubtitle =>
      'ابحث عن دوائك واختر الصيدلية المناسبة لإرسال طلب.';

  @override
  String get medicineAvailable => 'الدواء متوفر';

  @override
  String get requestDetailsTitle => 'تفاصيل الطلب';

  @override
  String get requestDetailsLoading => 'جاري تحميل تفاصيل الطلب...';

  @override
  String get yourNoteToPharmacy => 'ملاحظتك للصيدلية';

  @override
  String get cancellingProgress => 'جاري الإلغاء...';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get cancelRequestTitle => 'إلغاء الطلب؟';

  @override
  String get cancelRequestConfirm =>
      'لن تتمكن الصيدلية من متابعة هذا الطلب بعد إلغائه.';

  @override
  String get back => 'العودة';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get requestCancelled => 'تم إلغاء الطلب';

  @override
  String get cancelRequestFailed => 'تعذر إلغاء الطلب حاليًا.';

  @override
  String get requestStepSent => 'تم الإرسال';

  @override
  String get requestStepCancelled => 'تم الإلغاء';

  @override
  String get underReview => 'قيد المراجعة';

  @override
  String get responded => 'تم الرد';

  @override
  String get waitingForResponse => 'بانتظار الرد';

  @override
  String get quantityRequested => 'الكمية المطلوبة';

  @override
  String get createdDate => 'تاريخ الإنشاء';

  @override
  String get lastUpdate => 'آخر تحديث';

  @override
  String get currentAvailability => 'التوفر الحالي';

  @override
  String get availableInStock => 'متوفر في المخزون';

  @override
  String get notAvailableNow => 'غير متوفر حاليًا';

  @override
  String get pharmacyResponse => 'رد الصيدلية';

  @override
  String get suggestedAlternative => 'البديل المقترح';

  @override
  String get thePharmacy => 'الصيدلية';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get medicineUnavailable => 'الدواء غير متوفر';

  @override
  String get waitingForPharmacyResponse => 'بانتظار رد الصيدلية';

  @override
  String get pharmacyDetailsTitle => 'تفاصيل الصيدلية';

  @override
  String get pharmacyDetailsLoading => 'جاري تحميل بيانات الصيدلية...';

  @override
  String get availableMedicines => 'الأدوية المتوفرة';

  @override
  String medicinesAvailableCount(Object count) {
    return '$count دواء متاح للطلب';
  }

  @override
  String get deliveryAvailable => 'توصيل متاح';

  @override
  String get call => 'اتصال';

  @override
  String get requiresPrescription => 'يتطلب وصفة';

  @override
  String get requestMedicineTitle => 'إرسال طلب دواء';

  @override
  String get requestMedicineSubtitle => 'ستراجع الصيدلية طلبك وترد عليه';

  @override
  String get medicineLabel => 'الدواء';

  @override
  String get noteToPharmacyOptional => 'ملاحظة للصيدلية (اختياري)';

  @override
  String get sendingProgress => 'جاري الإرسال...';

  @override
  String get sendRequest => 'إرسال الطلب';

  @override
  String get rateExperienceTitle => 'قيّم تجربتك';

  @override
  String get rateExperienceSubtitle => 'شارك رأيك لمساعدة مستخدمين آخرين';

  @override
  String get ratingHint => 'اكتب رأيك باختصار (اختياري)';

  @override
  String get savingProgress => 'جاري الحفظ...';

  @override
  String get saveRating => 'حفظ التقييم';

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get workingHoursSubtitle => 'جدول الدوام الأسبوعي للصيدلية';

  @override
  String get dayFallback => 'يوم';

  @override
  String get closed => 'مغلق';

  @override
  String get daySunday => 'الأحد';

  @override
  String get dayMonday => 'الاثنين';

  @override
  String get dayTuesday => 'الثلاثاء';

  @override
  String get dayWednesday => 'الأربعاء';

  @override
  String get dayThursday => 'الخميس';

  @override
  String get dayFriday => 'الجمعة';

  @override
  String get daySaturday => 'السبت';

  @override
  String get chooseMedicineFirst => 'اختر الدواء أولًا.';

  @override
  String get requestSentTitle => 'تم إرسال الطلب';

  @override
  String requestSentContent(Object code) {
    return 'رقم الطلب $code\nيمكنك متابعة رد الصيدلية من صفحة طلباتي.';
  }

  @override
  String get close => 'إغلاق';

  @override
  String get viewRequest => 'عرض الطلب';

  @override
  String get chooseStarsFirst => 'اختر عدد النجوم أولًا.';

  @override
  String get ratingSaved => 'شكرًا، تم حفظ تقييمك.';

  @override
  String get operationFailed => 'تعذر إكمال العملية حاليًا.';

  @override
  String get noMedicinesAvailable => 'لا توجد أدوية متاحة حاليًا';

  @override
  String get priceNotAnnounced => 'السعر غير معلن';

  @override
  String currencySYP(String value) {
    return '$value ل.س';
  }

  @override
  String get medicineSearchTitle => 'البحث عن دواء';

  @override
  String get nearbyPharmacies => 'الصيدليات القريبة';

  @override
  String get searchStartTitle => 'ابدأ بكتابة اسم الدواء';

  @override
  String get searchStartMessage =>
      'ستظهر الصيدليات التي يتوفر لديها الدواء مع السعر والمسافة.';

  @override
  String get searchLoadingNearby => 'نبحث في الصيدليات القريبة...';

  @override
  String get searchNoResultsTitle => 'لم نجد نتائج مطابقة';

  @override
  String get searchNoResultsMessage =>
      'جرّب الاسم العلمي أو وسّع نطاق البحث وتحقق من كتابة الاسم.';

  @override
  String get searchResultsTitle => 'نتائج البحث';

  @override
  String searchResultsSubtitle(Object results, Object pharmacies) {
    return '$results نتيجة لدى $pharmacies صيدليات';
  }

  @override
  String get searchEmptyQuery => 'اكتب اسم الدواء للبحث.';

  @override
  String get setLocationFirst => 'حدد موقعك أولًا';

  @override
  String get setLocationDesc =>
      'نستخدم موقعك لعرض الدواء والصيدليات الأقرب إليك.';

  @override
  String get setLocationAction => 'تحديد الموقع';

  @override
  String get searchHeroTitle => 'ابحث عن دوائك بسهولة';

  @override
  String get searchHeroSubtitle => 'قارن التوفر والسعر والمسافة.';

  @override
  String get medicineNameLabel => 'اسم الدواء';

  @override
  String get medicineNameHint => 'اسم الدواء أو الاسم العلمي';

  @override
  String get radiusLabel => 'النطاق';

  @override
  String get sortLabel => 'الترتيب';

  @override
  String get searchingProgress => 'جاري البحث...';

  @override
  String get searchAction => 'عرض أماكن توفر الدواء';

  @override
  String get sortBestMatch => 'الأفضل تطابقًا';

  @override
  String get sortDistance => 'الأقرب';

  @override
  String get sortOpenNow => 'المفتوحة الآن';

  @override
  String get sortRating => 'الأعلى تقييمًا';

  @override
  String get sortPriceLowToHigh => 'السعر الأقل';

  @override
  String get priceLabel => 'السعر';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get ratingLabel => 'التقييم';

  @override
  String get viewPharmacyAndRequest => 'عرض الصيدلية وطلب الدواء';

  @override
  String get priceUnannounced => 'غير معلن';

  @override
  String get medicalProfileTitle => 'ملفي الصحي';

  @override
  String get healthProfileSaveFailed => 'تعذر حفظ الملف الصحي.';

  @override
  String get medicalProfileLoading => 'جاري تحميل ملفك الصحي...';

  @override
  String get healthCardLoading => 'جاري إعداد البطاقة الصحية...';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get selectDate => 'اختيار';

  @override
  String get choose => 'اختر';

  @override
  String get medicalProfileSaved => 'تم حفظ الملف الصحي بنجاح.';

  @override
  String get healthDataTab => 'البيانات الصحية';

  @override
  String get healthCardTab => 'البطاقة الصحية';

  @override
  String get healthIntroTitle => 'معلومات تساعدك وقت الحاجة';

  @override
  String get healthIntroSubtitle =>
      'احتفظ بحساسياتك وأدويتك الحالية وبيانات التواصل الضرورية محدثة.';

  @override
  String get basicInfoTitle => 'المعلومات الأساسية';

  @override
  String get chooseDate => 'اختر التاريخ';

  @override
  String get healthDetailsTitle => 'التفاصيل الصحية';

  @override
  String get allergiesLabel => 'الحساسيات';

  @override
  String get allergiesHint => 'مثال: البنسلين';

  @override
  String get chronicConditionsLabel => 'الحالات المزمنة';

  @override
  String get chronicConditionsHint => 'مثال: السكري';

  @override
  String get currentMedicationsLabel => 'الأدوية الحالية';

  @override
  String get currentMedicationsHint => 'اكتب اسم الدواء';

  @override
  String get emergencyContactTitle => 'جهة الاتصال عند الحاجة';

  @override
  String get emergencyNameLabel => 'اسم جهة الاتصال';

  @override
  String get emergencyNameHint => 'الاسم الكامل';

  @override
  String get nameTooLong => 'الاسم طويل جدًا.';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => 'مثال: 09XXXXXXXX';

  @override
  String get phoneTooLong => 'رقم الهاتف طويل جدًا.';

  @override
  String get importantNotesLabel => 'ملاحظات مهمة';

  @override
  String get importantNotesHint => 'أي معلومات تساعد جهة الاتصال';

  @override
  String get notesTooLong => 'الملاحظات تتجاوز الحد المسموح.';

  @override
  String get bloodTypeLabel => 'فصيلة الدم';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get noAllergies => 'لا توجد حساسيات مسجلة';

  @override
  String get noConditions => 'لا توجد حالات مزمنة مسجلة';

  @override
  String get noMedications => 'لا توجد أدوية حالية مسجلة';

  @override
  String get textTooLong => 'يجب ألا يتجاوز النص 150 حرفًا.';

  @override
  String get addTag => 'إضافة';

  @override
  String get emergencyContactEmpty => 'لم تتم إضافة جهة اتصال بعد.';

  @override
  String get dashboardLoading => 'نجهز مساحتك الشخصية...';

  @override
  String get metricActiveRequests => 'طلبات نشطة';

  @override
  String get metricCompletedRequests => 'طلبات مكتملة';

  @override
  String get metricOpenPharmacies => 'صيدليات مفتوحة';

  @override
  String get quickAccessTitle => 'وصول سريع';

  @override
  String get quickAccessSubtitle => 'الخدمات التي قد تحتاجها اليوم';

  @override
  String get myPrescriptions => 'وصفاتي';

  @override
  String get myPrescriptionsSubtitle => 'إدارة الوصفات والطلبات';

  @override
  String get donations => 'التبرعات';

  @override
  String get donationsSubtitle => 'قدّم دواءً أو اطلب مساعدة';

  @override
  String get organizations => 'المنظمات';

  @override
  String get organizationsSubtitle => 'اكتشف الحملات الفعّالة';

  @override
  String get pharmacyAssistant => 'المساعد الدوائي';

  @override
  String get pharmacyAssistantSubtitle => 'اسأل وتابع محادثاتك';

  @override
  String get medicineAlternatives => 'البدائل الدوائية';

  @override
  String get medicineAlternativesSubtitle => 'قارن البدائل المتاحة';

  @override
  String get searchHistorySubtitle => 'ارجع لعمليات البحث السابقة';

  @override
  String get locationSectionTitle => 'الموقع والصيدليات';

  @override
  String get locationSectionSubtitle =>
      'نتائج قريبة اعتمادًا على موقعك المحفوظ';

  @override
  String get latestRequestsTitle => 'أحدث الطلبات';

  @override
  String get latestRequestsSubtitle => 'آخر المستجدات على طلبات الأدوية';

  @override
  String get emptyRequestsActivity =>
      'لا توجد طلبات بعد. يمكنك البدء بالبحث عن دوائك.';

  @override
  String get searchActivityTitle => 'نشاط البحث';

  @override
  String get searchActivitySubtitle => 'عمليات البحث الحديثة';

  @override
  String get emptySearchActivity => 'لم تبدأ البحث بعد.';

  @override
  String get healthSpace => 'مساحتك الصحية';

  @override
  String get heroSubtitle =>
      'ابحث عن دوائك، تابع طلباتك واحتفظ\nبمعلوماتك الصحية في مكان واحد.';

  @override
  String get searchPlaceholder => 'ابحث عن دواء...';

  @override
  String get searchCta => 'بحث';

  @override
  String get locationSavedHero => 'موقعك محفوظ — النتائج الأقرب لك';

  @override
  String get addLocationHero => 'أضف موقعك لعرض الصيدليات القريبة';

  @override
  String get locationSavedTitle => 'موقعك محفوظ';

  @override
  String get setLocationTitle => 'حدد موقعك';

  @override
  String locationSummarySubtitle(Object radius, Object count) {
    return 'نطاق $radius كم — $count صيدليات مسجلة';
  }

  @override
  String get addLocationSubtitle => 'أضف موقعك من خدمة الصيدليات القريبة';

  @override
  String get openLabel => 'مفتوحة';

  @override
  String get closedLabel => 'مغلقة';

  @override
  String get searchForMedicine => 'بحث عن دواء';

  @override
  String get searchForPharmacy => 'بحث عن صيدلية';

  @override
  String get medicineRequestType => 'طلب دواء';

  @override
  String get updateMyLocation => 'تحديث موقعي';

  @override
  String get locatingPharmacies => 'نحدد الصيدليات الأقرب إليك...';

  @override
  String get discoverNearest => 'اكتشف الأقرب إليك';

  @override
  String get nearbyHeaderSubtitle =>
      'اعرض أقرب ثلاث صيدليات والطريق إلى الخيار الأقرب.';

  @override
  String get locatingNow => 'جاري التحديد...';

  @override
  String get myCurrentLocation => 'موقعي الحالي';

  @override
  String get manualLabel => 'يدوي';

  @override
  String get searchRangeLabel => 'نطاق البحث';

  @override
  String get dragMapHint => 'اسحب الخريطة للاستكشاف';

  @override
  String get locationUpdated => 'تم تحديث موقعك وعرض النتائج الأقرب.';

  @override
  String get locationUpdateFailed => 'تعذر تحديث الموقع حاليًا.';

  @override
  String get mapLoadFailed => 'تعذر تحميل الخريطة';

  @override
  String get mapLoadFailedSubtitle =>
      'تأكد من اتصالك بالإنترنت ثم حاول مجددًا.';

  @override
  String get backToMyLocation => 'العودة إلى موقعي';

  @override
  String get showAllLocations => 'عرض جميع المواقع';

  @override
  String get shrinkMap => 'تصغير الخريطة';

  @override
  String get expandMap => 'تكبير الخريطة';

  @override
  String get mapOpenFailed => 'تعذر فتح تطبيق الخرائط.';

  @override
  String routeToNearest(String distance, String time) {
    return '$distance$time إلى الأقرب';
  }

  @override
  String get minuteUnit => 'د';

  @override
  String get exploreMapHint => 'استكشف الصيدليات على الخريطة';

  @override
  String routeMinutes(Object minutes) {
    return 'نحو $minutes دقيقة';
  }

  @override
  String get startDirections => 'بدء الاتجاهات';

  @override
  String get yourCurrentLocation => 'موقعك الحالي';

  @override
  String pharmacyMarkerSemantics(Object number, String name) {
    return 'الصيدلية رقم $number، $name';
  }

  @override
  String get nearestThreePharmacies => 'أقرب 3 صيدليات';

  @override
  String resultsSummaryCounts(Object registered, Object external) {
    return '$registered مسجلة · $external خيارات إضافية';
  }

  @override
  String get nearestLabel => 'الأقرب';

  @override
  String get manualLocationTitle => 'إدخال الموقع يدويًا';

  @override
  String get manualLocationSubtitle => 'أدخل الإحداثيات الدقيقة لموقعك الحالي.';

  @override
  String get latitudeLabel => 'خط العرض';

  @override
  String get latitudeInvalid => 'أدخل خط عرض بين -90 و90.';

  @override
  String get longitudeLabel => 'خط الطول';

  @override
  String get longitudeInvalid => 'أدخل خط طول بين -180 و180.';

  @override
  String get saveLocation => 'حفظ الموقع';

  @override
  String get noLocationTitle => 'لم يتم تحديد الموقع';

  @override
  String get noLocationMessage =>
      'استخدم موقع الجهاز أو أدخل الإحداثيات لعرض الصيدليات.';

  @override
  String get noNearbyTitle => 'لا توجد صيدليات ضمن النطاق';

  @override
  String get noNearbyMessage =>
      'وسّع مسافة البحث أو حدّث موقعك ثم حاول مجددًا.';
}
