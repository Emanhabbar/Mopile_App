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
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingIntroTitle => 'مرحباً بك في دوائي';

  @override
  String get onboardingIntroDesc =>
      'منصة دوائية متكاملة تربط المستخدمين بالصيدليات والمستودعات والمنظمات لوصول أسرع وأسهل إلى الدواء.';

  @override
  String get onboardingSearchTitle => 'ابحث عن دوائك';

  @override
  String get onboardingSearchDesc =>
      'ابحث عن أي دواء، واعرف توفره وأسعاره، وقدّم طلبك بضغطة واحدة.';

  @override
  String get onboardingPharmaciesTitle => 'الصيدليات القريبة منك';

  @override
  String get onboardingPharmaciesDesc =>
      'اكتشف أقرب الصيدليات وساعات عملها وتفاصيلها قبل الزيارة.';

  @override
  String get onboardingInventoryTitle => 'إدارة المخزون والباركود';

  @override
  String get onboardingInventoryDesc =>
      'أدر مخزونك وامسح الباركود وتابع الكميات وتواريخ الصلاحية بسهولة.';

  @override
  String get onboardingDonationsTitle => 'تبرّع وساعد غيرك';

  @override
  String get onboardingDonationsDesc =>
      'شارك في حملات التبرع وقدّم المساعدة واحصل على دعم ذكي من المساعد.';

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
  String get donationsSubtitle => 'دواء يصل إلى من يحتاجه';

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

  @override
  String get chatAssistantSubtitle => 'إرشاد سريع للوصول إلى خدمات دوائي';

  @override
  String get chatLoadingSessions => 'جاري تحميل المحادثات...';

  @override
  String get previousChats => 'المحادثات السابقة';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get chatTitleOptional => 'عنوان المحادثة (اختياري)';

  @override
  String get start => 'بدء';

  @override
  String get startChatFailed => 'تعذر بدء المحادثة حاليًا.';

  @override
  String get howCanIHelp => 'كيف يمكنني مساعدتك؟';

  @override
  String get chatHeroSubtitle =>
      'ابحث عن دواء، صيدلية قريبة، أو خدمة داخل التطبيق.';

  @override
  String get nearbyPharmacy => 'صيدلية قريبة';

  @override
  String get healthServicesHint => 'خدمات صحية';

  @override
  String get chatSessionTitle => 'محادثة دوائية';

  @override
  String messageCount(Object count) {
    return '$count رسائل';
  }

  @override
  String get noPreviousChats => 'لا توجد محادثات سابقة';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsSubtitle => 'كل جديد في مكان واحد';

  @override
  String get markingAllRead => 'جاري التحديث...';

  @override
  String get markAllRead => 'قراءة الكل';

  @override
  String get notificationsLoading => 'جاري تحميل الإشعارات...';

  @override
  String get notifUpdateFailed => 'تعذر تحديث الإشعار.';

  @override
  String markedReadCount(Object count) {
    return 'تم تعليم $count إشعارات كمقروءة.';
  }

  @override
  String get notificationsUpdateFailed => 'تعذر تحديث الإشعارات.';

  @override
  String get notifStatTotal => 'الإجمالي';

  @override
  String get notifStatNew => 'جديدة';

  @override
  String get notifStatRead => 'مقروءة';

  @override
  String get unreadOnlyLabel => 'الجديدة فقط';

  @override
  String get notificationTypeHint => 'نوع الإشعار';

  @override
  String get allNotifications => 'جميع الإشعارات';

  @override
  String get notifTypePrescriptions => 'الوصفات';

  @override
  String get notifTypeRequests => 'الطلبات';

  @override
  String get notifTypeReminders => 'التذكيرات';

  @override
  String get notifTypeApprovals => 'الموافقات';

  @override
  String get notifTypeVerification => 'التحقق';

  @override
  String get notifTypeGeneral => 'عام';

  @override
  String get noNotifications => 'لا توجد إشعارات لعرضها';

  @override
  String get endedConversation => 'محادثة منتهية';

  @override
  String get readyToHelp => 'جاهز لمساعدتك';

  @override
  String get endConversation => 'إنهاء المحادثة';

  @override
  String get chatLoadingMessages => 'جاري تحميل الرسائل...';

  @override
  String get sendMessageFailed => 'تعذر إرسال الرسالة.';

  @override
  String get referencesTitle => 'مراجع دوائية مرتبطة بالإجابة';

  @override
  String get referenceFallback => 'بيانات دوائية مرجعية';

  @override
  String get conversationNotice =>
      'اكتب سؤالك بوضوح لتحصل على نتيجة أدق، ولا تعتمد على المحادثة في الحالات الطارئة.';

  @override
  String get conversationEndedHint => 'تم إنهاء هذه المحادثة';

  @override
  String get typeYourMessage => 'اكتب رسالتك...';

  @override
  String get intelligenceTitle => 'المعلومات الدوائية الذكية';

  @override
  String get searchAlternativesTitle => 'البحث عن بدائل';

  @override
  String get medicineAlternativesHint => 'أدخل اسم الدواء للبحث عن بدائل';

  @override
  String get showAlternatives => 'عرض البدائل';

  @override
  String get noAlternativesFound => 'لم يتم العثور على بدائل مناسبة.';

  @override
  String get stockoutPredictionTitle => 'توقع نفاد المخزون';

  @override
  String get stockLabel => 'المخزون';

  @override
  String get soldLabel => 'المباع';

  @override
  String get averageDailyLabel => 'المتوسط اليومي';

  @override
  String get sales7DaysLabel => 'مبيعات 7 أيام';

  @override
  String get sales30DaysLabel => 'مبيعات 30 يومًا';

  @override
  String get analyzing => 'جاري التحليل...';

  @override
  String get analyzeStock => 'تحليل المخزون';

  @override
  String get enterMedicineFirst => 'أدخل اسم الدواء أولًا.';

  @override
  String get intelligenceUnavailable =>
      'الخدمة الذكية غير متاحة حاليًا. حاول لاحقًا.';

  @override
  String get intelligenceIntro =>
      'نتائج مساعدة لاتخاذ القرار، ويجب مراجعة المختص قبل استبدال أي دواء.';

  @override
  String predictionResult(String days, Object quantity) {
    return 'متوقع النفاد خلال $days يوم\nالكمية المقترحة للطلب: $quantity';
  }

  @override
  String get openNow => 'مفتوحة الآن';

  @override
  String get closedNow => 'مغلقة الآن';

  @override
  String ratingOf(String rating, Object count) {
    return '$rating من $count تقييم';
  }

  @override
  String get openDirections => 'فتح الاتجاهات';

  @override
  String get externalPharmacyNotice =>
      'هذه الصيدلية معروضة من خدمة الخرائط وقد لا تكون مسجلة داخل منصة دوائي.';

  @override
  String distanceMetersFull(String value) {
    return '$value متر';
  }

  @override
  String get organizationsAndCampaignsTitle => 'المنظمات والحملات';

  @override
  String get activeCampaignsTitle => 'الحملات النشطة';

  @override
  String get activeCampaignsSubtitle => 'مبادرات دوائية متاحة للمساهمة';

  @override
  String get campaignsLoading => 'جاري تحميل الحملات...';

  @override
  String get noActiveCampaigns => 'لا توجد حملات نشطة حاليًا.';

  @override
  String get approvedOrganizationsTitle => 'المنظمات المعتمدة';

  @override
  String get approvedOrganizationsSubtitle => 'استعرض الجهات وحملاتها الحالية';

  @override
  String get organizationsLoading => 'جاري تحميل المنظمات...';

  @override
  String get noApprovedOrganizations => 'لا توجد منظمات معتمدة حاليًا.';

  @override
  String get medicineReachesWhoNeedsIt => 'دواء يصل لمن يحتاجه';

  @override
  String orgCampaignSummary(String orgs, String campaigns) {
    return '$orgs منظمة • $campaigns حملة نشطة';
  }

  @override
  String activeCampaignCount(Object count) {
    return '$count حملة نشطة';
  }

  @override
  String get urgent => 'عاجلة';

  @override
  String needLabel(String summary) {
    return 'الاحتياج: $summary';
  }

  @override
  String get organizationDetailsTitle => 'تفاصيل المنظمة';

  @override
  String get organizationLoading => 'جاري تحميل المنظمة...';

  @override
  String get approvedOrganizationLabel => 'منظمة معتمدة';

  @override
  String registrationNumber(Object number) {
    return 'رقم التسجيل: $number';
  }

  @override
  String requestedMedicinesLabel(String summary) {
    return 'الأدوية المطلوبة: $summary';
  }

  @override
  String get donateOffer => 'تقديم عرض تبرع';

  @override
  String get prescriptionStatusReserved => 'محجوزة';

  @override
  String get prescriptionStatusReady => 'جاهزة للاستلام';

  @override
  String get prescriptionStatusCollected => 'تم الاستلام';

  @override
  String get prescriptionStatusExpired => 'منتهية';

  @override
  String get prescriptionStatusCancelled => 'ملغاة';

  @override
  String get prescriptionStatusAnalyzed => 'تم التحليل';

  @override
  String get myPrescriptionsTitle => 'وصفاتي الطبية';

  @override
  String get prescriptionsLoading => 'جاري تحميل الوصفات...';

  @override
  String get previousPrescriptions => 'الوصفات السابقة';

  @override
  String get prescriptionFileTooLarge =>
      'يجب ألا يتجاوز حجم الوصفة 10 ميغابايت.';

  @override
  String get prescriptionAnalyzeFailed => 'تعذر تحليل الوصفة حاليًا.';

  @override
  String get addNewPrescription => 'إضافة وصفة جديدة';

  @override
  String get uploadPrescriptionHint =>
      'اختر صورة واضحة أو ملف PDF لوصفة مطبوعة، بحجم أقصى 10 ميغابايت.';

  @override
  String get choosePrescription => 'اختيار الوصفة';

  @override
  String get prescriptionFallbackTitle => 'وصفة طبية';

  @override
  String prescriptionItemsCount(Object count) {
    return '$count أدوية';
  }

  @override
  String get noPrescriptions => 'لم تتم إضافة أي وصفة بعد';

  @override
  String get prescriptionOrdersTitle => 'طلبات الوصفات';

  @override
  String get refreshOrders => 'تحديث الطلبات';

  @override
  String get ordersLoading => 'جاري تحميل الطلبات...';

  @override
  String matchPercentage(String percent) {
    return 'تطابق $percent٪';
  }

  @override
  String get confirmDeliveryTitle => 'تأكيد تسليم الوصفة';

  @override
  String get pickupCodeLabel => 'رمز الاستلام';

  @override
  String get pickupCodeHint => 'أدخل رمز الاستلام المكون من 8 أرقام';

  @override
  String get confirm => 'تأكيد';

  @override
  String get invalidPickupCode => 'أدخل رمز الاستلام المكون من 8 أرقام.';

  @override
  String get prescriptionCollectedMsg => 'تم تأكيد استلام الوصفة.';

  @override
  String get prescriptionReadyMsg => 'تم تحديث الطلب إلى جاهز للاستلام.';

  @override
  String get prescriptionStatusUpdateFailed => 'تعذر تحديث حالة الوصفة.';

  @override
  String get markReadyAction => 'تحديد كجاهزة للاستلام';

  @override
  String get confirmDeliveryWithCode => 'تأكيد التسليم بالرمز';

  @override
  String get pharmacyPrescriptionsTitle => 'وصفات الصيدلية';

  @override
  String get pharmacyPrescriptionsSubtitle =>
      'جهّز الوصفة ثم أكّد تسليمها بالرمز';

  @override
  String get orderFactActive => 'نشطة';

  @override
  String get orderFactReady => 'جاهزة';

  @override
  String get noPharmacyOrders => 'لا توجد طلبات وصفات للصيدلية';

  @override
  String get prescriptionDetailsTitle => 'تفاصيل الوصفة';

  @override
  String get prescriptionDetailsLoading => 'جاري تحميل الوصفة...';

  @override
  String get medicinesTitle => 'الأدوية';

  @override
  String itemsCount(Object count) {
    return '$count عناصر';
  }

  @override
  String get availablePharmaciesTitle => 'الصيدليات المتاحة';

  @override
  String get availablePharmaciesSubtitle => 'اختر صيدلية لحجز الأدوية المتوفرة';

  @override
  String get noMatchingPharmacy => 'لا توجد صيدلية مطابقة حاليًا.';

  @override
  String get editReminders => 'تعديل التذكيرات';

  @override
  String get activateMedicineReminders => 'تفعيل تذكيرات الدواء';

  @override
  String get cancelPrescription => 'إلغاء الوصفة';

  @override
  String reservedAt(String name) {
    return 'تم حجز الوصفة لدى $name.';
  }

  @override
  String get reserveFailed => 'تعذر حجز الوصفة.';

  @override
  String get cancelPrescriptionTitle => 'إلغاء الوصفة؟';

  @override
  String get cancelPrescriptionConfirm =>
      'سيتم إلغاء الحجز وإعادة الكميات إلى مخزون الصيدلية.';

  @override
  String get prescriptionCancelled => 'تم إلغاء الوصفة.';

  @override
  String get cancelFailed => 'تعذر إلغاء الوصفة.';

  @override
  String get remindersSaved => 'تم حفظ إعدادات التذكير.';

  @override
  String get remindersSaveFailed => 'تعذر حفظ التذكيرات.';

  @override
  String get importantWarnings => 'تنبيهات مهمة';

  @override
  String prescriptionMedicinesAvailable(Object available, Object total) {
    return '$available/$total أدوية متوفرة';
  }

  @override
  String get reserveFullPrescription => 'حجز الوصفة كاملة';

  @override
  String get reserveAvailableMedicines => 'حجز الأدوية المتوفرة';

  @override
  String get pickupCodeTitle => 'رمز استلام الوصفة';

  @override
  String get pickupCodeNote => 'قدّم هذا الرمز للصيدلية عند الاستلام.';

  @override
  String get reminderSettingsTitle => 'إعداد التذكيرات';

  @override
  String get dailyDoseReminder => 'تذكير الجرعات اليومية';

  @override
  String get refillReminder => 'تذكير إعادة التعبئة';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get treatmentDurationLabel => 'مدة العلاج بالأيام';

  @override
  String get refillAfterLabel => 'التعبئة بعد أيام';

  @override
  String get save => 'حفظ';

  @override
  String get medicinesCatalogTitle => 'دليل الأدوية';

  @override
  String get addMedicine => 'إضافة دواء';

  @override
  String get catalogLoading => 'جاري تحميل دليل الأدوية...';

  @override
  String get catalogSubtitle => 'ابحث عن الأدوية واطلع على تفاصيلها';

  @override
  String get searchLabel => 'بحث';

  @override
  String get catalogSearchHint => 'ابحث باسم الدواء، الاسم العلمي أو الشركة';

  @override
  String get byPrescriptionTag => 'بوصفة طبية';

  @override
  String get loadingMore => 'جاري تحميل المزيد...';

  @override
  String get emptyCatalogTitle => 'دليل الأدوية فارغ';

  @override
  String get noSearchResultsTitle => 'لا توجد نتائج مطابقة';

  @override
  String get emptyCatalogNoSearch => 'ستظهر الأدوية المسجلة هنا.';

  @override
  String get noSearchResultsHint => 'جرّب اسمًا آخر أو جزءًا من الاسم العلمي.';

  @override
  String get medicineDetailsTitle => 'تفاصيل الدواء';

  @override
  String get medicineDetailsLoading => 'جاري تحميل بيانات الدواء...';

  @override
  String get withoutPrescription => 'بدون وصفة';

  @override
  String get pharmaInfoTitle => 'المعلومات الدوائية';

  @override
  String get arabicScientificNameLabel => 'الاسم العلمي بالعربية';

  @override
  String get englishScientificNameLabel => 'الاسم العلمي بالإنكليزية';

  @override
  String get englishNameLabel => 'الاسم الإنكليزي';

  @override
  String get barcodeLabel => 'الباركود';

  @override
  String get compositionLabel => 'التركيب';

  @override
  String get dosageFormLabel => 'الشكل الدوائي';

  @override
  String get capacityLabel => 'السعة أو التركيز';

  @override
  String get packageSizeLabel => 'حجم العبوة';

  @override
  String get manufacturingTitle => 'التصنيع والتوفر';

  @override
  String get manufacturerLabel => 'الشركة المصنعة';

  @override
  String get referenceQuantityLabel => 'الكمية المرجعية';

  @override
  String get sellingPriceLabel => 'سعر البيع';

  @override
  String get purchasePriceLabel => 'سعر الشراء';

  @override
  String get editArabicNames => 'تعديل الاسم العربي وأسماء البحث';

  @override
  String get medicineArabicDataTitle => 'البيانات العربية للدواء';

  @override
  String get arabicNameLabel => 'الاسم العربي';

  @override
  String get otherSearchNamesLabel => 'أسماء أخرى للبحث';

  @override
  String get aliasesSeparatorHint => 'افصل بين الأسماء بفاصلة';

  @override
  String get arabicDataUpdated => 'تم تحديث البيانات العربية للدواء.';

  @override
  String get dataSaveFailed => 'تعذر حفظ البيانات.';

  @override
  String get quickFormLabel => 'الشكل';

  @override
  String get descriptionTitle => 'الوصف';

  @override
  String get disclaimerText =>
      'هذه البيانات تعريفية. التزم بتوجيهات الطبيب أو الصيدلي ولا تغيّر علاجك دون استشارة مختص.';

  @override
  String get createMedicineIntro =>
      'أدخل بيانات الدواء بدقة. سيصبح الدواء متاحًا للصيدليات لإضافته إلى مخزونها بعد الحفظ.';

  @override
  String get basicDataTitle => 'البيانات الأساسية';

  @override
  String get englishTradeNameLabel => 'الاسم التجاري بالإنكليزية';

  @override
  String get englishTradeNameHint => 'مثال: Paracetamol 500';

  @override
  String get medicineNameRequired => 'اسم الدواء مطلوب.';

  @override
  String get arabicTradeNameLabel => 'الاسم التجاري بالعربية';

  @override
  String get arabicTradeNameHint => 'مثال: باراسيتامول 500';

  @override
  String get barcodeHint => 'أرقام أو أحرف أو شرطة';

  @override
  String get optionalHint => 'اختياري';

  @override
  String get categoryManufacturingTitle => 'التصنيف والتصنيع';

  @override
  String get capacityFieldLabel => 'السعة';

  @override
  String get capacityHint => '500 mg';

  @override
  String get packageSizeHint => 'مثال: 20 قرصًا';

  @override
  String get detailedInfoTitle => 'المعلومات التفصيلية';

  @override
  String get compositionHint => 'المواد الفعالة والتركيب';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get descriptionHint => 'وصف مختصر ودقيق للدواء';

  @override
  String get saveMedicine => 'حفظ الدواء';

  @override
  String get medicineAdded => 'تمت إضافة الدواء بنجاح.';

  @override
  String get medicineAddFailed => 'تعذر إضافة الدواء حاليًا.';

  @override
  String get requiresPrescriptionSwitchTitle => 'يتطلب وصفة طبية';

  @override
  String get requiresPrescriptionSwitchSubtitle =>
      'فعّل الخيار إذا كان صرف الدواء يحتاج وصفة';

  @override
  String maxLengthMessage(Object max) {
    return 'الحد الأقصى $max حرفًا.';
  }

  @override
  String get maxLength64 => 'الحد الأقصى 64 محرفًا.';

  @override
  String get barcodeInvalidChars =>
      'استخدم الأرقام أو الأحرف الإنكليزية أو الشرطة فقط.';

  @override
  String get enterValidNumber => 'أدخل رقمًا صحيحًا.';

  @override
  String get valueNotNegative => 'لا يمكن أن تكون القيمة سالبة.';

  @override
  String get enterValidInteger => 'أدخل عددًا صحيحًا.';

  @override
  String get donationsTitle => 'التبرعات والمساعدة';

  @override
  String get donationOfferAction => 'عرض تبرع';

  @override
  String get assistanceRequestAction => 'طلب مساعدة';

  @override
  String get givingStartsWithStep => 'العطاء يبدأ بخطوة';

  @override
  String get donationHeroSubtitle =>
      'قدّم دواءً صالحًا أو اطلب المساعدة عبر الجهات المشاركة.';

  @override
  String get donationOffersTab => 'عروض التبرع';

  @override
  String get assistanceRequestsTab => 'طلبات المساعدة';

  @override
  String get offersLoading => 'جاري تحميل عروضك...';

  @override
  String get noDonationOffers => 'لا توجد عروض تبرع موجهة للمنظمة.';

  @override
  String get noAssistanceRequests => 'لا توجد طلبات مساعدة حاليًا.';

  @override
  String get donationStatusApproved => 'مقبول';

  @override
  String get donationStatusReceived => 'تم الاستلام';

  @override
  String get donationStatusRejected => 'مرفوض';

  @override
  String get donationStatusFulfilled => 'تمت المساعدة';

  @override
  String get donationStatusCancelled => 'ملغى';

  @override
  String get donationStatusUnderReview => 'قيد المراجعة';

  @override
  String get donationStatusOpen => 'مفتوح';

  @override
  String get statusOpen => 'مفتوح';

  @override
  String packagesCount(Object count) {
    return '$count عبوات';
  }

  @override
  String get targetOrganization => 'منظمة';

  @override
  String campaignLabel(String title) {
    return 'الحملة: $title';
  }

  @override
  String organizationNoteLabel(String note) {
    return 'ملاحظة المنظمة: $note';
  }

  @override
  String neededBeforeLabel(String date) {
    return 'مطلوب قبل $date';
  }

  @override
  String organizationResponseLabel(String note) {
    return 'رد المنظمة: $note';
  }

  @override
  String get verifyDonationsTitle => 'التحقق من التبرعات';

  @override
  String get verifyDonationsSubtitle => 'سلامة الدواء قبل وصوله للمستفيد';

  @override
  String get donationOffersLoading => 'جاري تحميل عروض التبرع...';

  @override
  String get noDonationsToVerify => 'لا توجد تبرعات بانتظار التحقق.';

  @override
  String get reviewNoteLabel => 'ملاحظة الفحص (اختياري)';

  @override
  String get reviewNoteHint => 'أضف ملاحظات حول فحص التبرع';

  @override
  String get donationStatusUpdated => 'تم تحديث حالة التبرع بنجاح.';

  @override
  String get donationUpdateFailed => 'تعذر تحديث التبرع.';

  @override
  String get pharmacyReviewTitle => 'مراجعة دقيقة وآمنة';

  @override
  String get pharmacyReviewSubtitle =>
      'افحص العبوات ثم حدّث حالتها حسب نتيجة التحقق.';

  @override
  String donorLabel(String name) {
    return 'المتبرع: $name';
  }

  @override
  String beneficiaryLabel(String name) {
    return 'الجهة المستفيدة: $name';
  }

  @override
  String expiryLabel(String date) {
    return 'الانتهاء: $date';
  }

  @override
  String get acceptAfterInspection => 'قبول بعد الفحص';

  @override
  String get reject => 'رفض';

  @override
  String get confirmReceivePackages => 'تأكيد استلام العبوات';

  @override
  String get statusPendingInspection => 'بانتظار الفحص';

  @override
  String get actionApproveDonation => 'اعتماد التبرع';

  @override
  String get actionRejectDonation => 'رفض التبرع';

  @override
  String get actionConfirmReceipt => 'تأكيد الاستلام';

  @override
  String get actionUpdateDonation => 'تحديث التبرع';

  @override
  String get offerDonationTitle => 'تقديم عرض تبرع';

  @override
  String get assistanceRequestPageTitle => 'طلب مساعدة دوائية';

  @override
  String get chooseMedicineSection => 'اختيار الدواء';

  @override
  String get chooseMedicineSectionSubtitle =>
      'ابحث في دليل الأدوية وحدد الصنف المطلوب';

  @override
  String get medicineSearchLabel => 'البحث عن دواء';

  @override
  String get medicineSearchHint => 'ابحث باسم الدواء ثم اختر من النتائج';

  @override
  String get catalogLoadFailed => 'تعذر تحميل دليل الأدوية.';

  @override
  String get medicineDropdownLabel => 'الدواء';

  @override
  String get medicineDropdownHint => 'اختر الدواء من الدليل';

  @override
  String get chooseMedicineFromCatalog => 'اختر الدواء من الدليل.';

  @override
  String get verificationPharmacySection => 'صيدلية التحقق والاستلام';

  @override
  String get verificationPharmacySectionSubtitle =>
      'ستتأكد الصيدلية من سلامة العبوات قبل تسليمها';

  @override
  String get verificationPharmaciesLoadFailed =>
      'تعذر تحميل صيدليات التحقق المعتمدة.';

  @override
  String get verificationPharmacyLabel => 'صيدلية التحقق';

  @override
  String get verificationPharmacyHint => 'اختر الصيدلية المعتمدة';

  @override
  String get chooseVerificationPharmacy =>
      'اختر الصيدلية التي ستتحقق من التبرع.';

  @override
  String get organizationSection => 'الجهة والتفاصيل';

  @override
  String get organizationSectionOfferSubtitle =>
      'حدد الجهة المستفيدة وبيانات العبوات';

  @override
  String get organizationSectionRequestSubtitle =>
      'حدد الجهة المستهدفة واحتياجك الدوائي';

  @override
  String get organizationsLoadFailed => 'تعذر تحميل المنظمات.';

  @override
  String get organizationDropdownLabel => 'المنظمة';

  @override
  String get organizationDropdownOfferHint => 'اختر الجهة المستفيدة';

  @override
  String get organizationDropdownRequestHint => 'اختر المنظمة المستهدفة';

  @override
  String get noSpecificOrganization => 'بدون منظمة محددة';

  @override
  String get chooseTargetOrganization => 'اختر المنظمة المستهدفة.';

  @override
  String get campaignOptionalLabel => 'الحملة (اختياري)';

  @override
  String get noSpecificCampaign => 'بدون حملة محددة';

  @override
  String get donatedPackagesLabel => 'عدد العبوات المتبرع بها';

  @override
  String get requestedPackagesLabel => 'عدد العبوات المطلوبة';

  @override
  String get packageCountHint => 'أدخل كمية بين 1 و1000';

  @override
  String get packageCountInvalid => 'أدخل عددًا بين 1 و1000.';

  @override
  String get medicineExpiryDate => 'تاريخ انتهاء الدواء';

  @override
  String get neededBeforeDate => 'مطلوب قبل تاريخ';

  @override
  String get sealedPackagesTitle => 'العبوات مغلقة ولم تُفتح';

  @override
  String get sealedPackagesSubtitle => 'تأكد من سلامة العبوة قبل تقديم العرض.';

  @override
  String get notesOptionalLabel => 'ملاحظات (اختياري)';

  @override
  String get notesHint => 'أضف أي تفاصيل إضافية';

  @override
  String get offerSubmitted => 'تم إرسال العرض إلى صيدلية التحقق بنجاح.';

  @override
  String get assistanceSubmitted => 'تم إرسال طلب المساعدة إلى المنظمة.';

  @override
  String get submitFailed => 'تعذر إرسال البيانات حاليًا.';

  @override
  String get donationOfferHeroTitle => 'عرض تبرع دوائي';

  @override
  String get donationOfferHeroSubtitle =>
      'أدخل بيانات دقيقة لتسهيل التحقق والاستلام.';

  @override
  String get assistanceHeroTitle => 'طلب مساعدة دوائية';

  @override
  String get assistanceHeroSubtitle =>
      'أدخل احتياجك واختر المنظمة المناسبة للطلب.';

  @override
  String get scanMedicineBarcode => 'مسح باركود الدواء';

  @override
  String get toggleFlash => 'تشغيل الإضاءة';

  @override
  String get cameraError =>
      'تعذر تشغيل الكاميرا. اسمح للتطبيق باستخدامها أو أدخل الباركود يدوياً.';

  @override
  String get placeBarcodeInFrame => 'ضع الرمز داخل الإطار وثبّت الهاتف للحظة';

  @override
  String get enterBarcodeManually => 'إدخال الباركود يدوياً';

  @override
  String get enterBarcodeTitle => 'إدخال الباركود';

  @override
  String get barcodeNumberLabel => 'رقم الباركود';

  @override
  String get use => 'استخدام';

  @override
  String get medicineRequestsTitle => 'طلبات الأدوية';

  @override
  String get searchRequestField => 'ابحث بالدواء أو اسم المستخدم أو الهاتف';

  @override
  String get requestsOverviewTitle => 'متابعة الطلبات';

  @override
  String pendingNeedReply(Object count) {
    return '$count طلب يحتاج إلى ردك الآن';
  }

  @override
  String get noPendingRequests => 'لا توجد طلبات معلّقة ضمن هذه القائمة';

  @override
  String get overviewAvailable => 'متوفر';

  @override
  String get overviewOrders => 'الطلبات';

  @override
  String quantityRequestedValue(Object count) {
    return 'الكمية $count';
  }

  @override
  String get replyNow => 'الرد الآن';

  @override
  String get requestStatusWaitingReply => 'بانتظار الرد';

  @override
  String get noMatchingRequests => 'لا توجد طلبات مطابقة';

  @override
  String get noMatchingRequestsSubtitle =>
      'ستظهر هنا طلبات الأدوية الجديدة الواردة من المستخدمين.';

  @override
  String get statusWaitingYou => 'بانتظارك';

  @override
  String get workingHoursTitle => 'ساعات العمل';

  @override
  String get saveTooltip => 'حفظ';

  @override
  String get restoreSavedHours => 'استعادة الساعات المحفوظة';

  @override
  String get workingHoursLoading => 'جاري تحميل ساعات العمل...';

  @override
  String get overnightHint =>
      'للدوام بعد منتصف الليل اختر وقت إغلاق أسبق من وقت الفتح، وسيُحفظ لليوم التالي تلقائيًا.';

  @override
  String get pharmacyClosed => 'الصيدلية مغلقة';

  @override
  String get overnightShift => 'دوام ممتد لليوم التالي';

  @override
  String get timeFrom => 'من';

  @override
  String get timeTo => 'إلى';

  @override
  String get endsNextDay => 'ينتهي الدوام في اليوم التالي';

  @override
  String get openingTimeHelp => 'وقت بدء الدوام';

  @override
  String get closingTimeHelp => 'وقت انتهاء الدوام';

  @override
  String get timesMustDiffer => 'وقت الفتح والإغلاق يجب أن يكونا مختلفين.';

  @override
  String get workingHoursSaved => 'تم حفظ ساعات العمل.';

  @override
  String get workingHoursSaveFailed => 'تعذر حفظ ساعات العمل.';

  @override
  String get scheduleTitle => 'جدول الصيدلية';

  @override
  String get scheduleSubtitle => 'حدّد أوقات استقبال طلبات المستخدمين';

  @override
  String get workDays => 'أيام عمل';

  @override
  String get overnightLabel => 'ليلي';

  @override
  String get refreshRequest => 'تحديث الطلب';

  @override
  String get openingRequest => 'جاري فتح الطلب...';

  @override
  String get confirmingProgress => 'جاري التأكيد...';

  @override
  String get confirmUserPickup => 'تأكيد استلام المستخدم للدواء';

  @override
  String get respondToRequest => 'الرد على الطلب';

  @override
  String get replyWillReachUser => 'سيصل اختيارك وملاحظتك إلى المستخدم';

  @override
  String get suggestAlternativeHint => 'يمكنك اقتراح بديل متوفر بدلًا منه';

  @override
  String get availableAlternativeLabel => 'بديل متاح (اختياري)';

  @override
  String get noteToUserOptional => 'ملاحظة للمستخدم (اختياري)';

  @override
  String get sendReply => 'إرسال الرد';

  @override
  String get replySent => 'تم إرسال الرد إلى المستخدم.';

  @override
  String get sendReplyFailed => 'تعذر إرسال الرد.';

  @override
  String get pickupConfirmed => 'تم تأكيد استلام المستخدم للدواء.';

  @override
  String get confirmPickupFailed => 'تعذر تأكيد استلام الدواء.';

  @override
  String get medicineDataTitle => 'بيانات الدواء';

  @override
  String get scientificNameLabel => 'الاسم العلمي';

  @override
  String get notRegistered => 'غير مسجل';

  @override
  String get formConcentrationLabel => 'الشكل والتركيز';

  @override
  String userNoteLabel(String note) {
    return 'ملاحظة المستخدم: $note';
  }

  @override
  String get userDataTitle => 'بيانات المستخدم';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get emailLabel => 'البريد';

  @override
  String get requestProcessed => 'تمت معالجة هذا الطلب';

  @override
  String get licenseVerificationTitle => 'التحقق من ترخيص الصيدلية';

  @override
  String get refreshStatus => 'تحديث الحالة';

  @override
  String get reviewingStatus => 'جاري مراجعة الحالة...';

  @override
  String get selectLicenseImage => 'اختيار صورة الترخيص وإرسالها';

  @override
  String get sendNewLicenseImage => 'إرسال صورة أحدث للترخيص';

  @override
  String get imageTooLarge => 'حجم الصورة يجب ألا يتجاوز 8 ميغابايت.';

  @override
  String get licenseSubmitted =>
      'تم إرسال الترخيص، ويمكنك متابعة نتيجة المراجعة من هنا.';

  @override
  String get licenseSubmitFailed => 'تعذر إرسال صورة الترخيص.';

  @override
  String get sendLicenseIntro => 'أرسل صورة واضحة من الترخيص لبدء المراجعة.';

  @override
  String lastFileLabel(String name) {
    return 'آخر ملف: $name';
  }

  @override
  String get beforeSendingTitle => 'قبل الإرسال';

  @override
  String get tipFullLicense => 'التقط الترخيص كاملاً دون قص الحواف.';

  @override
  String get tipClearDetails => 'تأكد من وضوح الاسم والرقم والأختام.';

  @override
  String get tipAcceptedFormats => 'الصيغ المقبولة: JPG أو PNG أو WEBP.';

  @override
  String get reviewDetailsTitle => 'تفاصيل المراجعة';

  @override
  String get registeredNameLabel => 'الاسم المسجل';

  @override
  String get licenseNameLabel => 'الاسم في الترخيص';

  @override
  String get registryNumberLabel => 'رقم السجل';

  @override
  String get documentNumberLabel => 'رقم الوثيقة';

  @override
  String get attemptCountLabel => 'عدد مرات الإرسال';

  @override
  String get manualReviewNoteLabel => 'ملاحظة المراجعة';

  @override
  String get licenseStatusVerified => 'تم التحقق من الترخيص';

  @override
  String get licenseStatusRejected => 'يحتاج الترخيص إلى إعادة إرسال';

  @override
  String get licenseStatusFailed => 'تعذرت قراءة الترخيص';

  @override
  String get licenseStatusManualReview => 'قيد المراجعة';

  @override
  String get licenseStatusProcessing => 'جاري مراجعة الترخيص';

  @override
  String get licenseStatusDefault => 'توثيق ترخيص الصيدلية';

  @override
  String get prepareMedicinesTitle => 'تجهيز الأدوية المختارة';

  @override
  String get prepareMedicinesSubtitle =>
      'أدخل سعر كل دواء، ثم راجع باقي بيانات المخزون.';

  @override
  String get applyCommonSettings => 'تطبيق إعدادات مشتركة على الجميع';

  @override
  String pricesProgress(Object completed, Object total) {
    return '$completed/$total أسعار';
  }

  @override
  String addMedicinesToStock(Object count) {
    return 'إضافة $count أدوية إلى المخزون';
  }

  @override
  String get removeFromList => 'إزالة من القائمة';

  @override
  String get concentrationLabel => 'التركيز';

  @override
  String get formLabel => 'الشكل';

  @override
  String get packageLabel => 'العبوة';

  @override
  String get sellingPriceFieldLabel => 'سعر البيع لهذا الدواء *';

  @override
  String get priceHint => 'مثال: 8500';

  @override
  String get currencySuffix => 'ل.س';

  @override
  String get enterPositivePrice => 'أدخل سعرًا أكبر من صفر.';

  @override
  String get invalidValue => 'قيمة غير صحيحة';

  @override
  String get enterQuantity => 'أدخل كمية';

  @override
  String get thresholdLabel => 'حد التنبيه';

  @override
  String get expiryDateLabel => 'تاريخ الصلاحية';

  @override
  String get removeDate => 'إزالة التاريخ';

  @override
  String get availableForOrder => 'متاح للطلب';

  @override
  String get showPriceToUser => 'إظهار السعر للمستخدم';

  @override
  String get priceHiddenHint =>
      'يمكن الاحتفاظ بالسعر داخليًا وإخفاؤه عند الحاجة';

  @override
  String get commonSettingsTitle => 'إعدادات مشتركة';

  @override
  String get commonSettingsDesc =>
      'ستُطبق هذه القيم على جميع الأدوية، بينما يبقى السعر مستقلًا لكل دواء.';

  @override
  String get lowStockThresholdLabel => 'حد المخزون المنخفض';

  @override
  String get applyToAll => 'تطبيق على الجميع';

  @override
  String get pharmacyDataTitle => 'بيانات الصيدلية';

  @override
  String get refreshData => 'تحديث البيانات';

  @override
  String get pharmacyProfileLoading => 'جاري تحميل ملف الصيدلية...';

  @override
  String get generalDataTitle => 'البيانات العامة';

  @override
  String get generalDataSubtitle =>
      'المعلومات التي تظهر للمستخدم عند فتح الصيدلية';

  @override
  String get pharmacyNameLabel => 'اسم الصيدلية';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get areaLabel => 'المنطقة';

  @override
  String get detailedAddressLabel => 'العنوان التفصيلي';

  @override
  String get pharmacyDescriptionLabel => 'وصف الصيدلية';

  @override
  String get deliveryServiceTitle => 'خدمة توصيل الأدوية';

  @override
  String get deliveryServiceSubtitle => 'أخبر المستخدمين بتوفر التوصيل';

  @override
  String get saveProfile => 'حفظ الملف';

  @override
  String get pharmacyLocationTitle => 'موقع الصيدلية';

  @override
  String get pharmacyLocationSubtitle =>
      'موقع دقيق يساعد المستخدم في العثور عليك بسهولة';

  @override
  String get automaticLocation => 'تحديد تلقائي';

  @override
  String get useDeviceLocation => 'استخدم موقع هذا الجهاز';

  @override
  String get orEnterCoordinates => 'أو أدخل الإحداثيات يدويًا';

  @override
  String get saveCoordinates => 'حفظ الإحداثيات';

  @override
  String get matchRegisteredPlace => 'مطابقة الموقع مع المكان المسجل';

  @override
  String get completeProfileFields =>
      'أكمل اسم الصيدلية والمدينة والمنطقة والعنوان.';

  @override
  String get pharmacyProfileSaved => 'تم حفظ بيانات الصيدلية.';

  @override
  String get invalidLatitude => 'أدخل خط عرض صحيحًا بين -90 و90.';

  @override
  String get invalidLongitude => 'أدخل خط طول صحيحًا بين -180 و180.';

  @override
  String get locationSaved => 'تم حفظ الموقع.';

  @override
  String get chooseCorrectPlace => 'اختر المكان الصحيح';

  @override
  String get noMatchingPlace =>
      'لم يتم العثور على مكان مطابق بالقرب من الإحداثيات.';

  @override
  String get matchRegisteredPlaceSuccess =>
      'تم ربط موقع الصيدلية بالمكان المسجل.';

  @override
  String get approvedAccount => 'حساب معتمد';

  @override
  String get pendingApproval => 'بانتظار الاعتماد';

  @override
  String get locationSavedBadge => 'الموقع محفوظ';

  @override
  String get locationIncomplete => 'الموقع غير مكتمل';

  @override
  String get inventoryTitle => 'مخزون الأدوية';

  @override
  String get scanBarcode => 'مسح باركود';

  @override
  String get arabicLabel => 'عربي';

  @override
  String get showArabicNamesTooltip => 'إظهار الأسماء العربية';

  @override
  String get refreshInventoryTooltip => 'تحديث المخزون';

  @override
  String get searchByMedicineOrScientificName =>
      'ابحث باسم الدواء أو الاسم العلمي';

  @override
  String get inventoryLoading => 'جاري تحميل المخزون...';

  @override
  String inventoryBatchAdded(Object count) {
    return 'تمت إضافة $count أدوية إلى المخزون.';
  }

  @override
  String get manualMedicineCreated => 'تم إنشاء الدواء وإضافته إلى المخزون.';

  @override
  String get inventoryItemAdded => 'تمت إضافة الدواء.';

  @override
  String get inventoryItemUpdated => 'تم تحديث الصنف.';

  @override
  String get inventoryItemDeleted => 'تم حذف الصنف.';

  @override
  String get deleteItemTitle => 'حذف الصنف؟';

  @override
  String deleteItemConfirm(Object name) {
    return 'سيتم حذف $name من مخزون الصيدلية.';
  }

  @override
  String get inventoryManagement => 'إدارة المخزون';

  @override
  String inventoryOverviewSummary(Object count, Object available) {
    return '$count صنف · $available متاح للطلب';
  }

  @override
  String get availableLabel => 'متوفر';

  @override
  String get lowLabel => 'منخفض';

  @override
  String get outOfStockLabel => 'نافد';

  @override
  String get itemOptions => 'خيارات الصنف';

  @override
  String get editLabel => 'تعديل';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get hiddenLabel => 'مخفي';

  @override
  String get statusLabel => 'الحالة';

  @override
  String concentrationChip(Object value) {
    return 'التركيز: $value';
  }

  @override
  String dosageFormChip(Object value) {
    return 'الشكل: $value';
  }

  @override
  String get notAvailable => 'غير متاح';

  @override
  String expiresOn(Object date) {
    return 'ينتهي $date';
  }

  @override
  String get lowStockLabel => 'مخزون منخفض';

  @override
  String get addToInventoryTitle => 'إضافة إلى المخزون';

  @override
  String get addToInventorySubtitle => 'اختر الطريقة الأنسب لإدخال الدواء.';

  @override
  String get chooseFromCatalog => 'اختيار من دليل الأدوية';

  @override
  String get chooseFromCatalogSubtitle =>
      'اختر دواءً واحدًا أو عدة أدوية دفعة واحدة';

  @override
  String get scanPackageBarcode => 'مسح باركود العبوة';

  @override
  String get scanPackageBarcodeSubtitle => 'اعثر على الدواء مباشرة بالكاميرا';

  @override
  String get addMedicineManually => 'إضافة دواء يدويًا';

  @override
  String get addMedicineManuallySubtitle =>
      'استخدمها عندما لا تجد الدواء في الدليل';

  @override
  String get newMedicineDataTitle => 'بيانات الدواء الجديد';

  @override
  String get newMedicineDataSubtitle =>
      'اكتب البيانات كما تظهر على عبوة الدواء لتسهيل العثور عليه.';

  @override
  String get medicineNameEnglishLabel => 'اسم الدواء بالإنكليزية *';

  @override
  String get medicineNameArabicLabel => 'اسم الدواء بالعربية';

  @override
  String get scanWithCamera => 'مسح بالكاميرا';

  @override
  String get scientificNameEnglishLabel => 'الاسم العلمي بالإنكليزية';

  @override
  String get scientificNameArabicLabel => 'الاسم العلمي بالعربية';

  @override
  String get concentrationOrCapacityLabel => 'التركيز أو السعة';

  @override
  String get continueToInventoryData => 'متابعة إلى بيانات المخزون';

  @override
  String get additionalDescriptionLabel => 'وصف إضافي';

  @override
  String get catalogSelectionTitle => 'اختيار أدوية من الدليل';

  @override
  String get catalogSelectionSubtitle =>
      'يمكنك اختيار دواء واحد أو عدة أدوية وإضافتها دفعة واحدة.';

  @override
  String get showArabicName => 'إظهار الاسم العربي';

  @override
  String selectedMedicinesCount(Object count) {
    return 'تم اختيار $count دواء';
  }

  @override
  String get catalogOpening => 'جاري فتح دليل الأدوية...';

  @override
  String get noMatchingMedicines => 'لا توجد أدوية مطابقة لبحثك.';

  @override
  String get selectAtLeastOneMedicine => 'اختر دواءً واحدًا على الأقل';

  @override
  String continueWithSelectedCount(Object count) {
    return 'متابعة مع $count دواء';
  }

  @override
  String get reloadMore => 'إعادة تحميل المزيد';

  @override
  String get scrollForMore => 'مرّر للأسفل لعرض المزيد';

  @override
  String shownCountOfTotal(Object loaded, Object total) {
    return 'تم عرض $loaded من $total دواء';
  }

  @override
  String get enterInventoryAvailability =>
      'أدخل بيانات توفر الدواء داخل صيدليتك.';

  @override
  String get updateInventoryData =>
      'حدّث الكمية والسعر وحالة العرض للمستخدمين.';

  @override
  String get priceInSyrianPounds => 'السعر بالليرة السورية';

  @override
  String priceValue(Object value) {
    return '$value ل.س';
  }

  @override
  String get invalidNumbersError =>
      'أدخل أرقامًا صحيحة؛ لا يمكن أن تكون الكمية أو السعر أو حد المخزون أقل من صفر.';

  @override
  String get saveItem => 'حفظ الصنف';

  @override
  String get noMatchingItems => 'لا توجد أصناف مطابقة';

  @override
  String get noMatchingItemsSubtitle =>
      'غيّر البحث أو أضف دواءً جديدًا من دليل الأدوية.';

  @override
  String get allLabel => 'الكل';

  @override
  String get dashboardPreparingPharmacy => 'نجهّز مركز تشغيل الصيدلية...';

  @override
  String get pharmacyOperationsSection => 'تشغيل الصيدلية';

  @override
  String get pharmacyOperationsSectionSubtitle => 'اختصارات لأهم مهامك اليومية';

  @override
  String get quickOverviewSection => 'نظرة سريعة';

  @override
  String get quickOverviewSectionSubtitle => 'مؤشرات المخزون والطلبات الحالية';

  @override
  String get inventoryAlertsSection => 'تنبيهات المخزون';

  @override
  String get inventoryAlertsSectionSubtitle =>
      'الأصناف التي تحتاج تدخلك قريبًا';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get verifyPharmacyLicense => 'التحقق من ترخيص الصيدلية';

  @override
  String get managePrescriptions => 'إدارة الوصفات الطبية';

  @override
  String get donationsLabel => 'التبرعات';

  @override
  String get analyzeInventory => 'تحليل المخزون';

  @override
  String get inventoryLabel => 'المخزون';

  @override
  String get manageItems => 'إدارة الأصناف';

  @override
  String lowStockCount(Object count) {
    return '$count منخفض';
  }

  @override
  String get ordersLabel => 'الطلبات';

  @override
  String get followReplies => 'متابعة الردود';

  @override
  String pendingRequestsBadge(Object count) {
    return '$count بانتظارك';
  }

  @override
  String get organizeHours => 'تنظيم الدوام';

  @override
  String get pharmacyProfile => 'ملف الصيدلية';

  @override
  String get locationAndData => 'الموقع والبيانات';

  @override
  String get inventoryItemsLabel => 'أصناف المخزون';

  @override
  String get addPharmacyLocation => 'أضف موقع الصيدلية لتظهر للمستخدمين';

  @override
  String get newLabel => 'جديد';

  @override
  String get activeRequests => 'طلبات نشطة';

  @override
  String get approvePharmacyAccount => 'اعتماد حساب الصيدلية';

  @override
  String get completedLabel => 'مكتمل';

  @override
  String get pendingReview => 'بانتظار المراجعة';

  @override
  String get locationSet => 'تم تحديده';

  @override
  String get requiredToAppear => 'مطلوب للظهور للمستخدمين';

  @override
  String get hoursConfigured => 'تم إعدادها';

  @override
  String get setWorkingHours => 'حدد أوقات الدوام';

  @override
  String inventoryItemsCountValue(Object count) {
    return '$count صنف';
  }

  @override
  String get addFirstMedicine => 'أضف أول دواء';

  @override
  String get pharmacyReadiness => 'جاهزية الصيدلية';

  @override
  String profileCompletionValue(Object percent) {
    return '$percent٪ من الملف مكتمل';
  }

  @override
  String inventoryAlertLowStock(Object quantity, Object threshold) {
    return 'الكمية $quantity · الحد الأدنى $threshold';
  }

  @override
  String inventoryAlertExpiry(Object days) {
    return 'متبقي $days يومًا على الانتهاء';
  }

  @override
  String get inventoryHealthy => 'المخزون مستقر ولا توجد تنبيهات عاجلة';

  @override
  String profileCompletionLabel(Object value) {
    return 'اكتمال الملف $value٪';
  }

  @override
  String get organizationManagement => 'إدارة المنظمة';

  @override
  String get orgManagementSubtitle => 'المبادرات والتبرعات والمستفيدون';

  @override
  String get refreshDataTooltip => 'تحديث البيانات';

  @override
  String get moreLabel => 'المزيد';

  @override
  String get editOrganizationData => 'تعديل بيانات المنظمة';

  @override
  String get uploadVerificationDocument => 'رفع وثيقة تحقق';

  @override
  String get newCampaign => 'حملة جديدة';

  @override
  String get addCampaignInfoSubtitle => 'أضف معلومات واضحة تساعد المتبرعين.';

  @override
  String get campaignTitleField => 'عنوان الحملة';

  @override
  String get campaignDescriptionField => 'وصف الحملة';

  @override
  String get requestedMedicinesField => 'الأدوية المطلوبة (اختياري)';

  @override
  String get urgentCampaign => 'حملة عاجلة';

  @override
  String get urgentCampaignSubtitle => 'تظهر بأولوية بصرية أعلى.';

  @override
  String get acceptPublicDonations => 'استقبال تبرعات عامة';

  @override
  String get acceptPublicDonationsSubtitle =>
      'يمكن للمستخدمين دعم الحملة مباشرة.';

  @override
  String get startDateLabel => 'تاريخ البداية';

  @override
  String get endDateLabel => 'تاريخ النهاية';

  @override
  String get createCampaign => 'إنشاء الحملة';

  @override
  String get organizationData => 'بيانات المنظمة';

  @override
  String get organizationNameField => 'اسم المنظمة';

  @override
  String get registrationNumberField => 'رقم التسجيل';

  @override
  String get addressLabel => 'العنوان';

  @override
  String get organizationDescriptionField => 'وصف المنظمة';

  @override
  String get chooseFile => 'اختيار ملف';

  @override
  String get documentSizeLimit => 'حجم الوثيقة يجب ألا يتجاوز 10 ميغابايت.';

  @override
  String get documentTypeTitle => 'نوع الوثيقة';

  @override
  String get updateSaved => 'تم حفظ التحديث.';

  @override
  String get summaryLabel => 'الملخص';

  @override
  String get campaignsLabel => 'الحملات';

  @override
  String get assistanceLabel => 'المساعدة';

  @override
  String get profileLabel => 'الملف';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String get whatDoYouWantToDo => 'ما الذي تريد إنجازه؟';

  @override
  String get orgOperationsReady => 'أهم عمليات المنظمة جاهزة من مكان واحد.';

  @override
  String get uploadDocument => 'رفع وثيقة';

  @override
  String get editProfileLabel => 'تعديل الملف';

  @override
  String get currentImpact => 'الأثر الحالي';

  @override
  String get workSummary => 'ملخص العمل';

  @override
  String get workSummarySubtitle => 'قراءة سريعة لحركة المبادرات والطلبات.';

  @override
  String get allCampaigns => 'جميع الحملات';

  @override
  String get activeCampaigns => 'الحملات النشطة';

  @override
  String get pendingOffers => 'عروض تنتظر';

  @override
  String get openRequests => 'طلبات مفتوحة';

  @override
  String get latestUpdates => 'آخر التحديثات';

  @override
  String get recentCampaigns => 'الحملات الأخيرة';

  @override
  String get recentCampaignsSubtitle =>
      'آخر المبادرات التي عملت عليها المنظمة.';

  @override
  String get startFirstCampaign => 'ابدأ بإنشاء أول حملة للمنظمة.';

  @override
  String get manageInitiatives => 'إدارة المبادرات';

  @override
  String get orgCampaigns => 'حملات المنظمة';

  @override
  String get orgCampaignsSubtitle => 'أنشئ الحملة وحدد حالتها وفق تقدم العمل.';

  @override
  String get createCampaignTooltip => 'إنشاء حملة';

  @override
  String get noCampaignsYet => 'لا توجد حملات بعد. أنشئ أول مبادرة الآن.';

  @override
  String get givingNetwork => 'شبكة العطاء';

  @override
  String get donationOffersTitle => 'عروض التبرع';

  @override
  String get donationOffersSubtitle =>
      'راجع العروض التي اجتازت التحقق وتابع استلامها.';

  @override
  String get beneficiaryCare => 'رعاية المستفيدين';

  @override
  String get assistanceRequestsTitle => 'طلبات المساعدة';

  @override
  String get assistanceRequestsSubtitle =>
      'تابع الحالات من الطلب الأول حتى اكتمال المساعدة.';

  @override
  String get reliableData => 'بيانات موثوقة';

  @override
  String get orgProfile => 'ملف المنظمة';

  @override
  String get orgProfileSubtitle =>
      'حافظ على دقة بيانات التواصل ووثائق الاعتماد.';

  @override
  String get documentsLabel => 'المستندات';

  @override
  String get accreditationDocs => 'وثائق الاعتماد';

  @override
  String uploadedDocsCount(Object count) {
    return '$count ملفات مرفوعة للمراجعة.';
  }

  @override
  String get noAccreditationDocs => 'لم تُرفع وثائق اعتماد بعد.';

  @override
  String get createNewCampaign => 'إنشاء حملة جديدة';

  @override
  String get activateCampaign => 'تفعيل الحملة';

  @override
  String get closeCampaign => 'إغلاق الحملة';

  @override
  String get cancelCampaign => 'إلغاء الحملة';

  @override
  String get urgentLabel => 'عاجلة';

  @override
  String get acceptsDonationsLabel => 'تستقبل التبرعات';

  @override
  String campaignEndsOn(Object date) {
    return 'تنتهي في $date';
  }

  @override
  String offerPackages(Object count, Object name) {
    return '$count عبوات · $name';
  }

  @override
  String verifiedViaPharmacy(Object name) {
    return 'تم التحقق عبر $name';
  }

  @override
  String validUntil(Object date) {
    return 'الصلاحية حتى $date';
  }

  @override
  String get acceptOffer => 'قبول العرض';

  @override
  String get confirmDonationReceived => 'تأكيد استلام التبرع';

  @override
  String requestPackages(Object count, Object name) {
    return '$count عبوات · $name';
  }

  @override
  String neededBefore(Object date) {
    return 'مطلوب قبل $date';
  }

  @override
  String get startReview => 'بدء المراجعة';

  @override
  String get assistanceCompleted => 'تمت المساعدة';

  @override
  String get cannotFulfill => 'تعذر التلبية';

  @override
  String get contactLabel => 'التواصل';

  @override
  String get aboutLabel => 'نبذة';

  @override
  String get optionalLabel => 'اختياري';

  @override
  String documentsUploaded(Object count) {
    return '$count وثائق مرفوعة';
  }

  @override
  String get orgVerified => 'تم التحقق من المنظمة';

  @override
  String get orgVerificationRejected => 'تم رفض التحقق';

  @override
  String get orgVerificationUnderReview => 'التحقق قيد المراجعة';

  @override
  String get orgVerificationIncomplete => 'التحقق غير مكتمل';

  @override
  String get verifiedShort => 'موثقة';

  @override
  String get rejectedShort => 'مرفوضة';

  @override
  String get underReviewShort => 'قيد المراجعة';

  @override
  String get incompleteShort => 'غير مكتملة';

  @override
  String get campaignActive => 'نشطة';

  @override
  String get campaignClosed => 'مغلقة';

  @override
  String get campaignCancelled => 'ملغاة';

  @override
  String get campaignDraft => 'مسودة';

  @override
  String get docRegistrationCertificate => 'شهادة التسجيل';

  @override
  String get docOperatingLicense => 'ترخيص العمل';

  @override
  String get docManagerIdentity => 'هوية المدير';

  @override
  String get docTaxOrLegal => 'وثيقة قانونية';

  @override
  String get docOther => 'أخرى';

  @override
  String get docLicensedDocument => 'وثيقة الترخيص';

  @override
  String get docIdentityDocument => 'إثبات الهوية';

  @override
  String get docAccreditation => 'وثيقة اعتماد';

  @override
  String get orgHomeLoading => 'نجهّز مساحة المنظمة...';

  @override
  String get orgHeroSubtitle =>
      'تابع أثر حملاتك واستجابتك لاحتياجات المستفيدين بوضوح.';

  @override
  String verifiedBadge(Object label) {
    return 'منظمة معتمدة · $label';
  }

  @override
  String get accountPendingApproval => 'الحساب بانتظار الاعتماد';

  @override
  String get orgImpactSection => 'أثر المنظمة';

  @override
  String get orgImpactSectionSubtitle => 'مؤشرات الحملات والطلبات الحالية';

  @override
  String get totalCampaigns => 'إجمالي الحملات';

  @override
  String get offersWaiting => 'عروض بانتظارك';

  @override
  String get assistanceRequests => 'طلبات مساعدة';

  @override
  String get workManagement => 'إدارة العمل';

  @override
  String get workManagementSubtitle => 'كل مسار يفتح في قسمه مباشرة';

  @override
  String get createUpdateCampaigns => 'إنشاء وتحديث حالة الحملات';

  @override
  String get reviewOfferedMedicines => 'مراجعة الأدوية المعروضة';

  @override
  String get followCasesAndRespond => 'متابعة الحالات والاستجابة لها';

  @override
  String get dataAndVerificationDocs => 'البيانات ووثائق التحقق';

  @override
  String get verificationStatusTitle => 'حالة التحقق';

  @override
  String verificationDocsCount(Object label, Object count) {
    return '$label · $count وثائق مرفوعة';
  }

  @override
  String get completeVerificationDocs =>
      'أكمل وثائق التحقق لتعزيز موثوقية المنظمة.';

  @override
  String get recentCampaignsAddedSubtitle =>
      'آخر المبادرات المضافة إلى حساب المنظمة';

  @override
  String get needsUpdate => 'تحتاج تحديثاً';

  @override
  String get notApproved => 'غير معتمدة';

  @override
  String get verificationStatusUnknown => 'حالة التحقق غير محددة';

  @override
  String get campaignPaused => 'متوقفة مؤقتاً';

  @override
  String get campaignCompleted => 'مكتملة';

  @override
  String get supplyWarehouseTitle => 'إدارة المستودع';

  @override
  String get supplyWarehouseSubtitle => 'مركز الإمداد والتوزيع';

  @override
  String get supplySummaryLabel => 'الملخص';

  @override
  String get supplyBatchesLabel => 'التشغيلات';

  @override
  String get supplyOrdersLabel => 'الطلبات';

  @override
  String get supplyRepresentativesLabel => 'المندوبون';

  @override
  String get supplyFinanceLabel => 'المالية';

  @override
  String get supplyLoadingWarehouse => 'جاري تحميل المستودع...';

  @override
  String get supplyWarehouseOpsTitle => 'مركز تشغيل المستودع';

  @override
  String supplyInventoryValue(Object money) {
    return 'قيمة المخزون $money ل.س';
  }

  @override
  String supplyNewOrdersCount(Object count) {
    return '$count طلب جديد';
  }

  @override
  String get supplyTodayIndicators => 'مؤشرات اليوم';

  @override
  String get supplyTodayIndicatorsSubtitle =>
      'قراءة سريعة لحالة التشغيل والمخزون';

  @override
  String get supplyActiveBatches => 'تشغيلات نشطة';

  @override
  String get supplyLowStock => 'مخزون منخفض';

  @override
  String get supplyExpiringSoon => 'قرب الانتهاء';

  @override
  String get supplyActiveDeliveries => 'شحنات نشطة';

  @override
  String get supplyNeedsAttention => 'تحتاج إلى انتباه';

  @override
  String get supplyNeedsAttentionSubtitle =>
      'تشغيلات منخفضة أو قريبة من الانتهاء';

  @override
  String get supplyNoBatches => 'لا توجد تشغيلات دوائية بعد.';

  @override
  String get supplyBatchesStockTitle => 'مخزون التشغيلات';

  @override
  String get supplyBatchesStockSubtitle =>
      'تتبّع الكميات والأسعار وتواريخ الانتهاء';

  @override
  String get supplyBatchLabel => 'تشغيلة';

  @override
  String get supplyAddBatch => 'إضافة تشغيلة';

  @override
  String get supplyBatchNumber => 'رقم التشغيلة';

  @override
  String get supplyPurchasePrice => 'سعر الشراء';

  @override
  String get supplyWholesalePrice => 'سعر الجملة';

  @override
  String get supplyStorageLocation => 'موضع التخزين';

  @override
  String get supplyBatchAdded => 'تمت إضافة التشغيلة.';

  @override
  String get supplyLoadingOrders => 'جاري تحميل الطلبات...';

  @override
  String get supplyPharmacyOrdersTitle => 'طلبات الصيدليات';

  @override
  String get supplyMyOrders => 'طلباتي';

  @override
  String get supplyPharmacyOrdersSubtitle =>
      'معالجة الطلب من الاستلام حتى التسليم';

  @override
  String get supplyMyOrdersSubtitle => 'متابعة حالة طلبات التوريد والشحن';

  @override
  String get supplyNewOrdersFilter => 'جديدة';

  @override
  String get supplyActiveOrdersFilter => 'قيد التنفيذ';

  @override
  String get supplyNoOrdersInCategory => 'لا توجد طلبات ضمن هذا التصنيف.';

  @override
  String supplyOrderItemsTotal(Object count, Object amount) {
    return '$count أصناف · $amount ل.س';
  }

  @override
  String supplyShipmentInfo(Object code, Object status) {
    return 'الشحنة: $code · $status';
  }

  @override
  String get supplyAccept => 'قبول';

  @override
  String get supplyStartPreparing => 'بدء التجهيز';

  @override
  String get supplyReadyForDispatch => 'جاهز للشحن';

  @override
  String get supplyAssignRepresentative => 'إسناد لمندوب';

  @override
  String get supplyConfirmReceipt => 'تأكيد استلام الشحنة';

  @override
  String get supplyReturnItem => 'طلب إرجاع صنف';

  @override
  String get supplyOrderUpdated => 'تم تحديث الطلب.';

  @override
  String get supplyAssignShipment => 'إسناد الشحنة';

  @override
  String get supplyRepresentativeLabel => 'المندوب';

  @override
  String get supplyPackagesCount => 'عدد الطرود';

  @override
  String get supplyAssign => 'إسناد';

  @override
  String get supplyShipmentAssigned => 'تم إسناد الشحنة للمندوب.';

  @override
  String get supplyReceiptCode => 'رمز الاستلام';

  @override
  String get supplyReceiptNote => 'ملاحظة الاستلام';

  @override
  String get supplyReceiptConfirmed => 'تم تأكيد استلام الشحنة.';

  @override
  String get supplyItemLabel => 'الصنف';

  @override
  String get supplyReturnReason => 'سبب الإرجاع';

  @override
  String get supplyReturnSent => 'تم إرسال طلب الإرجاع.';

  @override
  String get supplyNoRepresentatives => 'لا يوجد مندوبون.';

  @override
  String get supplyDeliveryTeam => 'فريق التوصيل';

  @override
  String supplyTeamSummary(Object available, Object tasks) {
    return '$available متاح الآن · $tasks مهمة نشطة';
  }

  @override
  String get supplyNoVehicle => 'دون مركبة';

  @override
  String get supplyOnShift => 'ضمن الوردية';

  @override
  String get supplyOffShift => 'خارج الوردية';

  @override
  String get supplyActiveShort => 'نشطة';

  @override
  String get supplyCompletedShort => 'مكتملة';

  @override
  String get supplyAddRepresentative => 'إضافة مندوب';

  @override
  String get supplyEmployeeCode => 'رمز الموظف';

  @override
  String get supplyVehiclePlate => 'لوحة المركبة';

  @override
  String get supplyCreate => 'إنشاء';

  @override
  String get supplyRepresentativeCreated => 'تم إنشاء حساب المندوب.';

  @override
  String get supplyInvoicesLabel => 'الفواتير';

  @override
  String get supplyReturnsLabel => 'المرتجعات';

  @override
  String get supplyRecallsLabel => 'السحب';

  @override
  String get supplyFinanceTitle => 'المالية والرقابة';

  @override
  String get supplyFinanceSubtitle =>
      'الفواتير والتحصيل والمرتجعات وسحب التشغيلات';

  @override
  String get supplyPharmacySupplyTitle => 'توريد الصيدلية';

  @override
  String get supplyWarehousesLabel => 'المستودعات';

  @override
  String get supplyStockNeeds => 'احتياج المخزون';

  @override
  String get supplyNoWarehouses => 'لا توجد مستودعات متاحة.';

  @override
  String get supplyAvailableWarehouses => 'المستودعات المتاحة';

  @override
  String get supplyAvailableWarehousesSubtitle =>
      'تصفح المستودعات واطلب الأدوية المطلوبة';

  @override
  String supplyAvailableMedicinesCount(Object count) {
    return '$count دواء';
  }

  @override
  String supplyDeliveryFee(Object fee) {
    return 'توصيل $fee ل.س';
  }

  @override
  String get supplySelectQuantities => 'حدد الكميات المطلوبة ثم أرسل الطلب.';

  @override
  String supplyCatalogItem(Object price, Object qty) {
    return '$price ل.س · متاح $qty';
  }

  @override
  String get supplySending => 'جاري الإرسال...';

  @override
  String get supplySupplyOrderSent => 'تم إرسال طلب التوريد.';

  @override
  String get supplyStockAdequate => 'المخزون ضمن الحدود المناسبة.';

  @override
  String get supplyStockNeedsSubtitle => 'الأدوية التي تحتاج إلى إعادة توريد';

  @override
  String supplyCurrentQty(Object qty) {
    return 'الحالي $qty';
  }

  @override
  String supplySuggestedQty(Object qty) {
    return 'المقترح $qty';
  }

  @override
  String get supplyDeliveryTasks => 'مهام التوصيل';

  @override
  String get supplyTodaySchedule => 'جدولك الميداني اليوم';

  @override
  String get supplyRefreshTasks => 'تحديث المهام';

  @override
  String get supplyLoadingTasks => 'جاري تجهيز مهامك...';

  @override
  String get supplyAssignedShipments => 'الشحنات المسندة';

  @override
  String get supplyNoTasksNow => 'لا توجد مهمة جديدة في الوقت الحالي';

  @override
  String get supplyUpdateTaskStatus => 'حدّث حالة المهمة عند كل مرحلة';

  @override
  String get supplySafeJourney => 'رحلة آمنة ومنظمة';

  @override
  String get supplySafeJourneySubtitle =>
      'راجع العنوان وحدّث حالة الشحنة أثناء التوصيل';

  @override
  String get supplyTasksLabel => 'المهام';

  @override
  String supplyDeliveryItems(Object code, Object count) {
    return '$code · $count أصناف';
  }

  @override
  String get supplyDeliveredSuccess => 'تم تسليم الشحنة بنجاح';

  @override
  String get supplyStepPickup => 'استلام';

  @override
  String get supplyStepLoading => 'تحميل';

  @override
  String get supplyStepOnWay => 'بالطريق';

  @override
  String get supplyStepArrival => 'وصول';

  @override
  String get supplyStepDelivered => 'تسليم';

  @override
  String get supplyNoData => 'لا توجد بيانات.';

  @override
  String supplyInvoiceRemaining(Object name, Object amount) {
    return '$name · متبقي $amount ل.س';
  }

  @override
  String supplyInvoiceSummary(Object total, Object paid) {
    return 'الإجمالي $total ل.س · المدفوع $paid ل.س';
  }

  @override
  String get supplyEditInvoiceTerms => 'تعديل شروط الفاتورة';

  @override
  String get supplyRecordPayment => 'تسجيل دفعة';

  @override
  String get supplyAmountLabel => 'المبلغ';

  @override
  String get supplyPaymentMethod => 'طريقة الدفع';

  @override
  String get supplyCashOnDelivery => 'نقدي عند التسليم';

  @override
  String get supplyBankTransfer => 'تحويل بنكي';

  @override
  String get supplyCredit => 'آجل';

  @override
  String get supplyReferenceOptional => 'رقم المرجع (اختياري)';

  @override
  String get supplyPaymentRecorded => 'تم تسجيل الدفعة.';

  @override
  String get supplyEditInvoice => 'تعديل الفاتورة';

  @override
  String get supplyDiscountLabel => 'الحسم';

  @override
  String get supplyTaxLabel => 'الضريبة';

  @override
  String get supplyWarehouseNote => 'ملاحظة المستودع';

  @override
  String get supplyDueDate => 'تاريخ الاستحقاق';

  @override
  String get supplyInvoiceUpdated => 'تم تحديث الفاتورة.';

  @override
  String supplyReturnDetails(Object qty, Object reason) {
    return '$qty عبوات · $reason';
  }

  @override
  String get supplyAcceptReturn => 'قبول المرتجع';

  @override
  String get supplyRejectReturn => 'رفض المرتجع';

  @override
  String get supplyCollectedFromPharmacy => 'تم الاستلام من الصيدلية';

  @override
  String get supplyCompleteReturn => 'إكمال المرتجع';

  @override
  String get supplyReturnUpdated => 'تم تحديث المرتجع.';

  @override
  String get supplyCreateRecallAlert => 'إنشاء تنبيه سحب';

  @override
  String get supplyRecallBatch => 'سحب تشغيلة دوائية';

  @override
  String get supplySeverityLabel => 'درجة الخطورة';

  @override
  String get supplySeverityLow => 'منخفضة';

  @override
  String get supplySeverityMedium => 'متوسطة';

  @override
  String get supplySeverityHigh => 'عالية';

  @override
  String get supplySeverityCritical => 'حرجة';

  @override
  String get supplyRecallReason => 'سبب السحب';

  @override
  String get supplyCreateAlertButton => 'إنشاء التنبيه';

  @override
  String get supplyRecallAlertCreated => 'تم إنشاء تنبيه السحب.';

  @override
  String supplyBatchNumberLabel(Object number) {
    return 'رقم التشغيلة $number';
  }

  @override
  String get supplyAvailableShort => 'المتاح';

  @override
  String get supplyExpiryShort => 'الانتهاء';

  @override
  String get supplyHealthHealthy => 'سليم';

  @override
  String get supplyHealthLow => 'منخفض';

  @override
  String get supplyHealthExpiring => 'قرب الانتهاء';

  @override
  String get supplyHealthExpired => 'منتهي';

  @override
  String get supplyStatusSubmitted => 'مرسل';

  @override
  String get supplyStatusAccepted => 'مقبول';

  @override
  String get supplyStatusPreparing => 'قيد التجهيز';

  @override
  String get supplyStatusReadyForDispatch => 'جاهز للشحن';

  @override
  String get supplyStatusAssigned => 'مسند';

  @override
  String get supplyStatusLoading => 'تحميل';

  @override
  String get supplyStatusOutForDelivery => 'في الطريق';

  @override
  String get supplyStatusArrived => 'وصل';

  @override
  String get supplyStatusDelivered => 'تم التسليم';

  @override
  String get supplyStatusRejected => 'مرفوض';

  @override
  String get supplyStatusPaid => 'مدفوع';

  @override
  String get supplyStatusPartiallyPaid => 'مدفوع جزئيًا';

  @override
  String get supplyStatusUnpaid => 'غير مدفوع';

  @override
  String get supplyStatusRequested => 'مطلوب';

  @override
  String get supplyStatusApproved => 'مقبول';

  @override
  String get supplyStatusActive => 'نشط';

  @override
  String get supplyNextLoading => 'بدء التحميل';

  @override
  String get supplyNextOutForDelivery => 'بدء التوصيل';

  @override
  String get supplyNextArrived => 'تأكيد الوصول';

  @override
  String get supplyNextDelivered => 'تأكيد التسليم';

  @override
  String get supplyNextUpdate => 'تحديث';

  @override
  String get adminCenterTitle => 'مركز الإدارة';

  @override
  String get adminCenterSubtitle => 'إدارة منصة دوائي ومتابعة عملياتها';

  @override
  String get adminRefreshTooltip => 'تحديث';

  @override
  String get adminLocationServiceTooltip => 'خدمة مواقع الصيدليات';

  @override
  String adminCannotApprovePharmacy(Object status) {
    return 'لا يمكن الموافقة على الصيدلية. حالة الترخيص: $status. يجب أن يكون الترخيص موثقاً أولاً.';
  }

  @override
  String adminLicenseCheckFailed(Object error) {
    return 'تعذر التحقق من حالة الترخيص: $error';
  }

  @override
  String get adminOrgReviewApproved => 'تمت مراجعة وثائق المنظمة واعتمادها.';

  @override
  String get adminOrgReviewNeedsUpdate => 'يرجى تحديث وثائق التحقق المطلوبة.';

  @override
  String get adminDeactivateAccount => 'إيقاف الحساب';

  @override
  String get adminDeactivateReason => 'سبب الإيقاف';

  @override
  String get adminDeactivateReasonHint =>
      'اكتب سببًا واضحًا لا يقل عن 10 أحرف.';

  @override
  String get adminLocationServiceTitle => 'خدمة مواقع الصيدليات';

  @override
  String get adminLocationServiceHealthy => 'الخدمة تعمل بصورة طبيعية.';

  @override
  String get adminLocationServiceUnhealthy =>
      'الخدمة لا تستجيب بالصورة المتوقعة.';

  @override
  String get adminCleanCache => 'تنظيف البيانات القديمة';

  @override
  String get adminSectionSummary => 'الملخص';

  @override
  String get adminSectionApprovals => 'الموافقات';

  @override
  String get adminSectionAccounts => 'الحسابات';

  @override
  String get adminSectionAds => 'الإعلانات';

  @override
  String get adminTickerNewContent => 'محتوى جديد';

  @override
  String get adminTickerEditContent => 'تعديل المحتوى';

  @override
  String get adminTickerAppearsHint =>
      'سيظهر هذا المحتوى في الصفحة الرئيسية للمستخدمين.';

  @override
  String get adminAnnouncement => 'إعلان عام';

  @override
  String get adminDutyPharmacy => 'صيدلية مناوبة';

  @override
  String get adminDutyPharmacyLabel => 'الصيدلية المناوبة';

  @override
  String get adminChoosePharmacy => 'اختر الصيدلية';

  @override
  String get adminTitleLabel => 'العنوان';

  @override
  String get adminEnterTitleHint => 'أدخل عنوان المحتوى';

  @override
  String get adminVisibleTextLabel => 'النص الظاهر للمستخدم';

  @override
  String get adminEnterTextHint => 'أدخل النص المراد إظهاره';

  @override
  String get adminPublishContent => 'نشر المحتوى';

  @override
  String get adminVisibleNow => 'ظاهر حاليًا للمستخدمين';

  @override
  String get adminSavedUnpublished => 'محفوظ دون نشر';

  @override
  String get adminSaveContent => 'حفظ المحتوى';

  @override
  String get adminLoadingIndicators => 'جاري تحميل المؤشرات...';

  @override
  String get adminUsers => 'المستخدمون';

  @override
  String get adminActiveAccounts => 'حسابات نشطة';

  @override
  String get adminPharmacies => 'الصيدليات';

  @override
  String get adminPendingPharmacies => 'صيدليات معلقة';

  @override
  String get adminOrganizations => 'المنظمات';

  @override
  String get adminWarehouses => 'المستودعات';

  @override
  String get adminPendingWarehouses => 'مستودعات معلقة';

  @override
  String get adminOrganizationVerifications => 'تحقق منظمات';

  @override
  String get adminMedicineRequests => 'طلبات الأدوية';

  @override
  String get adminDonations => 'تبرعات';

  @override
  String get adminOverviewEyebrow => 'المشهد العام';

  @override
  String get adminPlatformIndicators => 'مؤشرات المنصة';

  @override
  String get adminOverviewSubtitle =>
      'الأرقام الأساسية وحالات الاعتماد التي تتطلب المتابعة.';

  @override
  String get adminHeroPulse => 'نبض منصة دوائي';

  @override
  String get adminHeroSubtitle => 'نظرة موحدة على الحسابات والجهات والخدمات';

  @override
  String get adminNeedsDecision => 'تحتاج قرارًا';

  @override
  String get adminActiveAccount => 'حساب نشط';

  @override
  String get adminPharmacyPoints => 'نقاط دوائية';

  @override
  String get adminLicenseVerifiedMsg =>
      'الترخيص موثق، يمكنك الموافقة على الصيدلية';

  @override
  String get adminLicenseManualReviewMsg =>
      'الترخيص يحتاج إلى مراجعة يدوية. يجب أن يكون الترخيص موثقاً أولاً قبل الموافقة على الصيدلية.';

  @override
  String get adminLicenseProcessingMsg => 'الترخيص قيد المعالجة.';

  @override
  String get adminLicenseDetailsTitle => 'تفاصيل ترخيص الصيدلية';

  @override
  String get adminLicenseNameInDocument => 'الاسم في الوثيقة';

  @override
  String get adminMatchScore => 'درجة التطابق';

  @override
  String get adminRejectionReason => 'سبب الرفض';

  @override
  String get adminReadFailure => 'مشكلة القراءة';

  @override
  String get adminViewDocument => 'عرض الوثيقة';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع.';

  @override
  String get adminApprovalDecisions => 'قرارات الاعتماد';

  @override
  String get adminPendingYourReview => 'طلبات تحتاج مراجعتك';

  @override
  String get adminApprovalSubtitle =>
      'تحقق من بيانات الجهة قبل منحها صلاحية العمل على المنصة.';

  @override
  String get adminNoPendingRequests => 'لا توجد طلبات معلقة ضمن هذا القسم.';

  @override
  String get adminApprovePharmacy => 'اعتماد الصيدلية';

  @override
  String get adminRejectPharmacy => 'رفض الصيدلية';

  @override
  String get adminOwner => 'المالك';

  @override
  String adminVerificationDocsSubtitle(Object name, Object count) {
    return '$name · $count وثائق';
  }

  @override
  String get adminVerificationStatus => 'حالة التحقق';

  @override
  String get adminVerificationDocsLabel => 'الوثائق';

  @override
  String get adminApproveWarehouse => 'اعتماد المستودع';

  @override
  String get adminRejectWarehouse => 'رفض المستودع';

  @override
  String get adminMinOrderLimit => 'حد الطلب الأدنى';

  @override
  String get adminCurrencySuffix => 'ر.س';

  @override
  String get adminDeliveryFee => 'رسوم التوصيل';

  @override
  String get adminMedicineBatches => 'دفعات الأدوية';

  @override
  String get adminRepresentatives => 'المندوبين';

  @override
  String get adminAccountsGuide => 'دليل الحسابات';

  @override
  String get adminPlatformUsers => 'مستخدمو المنصة';

  @override
  String get adminAccountsSubtitle => 'ابحث عن الحسابات وراجع حالتها ودورها.';

  @override
  String get adminSearchByNameOrEmail => 'ابحث بالاسم أو البريد الإلكتروني';

  @override
  String get adminLoadingAccounts => 'جاري تحميل الحسابات...';

  @override
  String get adminNoResultsSubtitle => 'غيّر كلمات البحث أو اختر دورًا آخر.';

  @override
  String get adminLiveContent => 'المحتوى المباشر';

  @override
  String get adminHomeTicker => 'شريط الصفحة الرئيسية';

  @override
  String get adminTickerSubtitle =>
      'أدر الإعلانات العامة والصيدليات المناوبة الظاهرة للمستخدمين.';

  @override
  String get adminAddAd => 'إضافة إعلان';

  @override
  String get adminLoading => 'جاري التحميل...';

  @override
  String get adminNoPublishedContent => 'لا يوجد محتوى منشور';

  @override
  String get adminNoContentSubtitle =>
      'أضف إعلانًا أو صيدلية مناوبة لتظهر في الرئيسية.';

  @override
  String get adminReviewLicense => 'مراجعة الترخيص';

  @override
  String get adminApprove => 'اعتماد';

  @override
  String get adminWriteReasonHint => 'اكتب سبب القرار (10 أحرف على الأقل)';

  @override
  String get adminReasonExample =>
      'مثال: تمت مراجعة البيانات والوثائق والاعتماد مطابق للمعايير المطلوبة.';

  @override
  String get adminActive => 'نشط';

  @override
  String get adminSuspended => 'موقوف';

  @override
  String get adminRole => 'الدور';

  @override
  String get adminLocation => 'الموقع';

  @override
  String get adminAccreditationNumber => 'رقم الاعتماد';

  @override
  String get adminSuspendedAccount => 'حساب موقوف';

  @override
  String get adminAdditionalInfo => 'معلومات إضافية';

  @override
  String get adminPublished => 'منشور';

  @override
  String get adminStopped => 'متوقف';

  @override
  String get adminRoleAdmin => 'إدارة';

  @override
  String get adminRolePharmacy => 'صيدلية';

  @override
  String get adminRoleOrganization => 'منظمة';

  @override
  String get adminRoleWarehouse => 'مستودع';

  @override
  String get adminRoleRepresentative => 'مندوب';

  @override
  String get adminRoleUser => 'مستخدم';

  @override
  String get warehouseHeroTitle => 'توريد منظم من المخزون للتسليم';

  @override
  String get warehouseHeroSubtitle =>
      'راقب التشغيلات والطلبات والشحنات قبل أن تتحول إلى تأخير.';

  @override
  String warehousePendingOrders(Object count) {
    return '$count طلبات توريد بانتظارك';
  }

  @override
  String get warehouseOrdersUpToDate => 'الطلبات محدثة';

  @override
  String get warehouseOpsStatus => 'حالة التشغيل';

  @override
  String get warehouseOpsStatusSubtitle => 'مؤشرات حية من مخزون المستودع';

  @override
  String get warehouseInventoryValueTitle => 'قيمة المخزون الحالية';

  @override
  String warehouseInventoryValueMessage(Object money) {
    return '$money ل.س ضمن التشغيلات النشطة';
  }

  @override
  String get warehouseQuickOps => 'تشغيل سريع';

  @override
  String get warehouseQuickOpsSubtitle => 'اختصارات لأهم أعمال المستودع';

  @override
  String get warehouseManage => 'إدارة المستودع';

  @override
  String get warehouseManageSubtitle => 'التشغيلات والمخزون';

  @override
  String get warehouseSupplyOrders => 'طلبات التوريد';

  @override
  String get warehouseSupplyOrdersSubtitle => 'قبول وتجهيز وإسناد الطلبات';

  @override
  String get warehouseShipping => 'الشحن والتوصيل';

  @override
  String get warehouseShippingSubtitle => 'المندوبون وحالة الشحنات';

  @override
  String get warehouseInventoryAnalysis => 'تحليل المخزون';

  @override
  String get warehouseInventoryAnalysisSubtitle =>
      'توقع النفاد ودعم قرار التوريد';

  @override
  String get warehouseAlertsTitle => 'تنبيهات المخزون';

  @override
  String get warehouseAlertsSubtitle => 'التشغيلات التي تحتاج تدخلاً قريباً';

  @override
  String warehouseBatchAlert(Object batchNumber, Object qty) {
    return 'تشغيلة $batchNumber · $qty عبوات متاحة';
  }

  @override
  String get warehouseRecentOrders => 'أحدث الطلبات';

  @override
  String get warehouseRecentOrdersSubtitle =>
      'آخر طلبات التوريد الواردة للمستودع';

  @override
  String warehouseOrderSummary(Object code, Object status, Object amount) {
    return '$code · $status · $amount ل.س';
  }

  @override
  String get warehouseCurrencySuffix => 'ل.س';

  @override
  String get representativeLoadingSchedule => 'نجهّز جدول التوصيل...';

  @override
  String get representativeReadyForNextTask => 'جاهز لمهمتك القادمة';

  @override
  String representativeCurrentTaskTo(Object pharmacyName) {
    return 'مهمتك الحالية إلى $pharmacyName';
  }

  @override
  String get representativeNoTaskSubtitle =>
      'ستظهر هنا أي شحنة جديدة يسندها المستودع إليك.';

  @override
  String representativeTaskLocation(Object area, Object city, Object status) {
    return '$area، $city · $status';
  }

  @override
  String get representativeNoActiveTask => 'لا توجد مهمة نشطة';

  @override
  String representativeActiveTasksCount(Object count) {
    return '$count مهام نشطة';
  }

  @override
  String get representativeTripsSummary => 'ملخص الرحلات';

  @override
  String get representativeTripsSummarySubtitle =>
      'حالة الشحنات المسندة إلى حسابك';

  @override
  String get representativeTotalTasks => 'إجمالي المهام';

  @override
  String get representativeActiveTasks => 'مهام نشطة';

  @override
  String get representativeFailedTasks => 'متعثرة';

  @override
  String get representativeQuickAccess => 'وصول سريع';

  @override
  String get representativeQuickAccessSubtitle => 'اختصارات لمهام المندوب';

  @override
  String get representativeDeliveryTasksSubtitle =>
      'العناوين وتحديث حالة الشحنة';

  @override
  String get representativeNotificationsSubtitle =>
      'التكليفات وآخر تحديثات المستودع';

  @override
  String get representativeActiveTasksTitle => 'المهام النشطة';

  @override
  String get representativeNoActionRequired => 'لا توجد رحلة تتطلب إجراء الآن';

  @override
  String get representativeStartOldest =>
      'ابدأ بالأقدم وحدّث الحالة عند كل مرحلة';

  @override
  String get representativeAvailableForNewTask => 'أنت متاح لمهمة جديدة';

  @override
  String get representativeAvailableForNewTaskSubtitle =>
      'عند إسناد شحنة ستصلك عبر الإشعارات وتظهر في هذه الصفحة.';

  @override
  String representativeDeliveryCardSummary(
    Object code,
    Object area,
    Object city,
    Object status,
  ) {
    return '$code · $area، $city · $status';
  }

  @override
  String get representativeStatusFailed => 'تعذر التسليم';

  @override
  String get representativeStatusReturned => 'أُعيدت للمستودع';

  @override
  String get adminHeroTitle => 'منصة واضحة تحت إدارتك';

  @override
  String get adminHeroDescription =>
      'تابع الاعتمادات والحسابات ونشاط المنصة من نقطة واحدة.';

  @override
  String adminPendingReviewCount(Object count) {
    return '$count عناصر بانتظار المراجعة';
  }

  @override
  String get adminReviewsUpToDate => 'جميع المراجعات محدثة';

  @override
  String get adminOverviewTitle => 'نظرة المنصة';

  @override
  String get adminOverviewLiveSubtitle => 'إحصاءات مباشرة من قاعدة البيانات';

  @override
  String get adminApprovedShort => 'معتمد';

  @override
  String get adminControlCenter => 'مركز التحكم';

  @override
  String get adminControlCenterSubtitle => 'انتقل مباشرة إلى العملية المطلوبة';

  @override
  String get adminApprovalsActionSubtitle => 'صيدليات ومنظمات ومستودعات';

  @override
  String get adminAccountsActionSubtitle => 'متابعة الحالة والصلاحية';

  @override
  String get adminPlatformBar => 'شريط المنصة';

  @override
  String get adminPlatformBarSubtitle => 'الإعلانات والصيدليات المناوبة';

  @override
  String get adminMedicineGuide => 'دليل الأدوية';

  @override
  String get adminMedicineGuideSubtitle => 'مراجعة وإضافة بيانات الدواء';

  @override
  String get adminOpenOperations => 'العمليات المفتوحة';

  @override
  String adminOpenOperationsMessage(
    Object medicineRequests,
    Object assistanceRequests,
    Object donationOffers,
  ) {
    return '$medicineRequests طلب دواء معلق · $assistanceRequests طلب مساعدة مفتوح · $donationOffers عروض تبرع';
  }

  @override
  String get adminAiServices => 'خدمات المعالجة الذكية';

  @override
  String get adminRefreshStatus => 'تحديث الحالة';

  @override
  String get adminAiHealthReadFailed => 'تعذر قراءة حالة الخدمات حالياً.';

  @override
  String get adminAiDrugSearch => 'البحث الدوائي';

  @override
  String get adminAiWorking => 'يعمل';

  @override
  String dashboardWelcome(Object name) {
    return 'مرحبًا، $name';
  }

  @override
  String get dashboardUserSubtitle => 'كل ما تحتاجه لصحتك ودوائك في مكان واحد.';

  @override
  String get dashboardPharmacySubtitle => 'تابع عمل الصيدلية والطلبات بسهولة.';

  @override
  String get dashboardOrganizationSubtitle =>
      'أدر المبادرات وطلبات المساعدة بوضوح.';

  @override
  String get dashboardAdminSubtitle => 'راقب المنصة وأدر العمليات الأساسية.';

  @override
  String get dashboardWarehouseSubtitle =>
      'أدر المخزون والطلبات والتوزيع من مكان واحد.';

  @override
  String get dashboardRepresentativeSubtitle =>
      'تابع الشحنات المسندة إليك خطوة بخطوة.';

  @override
  String get dashboardBannerUser => 'صحتك تبدأ بخطوة';

  @override
  String get dashboardBannerPharmacy => 'خدمة أسرع للمستخدمين';

  @override
  String get dashboardBannerOrganization => 'أثر يصل لمن يحتاجه';

  @override
  String get dashboardBannerAdmin => 'نظرة موحدة على المنصة';

  @override
  String get dashboardBannerWarehouse => 'توريد منظم وموثوق';

  @override
  String get dashboardBannerRepresentative => 'كل شحنة في موعدها';

  @override
  String get dashboardBannerDescUser =>
      'ابحث عن الدواء واعثر على أقرب صيدلية بثقة.';

  @override
  String get dashboardBannerDescPharmacy =>
      'حدّث المخزون وتابع الطلبات من لوحة واحدة.';

  @override
  String get dashboardBannerDescOrganization =>
      'تابع الحملات والتبرعات وطلبات المساعدة.';

  @override
  String get dashboardBannerDescAdmin =>
      'الموافقات والحسابات والإعلانات بين يديك.';

  @override
  String get dashboardBannerDescWarehouse =>
      'تابع التشغيلات والطلبات والشحنات والمدفوعات.';

  @override
  String get dashboardBannerDescRepresentative =>
      'حدّث حالة التوصيل حتى استلام الصيدلية.';

  @override
  String dashboardServicesCount(Object count) {
    return '$count خدمات';
  }

  @override
  String get homeShellSupply => 'التوريد';

  @override
  String get homeShellAdmin => 'الإدارة';

  @override
  String get homeShellMedicines => 'الأدوية';

  @override
  String get homeShellOrgManagement => 'إدارة المنظمة';

  @override
  String get homeShellWarehouse => 'المستودع';

  @override
  String get homeShellMyTasks => 'مهامي';

  @override
  String get modulesTitle => 'خدماتك';

  @override
  String get modulesSubtitle => 'كل ما تحتاجه في مكان واضح وسريع';

  @override
  String get moduleSearchMedicine => 'البحث عن دواء';

  @override
  String get moduleSearchMedicineDesc => 'ابحث في الصيدليات القريبة';

  @override
  String get moduleNearbyPharmacies => 'الصيدليات القريبة';

  @override
  String get moduleNearbyPharmaciesDesc => 'اعرض الأقرب والمسار إليها';

  @override
  String get moduleMyPrescriptions => 'وصفاتي';

  @override
  String get moduleMyPrescriptionsDesc => 'حلّل الوصفة وتابع الحجز';

  @override
  String get moduleMyRequests => 'طلباتي';

  @override
  String get moduleMyRequestsDesc => 'تابع طلبات توفر الأدوية';

  @override
  String get moduleMyHealthProfile => 'ملفي الصحي';

  @override
  String get moduleMyHealthProfileDesc => 'بياناتك الصحية والبطاقة';

  @override
  String get moduleDonationsDesc => 'عروض الدواء وطلبات المساعدة';

  @override
  String get moduleOrganizations => 'المنظمات';

  @override
  String get moduleOrganizationsDesc => 'الحملات والمنظمات المعتمدة';

  @override
  String get modulePharmacyAssistant => 'المساعد الدوائي';

  @override
  String get modulePharmacyAssistantDesc => 'مساعدة سريعة ومعلومات موثوقة';

  @override
  String get moduleMedicineAlternatives => 'البدائل الدوائية';

  @override
  String get moduleMedicineAlternativesDesc =>
      'اعرض خيارات مشابهة ومعلومات المقارنة';

  @override
  String get moduleInventoryDesc => 'الكميات والأسعار والتوفر';

  @override
  String get moduleUserRequests => 'طلبات المستخدمين';

  @override
  String get moduleUserRequestsDesc => 'راجع الطلبات وأرسل الرد';

  @override
  String get modulePrescriptionOrders => 'طلبات الوصفات';

  @override
  String get modulePrescriptionOrdersDesc => 'جهّز الحجوزات وتابع حالتها';

  @override
  String get modulePharmacyLocation => 'موقع الصيدلية';

  @override
  String get modulePharmacyLocationDesc => 'الموقع والبيانات العامة';

  @override
  String get moduleWorkingHoursDesc => 'أوقات الدوام وحالة الفتح';

  @override
  String get moduleMedicineCatalog => 'دليل الأدوية';

  @override
  String get moduleMedicineCatalogDesc => 'اختر الأدوية لإضافتها للمخزون';

  @override
  String get moduleMedicineCatalogAdminDesc => 'إدارة بيانات الأدوية';

  @override
  String get moduleDonationVerification => 'التحقق من التبرعات';

  @override
  String get moduleDonationVerificationDesc => 'فحص العبوات واعتماد استلامها';

  @override
  String get moduleSupplyChain => 'توريد الصيدلية';

  @override
  String get moduleSupplyChainDesc => 'المستودعات والطلبات واحتياج المخزون';

  @override
  String get moduleInventoryAnalysis => 'تحليل المخزون';

  @override
  String get moduleInventoryAnalysisDesc =>
      'بدائل الأدوية وتوقع الاحتياج القادم';

  @override
  String get moduleInventoryAnalysisWarehouseDesc =>
      'توقع النفاد وتخطيط إعادة الطلب';

  @override
  String get moduleCampaignsDesc => 'أنشئ الحملات وتابع حالتها';

  @override
  String get moduleAssistanceDesc => 'تابع الطلبات وحدّث حالتها';

  @override
  String get moduleApprovals => 'الموافقات';

  @override
  String get moduleApprovalsDesc => 'الصيدليات والمنظمات المعلقة';

  @override
  String get moduleAccounts => 'الحسابات';

  @override
  String get moduleAccountsDesc => 'عرض الحسابات وإدارة حالتها';

  @override
  String get moduleHomeTicker => 'شريط الإعلانات';

  @override
  String get moduleHomeTickerDesc => 'الإعلانات والصيدليات المناوبة';

  @override
  String get moduleAnalysisServices => 'خدمات التحليل';

  @override
  String get moduleAnalysisServicesDesc => 'اختبار البدائل وتوقع نفاد المخزون';

  @override
  String get moduleWarehouseManagement => 'إدارة المستودع';

  @override
  String get moduleWarehouseManagementDesc =>
      'المخزون والطلبات والشحنات والفواتير';

  @override
  String get moduleDeliveryTasks => 'مهام التوصيل';

  @override
  String get moduleDeliveryTasksDesc => 'تابع الشحنات المسندة وحدّث حالتها';

  @override
  String get errorTimeout => 'انتهت مهلة الاتصال، حاول مجددًا.';

  @override
  String get errorConnection =>
      'تعذر الاتصال بالخادم. تحقق من الشبكة وتشغيل الخدمة.';

  @override
  String get errorGeneric => 'تعذر إكمال العملية حاليًا.';

  @override
  String get errorLocationRequired => 'حدد موقعك أولًا لعرض الصيدليات القريبة.';

  @override
  String get errorLocationCoordinates => 'يجب إدخال خط العرض وخط الطول معًا.';

  @override
  String get errorAwaitingApproval => 'حسابك بانتظار موافقة الإدارة.';

  @override
  String get errorAlreadyApproved => 'تم الاعتماد مسبقًا.';

  @override
  String get errorAlreadyRejected => 'تم رفض الطلب مسبقًا.';

  @override
  String get errorNotFound => 'العنصر غير موجود.';

  @override
  String get errorAlreadyTaken => 'القيمة مستخدمة مسبقًا.';

  @override
  String get errorLocationServiceDisabled =>
      'خدمة الموقع متوقفة. فعّلها من إعدادات الجهاز ثم حاول مجددًا.';

  @override
  String get errorLocationPermissionDenied =>
      'لم يتم السماح بالوصول إلى الموقع.';

  @override
  String get errorLocationPermissionForever =>
      'إذن الموقع موقوف لهذا التطبيق. يمكنك تفعيله من إعدادات الجهاز.';

  @override
  String get errorLoginResponseIncomplete => 'استجابة تسجيل الدخول غير مكتملة.';

  @override
  String get errorSessionReadFailed => 'تعذر قراءة بيانات الجلسة.';

  @override
  String get errorRegisterResponseIncomplete =>
      'استجابة إنشاء الحساب غير مكتملة.';

  @override
  String get errorNewAccountReadFailed => 'تعذر قراءة بيانات الحساب الجديد.';

  @override
  String get errorInvalidListResponse => 'استجابة القائمة من الخادم غير صالحة.';

  @override
  String get adminCacheCleared => 'تم تنظيف بيانات المواقع القديمة.';
}
