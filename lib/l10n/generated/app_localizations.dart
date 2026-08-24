import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'دوائي'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get services;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get account;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @signOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// No description provided for @sessionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت جلستك، سجّل دخولك مجدداً.'**
  String get sessionExpired;

  /// No description provided for @loadingDefault.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل البيانات...'**
  String get loadingDefault;

  /// No description provided for @loadFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إكمال التحميل'**
  String get loadFailedTitle;

  /// No description provided for @loadFailedMessage.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل البيانات حاليًا.'**
  String get loadFailedMessage;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @appTagline.
  ///
  /// In ar, this message translates to:
  /// **'دواؤك أقرب'**
  String get appTagline;

  /// No description provided for @loginFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تسجيل الدخول. تحقق من البيانات وحاول مجددًا.'**
  String get loginFailed;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات حسابك للوصول إلى خدماتك.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدًا إلكترونيًا صحيحًا.'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get loginPasswordLabel;

  /// No description provided for @loginShowPassword.
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة المرور'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة المرور'**
  String get loginHidePassword;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور.'**
  String get loginPasswordRequired;

  /// No description provided for @loginForgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get loginForgotPassword;

  /// No description provided for @orDivider.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get orDivider;

  /// No description provided for @loginTermsPrefix.
  ///
  /// In ar, this message translates to:
  /// **'بالمتابعة، أنت توافق على '**
  String get loginTermsPrefix;

  /// No description provided for @termsOfUse.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfUse;

  /// No description provided for @andWord.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get andWord;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @noAccountYet.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب بعد؟'**
  String get noAccountYet;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccount;

  /// No description provided for @welcomeName.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا {name}'**
  String welcomeName(Object name);

  /// No description provided for @accountCreatedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء حسابك'**
  String get accountCreatedTitle;

  /// No description provided for @goToHome.
  ///
  /// In ar, this message translates to:
  /// **'الانتقال إلى الرئيسية'**
  String get goToHome;

  /// No description provided for @splashAppLogoLabel.
  ///
  /// In ar, this message translates to:
  /// **'شعار تطبيق دوائي'**
  String get splashAppLogoLabel;

  /// No description provided for @splashTagline.
  ///
  /// In ar, this message translates to:
  /// **'دواؤك أقرب، ورعايتك أسهل'**
  String get splashTagline;

  /// No description provided for @splashPreparing.
  ///
  /// In ar, this message translates to:
  /// **'نجهّز تجربتك'**
  String get splashPreparing;

  /// No description provided for @splashTopCaption.
  ///
  /// In ar, this message translates to:
  /// **'رعاية دوائية أقرب إليك'**
  String get splashTopCaption;

  /// No description provided for @splashLoadingLabel.
  ///
  /// In ar, this message translates to:
  /// **'جاري تجهيز التطبيق'**
  String get splashLoadingLabel;

  /// No description provided for @splashPercent.
  ///
  /// In ar, this message translates to:
  /// **'{percent} بالمئة'**
  String splashPercent(Object percent);

  /// No description provided for @onboardingSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في دوائي'**
  String get onboardingIntroTitle;

  /// No description provided for @onboardingIntroDesc.
  ///
  /// In ar, this message translates to:
  /// **'منصة دوائية متكاملة تربط المستخدمين بالصيدليات والمستودعات والمنظمات لوصول أسرع وأسهل إلى الدواء.'**
  String get onboardingIntroDesc;

  /// No description provided for @onboardingSearchTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دوائك'**
  String get onboardingSearchTitle;

  /// No description provided for @onboardingSearchDesc.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن أي دواء، واعرف توفره وأسعاره، وقدّم طلبك بضغطة واحدة.'**
  String get onboardingSearchDesc;

  /// No description provided for @onboardingPharmaciesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات القريبة منك'**
  String get onboardingPharmaciesTitle;

  /// No description provided for @onboardingPharmaciesDesc.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف أقرب الصيدليات وساعات عملها وتفاصيلها قبل الزيارة.'**
  String get onboardingPharmaciesDesc;

  /// No description provided for @onboardingInventoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المخزون والباركود'**
  String get onboardingInventoryTitle;

  /// No description provided for @onboardingInventoryDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدر مخزونك وامسح الباركود وتابع الكميات وتواريخ الصلاحية بسهولة.'**
  String get onboardingInventoryDesc;

  /// No description provided for @onboardingDonationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تبرّع وساعد غيرك'**
  String get onboardingDonationsTitle;

  /// No description provided for @onboardingDonationsDesc.
  ///
  /// In ar, this message translates to:
  /// **'شارك في حملات التبرع وقدّم المساعدة واحصل على دعم ذكي من المساعد.'**
  String get onboardingDonationsDesc;

  /// No description provided for @forgotOperationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إكمال العملية الآن. حاول مجددًا.'**
  String get forgotOperationFailed;

  /// No description provided for @forgotBack.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get forgotBack;

  /// No description provided for @forgotTitle.
  ///
  /// In ar, this message translates to:
  /// **'استعادة الحساب'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني وسنساعدك على تعيين كلمة مرور جديدة بأمان.'**
  String get forgotSubtitle;

  /// No description provided for @forgotEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get forgotEmailLabel;

  /// No description provided for @forgotVerifying.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق...'**
  String get forgotVerifying;

  /// No description provided for @forgotContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get forgotContinue;

  /// No description provided for @forgotSetNewTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كلمة مرور جديدة'**
  String get forgotSetNewTitle;

  /// No description provided for @forgotResetSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المرسل إلى بريدك ثم اختر كلمة مرور جديدة.'**
  String get forgotResetSubtitle;

  /// No description provided for @forgotTokenLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاستعادة'**
  String get forgotTokenLabel;

  /// No description provided for @forgotTokenRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الاستعادة.'**
  String get forgotTokenRequired;

  /// No description provided for @forgotNewPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get forgotNewPasswordLabel;

  /// No description provided for @forgotConfirmPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get forgotConfirmPasswordLabel;

  /// No description provided for @forgotPasswordsMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين.'**
  String get forgotPasswordsMismatch;

  /// No description provided for @forgotPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'استخدم 8 أحرف على الأقل مع حرف كبير وصغير ورقم ورمز.'**
  String get forgotPasswordHint;

  /// No description provided for @forgotSaving.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get forgotSaving;

  /// No description provided for @forgotSavePassword.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كلمة المرور'**
  String get forgotSavePassword;

  /// No description provided for @forgotSendNewCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز جديد'**
  String get forgotSendNewCode;

  /// No description provided for @forgotSuccessTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث كلمة المرور'**
  String get forgotSuccessTitle;

  /// No description provided for @forgotSuccessSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.'**
  String get forgotSuccessSubtitle;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى تسجيل الدخول'**
  String get forgotBackToLogin;

  /// No description provided for @forgotEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدًا إلكترونيًا صحيحًا.'**
  String get forgotEmailInvalid;

  /// No description provided for @forgotPasswordRequirements.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور لا تحقق المتطلبات.'**
  String get forgotPasswordRequirements;

  /// No description provided for @registerTypeAccount.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع الحساب'**
  String get registerTypeAccount;

  /// No description provided for @registerAccountData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الحساب'**
  String get registerAccountData;

  /// No description provided for @registerPharmacyData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الصيدلية'**
  String get registerPharmacyData;

  /// No description provided for @registerOrganizationData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المنظمة'**
  String get registerOrganizationData;

  /// No description provided for @registerWarehouseData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المستودع'**
  String get registerWarehouseData;

  /// No description provided for @registerTypeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع الحساب المناسب لاحتياجاتك.'**
  String get registerTypeSubtitle;

  /// No description provided for @registerAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات حسابك للمتابعة.'**
  String get registerAccountSubtitle;

  /// No description provided for @registerEntitySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل بيانات الجهة لإنشاء الحساب.'**
  String get registerEntitySubtitle;

  /// No description provided for @registerFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الحساب حاليًا.'**
  String get registerFailed;

  /// No description provided for @registerCoordsTogether.
  ///
  /// In ar, this message translates to:
  /// **'أدخل خط العرض وخط الطول معًا.'**
  String get registerCoordsTogether;

  /// No description provided for @registerCoordsInvalid.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من قيم الإحداثيات المدخلة.'**
  String get registerCoordsInvalid;

  /// No description provided for @registerIntro.
  ///
  /// In ar, this message translates to:
  /// **'لكل حساب مساحة عمل وخدمات مصممة حسب احتياجه.'**
  String get registerIntro;

  /// No description provided for @registerTypeUser.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get registerTypeUser;

  /// No description provided for @registerTypeUserDesc.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دوائك وتابع طلباتك ومعلوماتك الصحية.'**
  String get registerTypeUserDesc;

  /// No description provided for @registerTypePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية'**
  String get registerTypePharmacy;

  /// No description provided for @registerTypePharmacyDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدر المخزون وساعات العمل وطلبات المستخدمين.'**
  String get registerTypePharmacyDesc;

  /// No description provided for @registerTypeOrganization.
  ///
  /// In ar, this message translates to:
  /// **'منظمة'**
  String get registerTypeOrganization;

  /// No description provided for @registerTypeOrganizationDesc.
  ///
  /// In ar, this message translates to:
  /// **'نظّم الحملات واستقبل عروض التبرع وطلبات المساعدة.'**
  String get registerTypeOrganizationDesc;

  /// No description provided for @registerTypeWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'مستودع أدوية'**
  String get registerTypeWarehouse;

  /// No description provided for @registerTypeWarehouseDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدر التشغيلات وطلبات الصيدليات والشحن والفواتير.'**
  String get registerTypeWarehouseDesc;

  /// No description provided for @registerAccountInfo.
  ///
  /// In ar, this message translates to:
  /// **'أدخل معلومات صحيحة لنجهز حسابك بالشكل المناسب.'**
  String get registerAccountInfo;

  /// No description provided for @registerFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم كما يظهر في الحساب'**
  String get registerFullNameHint;

  /// No description provided for @registerFullNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم الكامل.'**
  String get registerFullNameRequired;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneOptionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف (اختياري)'**
  String get registerPhoneOptionalLabel;

  /// No description provided for @registerPhoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الهاتف.'**
  String get registerPhoneRequired;

  /// No description provided for @registerEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدًا إلكترونيًا صحيحًا.'**
  String get registerEmailInvalid;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'استخدم 8 محارف مع حرف كبير وصغير ورقم ورمز.'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerPasswordsMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين.'**
  String get registerPasswordsMismatch;

  /// No description provided for @registerAccountHelp.
  ///
  /// In ar, this message translates to:
  /// **'تساعد بيانات الحساب الصحيحة في تقديم تجربة مناسبة وآمنة.'**
  String get registerAccountHelp;

  /// No description provided for @registerPharmacyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصيدلية'**
  String get registerPharmacyName;

  /// No description provided for @registerWarehouseName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستودع'**
  String get registerWarehouseName;

  /// No description provided for @registerOrgName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنظمة'**
  String get registerOrgName;

  /// No description provided for @registerLicenseNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الترخيص'**
  String get registerLicenseNumber;

  /// No description provided for @registerRegNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم التسجيل'**
  String get registerRegNumber;

  /// No description provided for @registerPharmacyNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الصيدلية.'**
  String get registerPharmacyNameHint;

  /// No description provided for @registerWarehouseNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المستودع.'**
  String get registerWarehouseNameHint;

  /// No description provided for @registerOrgNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المنظمة.'**
  String get registerOrgNameHint;

  /// No description provided for @registerLicenseHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الترخيص.'**
  String get registerLicenseHint;

  /// No description provided for @registerRegNumberHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم التسجيل.'**
  String get registerRegNumberHint;

  /// No description provided for @registerBusinessIntro.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات {entityType}، وسيتم مراجعتها قبل تفعيل خدمات الحساب.'**
  String registerBusinessIntro(Object entityType);

  /// No description provided for @registerPharmacyWord.
  ///
  /// In ar, this message translates to:
  /// **'الصيدلية'**
  String get registerPharmacyWord;

  /// No description provided for @registerWarehouseWord.
  ///
  /// In ar, this message translates to:
  /// **'المستودع'**
  String get registerWarehouseWord;

  /// No description provided for @registerOrgWord.
  ///
  /// In ar, this message translates to:
  /// **'المنظمة'**
  String get registerOrgWord;

  /// No description provided for @registerCity.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get registerCity;

  /// No description provided for @registerCityRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل المدينة.'**
  String get registerCityRequired;

  /// No description provided for @registerArea.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة'**
  String get registerArea;

  /// No description provided for @registerAreaRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل المنطقة.'**
  String get registerAreaRequired;

  /// No description provided for @registerAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get registerAddress;

  /// No description provided for @registerAddressRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل العنوان.'**
  String get registerAddressRequired;

  /// No description provided for @registerDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف مختصر (اختياري)'**
  String get registerDescription;

  /// No description provided for @registerDeliveryService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة توصيل'**
  String get registerDeliveryService;

  /// No description provided for @registerDeliveryServiceSub.
  ///
  /// In ar, this message translates to:
  /// **'حددها إذا كانت الصيدلية توفر التوصيل'**
  String get registerDeliveryServiceSub;

  /// No description provided for @registerLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'موقع الصيدلية (اختياري)'**
  String get registerLocationTitle;

  /// No description provided for @registerLocationHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكن حفظ الموقع الآن أو إضافته لاحقًا من ملف الصيدلية.'**
  String get registerLocationHint;

  /// No description provided for @registerLatitude.
  ///
  /// In ar, this message translates to:
  /// **'خط العرض'**
  String get registerLatitude;

  /// No description provided for @registerLongitude.
  ///
  /// In ar, this message translates to:
  /// **'خط الطول'**
  String get registerLongitude;

  /// No description provided for @registerLocating.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحديد الموقع...'**
  String get registerLocating;

  /// No description provided for @registerLocateAuto.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الموقع تلقائيًا'**
  String get registerLocateAuto;

  /// No description provided for @registerLocationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديد الموقع. حاول مجددًا.'**
  String get registerLocationFailed;

  /// No description provided for @registerMinOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب'**
  String get registerMinOrder;

  /// No description provided for @registerDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل'**
  String get registerDeliveryFee;

  /// No description provided for @registerInvalidValue.
  ///
  /// In ar, this message translates to:
  /// **'أدخل قيمة صحيحة.'**
  String get registerInvalidValue;

  /// No description provided for @continueAction.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueAction;

  /// No description provided for @registerCreate.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get registerCreate;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك وتفضيلات استخدام التطبيق'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsPrefsSection.
  ///
  /// In ar, this message translates to:
  /// **'التفضيلات والحساب'**
  String get settingsPrefsSection;

  /// No description provided for @settingsPrefsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة بياناتك وطريقة استخدام التطبيق'**
  String get settingsPrefsSubtitle;

  /// No description provided for @settingsProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get settingsProfile;

  /// No description provided for @settingsProfileDesc.
  ///
  /// In ar, this message translates to:
  /// **'الاسم ورقم الهاتف والصورة'**
  String get settingsProfileDesc;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة التطبيق'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get settingsLanguageAr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsAppearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsAppearance;

  /// No description provided for @settingsAppearanceDesc.
  ///
  /// In ar, this message translates to:
  /// **'فاتح أو داكن أو حسب إعداد الجهاز'**
  String get settingsAppearanceDesc;

  /// No description provided for @settingsNotifications.
  ///
  /// In ar, this message translates to:
  /// **'تفضيلات الإشعارات'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsDesc.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات والتذكيرات والحملات'**
  String get settingsNotificationsDesc;

  /// No description provided for @settingsChangePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordDesc.
  ///
  /// In ar, this message translates to:
  /// **'تحديث كلمة مرور حسابك'**
  String get settingsChangePasswordDesc;

  /// No description provided for @settingsPrivacyHelpSection.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والمساعدة'**
  String get settingsPrivacyHelpSection;

  /// No description provided for @settingsPrivacyHelpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحيات والمعلومات المهمة عن استخدام دوائي'**
  String get settingsPrivacyHelpSubtitle;

  /// No description provided for @settingsNotificationCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز الإشعارات'**
  String get settingsNotificationCenter;

  /// No description provided for @settingsNotificationCenterDesc.
  ///
  /// In ar, this message translates to:
  /// **'عرض التنبيهات الواردة وحالتها'**
  String get settingsNotificationCenterDesc;

  /// No description provided for @settingsPermissions.
  ///
  /// In ar, this message translates to:
  /// **'صلاحيات الجهاز'**
  String get settingsPermissions;

  /// No description provided for @settingsPermissionsDesc.
  ///
  /// In ar, this message translates to:
  /// **'الموقع والكاميرا والملفات'**
  String get settingsPermissionsDesc;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyDesc.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك الآمنة وخصوصيتك'**
  String get settingsPrivacyDesc;

  /// No description provided for @settingsTermsDesc.
  ///
  /// In ar, this message translates to:
  /// **'البنود والأحكام العامة'**
  String get settingsTermsDesc;

  /// No description provided for @settingsHelp.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get settingsHelp;

  /// No description provided for @settingsHelpDesc.
  ///
  /// In ar, this message translates to:
  /// **'الدعم الفني والأسئلة الشائعة'**
  String get settingsHelpDesc;

  /// No description provided for @settingsAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن دوائي'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 1.0.0'**
  String get settingsVersion;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج من حسابك؟'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @roleRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'مندوب مستودع'**
  String get roleRepresentative;

  /// No description provided for @roleAdmin.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المنصة'**
  String get roleAdmin;

  /// No description provided for @verifiedAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب موثّق'**
  String get verifiedAccount;

  /// No description provided for @unverifiedAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب غير موثّق'**
  String get unverifiedAccount;

  /// No description provided for @accountProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get accountProfileTitle;

  /// No description provided for @accountProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات حسابك وصورتك'**
  String get accountProfileSubtitle;

  /// No description provided for @accountLoadingProfile.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل بياناتك...'**
  String get accountLoadingProfile;

  /// No description provided for @accountBasicData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الأساسية'**
  String get accountBasicData;

  /// No description provided for @accountFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get accountFullName;

  /// No description provided for @accountFullNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الاسم الكامل'**
  String get accountFullNameRequired;

  /// No description provided for @accountFullNameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا يتجاوز الاسم 150 حرفًا'**
  String get accountFullNameTooLong;

  /// No description provided for @accountEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get accountEmailLabel;

  /// No description provided for @accountPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get accountPhoneLabel;

  /// No description provided for @accountOptionalHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get accountOptionalHint;

  /// No description provided for @accountPhoneTooLong.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا يتجاوز الرقم 30 محرفًا'**
  String get accountPhoneTooLong;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @accountSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ بيانات الحساب'**
  String get accountSaved;

  /// No description provided for @accountImagesGroup.
  ///
  /// In ar, this message translates to:
  /// **'صور'**
  String get accountImagesGroup;

  /// No description provided for @accountImageTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'حجم الصورة يجب ألا يتجاوز 5 ميغابايت'**
  String get accountImageTooLarge;

  /// No description provided for @accountAvatarUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الصورة الشخصية'**
  String get accountAvatarUpdated;

  /// No description provided for @deleteImageTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get deleteImageTitle;

  /// No description provided for @deleteImageConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد إزالة صورتك الشخصية؟'**
  String get deleteImageConfirm;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @accountAvatarDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الصورة الشخصية'**
  String get accountAvatarDeleted;

  /// No description provided for @accountOperationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إكمال العملية حاليًا.'**
  String get accountOperationFailed;

  /// No description provided for @changePhoto.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الصورة'**
  String get changePhoto;

  /// No description provided for @addPhoto.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get addPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get removePhoto;

  /// No description provided for @changePasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على أمان حسابك'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الحالية'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordCurrentRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الحالية'**
  String get changePasswordCurrentRequired;

  /// No description provided for @changePasswordNew.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get changePasswordNew;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا تقل عن 8 أحرف'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordMaxLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا تتجاوز 128 حرفًا'**
  String get changePasswordMaxLength;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور الجديدة'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordDone.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة المرور بنجاح'**
  String get changePasswordDone;

  /// No description provided for @changePasswordFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تغيير كلمة المرور حاليًا.'**
  String get changePasswordFailed;

  /// No description provided for @changePasswordHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحديث كلمة المرور'**
  String get changePasswordHeroTitle;

  /// No description provided for @changePasswordHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر كلمة مختلفة وقوية لا تقل عن 8 أحرف.'**
  String get changePasswordHeroSubtitle;

  /// No description provided for @appearanceIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'مظهر مريح لك'**
  String get appearanceIntroTitle;

  /// No description provided for @appearanceIntroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر مظهر التطبيق أو اجعله يتبع إعداد جهازك.'**
  String get appearanceIntroSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'إعداد الجهاز'**
  String get themeSystem;

  /// No description provided for @themeSystemDesc.
  ///
  /// In ar, this message translates to:
  /// **'يتغير تلقائيًا مع مظهر الهاتف'**
  String get themeSystemDesc;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeLightDesc.
  ///
  /// In ar, this message translates to:
  /// **'ألوان واضحة ومضيئة'**
  String get themeLightDesc;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @themeDarkDesc.
  ///
  /// In ar, this message translates to:
  /// **'أكثر راحة في الإضاءة المنخفضة'**
  String get themeDarkDesc;

  /// No description provided for @notifIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابقَ على اطلاع'**
  String get notifIntroTitle;

  /// No description provided for @notifIntroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحكم بأنواع التنبيهات التي يعرضها التطبيق لك. صلاحية الإشعارات تُدار من إعدادات الهاتف.'**
  String get notifIntroSubtitle;

  /// No description provided for @notifInApp.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات داخل التطبيق'**
  String get notifInApp;

  /// No description provided for @notifInAppDesc.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل أو إيقاف عرض التنبيهات'**
  String get notifInAppDesc;

  /// No description provided for @notifRequestUpdates.
  ///
  /// In ar, this message translates to:
  /// **'تحديثات الطلبات'**
  String get notifRequestUpdates;

  /// No description provided for @notifRequestUpdatesDesc.
  ///
  /// In ar, this message translates to:
  /// **'حالة طلب الدواء والتجهيز والاستجابة'**
  String get notifRequestUpdatesDesc;

  /// No description provided for @notifHealthReminders.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات الصحية'**
  String get notifHealthReminders;

  /// No description provided for @notifHealthRemindersDesc.
  ///
  /// In ar, this message translates to:
  /// **'مواعيد الدواء والتنبيهات المرتبطة بصحتك'**
  String get notifHealthRemindersDesc;

  /// No description provided for @notifCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'الحملات والمبادرات'**
  String get notifCampaigns;

  /// No description provided for @notifCampaignsDesc.
  ///
  /// In ar, this message translates to:
  /// **'المستجدات المتعلقة بالتبرعات والحملات'**
  String get notifCampaignsDesc;

  /// No description provided for @permIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت المتحكم'**
  String get permIntroTitle;

  /// No description provided for @permIntroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يطلب دوائي الصلاحية عند الحاجة فقط، ويمكنك تعديلها من إعدادات هاتفك.'**
  String get permIntroSubtitle;

  /// No description provided for @permLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get permLocation;

  /// No description provided for @permLocationAllowed.
  ///
  /// In ar, this message translates to:
  /// **'مسموح أثناء استخدام التطبيق'**
  String get permLocationAllowed;

  /// No description provided for @permLocationServiceOff.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية متاحة، وخدمة الموقع متوقفة'**
  String get permLocationServiceOff;

  /// No description provided for @permLocationNotAllowed.
  ///
  /// In ar, this message translates to:
  /// **'غير مسموح حاليًا'**
  String get permLocationNotAllowed;

  /// No description provided for @permAllow.
  ///
  /// In ar, this message translates to:
  /// **'سماح'**
  String get permAllow;

  /// No description provided for @permCameraFiles.
  ///
  /// In ar, this message translates to:
  /// **'الكاميرا والملفات'**
  String get permCameraFiles;

  /// No description provided for @permCameraFilesDesc.
  ///
  /// In ar, this message translates to:
  /// **'تُطلب فقط عند اختيار صورة أو مستند لإرساله'**
  String get permCameraFilesDesc;

  /// No description provided for @permOpenLocationSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح إعدادات الموقع'**
  String get permOpenLocationSettings;

  /// No description provided for @permOpenAppSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح إعدادات التطبيق في الهاتف'**
  String get permOpenAppSettings;

  /// No description provided for @infoAccountData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الحساب'**
  String get infoAccountData;

  /// No description provided for @infoAccountDataDesc.
  ///
  /// In ar, this message translates to:
  /// **'نستخدم بيانات الحساب لتقديم الخدمات المرتبطة بدورك داخل النظام.'**
  String get infoAccountDataDesc;

  /// No description provided for @infoLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get infoLocation;

  /// No description provided for @infoLocationDesc.
  ///
  /// In ar, this message translates to:
  /// **'يُستخدم موقعك عند طلب البحث عن الصيدليات القريبة أو حساب المسار، ويمكنك إيقاف الصلاحية من هاتفك.'**
  String get infoLocationDesc;

  /// No description provided for @infoHealthData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الصحية'**
  String get infoHealthData;

  /// No description provided for @infoHealthDataDesc.
  ///
  /// In ar, this message translates to:
  /// **'تُرسل البيانات التي تدخلها إلى الخادم لتقديم المزايا الصحية المطلوبة، ولا ينبغي مشاركة بيانات الدخول مع أي شخص.'**
  String get infoHealthDataDesc;

  /// No description provided for @infoControl.
  ///
  /// In ar, this message translates to:
  /// **'التحكم'**
  String get infoControl;

  /// No description provided for @infoControlDesc.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تعديل بياناتك وكلمة مرورك وصلاحيات الجهاز من صفحات الحساب والإعدادات.'**
  String get infoControlDesc;

  /// No description provided for @infoInfoAccuracy.
  ///
  /// In ar, this message translates to:
  /// **'دقة المعلومات'**
  String get infoInfoAccuracy;

  /// No description provided for @infoInfoAccuracyDesc.
  ///
  /// In ar, this message translates to:
  /// **'اعتمد على العبوة والصيدلي أو الطبيب في القرارات الطبية؛ المعلومات داخل التطبيق مساندة وليست بديلًا عن المختص.'**
  String get infoInfoAccuracyDesc;

  /// No description provided for @infoResponsibleUse.
  ///
  /// In ar, this message translates to:
  /// **'الاستخدام المسؤول'**
  String get infoResponsibleUse;

  /// No description provided for @infoResponsibleUseDesc.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخال بيانات صحيحة وعدم إساءة استخدام الطلبات أو التبرعات أو حسابات الجهات.'**
  String get infoResponsibleUseDesc;

  /// No description provided for @infoEmergency.
  ///
  /// In ar, this message translates to:
  /// **'الطوارئ'**
  String get infoEmergency;

  /// No description provided for @infoEmergencyDesc.
  ///
  /// In ar, this message translates to:
  /// **'لا يُستخدم التطبيق لطلب إسعاف أو معالجة حالة طارئة؛ تواصل مع خدمات الطوارئ المحلية فورًا.'**
  String get infoEmergencyDesc;

  /// No description provided for @infoAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get infoAccount;

  /// No description provided for @infoAccountDesc.
  ///
  /// In ar, this message translates to:
  /// **'أنت مسؤول عن الحفاظ على سرية بيانات الدخول والإبلاغ عن أي استخدام غير معتاد.'**
  String get infoAccountDesc;

  /// No description provided for @infoMapNotShown.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة لا تظهر'**
  String get infoMapNotShown;

  /// No description provided for @infoMapNotShownDesc.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من تشغيل خدمة الموقع ومنح التطبيق صلاحية الموقع، ثم أعد تحميل الصفحة.'**
  String get infoMapNotShownDesc;

  /// No description provided for @infoConnectionFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال'**
  String get infoConnectionFailed;

  /// No description provided for @infoConnectionFailedDesc.
  ///
  /// In ar, this message translates to:
  /// **'تأكد أن الهاتف والخادم على الشبكة نفسها وأن عنوان الخادم صحيح ومتاح.'**
  String get infoConnectionFailedDesc;

  /// No description provided for @infoRecoveryCodeMissing.
  ///
  /// In ar, this message translates to:
  /// **'لم يصل رمز الاستعادة'**
  String get infoRecoveryCodeMissing;

  /// No description provided for @infoRecoveryCodeMissingDesc.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من البريد غير المرغوب فيه ثم اطلب رمزًا جديدًا. أثناء التطوير المحلي يظهر الرمز داخل صفحة الاستعادة.'**
  String get infoRecoveryCodeMissingDesc;

  /// No description provided for @infoAccountIssue.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في الحساب'**
  String get infoAccountIssue;

  /// No description provided for @infoAccountIssueDesc.
  ///
  /// In ar, this message translates to:
  /// **'جرّب تسجيل الخروج والدخول مجددًا، وتأكد من اعتماد حساب الجهة إن كان يتطلب موافقة الإدارة.'**
  String get infoAccountIssueDesc;

  /// No description provided for @infoDawaaiDesc.
  ///
  /// In ar, this message translates to:
  /// **'منصة تربط المستخدم بالصيدليات والمنظمات وسلسلة توريد الدواء ضمن تجربة موحدة.'**
  String get infoDawaaiDesc;

  /// No description provided for @infoProjectGoal.
  ///
  /// In ar, this message translates to:
  /// **'هدف المشروع'**
  String get infoProjectGoal;

  /// No description provided for @infoProjectGoalDesc.
  ///
  /// In ar, this message translates to:
  /// **'تسهيل العثور على الدواء، متابعة الطلبات، دعم المبادرات الدوائية، وتنظيم عمل الجهات المشاركة.'**
  String get infoProjectGoalDesc;

  /// No description provided for @infoMedicalNotice.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه طبي'**
  String get infoMedicalNotice;

  /// No description provided for @infoMedicalNoticeDesc.
  ///
  /// In ar, this message translates to:
  /// **'لا يقدم التطبيق تشخيصًا طبيًا، ويجب الرجوع إلى الطبيب أو الصيدلي عند الحاجة.'**
  String get infoMedicalNoticeDesc;

  /// No description provided for @searchHistoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل البحث'**
  String get searchHistoryTitle;

  /// No description provided for @searchClearing.
  ///
  /// In ar, this message translates to:
  /// **'جاري المسح'**
  String get searchClearing;

  /// No description provided for @searchClearAll.
  ///
  /// In ar, this message translates to:
  /// **'مسح الكل'**
  String get searchClearAll;

  /// No description provided for @searchLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل سجل البحث...'**
  String get searchLoading;

  /// No description provided for @searchNearbyPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن صيدليات قريبة'**
  String get searchNearbyPharmacy;

  /// No description provided for @searchResultCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} نتيجة'**
  String searchResultCount(Object count);

  /// No description provided for @searchDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get searchDelete;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سجل بحث'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر عمليات البحث التي تجريها هنا.'**
  String get searchEmptySubtitle;

  /// No description provided for @searchClearTitle.
  ///
  /// In ar, this message translates to:
  /// **'مسح سجل البحث؟'**
  String get searchClearTitle;

  /// No description provided for @searchClearConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف جميع عمليات البحث المحفوظة في حسابك.'**
  String get searchClearConfirm;

  /// No description provided for @searchClearAction.
  ///
  /// In ar, this message translates to:
  /// **'مسح السجل'**
  String get searchClearAction;

  /// No description provided for @searchClearFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حذف سجل البحث حاليًا.'**
  String get searchClearFailed;

  /// No description provided for @distanceMeters.
  ///
  /// In ar, this message translates to:
  /// **'{value} م'**
  String distanceMeters(String value);

  /// No description provided for @distanceKm.
  ///
  /// In ar, this message translates to:
  /// **'{value} كم'**
  String distanceKm(String value);

  /// No description provided for @statusAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get statusAll;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get statusPending;

  /// No description provided for @statusAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get statusAvailable;

  /// No description provided for @statusUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get statusUnavailable;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get statusCancelled;

  /// No description provided for @requestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get requestsTitle;

  /// No description provided for @requestsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل طلباتك...'**
  String get requestsLoading;

  /// No description provided for @requestsIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع طلبات أدويتك'**
  String get requestsIntroTitle;

  /// No description provided for @requestsIntroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اطّلع على رد الصيدلية وحالة كل طلب.'**
  String get requestsIntroSubtitle;

  /// No description provided for @newRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get newRequest;

  /// No description provided for @requestNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get requestNumber;

  /// No description provided for @requestQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get requestQuantity;

  /// No description provided for @requestDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get requestDate;

  /// No description provided for @requestsEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات ضمن هذا التصنيف'**
  String get requestsEmptyTitle;

  /// No description provided for @requestsEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دوائك واختر الصيدلية المناسبة لإرسال طلب.'**
  String get requestsEmptySubtitle;

  /// No description provided for @medicineAvailable.
  ///
  /// In ar, this message translates to:
  /// **'الدواء متوفر'**
  String get medicineAvailable;

  /// No description provided for @requestDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get requestDetailsTitle;

  /// No description provided for @requestDetailsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل تفاصيل الطلب...'**
  String get requestDetailsLoading;

  /// No description provided for @yourNoteToPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظتك للصيدلية'**
  String get yourNoteToPharmacy;

  /// No description provided for @cancellingProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري الإلغاء...'**
  String get cancellingProgress;

  /// No description provided for @cancelRequest.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get cancelRequest;

  /// No description provided for @cancelRequestTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب؟'**
  String get cancelRequestTitle;

  /// No description provided for @cancelRequestConfirm.
  ///
  /// In ar, this message translates to:
  /// **'لن تتمكن الصيدلية من متابعة هذا الطلب بعد إلغائه.'**
  String get cancelRequestConfirm;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get back;

  /// No description provided for @confirmCancellation.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الإلغاء'**
  String get confirmCancellation;

  /// No description provided for @requestCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الطلب'**
  String get requestCancelled;

  /// No description provided for @cancelRequestFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إلغاء الطلب حاليًا.'**
  String get cancelRequestFailed;

  /// No description provided for @requestStepSent.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال'**
  String get requestStepSent;

  /// No description provided for @requestStepCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم الإلغاء'**
  String get requestStepCancelled;

  /// No description provided for @underReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get underReview;

  /// No description provided for @responded.
  ///
  /// In ar, this message translates to:
  /// **'تم الرد'**
  String get responded;

  /// No description provided for @waitingForResponse.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الرد'**
  String get waitingForResponse;

  /// No description provided for @quantityRequested.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المطلوبة'**
  String get quantityRequested;

  /// No description provided for @createdDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإنشاء'**
  String get createdDate;

  /// No description provided for @lastUpdate.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث'**
  String get lastUpdate;

  /// No description provided for @currentAvailability.
  ///
  /// In ar, this message translates to:
  /// **'التوفر الحالي'**
  String get currentAvailability;

  /// No description provided for @availableInStock.
  ///
  /// In ar, this message translates to:
  /// **'متوفر في المخزون'**
  String get availableInStock;

  /// No description provided for @notAvailableNow.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر حاليًا'**
  String get notAvailableNow;

  /// No description provided for @pharmacyResponse.
  ///
  /// In ar, this message translates to:
  /// **'رد الصيدلية'**
  String get pharmacyResponse;

  /// No description provided for @suggestedAlternative.
  ///
  /// In ar, this message translates to:
  /// **'البديل المقترح'**
  String get suggestedAlternative;

  /// No description provided for @thePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'الصيدلية'**
  String get thePharmacy;

  /// No description provided for @directions.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get directions;

  /// No description provided for @medicineUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'الدواء غير متوفر'**
  String get medicineUnavailable;

  /// No description provided for @waitingForPharmacyResponse.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار رد الصيدلية'**
  String get waitingForPharmacyResponse;

  /// No description provided for @pharmacyDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الصيدلية'**
  String get pharmacyDetailsTitle;

  /// No description provided for @pharmacyDetailsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل بيانات الصيدلية...'**
  String get pharmacyDetailsLoading;

  /// No description provided for @availableMedicines.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية المتوفرة'**
  String get availableMedicines;

  /// No description provided for @medicinesAvailableCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} دواء متاح للطلب'**
  String medicinesAvailableCount(Object count);

  /// No description provided for @deliveryAvailable.
  ///
  /// In ar, this message translates to:
  /// **'توصيل متاح'**
  String get deliveryAvailable;

  /// No description provided for @call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get call;

  /// No description provided for @requiresPrescription.
  ///
  /// In ar, this message translates to:
  /// **'يتطلب وصفة'**
  String get requiresPrescription;

  /// No description provided for @requestMedicineTitle.
  ///
  /// In ar, this message translates to:
  /// **'إرسال طلب دواء'**
  String get requestMedicineTitle;

  /// No description provided for @requestMedicineSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستراجع الصيدلية طلبك وترد عليه'**
  String get requestMedicineSubtitle;

  /// No description provided for @medicineLabel.
  ///
  /// In ar, this message translates to:
  /// **'الدواء'**
  String get medicineLabel;

  /// No description provided for @noteToPharmacyOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة للصيدلية (اختياري)'**
  String get noteToPharmacyOptional;

  /// No description provided for @sendingProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري الإرسال...'**
  String get sendingProgress;

  /// No description provided for @sendRequest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get sendRequest;

  /// No description provided for @rateExperienceTitle.
  ///
  /// In ar, this message translates to:
  /// **'قيّم تجربتك'**
  String get rateExperienceTitle;

  /// No description provided for @rateExperienceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'شارك رأيك لمساعدة مستخدمين آخرين'**
  String get rateExperienceSubtitle;

  /// No description provided for @ratingHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رأيك باختصار (اختياري)'**
  String get ratingHint;

  /// No description provided for @savingProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get savingProgress;

  /// No description provided for @saveRating.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التقييم'**
  String get saveRating;

  /// No description provided for @workingHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get workingHours;

  /// No description provided for @workingHoursSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'جدول الدوام الأسبوعي للصيدلية'**
  String get workingHoursSubtitle;

  /// No description provided for @dayFallback.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get dayFallback;

  /// No description provided for @closed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get closed;

  /// No description provided for @daySunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get daySunday;

  /// No description provided for @dayMonday.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get daySaturday;

  /// No description provided for @chooseMedicineFirst.
  ///
  /// In ar, this message translates to:
  /// **'اختر الدواء أولًا.'**
  String get chooseMedicineFirst;

  /// No description provided for @requestSentTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الطلب'**
  String get requestSentTitle;

  /// No description provided for @requestSentContent.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب {code}\nيمكنك متابعة رد الصيدلية من صفحة طلباتي.'**
  String requestSentContent(Object code);

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @viewRequest.
  ///
  /// In ar, this message translates to:
  /// **'عرض الطلب'**
  String get viewRequest;

  /// No description provided for @chooseStarsFirst.
  ///
  /// In ar, this message translates to:
  /// **'اختر عدد النجوم أولًا.'**
  String get chooseStarsFirst;

  /// No description provided for @ratingSaved.
  ///
  /// In ar, this message translates to:
  /// **'شكرًا، تم حفظ تقييمك.'**
  String get ratingSaved;

  /// No description provided for @operationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إكمال العملية حاليًا.'**
  String get operationFailed;

  /// No description provided for @noMedicinesAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية متاحة حاليًا'**
  String get noMedicinesAvailable;

  /// No description provided for @priceNotAnnounced.
  ///
  /// In ar, this message translates to:
  /// **'السعر غير معلن'**
  String get priceNotAnnounced;

  /// No description provided for @currencySYP.
  ///
  /// In ar, this message translates to:
  /// **'{value} ل.س'**
  String currencySYP(String value);

  /// No description provided for @medicineSearchTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن دواء'**
  String get medicineSearchTitle;

  /// No description provided for @nearbyPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات القريبة'**
  String get nearbyPharmacies;

  /// No description provided for @searchStartTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بكتابة اسم الدواء'**
  String get searchStartTitle;

  /// No description provided for @searchStartMessage.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر الصيدليات التي يتوفر لديها الدواء مع السعر والمسافة.'**
  String get searchStartMessage;

  /// No description provided for @searchLoadingNearby.
  ///
  /// In ar, this message translates to:
  /// **'نبحث في الصيدليات القريبة...'**
  String get searchLoadingNearby;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد نتائج مطابقة'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsMessage.
  ///
  /// In ar, this message translates to:
  /// **'جرّب الاسم العلمي أو وسّع نطاق البحث وتحقق من كتابة الاسم.'**
  String get searchNoResultsMessage;

  /// No description provided for @searchResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نتائج البحث'**
  String get searchResultsTitle;

  /// No description provided for @searchResultsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{results} نتيجة لدى {pharmacies} صيدليات'**
  String searchResultsSubtitle(Object results, Object pharmacies);

  /// No description provided for @searchEmptyQuery.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسم الدواء للبحث.'**
  String get searchEmptyQuery;

  /// No description provided for @setLocationFirst.
  ///
  /// In ar, this message translates to:
  /// **'حدد موقعك أولًا'**
  String get setLocationFirst;

  /// No description provided for @setLocationDesc.
  ///
  /// In ar, this message translates to:
  /// **'نستخدم موقعك لعرض الدواء والصيدليات الأقرب إليك.'**
  String get setLocationDesc;

  /// No description provided for @setLocationAction.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الموقع'**
  String get setLocationAction;

  /// No description provided for @searchHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دوائك بسهولة'**
  String get searchHeroTitle;

  /// No description provided for @searchHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قارن التوفر والسعر والمسافة.'**
  String get searchHeroSubtitle;

  /// No description provided for @medicineNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get medicineNameLabel;

  /// No description provided for @medicineNameHint.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء أو الاسم العلمي'**
  String get medicineNameHint;

  /// No description provided for @radiusLabel.
  ///
  /// In ar, this message translates to:
  /// **'النطاق'**
  String get radiusLabel;

  /// No description provided for @sortLabel.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get sortLabel;

  /// No description provided for @searchingProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري البحث...'**
  String get searchingProgress;

  /// No description provided for @searchAction.
  ///
  /// In ar, this message translates to:
  /// **'عرض أماكن توفر الدواء'**
  String get searchAction;

  /// No description provided for @sortBestMatch.
  ///
  /// In ar, this message translates to:
  /// **'الأفضل تطابقًا'**
  String get sortBestMatch;

  /// No description provided for @sortDistance.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get sortDistance;

  /// No description provided for @sortOpenNow.
  ///
  /// In ar, this message translates to:
  /// **'المفتوحة الآن'**
  String get sortOpenNow;

  /// No description provided for @sortRating.
  ///
  /// In ar, this message translates to:
  /// **'الأعلى تقييمًا'**
  String get sortRating;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأقل'**
  String get sortPriceLowToHigh;

  /// No description provided for @priceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get priceLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get distanceLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get ratingLabel;

  /// No description provided for @viewPharmacyAndRequest.
  ///
  /// In ar, this message translates to:
  /// **'عرض الصيدلية وطلب الدواء'**
  String get viewPharmacyAndRequest;

  /// No description provided for @priceUnannounced.
  ///
  /// In ar, this message translates to:
  /// **'غير معلن'**
  String get priceUnannounced;

  /// No description provided for @medicalProfileTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الصحي'**
  String get medicalProfileTitle;

  /// No description provided for @healthProfileSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ الملف الصحي.'**
  String get healthProfileSaveFailed;

  /// No description provided for @medicalProfileLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل ملفك الصحي...'**
  String get medicalProfileLoading;

  /// No description provided for @healthCardLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري إعداد البطاقة الصحية...'**
  String get healthCardLoading;

  /// No description provided for @birthDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get birthDate;

  /// No description provided for @selectDate.
  ///
  /// In ar, this message translates to:
  /// **'اختيار'**
  String get selectDate;

  /// No description provided for @choose.
  ///
  /// In ar, this message translates to:
  /// **'اختر'**
  String get choose;

  /// No description provided for @medicalProfileSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملف الصحي بنجاح.'**
  String get medicalProfileSaved;

  /// No description provided for @healthDataTab.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الصحية'**
  String get healthDataTab;

  /// No description provided for @healthCardTab.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة الصحية'**
  String get healthCardTab;

  /// No description provided for @healthIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات تساعدك وقت الحاجة'**
  String get healthIntroTitle;

  /// No description provided for @healthIntroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احتفظ بحساسياتك وأدويتك الحالية وبيانات التواصل الضرورية محدثة.'**
  String get healthIntroSubtitle;

  /// No description provided for @basicInfoTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الأساسية'**
  String get basicInfoTitle;

  /// No description provided for @chooseDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get chooseDate;

  /// No description provided for @healthDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل الصحية'**
  String get healthDetailsTitle;

  /// No description provided for @allergiesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحساسيات'**
  String get allergiesLabel;

  /// No description provided for @allergiesHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: البنسلين'**
  String get allergiesHint;

  /// No description provided for @chronicConditionsLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحالات المزمنة'**
  String get chronicConditionsLabel;

  /// No description provided for @chronicConditionsHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: السكري'**
  String get chronicConditionsHint;

  /// No description provided for @currentMedicationsLabel.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية الحالية'**
  String get currentMedicationsLabel;

  /// No description provided for @currentMedicationsHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسم الدواء'**
  String get currentMedicationsHint;

  /// No description provided for @emergencyContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'جهة الاتصال عند الحاجة'**
  String get emergencyContactTitle;

  /// No description provided for @emergencyNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم جهة الاتصال'**
  String get emergencyNameLabel;

  /// No description provided for @emergencyNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get emergencyNameHint;

  /// No description provided for @nameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'الاسم طويل جدًا.'**
  String get nameTooLong;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 09XXXXXXXX'**
  String get phoneHint;

  /// No description provided for @phoneTooLong.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف طويل جدًا.'**
  String get phoneTooLong;

  /// No description provided for @importantNotesLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات مهمة'**
  String get importantNotesLabel;

  /// No description provided for @importantNotesHint.
  ///
  /// In ar, this message translates to:
  /// **'أي معلومات تساعد جهة الاتصال'**
  String get importantNotesHint;

  /// No description provided for @notesTooLong.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات تتجاوز الحد المسموح.'**
  String get notesTooLong;

  /// No description provided for @bloodTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'فصيلة الدم'**
  String get bloodTypeLabel;

  /// No description provided for @notSpecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get notSpecified;

  /// No description provided for @noAllergies.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حساسيات مسجلة'**
  String get noAllergies;

  /// No description provided for @noConditions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حالات مزمنة مسجلة'**
  String get noConditions;

  /// No description provided for @noMedications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية حالية مسجلة'**
  String get noMedications;

  /// No description provided for @textTooLong.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا يتجاوز النص 150 حرفًا.'**
  String get textTooLong;

  /// No description provided for @addTag.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get addTag;

  /// No description provided for @emergencyContactEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم إضافة جهة اتصال بعد.'**
  String get emergencyContactEmpty;

  /// No description provided for @dashboardLoading.
  ///
  /// In ar, this message translates to:
  /// **'نجهز مساحتك الشخصية...'**
  String get dashboardLoading;

  /// No description provided for @metricActiveRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات نشطة'**
  String get metricActiveRequests;

  /// No description provided for @metricCompletedRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مكتملة'**
  String get metricCompletedRequests;

  /// No description provided for @metricOpenPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'صيدليات مفتوحة'**
  String get metricOpenPharmacies;

  /// No description provided for @quickAccessTitle.
  ///
  /// In ar, this message translates to:
  /// **'وصول سريع'**
  String get quickAccessTitle;

  /// No description provided for @quickAccessSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات التي قد تحتاجها اليوم'**
  String get quickAccessSubtitle;

  /// No description provided for @myPrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'وصفاتي'**
  String get myPrescriptions;

  /// No description provided for @myPrescriptionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الوصفات والطلبات'**
  String get myPrescriptionsSubtitle;

  /// No description provided for @donations.
  ///
  /// In ar, this message translates to:
  /// **'التبرعات'**
  String get donations;

  /// No description provided for @donationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دواء يصل إلى من يحتاجه'**
  String get donationsSubtitle;

  /// No description provided for @organizations.
  ///
  /// In ar, this message translates to:
  /// **'المنظمات'**
  String get organizations;

  /// No description provided for @organizationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف الحملات الفعّالة'**
  String get organizationsSubtitle;

  /// No description provided for @pharmacyAssistant.
  ///
  /// In ar, this message translates to:
  /// **'المساعد الدوائي'**
  String get pharmacyAssistant;

  /// No description provided for @pharmacyAssistantSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اسأل وتابع محادثاتك'**
  String get pharmacyAssistantSubtitle;

  /// No description provided for @medicineAlternatives.
  ///
  /// In ar, this message translates to:
  /// **'البدائل الدوائية'**
  String get medicineAlternatives;

  /// No description provided for @medicineAlternativesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قارن البدائل المتاحة'**
  String get medicineAlternativesSubtitle;

  /// No description provided for @searchHistorySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ارجع لعمليات البحث السابقة'**
  String get searchHistorySubtitle;

  /// No description provided for @locationSectionTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموقع والصيدليات'**
  String get locationSectionTitle;

  /// No description provided for @locationSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نتائج قريبة اعتمادًا على موقعك المحفوظ'**
  String get locationSectionSubtitle;

  /// No description provided for @latestRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'أحدث الطلبات'**
  String get latestRequestsTitle;

  /// No description provided for @latestRequestsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر المستجدات على طلبات الأدوية'**
  String get latestRequestsSubtitle;

  /// No description provided for @emptyRequestsActivity.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات بعد. يمكنك البدء بالبحث عن دوائك.'**
  String get emptyRequestsActivity;

  /// No description provided for @searchActivityTitle.
  ///
  /// In ar, this message translates to:
  /// **'نشاط البحث'**
  String get searchActivityTitle;

  /// No description provided for @searchActivitySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عمليات البحث الحديثة'**
  String get searchActivitySubtitle;

  /// No description provided for @emptySearchActivity.
  ///
  /// In ar, this message translates to:
  /// **'لم تبدأ البحث بعد.'**
  String get emptySearchActivity;

  /// No description provided for @healthSpace.
  ///
  /// In ar, this message translates to:
  /// **'مساحتك الصحية'**
  String get healthSpace;

  /// No description provided for @heroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دوائك، تابع طلباتك واحتفظ\nبمعلوماتك الصحية في مكان واحد.'**
  String get heroSubtitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دواء...'**
  String get searchPlaceholder;

  /// No description provided for @searchCta.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get searchCta;

  /// No description provided for @locationSavedHero.
  ///
  /// In ar, this message translates to:
  /// **'موقعك محفوظ — النتائج الأقرب لك'**
  String get locationSavedHero;

  /// No description provided for @addLocationHero.
  ///
  /// In ar, this message translates to:
  /// **'أضف موقعك لعرض الصيدليات القريبة'**
  String get addLocationHero;

  /// No description provided for @locationSavedTitle.
  ///
  /// In ar, this message translates to:
  /// **'موقعك محفوظ'**
  String get locationSavedTitle;

  /// No description provided for @setLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'حدد موقعك'**
  String get setLocationTitle;

  /// No description provided for @locationSummarySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نطاق {radius} كم — {count} صيدليات مسجلة'**
  String locationSummarySubtitle(Object radius, Object count);

  /// No description provided for @addLocationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف موقعك من خدمة الصيدليات القريبة'**
  String get addLocationSubtitle;

  /// No description provided for @openLabel.
  ///
  /// In ar, this message translates to:
  /// **'مفتوحة'**
  String get openLabel;

  /// No description provided for @closedLabel.
  ///
  /// In ar, this message translates to:
  /// **'مغلقة'**
  String get closedLabel;

  /// No description provided for @searchForMedicine.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن دواء'**
  String get searchForMedicine;

  /// No description provided for @searchForPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن صيدلية'**
  String get searchForPharmacy;

  /// No description provided for @medicineRequestType.
  ///
  /// In ar, this message translates to:
  /// **'طلب دواء'**
  String get medicineRequestType;

  /// No description provided for @updateMyLocation.
  ///
  /// In ar, this message translates to:
  /// **'تحديث موقعي'**
  String get updateMyLocation;

  /// No description provided for @locatingPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'نحدد الصيدليات الأقرب إليك...'**
  String get locatingPharmacies;

  /// No description provided for @discoverNearest.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف الأقرب إليك'**
  String get discoverNearest;

  /// No description provided for @nearbyHeaderSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اعرض أقرب ثلاث صيدليات والطريق إلى الخيار الأقرب.'**
  String get nearbyHeaderSubtitle;

  /// No description provided for @locatingNow.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحديد...'**
  String get locatingNow;

  /// No description provided for @myCurrentLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي الحالي'**
  String get myCurrentLocation;

  /// No description provided for @manualLabel.
  ///
  /// In ar, this message translates to:
  /// **'يدوي'**
  String get manualLabel;

  /// No description provided for @searchRangeLabel.
  ///
  /// In ar, this message translates to:
  /// **'نطاق البحث'**
  String get searchRangeLabel;

  /// No description provided for @dragMapHint.
  ///
  /// In ar, this message translates to:
  /// **'اسحب الخريطة للاستكشاف'**
  String get dragMapHint;

  /// No description provided for @locationUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث موقعك وعرض النتائج الأقرب.'**
  String get locationUpdated;

  /// No description provided for @locationUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الموقع حاليًا.'**
  String get locationUpdateFailed;

  /// No description provided for @mapLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل الخريطة'**
  String get mapLoadFailed;

  /// No description provided for @mapLoadFailedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من اتصالك بالإنترنت ثم حاول مجددًا.'**
  String get mapLoadFailedSubtitle;

  /// No description provided for @backToMyLocation.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى موقعي'**
  String get backToMyLocation;

  /// No description provided for @showAllLocations.
  ///
  /// In ar, this message translates to:
  /// **'عرض جميع المواقع'**
  String get showAllLocations;

  /// No description provided for @shrinkMap.
  ///
  /// In ar, this message translates to:
  /// **'تصغير الخريطة'**
  String get shrinkMap;

  /// No description provided for @expandMap.
  ///
  /// In ar, this message translates to:
  /// **'تكبير الخريطة'**
  String get expandMap;

  /// No description provided for @mapOpenFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح تطبيق الخرائط.'**
  String get mapOpenFailed;

  /// No description provided for @routeToNearest.
  ///
  /// In ar, this message translates to:
  /// **'{distance}{time} إلى الأقرب'**
  String routeToNearest(String distance, String time);

  /// No description provided for @minuteUnit.
  ///
  /// In ar, this message translates to:
  /// **'د'**
  String get minuteUnit;

  /// No description provided for @exploreMapHint.
  ///
  /// In ar, this message translates to:
  /// **'استكشف الصيدليات على الخريطة'**
  String get exploreMapHint;

  /// No description provided for @routeMinutes.
  ///
  /// In ar, this message translates to:
  /// **'نحو {minutes} دقيقة'**
  String routeMinutes(Object minutes);

  /// No description provided for @startDirections.
  ///
  /// In ar, this message translates to:
  /// **'بدء الاتجاهات'**
  String get startDirections;

  /// No description provided for @yourCurrentLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعك الحالي'**
  String get yourCurrentLocation;

  /// No description provided for @pharmacyMarkerSemantics.
  ///
  /// In ar, this message translates to:
  /// **'الصيدلية رقم {number}، {name}'**
  String pharmacyMarkerSemantics(Object number, String name);

  /// No description provided for @nearestThreePharmacies.
  ///
  /// In ar, this message translates to:
  /// **'أقرب 3 صيدليات'**
  String get nearestThreePharmacies;

  /// No description provided for @resultsSummaryCounts.
  ///
  /// In ar, this message translates to:
  /// **'{registered} مسجلة · {external} خيارات إضافية'**
  String resultsSummaryCounts(Object registered, Object external);

  /// No description provided for @nearestLabel.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get nearestLabel;

  /// No description provided for @manualLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدخال الموقع يدويًا'**
  String get manualLocationTitle;

  /// No description provided for @manualLocationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الإحداثيات الدقيقة لموقعك الحالي.'**
  String get manualLocationSubtitle;

  /// No description provided for @latitudeLabel.
  ///
  /// In ar, this message translates to:
  /// **'خط العرض'**
  String get latitudeLabel;

  /// No description provided for @latitudeInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل خط عرض بين -90 و90.'**
  String get latitudeInvalid;

  /// No description provided for @longitudeLabel.
  ///
  /// In ar, this message translates to:
  /// **'خط الطول'**
  String get longitudeLabel;

  /// No description provided for @longitudeInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل خط طول بين -180 و180.'**
  String get longitudeInvalid;

  /// No description provided for @saveLocation.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الموقع'**
  String get saveLocation;

  /// No description provided for @noLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تحديد الموقع'**
  String get noLocationTitle;

  /// No description provided for @noLocationMessage.
  ///
  /// In ar, this message translates to:
  /// **'استخدم موقع الجهاز أو أدخل الإحداثيات لعرض الصيدليات.'**
  String get noLocationMessage;

  /// No description provided for @noNearbyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صيدليات ضمن النطاق'**
  String get noNearbyTitle;

  /// No description provided for @noNearbyMessage.
  ///
  /// In ar, this message translates to:
  /// **'وسّع مسافة البحث أو حدّث موقعك ثم حاول مجددًا.'**
  String get noNearbyMessage;

  /// No description provided for @chatAssistantSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إرشاد سريع للوصول إلى خدمات دوائي'**
  String get chatAssistantSubtitle;

  /// No description provided for @chatLoadingSessions.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المحادثات...'**
  String get chatLoadingSessions;

  /// No description provided for @previousChats.
  ///
  /// In ar, this message translates to:
  /// **'المحادثات السابقة'**
  String get previousChats;

  /// No description provided for @newChat.
  ///
  /// In ar, this message translates to:
  /// **'محادثة جديدة'**
  String get newChat;

  /// No description provided for @chatTitleOptional.
  ///
  /// In ar, this message translates to:
  /// **'عنوان المحادثة (اختياري)'**
  String get chatTitleOptional;

  /// No description provided for @start.
  ///
  /// In ar, this message translates to:
  /// **'بدء'**
  String get start;

  /// No description provided for @startChatFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر بدء المحادثة حاليًا.'**
  String get startChatFailed;

  /// No description provided for @howCanIHelp.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني مساعدتك؟'**
  String get howCanIHelp;

  /// No description provided for @chatHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن دواء، صيدلية قريبة، أو خدمة داخل التطبيق.'**
  String get chatHeroSubtitle;

  /// No description provided for @nearbyPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية قريبة'**
  String get nearbyPharmacy;

  /// No description provided for @healthServicesHint.
  ///
  /// In ar, this message translates to:
  /// **'خدمات صحية'**
  String get healthServicesHint;

  /// No description provided for @chatSessionTitle.
  ///
  /// In ar, this message translates to:
  /// **'محادثة دوائية'**
  String get chatSessionTitle;

  /// No description provided for @messageCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} رسائل'**
  String messageCount(Object count);

  /// No description provided for @noPreviousChats.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محادثات سابقة'**
  String get noPreviousChats;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل جديد في مكان واحد'**
  String get notificationsSubtitle;

  /// No description provided for @markingAllRead.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحديث...'**
  String get markingAllRead;

  /// No description provided for @markAllRead.
  ///
  /// In ar, this message translates to:
  /// **'قراءة الكل'**
  String get markAllRead;

  /// No description provided for @notificationsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الإشعارات...'**
  String get notificationsLoading;

  /// No description provided for @notifUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الإشعار.'**
  String get notifUpdateFailed;

  /// No description provided for @markedReadCount.
  ///
  /// In ar, this message translates to:
  /// **'تم تعليم {count} إشعارات كمقروءة.'**
  String markedReadCount(Object count);

  /// No description provided for @notificationsUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الإشعارات.'**
  String get notificationsUpdateFailed;

  /// No description provided for @notifStatTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get notifStatTotal;

  /// No description provided for @notifStatNew.
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get notifStatNew;

  /// No description provided for @notifStatRead.
  ///
  /// In ar, this message translates to:
  /// **'مقروءة'**
  String get notifStatRead;

  /// No description provided for @unreadOnlyLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجديدة فقط'**
  String get unreadOnlyLabel;

  /// No description provided for @notificationTypeHint.
  ///
  /// In ar, this message translates to:
  /// **'نوع الإشعار'**
  String get notificationTypeHint;

  /// No description provided for @allNotifications.
  ///
  /// In ar, this message translates to:
  /// **'جميع الإشعارات'**
  String get allNotifications;

  /// No description provided for @notifTypePrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'الوصفات'**
  String get notifTypePrescriptions;

  /// No description provided for @notifTypeRequests.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get notifTypeRequests;

  /// No description provided for @notifTypeReminders.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات'**
  String get notifTypeReminders;

  /// No description provided for @notifTypeApprovals.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات'**
  String get notifTypeApprovals;

  /// No description provided for @notifTypeVerification.
  ///
  /// In ar, this message translates to:
  /// **'التحقق'**
  String get notifTypeVerification;

  /// No description provided for @notifTypeGeneral.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get notifTypeGeneral;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات لعرضها'**
  String get noNotifications;

  /// No description provided for @endedConversation.
  ///
  /// In ar, this message translates to:
  /// **'محادثة منتهية'**
  String get endedConversation;

  /// No description provided for @readyToHelp.
  ///
  /// In ar, this message translates to:
  /// **'جاهز لمساعدتك'**
  String get readyToHelp;

  /// No description provided for @endConversation.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء المحادثة'**
  String get endConversation;

  /// No description provided for @chatLoadingMessages.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الرسائل...'**
  String get chatLoadingMessages;

  /// No description provided for @sendMessageFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال الرسالة.'**
  String get sendMessageFailed;

  /// No description provided for @referencesTitle.
  ///
  /// In ar, this message translates to:
  /// **'مراجع دوائية مرتبطة بالإجابة'**
  String get referencesTitle;

  /// No description provided for @referenceFallback.
  ///
  /// In ar, this message translates to:
  /// **'بيانات دوائية مرجعية'**
  String get referenceFallback;

  /// No description provided for @conversationNotice.
  ///
  /// In ar, this message translates to:
  /// **'اكتب سؤالك بوضوح لتحصل على نتيجة أدق، ولا تعتمد على المحادثة في الحالات الطارئة.'**
  String get conversationNotice;

  /// No description provided for @conversationEndedHint.
  ///
  /// In ar, this message translates to:
  /// **'تم إنهاء هذه المحادثة'**
  String get conversationEndedHint;

  /// No description provided for @typeYourMessage.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رسالتك...'**
  String get typeYourMessage;

  /// No description provided for @intelligenceTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الدوائية الذكية'**
  String get intelligenceTitle;

  /// No description provided for @searchAlternativesTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن بدائل'**
  String get searchAlternativesTitle;

  /// No description provided for @medicineAlternativesHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الدواء للبحث عن بدائل'**
  String get medicineAlternativesHint;

  /// No description provided for @showAlternatives.
  ///
  /// In ar, this message translates to:
  /// **'عرض البدائل'**
  String get showAlternatives;

  /// No description provided for @noAlternativesFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على بدائل مناسبة.'**
  String get noAlternativesFound;

  /// No description provided for @stockoutPredictionTitle.
  ///
  /// In ar, this message translates to:
  /// **'توقع نفاد المخزون'**
  String get stockoutPredictionTitle;

  /// No description provided for @stockLabel.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get stockLabel;

  /// No description provided for @soldLabel.
  ///
  /// In ar, this message translates to:
  /// **'المباع'**
  String get soldLabel;

  /// No description provided for @averageDailyLabel.
  ///
  /// In ar, this message translates to:
  /// **'المتوسط اليومي'**
  String get averageDailyLabel;

  /// No description provided for @sales7DaysLabel.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات 7 أيام'**
  String get sales7DaysLabel;

  /// No description provided for @sales30DaysLabel.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات 30 يومًا'**
  String get sales30DaysLabel;

  /// No description provided for @analyzing.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحليل...'**
  String get analyzing;

  /// No description provided for @analyzeStock.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المخزون'**
  String get analyzeStock;

  /// No description provided for @enterMedicineFirst.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الدواء أولًا.'**
  String get enterMedicineFirst;

  /// No description provided for @intelligenceUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة الذكية غير متاحة حاليًا. حاول لاحقًا.'**
  String get intelligenceUnavailable;

  /// No description provided for @intelligenceIntro.
  ///
  /// In ar, this message translates to:
  /// **'نتائج مساعدة لاتخاذ القرار، ويجب مراجعة المختص قبل استبدال أي دواء.'**
  String get intelligenceIntro;

  /// No description provided for @predictionResult.
  ///
  /// In ar, this message translates to:
  /// **'متوقع النفاد خلال {days} يوم\nالكمية المقترحة للطلب: {quantity}'**
  String predictionResult(String days, Object quantity);

  /// No description provided for @openNow.
  ///
  /// In ar, this message translates to:
  /// **'مفتوحة الآن'**
  String get openNow;

  /// No description provided for @closedNow.
  ///
  /// In ar, this message translates to:
  /// **'مغلقة الآن'**
  String get closedNow;

  /// No description provided for @ratingOf.
  ///
  /// In ar, this message translates to:
  /// **'{rating} من {count} تقييم'**
  String ratingOf(String rating, Object count);

  /// No description provided for @openDirections.
  ///
  /// In ar, this message translates to:
  /// **'فتح الاتجاهات'**
  String get openDirections;

  /// No description provided for @externalPharmacyNotice.
  ///
  /// In ar, this message translates to:
  /// **'هذه الصيدلية معروضة من خدمة الخرائط وقد لا تكون مسجلة داخل منصة دوائي.'**
  String get externalPharmacyNotice;

  /// No description provided for @distanceMetersFull.
  ///
  /// In ar, this message translates to:
  /// **'{value} متر'**
  String distanceMetersFull(String value);

  /// No description provided for @organizationsAndCampaignsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المنظمات والحملات'**
  String get organizationsAndCampaignsTitle;

  /// No description provided for @activeCampaignsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الحملات النشطة'**
  String get activeCampaignsTitle;

  /// No description provided for @activeCampaignsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مبادرات دوائية متاحة للمساهمة'**
  String get activeCampaignsSubtitle;

  /// No description provided for @campaignsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الحملات...'**
  String get campaignsLoading;

  /// No description provided for @noActiveCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حملات نشطة حاليًا.'**
  String get noActiveCampaigns;

  /// No description provided for @approvedOrganizationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المنظمات المعتمدة'**
  String get approvedOrganizationsTitle;

  /// No description provided for @approvedOrganizationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استعرض الجهات وحملاتها الحالية'**
  String get approvedOrganizationsSubtitle;

  /// No description provided for @organizationsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المنظمات...'**
  String get organizationsLoading;

  /// No description provided for @noApprovedOrganizations.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منظمات معتمدة حاليًا.'**
  String get noApprovedOrganizations;

  /// No description provided for @medicineReachesWhoNeedsIt.
  ///
  /// In ar, this message translates to:
  /// **'دواء يصل لمن يحتاجه'**
  String get medicineReachesWhoNeedsIt;

  /// No description provided for @orgCampaignSummary.
  ///
  /// In ar, this message translates to:
  /// **'{orgs} منظمة • {campaigns} حملة نشطة'**
  String orgCampaignSummary(String orgs, String campaigns);

  /// No description provided for @activeCampaignCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} حملة نشطة'**
  String activeCampaignCount(Object count);

  /// No description provided for @urgent.
  ///
  /// In ar, this message translates to:
  /// **'عاجلة'**
  String get urgent;

  /// No description provided for @needLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاحتياج: {summary}'**
  String needLabel(String summary);

  /// No description provided for @organizationDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المنظمة'**
  String get organizationDetailsTitle;

  /// No description provided for @organizationLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المنظمة...'**
  String get organizationLoading;

  /// No description provided for @approvedOrganizationLabel.
  ///
  /// In ar, this message translates to:
  /// **'منظمة معتمدة'**
  String get approvedOrganizationLabel;

  /// No description provided for @registrationNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم التسجيل: {number}'**
  String registrationNumber(Object number);

  /// No description provided for @requestedMedicinesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية المطلوبة: {summary}'**
  String requestedMedicinesLabel(String summary);

  /// No description provided for @donateOffer.
  ///
  /// In ar, this message translates to:
  /// **'تقديم عرض تبرع'**
  String get donateOffer;

  /// No description provided for @prescriptionStatusReserved.
  ///
  /// In ar, this message translates to:
  /// **'محجوزة'**
  String get prescriptionStatusReserved;

  /// No description provided for @prescriptionStatusReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة للاستلام'**
  String get prescriptionStatusReady;

  /// No description provided for @prescriptionStatusCollected.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get prescriptionStatusCollected;

  /// No description provided for @prescriptionStatusExpired.
  ///
  /// In ar, this message translates to:
  /// **'منتهية'**
  String get prescriptionStatusExpired;

  /// No description provided for @prescriptionStatusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get prescriptionStatusCancelled;

  /// No description provided for @prescriptionStatusAnalyzed.
  ///
  /// In ar, this message translates to:
  /// **'تم التحليل'**
  String get prescriptionStatusAnalyzed;

  /// No description provided for @myPrescriptionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'وصفاتي الطبية'**
  String get myPrescriptionsTitle;

  /// No description provided for @prescriptionsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الوصفات...'**
  String get prescriptionsLoading;

  /// No description provided for @previousPrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'الوصفات السابقة'**
  String get previousPrescriptions;

  /// No description provided for @prescriptionFileTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'يجب ألا يتجاوز حجم الوصفة 10 ميغابايت.'**
  String get prescriptionFileTooLarge;

  /// No description provided for @prescriptionAnalyzeFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحليل الوصفة حاليًا.'**
  String get prescriptionAnalyzeFailed;

  /// No description provided for @addNewPrescription.
  ///
  /// In ar, this message translates to:
  /// **'إضافة وصفة جديدة'**
  String get addNewPrescription;

  /// No description provided for @uploadPrescriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر صورة واضحة أو ملف PDF لوصفة مطبوعة، بحجم أقصى 10 ميغابايت.'**
  String get uploadPrescriptionHint;

  /// No description provided for @choosePrescription.
  ///
  /// In ar, this message translates to:
  /// **'اختيار الوصفة'**
  String get choosePrescription;

  /// No description provided for @prescriptionFallbackTitle.
  ///
  /// In ar, this message translates to:
  /// **'وصفة طبية'**
  String get prescriptionFallbackTitle;

  /// No description provided for @prescriptionItemsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} أدوية'**
  String prescriptionItemsCount(Object count);

  /// No description provided for @noPrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم إضافة أي وصفة بعد'**
  String get noPrescriptions;

  /// No description provided for @prescriptionOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الوصفات'**
  String get prescriptionOrdersTitle;

  /// No description provided for @refreshOrders.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الطلبات'**
  String get refreshOrders;

  /// No description provided for @ordersLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الطلبات...'**
  String get ordersLoading;

  /// No description provided for @matchPercentage.
  ///
  /// In ar, this message translates to:
  /// **'تطابق {percent}٪'**
  String matchPercentage(String percent);

  /// No description provided for @confirmDeliveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تسليم الوصفة'**
  String get confirmDeliveryTitle;

  /// No description provided for @pickupCodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاستلام'**
  String get pickupCodeLabel;

  /// No description provided for @pickupCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الاستلام المكون من 8 أرقام'**
  String get pickupCodeHint;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @invalidPickupCode.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الاستلام المكون من 8 أرقام.'**
  String get invalidPickupCode;

  /// No description provided for @prescriptionCollectedMsg.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد استلام الوصفة.'**
  String get prescriptionCollectedMsg;

  /// No description provided for @prescriptionReadyMsg.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الطلب إلى جاهز للاستلام.'**
  String get prescriptionReadyMsg;

  /// No description provided for @prescriptionStatusUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث حالة الوصفة.'**
  String get prescriptionStatusUpdateFailed;

  /// No description provided for @markReadyAction.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كجاهزة للاستلام'**
  String get markReadyAction;

  /// No description provided for @confirmDeliveryWithCode.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم بالرمز'**
  String get confirmDeliveryWithCode;

  /// No description provided for @pharmacyPrescriptionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'وصفات الصيدلية'**
  String get pharmacyPrescriptionsTitle;

  /// No description provided for @pharmacyPrescriptionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'جهّز الوصفة ثم أكّد تسليمها بالرمز'**
  String get pharmacyPrescriptionsSubtitle;

  /// No description provided for @orderFactActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get orderFactActive;

  /// No description provided for @orderFactReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة'**
  String get orderFactReady;

  /// No description provided for @noPharmacyOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات وصفات للصيدلية'**
  String get noPharmacyOrders;

  /// No description provided for @prescriptionDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوصفة'**
  String get prescriptionDetailsTitle;

  /// No description provided for @prescriptionDetailsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الوصفة...'**
  String get prescriptionDetailsLoading;

  /// No description provided for @medicinesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get medicinesTitle;

  /// No description provided for @itemsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عناصر'**
  String itemsCount(Object count);

  /// No description provided for @availablePharmaciesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات المتاحة'**
  String get availablePharmaciesTitle;

  /// No description provided for @availablePharmaciesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر صيدلية لحجز الأدوية المتوفرة'**
  String get availablePharmaciesSubtitle;

  /// No description provided for @noMatchingPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد صيدلية مطابقة حاليًا.'**
  String get noMatchingPharmacy;

  /// No description provided for @editReminders.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التذكيرات'**
  String get editReminders;

  /// No description provided for @activateMedicineReminders.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل تذكيرات الدواء'**
  String get activateMedicineReminders;

  /// No description provided for @cancelPrescription.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الوصفة'**
  String get cancelPrescription;

  /// No description provided for @reservedAt.
  ///
  /// In ar, this message translates to:
  /// **'تم حجز الوصفة لدى {name}.'**
  String reservedAt(String name);

  /// No description provided for @reserveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حجز الوصفة.'**
  String get reserveFailed;

  /// No description provided for @cancelPrescriptionTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الوصفة؟'**
  String get cancelPrescriptionTitle;

  /// No description provided for @cancelPrescriptionConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إلغاء الحجز وإعادة الكميات إلى مخزون الصيدلية.'**
  String get cancelPrescriptionConfirm;

  /// No description provided for @prescriptionCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الوصفة.'**
  String get prescriptionCancelled;

  /// No description provided for @cancelFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إلغاء الوصفة.'**
  String get cancelFailed;

  /// No description provided for @remindersSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ إعدادات التذكير.'**
  String get remindersSaved;

  /// No description provided for @remindersSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ التذكيرات.'**
  String get remindersSaveFailed;

  /// No description provided for @importantWarnings.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات مهمة'**
  String get importantWarnings;

  /// No description provided for @prescriptionMedicinesAvailable.
  ///
  /// In ar, this message translates to:
  /// **'{available}/{total} أدوية متوفرة'**
  String prescriptionMedicinesAvailable(Object available, Object total);

  /// No description provided for @reserveFullPrescription.
  ///
  /// In ar, this message translates to:
  /// **'حجز الوصفة كاملة'**
  String get reserveFullPrescription;

  /// No description provided for @reserveAvailableMedicines.
  ///
  /// In ar, this message translates to:
  /// **'حجز الأدوية المتوفرة'**
  String get reserveAvailableMedicines;

  /// No description provided for @pickupCodeTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز استلام الوصفة'**
  String get pickupCodeTitle;

  /// No description provided for @pickupCodeNote.
  ///
  /// In ar, this message translates to:
  /// **'قدّم هذا الرمز للصيدلية عند الاستلام.'**
  String get pickupCodeNote;

  /// No description provided for @reminderSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعداد التذكيرات'**
  String get reminderSettingsTitle;

  /// No description provided for @dailyDoseReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير الجرعات اليومية'**
  String get dailyDoseReminder;

  /// No description provided for @refillReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير إعادة التعبئة'**
  String get refillReminder;

  /// No description provided for @reminderTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت التذكير'**
  String get reminderTime;

  /// No description provided for @treatmentDurationLabel.
  ///
  /// In ar, this message translates to:
  /// **'مدة العلاج بالأيام'**
  String get treatmentDurationLabel;

  /// No description provided for @refillAfterLabel.
  ///
  /// In ar, this message translates to:
  /// **'التعبئة بعد أيام'**
  String get refillAfterLabel;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @medicinesCatalogTitle.
  ///
  /// In ar, this message translates to:
  /// **'دليل الأدوية'**
  String get medicinesCatalogTitle;

  /// No description provided for @addMedicine.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء'**
  String get addMedicine;

  /// No description provided for @catalogLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل دليل الأدوية...'**
  String get catalogLoading;

  /// No description provided for @catalogSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الأدوية واطلع على تفاصيلها'**
  String get catalogSubtitle;

  /// No description provided for @searchLabel.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get searchLabel;

  /// No description provided for @catalogSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم الدواء، الاسم العلمي أو الشركة'**
  String get catalogSearchHint;

  /// No description provided for @byPrescriptionTag.
  ///
  /// In ar, this message translates to:
  /// **'بوصفة طبية'**
  String get byPrescriptionTag;

  /// No description provided for @loadingMore.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المزيد...'**
  String get loadingMore;

  /// No description provided for @emptyCatalogTitle.
  ///
  /// In ar, this message translates to:
  /// **'دليل الأدوية فارغ'**
  String get emptyCatalogTitle;

  /// No description provided for @noSearchResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج مطابقة'**
  String get noSearchResultsTitle;

  /// No description provided for @emptyCatalogNoSearch.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر الأدوية المسجلة هنا.'**
  String get emptyCatalogNoSearch;

  /// No description provided for @noSearchResultsHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب اسمًا آخر أو جزءًا من الاسم العلمي.'**
  String get noSearchResultsHint;

  /// No description provided for @medicineDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدواء'**
  String get medicineDetailsTitle;

  /// No description provided for @medicineDetailsLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل بيانات الدواء...'**
  String get medicineDetailsLoading;

  /// No description provided for @withoutPrescription.
  ///
  /// In ar, this message translates to:
  /// **'بدون وصفة'**
  String get withoutPrescription;

  /// No description provided for @pharmaInfoTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الدوائية'**
  String get pharmaInfoTitle;

  /// No description provided for @arabicScientificNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العلمي بالعربية'**
  String get arabicScientificNameLabel;

  /// No description provided for @englishScientificNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العلمي بالإنكليزية'**
  String get englishScientificNameLabel;

  /// No description provided for @englishNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الإنكليزي'**
  String get englishNameLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الباركود'**
  String get barcodeLabel;

  /// No description provided for @compositionLabel.
  ///
  /// In ar, this message translates to:
  /// **'التركيب'**
  String get compositionLabel;

  /// No description provided for @dosageFormLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشكل الدوائي'**
  String get dosageFormLabel;

  /// No description provided for @capacityLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعة أو التركيز'**
  String get capacityLabel;

  /// No description provided for @packageSizeLabel.
  ///
  /// In ar, this message translates to:
  /// **'حجم العبوة'**
  String get packageSizeLabel;

  /// No description provided for @manufacturingTitle.
  ///
  /// In ar, this message translates to:
  /// **'التصنيع والتوفر'**
  String get manufacturingTitle;

  /// No description provided for @manufacturerLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشركة المصنعة'**
  String get manufacturerLabel;

  /// No description provided for @referenceQuantityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المرجعية'**
  String get referenceQuantityLabel;

  /// No description provided for @sellingPriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'سعر البيع'**
  String get sellingPriceLabel;

  /// No description provided for @purchasePriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'سعر الشراء'**
  String get purchasePriceLabel;

  /// No description provided for @editArabicNames.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الاسم العربي وأسماء البحث'**
  String get editArabicNames;

  /// No description provided for @medicineArabicDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات العربية للدواء'**
  String get medicineArabicDataTitle;

  /// No description provided for @arabicNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العربي'**
  String get arabicNameLabel;

  /// No description provided for @otherSearchNamesLabel.
  ///
  /// In ar, this message translates to:
  /// **'أسماء أخرى للبحث'**
  String get otherSearchNamesLabel;

  /// No description provided for @aliasesSeparatorHint.
  ///
  /// In ar, this message translates to:
  /// **'افصل بين الأسماء بفاصلة'**
  String get aliasesSeparatorHint;

  /// No description provided for @arabicDataUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث البيانات العربية للدواء.'**
  String get arabicDataUpdated;

  /// No description provided for @dataSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ البيانات.'**
  String get dataSaveFailed;

  /// No description provided for @quickFormLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشكل'**
  String get quickFormLabel;

  /// No description provided for @descriptionTitle.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get descriptionTitle;

  /// No description provided for @disclaimerText.
  ///
  /// In ar, this message translates to:
  /// **'هذه البيانات تعريفية. التزم بتوجيهات الطبيب أو الصيدلي ولا تغيّر علاجك دون استشارة مختص.'**
  String get disclaimerText;

  /// No description provided for @createMedicineIntro.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات الدواء بدقة. سيصبح الدواء متاحًا للصيدليات لإضافته إلى مخزونها بعد الحفظ.'**
  String get createMedicineIntro;

  /// No description provided for @basicDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الأساسية'**
  String get basicDataTitle;

  /// No description provided for @englishTradeNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم التجاري بالإنكليزية'**
  String get englishTradeNameLabel;

  /// No description provided for @englishTradeNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: Paracetamol 500'**
  String get englishTradeNameHint;

  /// No description provided for @medicineNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء مطلوب.'**
  String get medicineNameRequired;

  /// No description provided for @arabicTradeNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم التجاري بالعربية'**
  String get arabicTradeNameLabel;

  /// No description provided for @arabicTradeNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: باراسيتامول 500'**
  String get arabicTradeNameHint;

  /// No description provided for @barcodeHint.
  ///
  /// In ar, this message translates to:
  /// **'أرقام أو أحرف أو شرطة'**
  String get barcodeHint;

  /// No description provided for @optionalHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optionalHint;

  /// No description provided for @categoryManufacturingTitle.
  ///
  /// In ar, this message translates to:
  /// **'التصنيف والتصنيع'**
  String get categoryManufacturingTitle;

  /// No description provided for @capacityFieldLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعة'**
  String get capacityFieldLabel;

  /// No description provided for @capacityHint.
  ///
  /// In ar, this message translates to:
  /// **'500 mg'**
  String get capacityHint;

  /// No description provided for @packageSizeHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 20 قرصًا'**
  String get packageSizeHint;

  /// No description provided for @detailedInfoTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات التفصيلية'**
  String get detailedInfoTitle;

  /// No description provided for @compositionHint.
  ///
  /// In ar, this message translates to:
  /// **'المواد الفعالة والتركيب'**
  String get compositionHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'وصف مختصر ودقيق للدواء'**
  String get descriptionHint;

  /// No description provided for @saveMedicine.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الدواء'**
  String get saveMedicine;

  /// No description provided for @medicineAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الدواء بنجاح.'**
  String get medicineAdded;

  /// No description provided for @medicineAddFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إضافة الدواء حاليًا.'**
  String get medicineAddFailed;

  /// No description provided for @requiresPrescriptionSwitchTitle.
  ///
  /// In ar, this message translates to:
  /// **'يتطلب وصفة طبية'**
  String get requiresPrescriptionSwitchTitle;

  /// No description provided for @requiresPrescriptionSwitchSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'فعّل الخيار إذا كان صرف الدواء يحتاج وصفة'**
  String get requiresPrescriptionSwitchSubtitle;

  /// No description provided for @maxLengthMessage.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى {max} حرفًا.'**
  String maxLengthMessage(Object max);

  /// No description provided for @maxLength64.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى 64 محرفًا.'**
  String get maxLength64;

  /// No description provided for @barcodeInvalidChars.
  ///
  /// In ar, this message translates to:
  /// **'استخدم الأرقام أو الأحرف الإنكليزية أو الشرطة فقط.'**
  String get barcodeInvalidChars;

  /// No description provided for @enterValidNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقمًا صحيحًا.'**
  String get enterValidNumber;

  /// No description provided for @valueNotNegative.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن أن تكون القيمة سالبة.'**
  String get valueNotNegative;

  /// No description provided for @enterValidInteger.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عددًا صحيحًا.'**
  String get enterValidInteger;

  /// No description provided for @donationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التبرعات والمساعدة'**
  String get donationsTitle;

  /// No description provided for @donationOfferAction.
  ///
  /// In ar, this message translates to:
  /// **'عرض تبرع'**
  String get donationOfferAction;

  /// No description provided for @assistanceRequestAction.
  ///
  /// In ar, this message translates to:
  /// **'طلب مساعدة'**
  String get assistanceRequestAction;

  /// No description provided for @givingStartsWithStep.
  ///
  /// In ar, this message translates to:
  /// **'العطاء يبدأ بخطوة'**
  String get givingStartsWithStep;

  /// No description provided for @donationHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قدّم دواءً صالحًا أو اطلب المساعدة عبر الجهات المشاركة.'**
  String get donationHeroSubtitle;

  /// No description provided for @donationOffersTab.
  ///
  /// In ar, this message translates to:
  /// **'عروض التبرع'**
  String get donationOffersTab;

  /// No description provided for @assistanceRequestsTab.
  ///
  /// In ar, this message translates to:
  /// **'طلبات المساعدة'**
  String get assistanceRequestsTab;

  /// No description provided for @offersLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل عروضك...'**
  String get offersLoading;

  /// No description provided for @noDonationOffers.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عروض تبرع موجهة للمنظمة.'**
  String get noDonationOffers;

  /// No description provided for @noAssistanceRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات مساعدة حاليًا.'**
  String get noAssistanceRequests;

  /// No description provided for @donationStatusApproved.
  ///
  /// In ar, this message translates to:
  /// **'مقبول'**
  String get donationStatusApproved;

  /// No description provided for @donationStatusReceived.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get donationStatusReceived;

  /// No description provided for @donationStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get donationStatusRejected;

  /// No description provided for @donationStatusFulfilled.
  ///
  /// In ar, this message translates to:
  /// **'تمت المساعدة'**
  String get donationStatusFulfilled;

  /// No description provided for @donationStatusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get donationStatusCancelled;

  /// No description provided for @donationStatusUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get donationStatusUnderReview;

  /// No description provided for @donationStatusOpen.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get donationStatusOpen;

  /// No description provided for @statusOpen.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get statusOpen;

  /// No description provided for @packagesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عبوات'**
  String packagesCount(Object count);

  /// No description provided for @targetOrganization.
  ///
  /// In ar, this message translates to:
  /// **'منظمة'**
  String get targetOrganization;

  /// No description provided for @campaignLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحملة: {title}'**
  String campaignLabel(String title);

  /// No description provided for @organizationNoteLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة المنظمة: {note}'**
  String organizationNoteLabel(String note);

  /// No description provided for @neededBeforeLabel.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب قبل {date}'**
  String neededBeforeLabel(String date);

  /// No description provided for @organizationResponseLabel.
  ///
  /// In ar, this message translates to:
  /// **'رد المنظمة: {note}'**
  String organizationResponseLabel(String note);

  /// No description provided for @verifyDonationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من التبرعات'**
  String get verifyDonationsTitle;

  /// No description provided for @verifyDonationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سلامة الدواء قبل وصوله للمستفيد'**
  String get verifyDonationsSubtitle;

  /// No description provided for @donationOffersLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل عروض التبرع...'**
  String get donationOffersLoading;

  /// No description provided for @noDonationsToVerify.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تبرعات بانتظار التحقق.'**
  String get noDonationsToVerify;

  /// No description provided for @reviewNoteLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة الفحص (اختياري)'**
  String get reviewNoteLabel;

  /// No description provided for @reviewNoteHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف ملاحظات حول فحص التبرع'**
  String get reviewNoteHint;

  /// No description provided for @donationStatusUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث حالة التبرع بنجاح.'**
  String get donationStatusUpdated;

  /// No description provided for @donationUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث التبرع.'**
  String get donationUpdateFailed;

  /// No description provided for @pharmacyReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة دقيقة وآمنة'**
  String get pharmacyReviewTitle;

  /// No description provided for @pharmacyReviewSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'افحص العبوات ثم حدّث حالتها حسب نتيجة التحقق.'**
  String get pharmacyReviewSubtitle;

  /// No description provided for @donorLabel.
  ///
  /// In ar, this message translates to:
  /// **'المتبرع: {name}'**
  String donorLabel(String name);

  /// No description provided for @beneficiaryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجهة المستفيدة: {name}'**
  String beneficiaryLabel(String name);

  /// No description provided for @expiryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الانتهاء: {date}'**
  String expiryLabel(String date);

  /// No description provided for @acceptAfterInspection.
  ///
  /// In ar, this message translates to:
  /// **'قبول بعد الفحص'**
  String get acceptAfterInspection;

  /// No description provided for @reject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get reject;

  /// No description provided for @confirmReceivePackages.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد استلام العبوات'**
  String get confirmReceivePackages;

  /// No description provided for @statusPendingInspection.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الفحص'**
  String get statusPendingInspection;

  /// No description provided for @actionApproveDonation.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد التبرع'**
  String get actionApproveDonation;

  /// No description provided for @actionRejectDonation.
  ///
  /// In ar, this message translates to:
  /// **'رفض التبرع'**
  String get actionRejectDonation;

  /// No description provided for @actionConfirmReceipt.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الاستلام'**
  String get actionConfirmReceipt;

  /// No description provided for @actionUpdateDonation.
  ///
  /// In ar, this message translates to:
  /// **'تحديث التبرع'**
  String get actionUpdateDonation;

  /// No description provided for @offerDonationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقديم عرض تبرع'**
  String get offerDonationTitle;

  /// No description provided for @assistanceRequestPageTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب مساعدة دوائية'**
  String get assistanceRequestPageTitle;

  /// No description provided for @chooseMedicineSection.
  ///
  /// In ar, this message translates to:
  /// **'اختيار الدواء'**
  String get chooseMedicineSection;

  /// No description provided for @chooseMedicineSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في دليل الأدوية وحدد الصنف المطلوب'**
  String get chooseMedicineSectionSubtitle;

  /// No description provided for @medicineSearchLabel.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن دواء'**
  String get medicineSearchLabel;

  /// No description provided for @medicineSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم الدواء ثم اختر من النتائج'**
  String get medicineSearchHint;

  /// No description provided for @catalogLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل دليل الأدوية.'**
  String get catalogLoadFailed;

  /// No description provided for @medicineDropdownLabel.
  ///
  /// In ar, this message translates to:
  /// **'الدواء'**
  String get medicineDropdownLabel;

  /// No description provided for @medicineDropdownHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر الدواء من الدليل'**
  String get medicineDropdownHint;

  /// No description provided for @chooseMedicineFromCatalog.
  ///
  /// In ar, this message translates to:
  /// **'اختر الدواء من الدليل.'**
  String get chooseMedicineFromCatalog;

  /// No description provided for @verificationPharmacySection.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية التحقق والاستلام'**
  String get verificationPharmacySection;

  /// No description provided for @verificationPharmacySectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستتأكد الصيدلية من سلامة العبوات قبل تسليمها'**
  String get verificationPharmacySectionSubtitle;

  /// No description provided for @verificationPharmaciesLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل صيدليات التحقق المعتمدة.'**
  String get verificationPharmaciesLoadFailed;

  /// No description provided for @verificationPharmacyLabel.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية التحقق'**
  String get verificationPharmacyLabel;

  /// No description provided for @verificationPharmacyHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصيدلية المعتمدة'**
  String get verificationPharmacyHint;

  /// No description provided for @chooseVerificationPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصيدلية التي ستتحقق من التبرع.'**
  String get chooseVerificationPharmacy;

  /// No description provided for @organizationSection.
  ///
  /// In ar, this message translates to:
  /// **'الجهة والتفاصيل'**
  String get organizationSection;

  /// No description provided for @organizationSectionOfferSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدد الجهة المستفيدة وبيانات العبوات'**
  String get organizationSectionOfferSubtitle;

  /// No description provided for @organizationSectionRequestSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدد الجهة المستهدفة واحتياجك الدوائي'**
  String get organizationSectionRequestSubtitle;

  /// No description provided for @organizationsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل المنظمات.'**
  String get organizationsLoadFailed;

  /// No description provided for @organizationDropdownLabel.
  ///
  /// In ar, this message translates to:
  /// **'المنظمة'**
  String get organizationDropdownLabel;

  /// No description provided for @organizationDropdownOfferHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر الجهة المستفيدة'**
  String get organizationDropdownOfferHint;

  /// No description provided for @organizationDropdownRequestHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر المنظمة المستهدفة'**
  String get organizationDropdownRequestHint;

  /// No description provided for @noSpecificOrganization.
  ///
  /// In ar, this message translates to:
  /// **'بدون منظمة محددة'**
  String get noSpecificOrganization;

  /// No description provided for @chooseTargetOrganization.
  ///
  /// In ar, this message translates to:
  /// **'اختر المنظمة المستهدفة.'**
  String get chooseTargetOrganization;

  /// No description provided for @campaignOptionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحملة (اختياري)'**
  String get campaignOptionalLabel;

  /// No description provided for @noSpecificCampaign.
  ///
  /// In ar, this message translates to:
  /// **'بدون حملة محددة'**
  String get noSpecificCampaign;

  /// No description provided for @donatedPackagesLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد العبوات المتبرع بها'**
  String get donatedPackagesLabel;

  /// No description provided for @requestedPackagesLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد العبوات المطلوبة'**
  String get requestedPackagesLabel;

  /// No description provided for @packageCountHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كمية بين 1 و1000'**
  String get packageCountHint;

  /// No description provided for @packageCountInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عددًا بين 1 و1000.'**
  String get packageCountInvalid;

  /// No description provided for @medicineExpiryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ انتهاء الدواء'**
  String get medicineExpiryDate;

  /// No description provided for @neededBeforeDate.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب قبل تاريخ'**
  String get neededBeforeDate;

  /// No description provided for @sealedPackagesTitle.
  ///
  /// In ar, this message translates to:
  /// **'العبوات مغلقة ولم تُفتح'**
  String get sealedPackagesTitle;

  /// No description provided for @sealedPackagesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من سلامة العبوة قبل تقديم العرض.'**
  String get sealedPackagesSubtitle;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get notesOptionalLabel;

  /// No description provided for @notesHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف أي تفاصيل إضافية'**
  String get notesHint;

  /// No description provided for @offerSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال العرض إلى صيدلية التحقق بنجاح.'**
  String get offerSubmitted;

  /// No description provided for @assistanceSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب المساعدة إلى المنظمة.'**
  String get assistanceSubmitted;

  /// No description provided for @submitFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال البيانات حاليًا.'**
  String get submitFailed;

  /// No description provided for @donationOfferHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض تبرع دوائي'**
  String get donationOfferHeroTitle;

  /// No description provided for @donationOfferHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات دقيقة لتسهيل التحقق والاستلام.'**
  String get donationOfferHeroSubtitle;

  /// No description provided for @assistanceHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب مساعدة دوائية'**
  String get assistanceHeroTitle;

  /// No description provided for @assistanceHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل احتياجك واختر المنظمة المناسبة للطلب.'**
  String get assistanceHeroSubtitle;

  /// No description provided for @scanMedicineBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح باركود الدواء'**
  String get scanMedicineBarcode;

  /// No description provided for @toggleFlash.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الإضاءة'**
  String get toggleFlash;

  /// No description provided for @cameraError.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تشغيل الكاميرا. اسمح للتطبيق باستخدامها أو أدخل الباركود يدوياً.'**
  String get cameraError;

  /// No description provided for @placeBarcodeInFrame.
  ///
  /// In ar, this message translates to:
  /// **'ضع الرمز داخل الإطار وثبّت الهاتف للحظة'**
  String get placeBarcodeInFrame;

  /// No description provided for @enterBarcodeManually.
  ///
  /// In ar, this message translates to:
  /// **'إدخال الباركود يدوياً'**
  String get enterBarcodeManually;

  /// No description provided for @enterBarcodeTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدخال الباركود'**
  String get enterBarcodeTitle;

  /// No description provided for @barcodeNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الباركود'**
  String get barcodeNumberLabel;

  /// No description provided for @use.
  ///
  /// In ar, this message translates to:
  /// **'استخدام'**
  String get use;

  /// No description provided for @medicineRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الأدوية'**
  String get medicineRequestsTitle;

  /// No description provided for @searchRequestField.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بالدواء أو اسم المستخدم أو الهاتف'**
  String get searchRequestField;

  /// No description provided for @requestsOverviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الطلبات'**
  String get requestsOverviewTitle;

  /// No description provided for @pendingNeedReply.
  ///
  /// In ar, this message translates to:
  /// **'{count} طلب يحتاج إلى ردك الآن'**
  String pendingNeedReply(Object count);

  /// No description provided for @noPendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات معلّقة ضمن هذه القائمة'**
  String get noPendingRequests;

  /// No description provided for @overviewAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get overviewAvailable;

  /// No description provided for @overviewOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get overviewOrders;

  /// No description provided for @quantityRequestedValue.
  ///
  /// In ar, this message translates to:
  /// **'الكمية {count}'**
  String quantityRequestedValue(Object count);

  /// No description provided for @replyNow.
  ///
  /// In ar, this message translates to:
  /// **'الرد الآن'**
  String get replyNow;

  /// No description provided for @requestStatusWaitingReply.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الرد'**
  String get requestStatusWaitingReply;

  /// No description provided for @noMatchingRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات مطابقة'**
  String get noMatchingRequests;

  /// No description provided for @noMatchingRequestsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا طلبات الأدوية الجديدة الواردة من المستخدمين.'**
  String get noMatchingRequestsSubtitle;

  /// No description provided for @statusWaitingYou.
  ///
  /// In ar, this message translates to:
  /// **'بانتظارك'**
  String get statusWaitingYou;

  /// No description provided for @workingHoursTitle.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get workingHoursTitle;

  /// No description provided for @saveTooltip.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get saveTooltip;

  /// No description provided for @restoreSavedHours.
  ///
  /// In ar, this message translates to:
  /// **'استعادة الساعات المحفوظة'**
  String get restoreSavedHours;

  /// No description provided for @workingHoursLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل ساعات العمل...'**
  String get workingHoursLoading;

  /// No description provided for @overnightHint.
  ///
  /// In ar, this message translates to:
  /// **'للدوام بعد منتصف الليل اختر وقت إغلاق أسبق من وقت الفتح، وسيُحفظ لليوم التالي تلقائيًا.'**
  String get overnightHint;

  /// No description provided for @pharmacyClosed.
  ///
  /// In ar, this message translates to:
  /// **'الصيدلية مغلقة'**
  String get pharmacyClosed;

  /// No description provided for @overnightShift.
  ///
  /// In ar, this message translates to:
  /// **'دوام ممتد لليوم التالي'**
  String get overnightShift;

  /// No description provided for @timeFrom.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get timeFrom;

  /// No description provided for @timeTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get timeTo;

  /// No description provided for @endsNextDay.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي الدوام في اليوم التالي'**
  String get endsNextDay;

  /// No description provided for @openingTimeHelp.
  ///
  /// In ar, this message translates to:
  /// **'وقت بدء الدوام'**
  String get openingTimeHelp;

  /// No description provided for @closingTimeHelp.
  ///
  /// In ar, this message translates to:
  /// **'وقت انتهاء الدوام'**
  String get closingTimeHelp;

  /// No description provided for @timesMustDiffer.
  ///
  /// In ar, this message translates to:
  /// **'وقت الفتح والإغلاق يجب أن يكونا مختلفين.'**
  String get timesMustDiffer;

  /// No description provided for @workingHoursSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ ساعات العمل.'**
  String get workingHoursSaved;

  /// No description provided for @workingHoursSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ ساعات العمل.'**
  String get workingHoursSaveFailed;

  /// No description provided for @scheduleTitle.
  ///
  /// In ar, this message translates to:
  /// **'جدول الصيدلية'**
  String get scheduleTitle;

  /// No description provided for @scheduleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد أوقات استقبال طلبات المستخدمين'**
  String get scheduleSubtitle;

  /// No description provided for @workDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام عمل'**
  String get workDays;

  /// No description provided for @overnightLabel.
  ///
  /// In ar, this message translates to:
  /// **'ليلي'**
  String get overnightLabel;

  /// No description provided for @refreshRequest.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الطلب'**
  String get refreshRequest;

  /// No description provided for @openingRequest.
  ///
  /// In ar, this message translates to:
  /// **'جاري فتح الطلب...'**
  String get openingRequest;

  /// No description provided for @confirmingProgress.
  ///
  /// In ar, this message translates to:
  /// **'جاري التأكيد...'**
  String get confirmingProgress;

  /// No description provided for @confirmUserPickup.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد استلام المستخدم للدواء'**
  String get confirmUserPickup;

  /// No description provided for @respondToRequest.
  ///
  /// In ar, this message translates to:
  /// **'الرد على الطلب'**
  String get respondToRequest;

  /// No description provided for @replyWillReachUser.
  ///
  /// In ar, this message translates to:
  /// **'سيصل اختيارك وملاحظتك إلى المستخدم'**
  String get replyWillReachUser;

  /// No description provided for @suggestAlternativeHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك اقتراح بديل متوفر بدلًا منه'**
  String get suggestAlternativeHint;

  /// No description provided for @availableAlternativeLabel.
  ///
  /// In ar, this message translates to:
  /// **'بديل متاح (اختياري)'**
  String get availableAlternativeLabel;

  /// No description provided for @noteToUserOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة للمستخدم (اختياري)'**
  String get noteToUserOptional;

  /// No description provided for @sendReply.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرد'**
  String get sendReply;

  /// No description provided for @replySent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الرد إلى المستخدم.'**
  String get replySent;

  /// No description provided for @sendReplyFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال الرد.'**
  String get sendReplyFailed;

  /// No description provided for @pickupConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد استلام المستخدم للدواء.'**
  String get pickupConfirmed;

  /// No description provided for @confirmPickupFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تأكيد استلام الدواء.'**
  String get confirmPickupFailed;

  /// No description provided for @medicineDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الدواء'**
  String get medicineDataTitle;

  /// No description provided for @scientificNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العلمي'**
  String get scientificNameLabel;

  /// No description provided for @notRegistered.
  ///
  /// In ar, this message translates to:
  /// **'غير مسجل'**
  String get notRegistered;

  /// No description provided for @formConcentrationLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشكل والتركيز'**
  String get formConcentrationLabel;

  /// No description provided for @userNoteLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة المستخدم: {note}'**
  String userNoteLabel(String note);

  /// No description provided for @userDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المستخدم'**
  String get userDataTitle;

  /// No description provided for @nameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد'**
  String get emailLabel;

  /// No description provided for @requestProcessed.
  ///
  /// In ar, this message translates to:
  /// **'تمت معالجة هذا الطلب'**
  String get requestProcessed;

  /// No description provided for @licenseVerificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من ترخيص الصيدلية'**
  String get licenseVerificationTitle;

  /// No description provided for @refreshStatus.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الحالة'**
  String get refreshStatus;

  /// No description provided for @reviewingStatus.
  ///
  /// In ar, this message translates to:
  /// **'جاري مراجعة الحالة...'**
  String get reviewingStatus;

  /// No description provided for @selectLicenseImage.
  ///
  /// In ar, this message translates to:
  /// **'اختيار صورة الترخيص وإرسالها'**
  String get selectLicenseImage;

  /// No description provided for @sendNewLicenseImage.
  ///
  /// In ar, this message translates to:
  /// **'إرسال صورة أحدث للترخيص'**
  String get sendNewLicenseImage;

  /// No description provided for @imageTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'حجم الصورة يجب ألا يتجاوز 8 ميغابايت.'**
  String get imageTooLarge;

  /// No description provided for @licenseSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الترخيص، ويمكنك متابعة نتيجة المراجعة من هنا.'**
  String get licenseSubmitted;

  /// No description provided for @licenseSubmitFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال صورة الترخيص.'**
  String get licenseSubmitFailed;

  /// No description provided for @sendLicenseIntro.
  ///
  /// In ar, this message translates to:
  /// **'أرسل صورة واضحة من الترخيص لبدء المراجعة.'**
  String get sendLicenseIntro;

  /// No description provided for @lastFileLabel.
  ///
  /// In ar, this message translates to:
  /// **'آخر ملف: {name}'**
  String lastFileLabel(String name);

  /// No description provided for @beforeSendingTitle.
  ///
  /// In ar, this message translates to:
  /// **'قبل الإرسال'**
  String get beforeSendingTitle;

  /// No description provided for @tipFullLicense.
  ///
  /// In ar, this message translates to:
  /// **'التقط الترخيص كاملاً دون قص الحواف.'**
  String get tipFullLicense;

  /// No description provided for @tipClearDetails.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من وضوح الاسم والرقم والأختام.'**
  String get tipClearDetails;

  /// No description provided for @tipAcceptedFormats.
  ///
  /// In ar, this message translates to:
  /// **'الصيغ المقبولة: JPG أو PNG أو WEBP.'**
  String get tipAcceptedFormats;

  /// No description provided for @reviewDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المراجعة'**
  String get reviewDetailsTitle;

  /// No description provided for @registeredNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم المسجل'**
  String get registeredNameLabel;

  /// No description provided for @licenseNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم في الترخيص'**
  String get licenseNameLabel;

  /// No description provided for @registryNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم السجل'**
  String get registryNumberLabel;

  /// No description provided for @documentNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الوثيقة'**
  String get documentNumberLabel;

  /// No description provided for @attemptCountLabel.
  ///
  /// In ar, this message translates to:
  /// **'عدد مرات الإرسال'**
  String get attemptCountLabel;

  /// No description provided for @manualReviewNoteLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة المراجعة'**
  String get manualReviewNoteLabel;

  /// No description provided for @licenseStatusVerified.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من الترخيص'**
  String get licenseStatusVerified;

  /// No description provided for @licenseStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج الترخيص إلى إعادة إرسال'**
  String get licenseStatusRejected;

  /// No description provided for @licenseStatusFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذرت قراءة الترخيص'**
  String get licenseStatusFailed;

  /// No description provided for @licenseStatusManualReview.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get licenseStatusManualReview;

  /// No description provided for @licenseStatusProcessing.
  ///
  /// In ar, this message translates to:
  /// **'جاري مراجعة الترخيص'**
  String get licenseStatusProcessing;

  /// No description provided for @licenseStatusDefault.
  ///
  /// In ar, this message translates to:
  /// **'توثيق ترخيص الصيدلية'**
  String get licenseStatusDefault;

  /// No description provided for @prepareMedicinesTitle.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز الأدوية المختارة'**
  String get prepareMedicinesTitle;

  /// No description provided for @prepareMedicinesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل سعر كل دواء، ثم راجع باقي بيانات المخزون.'**
  String get prepareMedicinesSubtitle;

  /// No description provided for @applyCommonSettings.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق إعدادات مشتركة على الجميع'**
  String get applyCommonSettings;

  /// No description provided for @pricesProgress.
  ///
  /// In ar, this message translates to:
  /// **'{completed}/{total} أسعار'**
  String pricesProgress(Object completed, Object total);

  /// No description provided for @addMedicinesToStock.
  ///
  /// In ar, this message translates to:
  /// **'إضافة {count} أدوية إلى المخزون'**
  String addMedicinesToStock(Object count);

  /// No description provided for @removeFromList.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من القائمة'**
  String get removeFromList;

  /// No description provided for @concentrationLabel.
  ///
  /// In ar, this message translates to:
  /// **'التركيز'**
  String get concentrationLabel;

  /// No description provided for @formLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشكل'**
  String get formLabel;

  /// No description provided for @packageLabel.
  ///
  /// In ar, this message translates to:
  /// **'العبوة'**
  String get packageLabel;

  /// No description provided for @sellingPriceFieldLabel.
  ///
  /// In ar, this message translates to:
  /// **'سعر البيع لهذا الدواء *'**
  String get sellingPriceFieldLabel;

  /// No description provided for @priceHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 8500'**
  String get priceHint;

  /// No description provided for @currencySuffix.
  ///
  /// In ar, this message translates to:
  /// **'ل.س'**
  String get currencySuffix;

  /// No description provided for @enterPositivePrice.
  ///
  /// In ar, this message translates to:
  /// **'أدخل سعرًا أكبر من صفر.'**
  String get enterPositivePrice;

  /// No description provided for @invalidValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة غير صحيحة'**
  String get invalidValue;

  /// No description provided for @enterQuantity.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كمية'**
  String get enterQuantity;

  /// No description provided for @thresholdLabel.
  ///
  /// In ar, this message translates to:
  /// **'حد التنبيه'**
  String get thresholdLabel;

  /// No description provided for @expiryDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الصلاحية'**
  String get expiryDateLabel;

  /// No description provided for @removeDate.
  ///
  /// In ar, this message translates to:
  /// **'إزالة التاريخ'**
  String get removeDate;

  /// No description provided for @availableForOrder.
  ///
  /// In ar, this message translates to:
  /// **'متاح للطلب'**
  String get availableForOrder;

  /// No description provided for @showPriceToUser.
  ///
  /// In ar, this message translates to:
  /// **'إظهار السعر للمستخدم'**
  String get showPriceToUser;

  /// No description provided for @priceHiddenHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكن الاحتفاظ بالسعر داخليًا وإخفاؤه عند الحاجة'**
  String get priceHiddenHint;

  /// No description provided for @commonSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات مشتركة'**
  String get commonSettingsTitle;

  /// No description provided for @commonSettingsDesc.
  ///
  /// In ar, this message translates to:
  /// **'ستُطبق هذه القيم على جميع الأدوية، بينما يبقى السعر مستقلًا لكل دواء.'**
  String get commonSettingsDesc;

  /// No description provided for @lowStockThresholdLabel.
  ///
  /// In ar, this message translates to:
  /// **'حد المخزون المنخفض'**
  String get lowStockThresholdLabel;

  /// No description provided for @applyToAll.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق على الجميع'**
  String get applyToAll;

  /// No description provided for @pharmacyDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الصيدلية'**
  String get pharmacyDataTitle;

  /// No description provided for @refreshData.
  ///
  /// In ar, this message translates to:
  /// **'تحديث البيانات'**
  String get refreshData;

  /// No description provided for @pharmacyProfileLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل ملف الصيدلية...'**
  String get pharmacyProfileLoading;

  /// No description provided for @generalDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيانات العامة'**
  String get generalDataTitle;

  /// No description provided for @generalDataSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات التي تظهر للمستخدم عند فتح الصيدلية'**
  String get generalDataSubtitle;

  /// No description provided for @pharmacyNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصيدلية'**
  String get pharmacyNameLabel;

  /// No description provided for @cityLabel.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get cityLabel;

  /// No description provided for @areaLabel.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة'**
  String get areaLabel;

  /// No description provided for @detailedAddressLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنوان التفصيلي'**
  String get detailedAddressLabel;

  /// No description provided for @pharmacyDescriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'وصف الصيدلية'**
  String get pharmacyDescriptionLabel;

  /// No description provided for @deliveryServiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'خدمة توصيل الأدوية'**
  String get deliveryServiceTitle;

  /// No description provided for @deliveryServiceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أخبر المستخدمين بتوفر التوصيل'**
  String get deliveryServiceSubtitle;

  /// No description provided for @saveProfile.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الملف'**
  String get saveProfile;

  /// No description provided for @pharmacyLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'موقع الصيدلية'**
  String get pharmacyLocationTitle;

  /// No description provided for @pharmacyLocationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'موقع دقيق يساعد المستخدم في العثور عليك بسهولة'**
  String get pharmacyLocationSubtitle;

  /// No description provided for @automaticLocation.
  ///
  /// In ar, this message translates to:
  /// **'تحديد تلقائي'**
  String get automaticLocation;

  /// No description provided for @useDeviceLocation.
  ///
  /// In ar, this message translates to:
  /// **'استخدم موقع هذا الجهاز'**
  String get useDeviceLocation;

  /// No description provided for @orEnterCoordinates.
  ///
  /// In ar, this message translates to:
  /// **'أو أدخل الإحداثيات يدويًا'**
  String get orEnterCoordinates;

  /// No description provided for @saveCoordinates.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإحداثيات'**
  String get saveCoordinates;

  /// No description provided for @matchRegisteredPlace.
  ///
  /// In ar, this message translates to:
  /// **'مطابقة الموقع مع المكان المسجل'**
  String get matchRegisteredPlace;

  /// No description provided for @completeProfileFields.
  ///
  /// In ar, this message translates to:
  /// **'أكمل اسم الصيدلية والمدينة والمنطقة والعنوان.'**
  String get completeProfileFields;

  /// No description provided for @pharmacyProfileSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ بيانات الصيدلية.'**
  String get pharmacyProfileSaved;

  /// No description provided for @invalidLatitude.
  ///
  /// In ar, this message translates to:
  /// **'أدخل خط عرض صحيحًا بين -90 و90.'**
  String get invalidLatitude;

  /// No description provided for @invalidLongitude.
  ///
  /// In ar, this message translates to:
  /// **'أدخل خط طول صحيحًا بين -180 و180.'**
  String get invalidLongitude;

  /// No description provided for @locationSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الموقع.'**
  String get locationSaved;

  /// No description provided for @chooseCorrectPlace.
  ///
  /// In ar, this message translates to:
  /// **'اختر المكان الصحيح'**
  String get chooseCorrectPlace;

  /// No description provided for @noMatchingPlace.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على مكان مطابق بالقرب من الإحداثيات.'**
  String get noMatchingPlace;

  /// No description provided for @matchRegisteredPlaceSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم ربط موقع الصيدلية بالمكان المسجل.'**
  String get matchRegisteredPlaceSuccess;

  /// No description provided for @approvedAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب معتمد'**
  String get approvedAccount;

  /// No description provided for @pendingApproval.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الاعتماد'**
  String get pendingApproval;

  /// No description provided for @locationSavedBadge.
  ///
  /// In ar, this message translates to:
  /// **'الموقع محفوظ'**
  String get locationSavedBadge;

  /// No description provided for @locationIncomplete.
  ///
  /// In ar, this message translates to:
  /// **'الموقع غير مكتمل'**
  String get locationIncomplete;

  /// No description provided for @inventoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'مخزون الأدوية'**
  String get inventoryTitle;

  /// No description provided for @scanBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح باركود'**
  String get scanBarcode;

  /// No description provided for @arabicLabel.
  ///
  /// In ar, this message translates to:
  /// **'عربي'**
  String get arabicLabel;

  /// No description provided for @showArabicNamesTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إظهار الأسماء العربية'**
  String get showArabicNamesTooltip;

  /// No description provided for @refreshInventoryTooltip.
  ///
  /// In ar, this message translates to:
  /// **'تحديث المخزون'**
  String get refreshInventoryTooltip;

  /// No description provided for @searchByMedicineOrScientificName.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم الدواء أو الاسم العلمي'**
  String get searchByMedicineOrScientificName;

  /// No description provided for @inventoryLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المخزون...'**
  String get inventoryLoading;

  /// No description provided for @inventoryBatchAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة {count} أدوية إلى المخزون.'**
  String inventoryBatchAdded(Object count);

  /// No description provided for @manualMedicineCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الدواء وإضافته إلى المخزون.'**
  String get manualMedicineCreated;

  /// No description provided for @inventoryItemAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة الدواء.'**
  String get inventoryItemAdded;

  /// No description provided for @inventoryItemUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الصنف.'**
  String get inventoryItemUpdated;

  /// No description provided for @inventoryItemDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الصنف.'**
  String get inventoryItemDeleted;

  /// No description provided for @deleteItemTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصنف؟'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف {name} من مخزون الصيدلية.'**
  String deleteItemConfirm(Object name);

  /// No description provided for @inventoryManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المخزون'**
  String get inventoryManagement;

  /// No description provided for @inventoryOverviewSummary.
  ///
  /// In ar, this message translates to:
  /// **'{count} صنف · {available} متاح للطلب'**
  String inventoryOverviewSummary(Object count, Object available);

  /// No description provided for @availableLabel.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get availableLabel;

  /// No description provided for @lowLabel.
  ///
  /// In ar, this message translates to:
  /// **'منخفض'**
  String get lowLabel;

  /// No description provided for @outOfStockLabel.
  ///
  /// In ar, this message translates to:
  /// **'نافد'**
  String get outOfStockLabel;

  /// No description provided for @itemOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات الصنف'**
  String get itemOptions;

  /// No description provided for @editLabel.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get editLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantityLabel;

  /// No description provided for @hiddenLabel.
  ///
  /// In ar, this message translates to:
  /// **'مخفي'**
  String get hiddenLabel;

  /// No description provided for @statusLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get statusLabel;

  /// No description provided for @concentrationChip.
  ///
  /// In ar, this message translates to:
  /// **'التركيز: {value}'**
  String concentrationChip(Object value);

  /// No description provided for @dosageFormChip.
  ///
  /// In ar, this message translates to:
  /// **'الشكل: {value}'**
  String dosageFormChip(Object value);

  /// No description provided for @notAvailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get notAvailable;

  /// No description provided for @expiresOn.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي {date}'**
  String expiresOn(Object date);

  /// No description provided for @lowStockLabel.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض'**
  String get lowStockLabel;

  /// No description provided for @addToInventoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى المخزون'**
  String get addToInventoryTitle;

  /// No description provided for @addToInventorySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر الطريقة الأنسب لإدخال الدواء.'**
  String get addToInventorySubtitle;

  /// No description provided for @chooseFromCatalog.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من دليل الأدوية'**
  String get chooseFromCatalog;

  /// No description provided for @chooseFromCatalogSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر دواءً واحدًا أو عدة أدوية دفعة واحدة'**
  String get chooseFromCatalogSubtitle;

  /// No description provided for @scanPackageBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح باركود العبوة'**
  String get scanPackageBarcode;

  /// No description provided for @scanPackageBarcodeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اعثر على الدواء مباشرة بالكاميرا'**
  String get scanPackageBarcodeSubtitle;

  /// No description provided for @addMedicineManually.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دواء يدويًا'**
  String get addMedicineManually;

  /// No description provided for @addMedicineManuallySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استخدمها عندما لا تجد الدواء في الدليل'**
  String get addMedicineManuallySubtitle;

  /// No description provided for @newMedicineDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الدواء الجديد'**
  String get newMedicineDataTitle;

  /// No description provided for @newMedicineDataSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتب البيانات كما تظهر على عبوة الدواء لتسهيل العثور عليه.'**
  String get newMedicineDataSubtitle;

  /// No description provided for @medicineNameEnglishLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء بالإنكليزية *'**
  String get medicineNameEnglishLabel;

  /// No description provided for @medicineNameArabicLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء بالعربية'**
  String get medicineNameArabicLabel;

  /// No description provided for @scanWithCamera.
  ///
  /// In ar, this message translates to:
  /// **'مسح بالكاميرا'**
  String get scanWithCamera;

  /// No description provided for @scientificNameEnglishLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العلمي بالإنكليزية'**
  String get scientificNameEnglishLabel;

  /// No description provided for @scientificNameArabicLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم العلمي بالعربية'**
  String get scientificNameArabicLabel;

  /// No description provided for @concentrationOrCapacityLabel.
  ///
  /// In ar, this message translates to:
  /// **'التركيز أو السعة'**
  String get concentrationOrCapacityLabel;

  /// No description provided for @continueToInventoryData.
  ///
  /// In ar, this message translates to:
  /// **'متابعة إلى بيانات المخزون'**
  String get continueToInventoryData;

  /// No description provided for @additionalDescriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'وصف إضافي'**
  String get additionalDescriptionLabel;

  /// No description provided for @catalogSelectionTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختيار أدوية من الدليل'**
  String get catalogSelectionTitle;

  /// No description provided for @catalogSelectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك اختيار دواء واحد أو عدة أدوية وإضافتها دفعة واحدة.'**
  String get catalogSelectionSubtitle;

  /// No description provided for @showArabicName.
  ///
  /// In ar, this message translates to:
  /// **'إظهار الاسم العربي'**
  String get showArabicName;

  /// No description provided for @selectedMedicinesCount.
  ///
  /// In ar, this message translates to:
  /// **'تم اختيار {count} دواء'**
  String selectedMedicinesCount(Object count);

  /// No description provided for @catalogOpening.
  ///
  /// In ar, this message translates to:
  /// **'جاري فتح دليل الأدوية...'**
  String get catalogOpening;

  /// No description provided for @noMatchingMedicines.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أدوية مطابقة لبحثك.'**
  String get noMatchingMedicines;

  /// No description provided for @selectAtLeastOneMedicine.
  ///
  /// In ar, this message translates to:
  /// **'اختر دواءً واحدًا على الأقل'**
  String get selectAtLeastOneMedicine;

  /// No description provided for @continueWithSelectedCount.
  ///
  /// In ar, this message translates to:
  /// **'متابعة مع {count} دواء'**
  String continueWithSelectedCount(Object count);

  /// No description provided for @reloadMore.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تحميل المزيد'**
  String get reloadMore;

  /// No description provided for @scrollForMore.
  ///
  /// In ar, this message translates to:
  /// **'مرّر للأسفل لعرض المزيد'**
  String get scrollForMore;

  /// No description provided for @shownCountOfTotal.
  ///
  /// In ar, this message translates to:
  /// **'تم عرض {loaded} من {total} دواء'**
  String shownCountOfTotal(Object loaded, Object total);

  /// No description provided for @enterInventoryAvailability.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات توفر الدواء داخل صيدليتك.'**
  String get enterInventoryAvailability;

  /// No description provided for @updateInventoryData.
  ///
  /// In ar, this message translates to:
  /// **'حدّث الكمية والسعر وحالة العرض للمستخدمين.'**
  String get updateInventoryData;

  /// No description provided for @priceInSyrianPounds.
  ///
  /// In ar, this message translates to:
  /// **'السعر بالليرة السورية'**
  String get priceInSyrianPounds;

  /// No description provided for @priceValue.
  ///
  /// In ar, this message translates to:
  /// **'{value} ل.س'**
  String priceValue(Object value);

  /// No description provided for @invalidNumbersError.
  ///
  /// In ar, this message translates to:
  /// **'أدخل أرقامًا صحيحة؛ لا يمكن أن تكون الكمية أو السعر أو حد المخزون أقل من صفر.'**
  String get invalidNumbersError;

  /// No description provided for @saveItem.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الصنف'**
  String get saveItem;

  /// No description provided for @noMatchingItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف مطابقة'**
  String get noMatchingItems;

  /// No description provided for @noMatchingItemsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر البحث أو أضف دواءً جديدًا من دليل الأدوية.'**
  String get noMatchingItemsSubtitle;

  /// No description provided for @allLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allLabel;

  /// No description provided for @dashboardPreparingPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'نجهّز مركز تشغيل الصيدلية...'**
  String get dashboardPreparingPharmacy;

  /// No description provided for @pharmacyOperationsSection.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل الصيدلية'**
  String get pharmacyOperationsSection;

  /// No description provided for @pharmacyOperationsSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختصارات لأهم مهامك اليومية'**
  String get pharmacyOperationsSectionSubtitle;

  /// No description provided for @quickOverviewSection.
  ///
  /// In ar, this message translates to:
  /// **'نظرة سريعة'**
  String get quickOverviewSection;

  /// No description provided for @quickOverviewSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مؤشرات المخزون والطلبات الحالية'**
  String get quickOverviewSectionSubtitle;

  /// No description provided for @inventoryAlertsSection.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات المخزون'**
  String get inventoryAlertsSection;

  /// No description provided for @inventoryAlertsSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأصناف التي تحتاج تدخلك قريبًا'**
  String get inventoryAlertsSectionSubtitle;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @verifyPharmacyLicense.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من ترخيص الصيدلية'**
  String get verifyPharmacyLicense;

  /// No description provided for @managePrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الوصفات الطبية'**
  String get managePrescriptions;

  /// No description provided for @donationsLabel.
  ///
  /// In ar, this message translates to:
  /// **'التبرعات'**
  String get donationsLabel;

  /// No description provided for @analyzeInventory.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المخزون'**
  String get analyzeInventory;

  /// No description provided for @inventoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get inventoryLabel;

  /// No description provided for @manageItems.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الأصناف'**
  String get manageItems;

  /// No description provided for @lowStockCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} منخفض'**
  String lowStockCount(Object count);

  /// No description provided for @ordersLabel.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get ordersLabel;

  /// No description provided for @followReplies.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الردود'**
  String get followReplies;

  /// No description provided for @pendingRequestsBadge.
  ///
  /// In ar, this message translates to:
  /// **'{count} بانتظارك'**
  String pendingRequestsBadge(Object count);

  /// No description provided for @organizeHours.
  ///
  /// In ar, this message translates to:
  /// **'تنظيم الدوام'**
  String get organizeHours;

  /// No description provided for @pharmacyProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف الصيدلية'**
  String get pharmacyProfile;

  /// No description provided for @locationAndData.
  ///
  /// In ar, this message translates to:
  /// **'الموقع والبيانات'**
  String get locationAndData;

  /// No description provided for @inventoryItemsLabel.
  ///
  /// In ar, this message translates to:
  /// **'أصناف المخزون'**
  String get inventoryItemsLabel;

  /// No description provided for @addPharmacyLocation.
  ///
  /// In ar, this message translates to:
  /// **'أضف موقع الصيدلية لتظهر للمستخدمين'**
  String get addPharmacyLocation;

  /// No description provided for @newLabel.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get newLabel;

  /// No description provided for @activeRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات نشطة'**
  String get activeRequests;

  /// No description provided for @approvePharmacyAccount.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد حساب الصيدلية'**
  String get approvePharmacyAccount;

  /// No description provided for @completedLabel.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get completedLabel;

  /// No description provided for @pendingReview.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار المراجعة'**
  String get pendingReview;

  /// No description provided for @locationSet.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديده'**
  String get locationSet;

  /// No description provided for @requiredToAppear.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب للظهور للمستخدمين'**
  String get requiredToAppear;

  /// No description provided for @hoursConfigured.
  ///
  /// In ar, this message translates to:
  /// **'تم إعدادها'**
  String get hoursConfigured;

  /// No description provided for @setWorkingHours.
  ///
  /// In ar, this message translates to:
  /// **'حدد أوقات الدوام'**
  String get setWorkingHours;

  /// No description provided for @inventoryItemsCountValue.
  ///
  /// In ar, this message translates to:
  /// **'{count} صنف'**
  String inventoryItemsCountValue(Object count);

  /// No description provided for @addFirstMedicine.
  ///
  /// In ar, this message translates to:
  /// **'أضف أول دواء'**
  String get addFirstMedicine;

  /// No description provided for @pharmacyReadiness.
  ///
  /// In ar, this message translates to:
  /// **'جاهزية الصيدلية'**
  String get pharmacyReadiness;

  /// No description provided for @profileCompletionValue.
  ///
  /// In ar, this message translates to:
  /// **'{percent}٪ من الملف مكتمل'**
  String profileCompletionValue(Object percent);

  /// No description provided for @inventoryAlertLowStock.
  ///
  /// In ar, this message translates to:
  /// **'الكمية {quantity} · الحد الأدنى {threshold}'**
  String inventoryAlertLowStock(Object quantity, Object threshold);

  /// No description provided for @inventoryAlertExpiry.
  ///
  /// In ar, this message translates to:
  /// **'متبقي {days} يومًا على الانتهاء'**
  String inventoryAlertExpiry(Object days);

  /// No description provided for @inventoryHealthy.
  ///
  /// In ar, this message translates to:
  /// **'المخزون مستقر ولا توجد تنبيهات عاجلة'**
  String get inventoryHealthy;

  /// No description provided for @profileCompletionLabel.
  ///
  /// In ar, this message translates to:
  /// **'اكتمال الملف {value}٪'**
  String profileCompletionLabel(Object value);

  /// No description provided for @organizationManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المنظمة'**
  String get organizationManagement;

  /// No description provided for @orgManagementSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المبادرات والتبرعات والمستفيدون'**
  String get orgManagementSubtitle;

  /// No description provided for @refreshDataTooltip.
  ///
  /// In ar, this message translates to:
  /// **'تحديث البيانات'**
  String get refreshDataTooltip;

  /// No description provided for @moreLabel.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get moreLabel;

  /// No description provided for @editOrganizationData.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات المنظمة'**
  String get editOrganizationData;

  /// No description provided for @uploadVerificationDocument.
  ///
  /// In ar, this message translates to:
  /// **'رفع وثيقة تحقق'**
  String get uploadVerificationDocument;

  /// No description provided for @newCampaign.
  ///
  /// In ar, this message translates to:
  /// **'حملة جديدة'**
  String get newCampaign;

  /// No description provided for @addCampaignInfoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف معلومات واضحة تساعد المتبرعين.'**
  String get addCampaignInfoSubtitle;

  /// No description provided for @campaignTitleField.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الحملة'**
  String get campaignTitleField;

  /// No description provided for @campaignDescriptionField.
  ///
  /// In ar, this message translates to:
  /// **'وصف الحملة'**
  String get campaignDescriptionField;

  /// No description provided for @requestedMedicinesField.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية المطلوبة (اختياري)'**
  String get requestedMedicinesField;

  /// No description provided for @urgentCampaign.
  ///
  /// In ar, this message translates to:
  /// **'حملة عاجلة'**
  String get urgentCampaign;

  /// No description provided for @urgentCampaignSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تظهر بأولوية بصرية أعلى.'**
  String get urgentCampaignSubtitle;

  /// No description provided for @acceptPublicDonations.
  ///
  /// In ar, this message translates to:
  /// **'استقبال تبرعات عامة'**
  String get acceptPublicDonations;

  /// No description provided for @acceptPublicDonationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكن للمستخدمين دعم الحملة مباشرة.'**
  String get acceptPublicDonationsSubtitle;

  /// No description provided for @startDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البداية'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النهاية'**
  String get endDateLabel;

  /// No description provided for @createCampaign.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحملة'**
  String get createCampaign;

  /// No description provided for @organizationData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المنظمة'**
  String get organizationData;

  /// No description provided for @organizationNameField.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنظمة'**
  String get organizationNameField;

  /// No description provided for @registrationNumberField.
  ///
  /// In ar, this message translates to:
  /// **'رقم التسجيل'**
  String get registrationNumberField;

  /// No description provided for @addressLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get addressLabel;

  /// No description provided for @organizationDescriptionField.
  ///
  /// In ar, this message translates to:
  /// **'وصف المنظمة'**
  String get organizationDescriptionField;

  /// No description provided for @chooseFile.
  ///
  /// In ar, this message translates to:
  /// **'اختيار ملف'**
  String get chooseFile;

  /// No description provided for @documentSizeLimit.
  ///
  /// In ar, this message translates to:
  /// **'حجم الوثيقة يجب ألا يتجاوز 10 ميغابايت.'**
  String get documentSizeLimit;

  /// No description provided for @documentTypeTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الوثيقة'**
  String get documentTypeTitle;

  /// No description provided for @updateSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ التحديث.'**
  String get updateSaved;

  /// No description provided for @summaryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الملخص'**
  String get summaryLabel;

  /// No description provided for @campaignsLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحملات'**
  String get campaignsLabel;

  /// No description provided for @assistanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get assistanceLabel;

  /// No description provided for @profileLabel.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get profileLabel;

  /// No description provided for @quickAccess.
  ///
  /// In ar, this message translates to:
  /// **'وصول سريع'**
  String get quickAccess;

  /// No description provided for @whatDoYouWantToDo.
  ///
  /// In ar, this message translates to:
  /// **'ما الذي تريد إنجازه؟'**
  String get whatDoYouWantToDo;

  /// No description provided for @orgOperationsReady.
  ///
  /// In ar, this message translates to:
  /// **'أهم عمليات المنظمة جاهزة من مكان واحد.'**
  String get orgOperationsReady;

  /// No description provided for @uploadDocument.
  ///
  /// In ar, this message translates to:
  /// **'رفع وثيقة'**
  String get uploadDocument;

  /// No description provided for @editProfileLabel.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get editProfileLabel;

  /// No description provided for @currentImpact.
  ///
  /// In ar, this message translates to:
  /// **'الأثر الحالي'**
  String get currentImpact;

  /// No description provided for @workSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص العمل'**
  String get workSummary;

  /// No description provided for @workSummarySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قراءة سريعة لحركة المبادرات والطلبات.'**
  String get workSummarySubtitle;

  /// No description provided for @allCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'جميع الحملات'**
  String get allCampaigns;

  /// No description provided for @activeCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'الحملات النشطة'**
  String get activeCampaigns;

  /// No description provided for @pendingOffers.
  ///
  /// In ar, this message translates to:
  /// **'عروض تنتظر'**
  String get pendingOffers;

  /// No description provided for @openRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مفتوحة'**
  String get openRequests;

  /// No description provided for @latestUpdates.
  ///
  /// In ar, this message translates to:
  /// **'آخر التحديثات'**
  String get latestUpdates;

  /// No description provided for @recentCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'الحملات الأخيرة'**
  String get recentCampaigns;

  /// No description provided for @recentCampaignsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر المبادرات التي عملت عليها المنظمة.'**
  String get recentCampaignsSubtitle;

  /// No description provided for @startFirstCampaign.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بإنشاء أول حملة للمنظمة.'**
  String get startFirstCampaign;

  /// No description provided for @manageInitiatives.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المبادرات'**
  String get manageInitiatives;

  /// No description provided for @orgCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'حملات المنظمة'**
  String get orgCampaigns;

  /// No description provided for @orgCampaignsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ الحملة وحدد حالتها وفق تقدم العمل.'**
  String get orgCampaignsSubtitle;

  /// No description provided for @createCampaignTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حملة'**
  String get createCampaignTooltip;

  /// No description provided for @noCampaignsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حملات بعد. أنشئ أول مبادرة الآن.'**
  String get noCampaignsYet;

  /// No description provided for @givingNetwork.
  ///
  /// In ar, this message translates to:
  /// **'شبكة العطاء'**
  String get givingNetwork;

  /// No description provided for @donationOffersTitle.
  ///
  /// In ar, this message translates to:
  /// **'عروض التبرع'**
  String get donationOffersTitle;

  /// No description provided for @donationOffersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع العروض التي اجتازت التحقق وتابع استلامها.'**
  String get donationOffersSubtitle;

  /// No description provided for @beneficiaryCare.
  ///
  /// In ar, this message translates to:
  /// **'رعاية المستفيدين'**
  String get beneficiaryCare;

  /// No description provided for @assistanceRequestsTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات المساعدة'**
  String get assistanceRequestsTitle;

  /// No description provided for @assistanceRequestsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع الحالات من الطلب الأول حتى اكتمال المساعدة.'**
  String get assistanceRequestsSubtitle;

  /// No description provided for @reliableData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات موثوقة'**
  String get reliableData;

  /// No description provided for @orgProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف المنظمة'**
  String get orgProfile;

  /// No description provided for @orgProfileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حافظ على دقة بيانات التواصل ووثائق الاعتماد.'**
  String get orgProfileSubtitle;

  /// No description provided for @documentsLabel.
  ///
  /// In ar, this message translates to:
  /// **'المستندات'**
  String get documentsLabel;

  /// No description provided for @accreditationDocs.
  ///
  /// In ar, this message translates to:
  /// **'وثائق الاعتماد'**
  String get accreditationDocs;

  /// No description provided for @uploadedDocsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} ملفات مرفوعة للمراجعة.'**
  String uploadedDocsCount(Object count);

  /// No description provided for @noAccreditationDocs.
  ///
  /// In ar, this message translates to:
  /// **'لم تُرفع وثائق اعتماد بعد.'**
  String get noAccreditationDocs;

  /// No description provided for @createNewCampaign.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حملة جديدة'**
  String get createNewCampaign;

  /// No description provided for @activateCampaign.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الحملة'**
  String get activateCampaign;

  /// No description provided for @closeCampaign.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق الحملة'**
  String get closeCampaign;

  /// No description provided for @cancelCampaign.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحملة'**
  String get cancelCampaign;

  /// No description provided for @urgentLabel.
  ///
  /// In ar, this message translates to:
  /// **'عاجلة'**
  String get urgentLabel;

  /// No description provided for @acceptsDonationsLabel.
  ///
  /// In ar, this message translates to:
  /// **'تستقبل التبرعات'**
  String get acceptsDonationsLabel;

  /// No description provided for @campaignEndsOn.
  ///
  /// In ar, this message translates to:
  /// **'تنتهي في {date}'**
  String campaignEndsOn(Object date);

  /// No description provided for @offerPackages.
  ///
  /// In ar, this message translates to:
  /// **'{count} عبوات · {name}'**
  String offerPackages(Object count, Object name);

  /// No description provided for @verifiedViaPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق عبر {name}'**
  String verifiedViaPharmacy(Object name);

  /// No description provided for @validUntil.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية حتى {date}'**
  String validUntil(Object date);

  /// No description provided for @acceptOffer.
  ///
  /// In ar, this message translates to:
  /// **'قبول العرض'**
  String get acceptOffer;

  /// No description provided for @confirmDonationReceived.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد استلام التبرع'**
  String get confirmDonationReceived;

  /// No description provided for @requestPackages.
  ///
  /// In ar, this message translates to:
  /// **'{count} عبوات · {name}'**
  String requestPackages(Object count, Object name);

  /// No description provided for @neededBefore.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب قبل {date}'**
  String neededBefore(Object date);

  /// No description provided for @startReview.
  ///
  /// In ar, this message translates to:
  /// **'بدء المراجعة'**
  String get startReview;

  /// No description provided for @assistanceCompleted.
  ///
  /// In ar, this message translates to:
  /// **'تمت المساعدة'**
  String get assistanceCompleted;

  /// No description provided for @cannotFulfill.
  ///
  /// In ar, this message translates to:
  /// **'تعذر التلبية'**
  String get cannotFulfill;

  /// No description provided for @contactLabel.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get contactLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In ar, this message translates to:
  /// **'نبذة'**
  String get aboutLabel;

  /// No description provided for @optionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optionalLabel;

  /// No description provided for @documentsUploaded.
  ///
  /// In ar, this message translates to:
  /// **'{count} وثائق مرفوعة'**
  String documentsUploaded(Object count);

  /// No description provided for @orgVerified.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من المنظمة'**
  String get orgVerified;

  /// No description provided for @orgVerificationRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض التحقق'**
  String get orgVerificationRejected;

  /// No description provided for @orgVerificationUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'التحقق قيد المراجعة'**
  String get orgVerificationUnderReview;

  /// No description provided for @orgVerificationIncomplete.
  ///
  /// In ar, this message translates to:
  /// **'التحقق غير مكتمل'**
  String get orgVerificationIncomplete;

  /// No description provided for @verifiedShort.
  ///
  /// In ar, this message translates to:
  /// **'موثقة'**
  String get verifiedShort;

  /// No description provided for @rejectedShort.
  ///
  /// In ar, this message translates to:
  /// **'مرفوضة'**
  String get rejectedShort;

  /// No description provided for @underReviewShort.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get underReviewShort;

  /// No description provided for @incompleteShort.
  ///
  /// In ar, this message translates to:
  /// **'غير مكتملة'**
  String get incompleteShort;

  /// No description provided for @campaignActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get campaignActive;

  /// No description provided for @campaignClosed.
  ///
  /// In ar, this message translates to:
  /// **'مغلقة'**
  String get campaignClosed;

  /// No description provided for @campaignCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get campaignCancelled;

  /// No description provided for @campaignDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get campaignDraft;

  /// No description provided for @docRegistrationCertificate.
  ///
  /// In ar, this message translates to:
  /// **'شهادة التسجيل'**
  String get docRegistrationCertificate;

  /// No description provided for @docOperatingLicense.
  ///
  /// In ar, this message translates to:
  /// **'ترخيص العمل'**
  String get docOperatingLicense;

  /// No description provided for @docManagerIdentity.
  ///
  /// In ar, this message translates to:
  /// **'هوية المدير'**
  String get docManagerIdentity;

  /// No description provided for @docTaxOrLegal.
  ///
  /// In ar, this message translates to:
  /// **'وثيقة قانونية'**
  String get docTaxOrLegal;

  /// No description provided for @docOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get docOther;

  /// No description provided for @docLicensedDocument.
  ///
  /// In ar, this message translates to:
  /// **'وثيقة الترخيص'**
  String get docLicensedDocument;

  /// No description provided for @docIdentityDocument.
  ///
  /// In ar, this message translates to:
  /// **'إثبات الهوية'**
  String get docIdentityDocument;

  /// No description provided for @docAccreditation.
  ///
  /// In ar, this message translates to:
  /// **'وثيقة اعتماد'**
  String get docAccreditation;

  /// No description provided for @orgHomeLoading.
  ///
  /// In ar, this message translates to:
  /// **'نجهّز مساحة المنظمة...'**
  String get orgHomeLoading;

  /// No description provided for @orgHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع أثر حملاتك واستجابتك لاحتياجات المستفيدين بوضوح.'**
  String get orgHeroSubtitle;

  /// No description provided for @verifiedBadge.
  ///
  /// In ar, this message translates to:
  /// **'منظمة معتمدة · {label}'**
  String verifiedBadge(Object label);

  /// No description provided for @accountPendingApproval.
  ///
  /// In ar, this message translates to:
  /// **'الحساب بانتظار الاعتماد'**
  String get accountPendingApproval;

  /// No description provided for @orgImpactSection.
  ///
  /// In ar, this message translates to:
  /// **'أثر المنظمة'**
  String get orgImpactSection;

  /// No description provided for @orgImpactSectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مؤشرات الحملات والطلبات الحالية'**
  String get orgImpactSectionSubtitle;

  /// No description provided for @totalCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الحملات'**
  String get totalCampaigns;

  /// No description provided for @offersWaiting.
  ///
  /// In ar, this message translates to:
  /// **'عروض بانتظارك'**
  String get offersWaiting;

  /// No description provided for @assistanceRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات مساعدة'**
  String get assistanceRequests;

  /// No description provided for @workManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة العمل'**
  String get workManagement;

  /// No description provided for @workManagementSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل مسار يفتح في قسمه مباشرة'**
  String get workManagementSubtitle;

  /// No description provided for @createUpdateCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء وتحديث حالة الحملات'**
  String get createUpdateCampaigns;

  /// No description provided for @reviewOfferedMedicines.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الأدوية المعروضة'**
  String get reviewOfferedMedicines;

  /// No description provided for @followCasesAndRespond.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الحالات والاستجابة لها'**
  String get followCasesAndRespond;

  /// No description provided for @dataAndVerificationDocs.
  ///
  /// In ar, this message translates to:
  /// **'البيانات ووثائق التحقق'**
  String get dataAndVerificationDocs;

  /// No description provided for @verificationStatusTitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة التحقق'**
  String get verificationStatusTitle;

  /// No description provided for @verificationDocsCount.
  ///
  /// In ar, this message translates to:
  /// **'{label} · {count} وثائق مرفوعة'**
  String verificationDocsCount(Object label, Object count);

  /// No description provided for @completeVerificationDocs.
  ///
  /// In ar, this message translates to:
  /// **'أكمل وثائق التحقق لتعزيز موثوقية المنظمة.'**
  String get completeVerificationDocs;

  /// No description provided for @recentCampaignsAddedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر المبادرات المضافة إلى حساب المنظمة'**
  String get recentCampaignsAddedSubtitle;

  /// No description provided for @needsUpdate.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج تحديثاً'**
  String get needsUpdate;

  /// No description provided for @notApproved.
  ///
  /// In ar, this message translates to:
  /// **'غير معتمدة'**
  String get notApproved;

  /// No description provided for @verificationStatusUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حالة التحقق غير محددة'**
  String get verificationStatusUnknown;

  /// No description provided for @campaignPaused.
  ///
  /// In ar, this message translates to:
  /// **'متوقفة مؤقتاً'**
  String get campaignPaused;

  /// No description provided for @campaignCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get campaignCompleted;

  /// No description provided for @supplyWarehouseTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المستودع'**
  String get supplyWarehouseTitle;

  /// No description provided for @supplyWarehouseSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مركز الإمداد والتوزيع'**
  String get supplyWarehouseSubtitle;

  /// No description provided for @supplySummaryLabel.
  ///
  /// In ar, this message translates to:
  /// **'الملخص'**
  String get supplySummaryLabel;

  /// No description provided for @supplyBatchesLabel.
  ///
  /// In ar, this message translates to:
  /// **'التشغيلات'**
  String get supplyBatchesLabel;

  /// No description provided for @supplyOrdersLabel.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get supplyOrdersLabel;

  /// No description provided for @supplyRepresentativesLabel.
  ///
  /// In ar, this message translates to:
  /// **'المندوبون'**
  String get supplyRepresentativesLabel;

  /// No description provided for @supplyFinanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'المالية'**
  String get supplyFinanceLabel;

  /// No description provided for @supplyLoadingWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المستودع...'**
  String get supplyLoadingWarehouse;

  /// No description provided for @supplyWarehouseOpsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مركز تشغيل المستودع'**
  String get supplyWarehouseOpsTitle;

  /// No description provided for @supplyInventoryValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة المخزون {money} ل.س'**
  String supplyInventoryValue(Object money);

  /// No description provided for @supplyNewOrdersCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} طلب جديد'**
  String supplyNewOrdersCount(Object count);

  /// No description provided for @supplyTodayIndicators.
  ///
  /// In ar, this message translates to:
  /// **'مؤشرات اليوم'**
  String get supplyTodayIndicators;

  /// No description provided for @supplyTodayIndicatorsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قراءة سريعة لحالة التشغيل والمخزون'**
  String get supplyTodayIndicatorsSubtitle;

  /// No description provided for @supplyActiveBatches.
  ///
  /// In ar, this message translates to:
  /// **'تشغيلات نشطة'**
  String get supplyActiveBatches;

  /// No description provided for @supplyLowStock.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض'**
  String get supplyLowStock;

  /// No description provided for @supplyExpiringSoon.
  ///
  /// In ar, this message translates to:
  /// **'قرب الانتهاء'**
  String get supplyExpiringSoon;

  /// No description provided for @supplyActiveDeliveries.
  ///
  /// In ar, this message translates to:
  /// **'شحنات نشطة'**
  String get supplyActiveDeliveries;

  /// No description provided for @supplyNeedsAttention.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج إلى انتباه'**
  String get supplyNeedsAttention;

  /// No description provided for @supplyNeedsAttentionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تشغيلات منخفضة أو قريبة من الانتهاء'**
  String get supplyNeedsAttentionSubtitle;

  /// No description provided for @supplyNoBatches.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تشغيلات دوائية بعد.'**
  String get supplyNoBatches;

  /// No description provided for @supplyBatchesStockTitle.
  ///
  /// In ar, this message translates to:
  /// **'مخزون التشغيلات'**
  String get supplyBatchesStockTitle;

  /// No description provided for @supplyBatchesStockSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الكميات والأسعار وتواريخ الانتهاء'**
  String get supplyBatchesStockSubtitle;

  /// No description provided for @supplyBatchLabel.
  ///
  /// In ar, this message translates to:
  /// **'تشغيلة'**
  String get supplyBatchLabel;

  /// No description provided for @supplyAddBatch.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تشغيلة'**
  String get supplyAddBatch;

  /// No description provided for @supplyBatchNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم التشغيلة'**
  String get supplyBatchNumber;

  /// No description provided for @supplyPurchasePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الشراء'**
  String get supplyPurchasePrice;

  /// No description provided for @supplyWholesalePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الجملة'**
  String get supplyWholesalePrice;

  /// No description provided for @supplyStorageLocation.
  ///
  /// In ar, this message translates to:
  /// **'موضع التخزين'**
  String get supplyStorageLocation;

  /// No description provided for @supplyBatchAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة التشغيلة.'**
  String get supplyBatchAdded;

  /// No description provided for @supplyLoadingOrders.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الطلبات...'**
  String get supplyLoadingOrders;

  /// No description provided for @supplyPharmacyOrdersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الصيدليات'**
  String get supplyPharmacyOrdersTitle;

  /// No description provided for @supplyMyOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get supplyMyOrders;

  /// No description provided for @supplyPharmacyOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'معالجة الطلب من الاستلام حتى التسليم'**
  String get supplyPharmacyOrdersSubtitle;

  /// No description provided for @supplyMyOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة حالة طلبات التوريد والشحن'**
  String get supplyMyOrdersSubtitle;

  /// No description provided for @supplyNewOrdersFilter.
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get supplyNewOrdersFilter;

  /// No description provided for @supplyActiveOrdersFilter.
  ///
  /// In ar, this message translates to:
  /// **'قيد التنفيذ'**
  String get supplyActiveOrdersFilter;

  /// No description provided for @supplyNoOrdersInCategory.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات ضمن هذا التصنيف.'**
  String get supplyNoOrdersInCategory;

  /// No description provided for @supplyOrderItemsTotal.
  ///
  /// In ar, this message translates to:
  /// **'{count} أصناف · {amount} ل.س'**
  String supplyOrderItemsTotal(Object count, Object amount);

  /// No description provided for @supplyShipmentInfo.
  ///
  /// In ar, this message translates to:
  /// **'الشحنة: {code} · {status}'**
  String supplyShipmentInfo(Object code, Object status);

  /// No description provided for @supplyAccept.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get supplyAccept;

  /// No description provided for @supplyStartPreparing.
  ///
  /// In ar, this message translates to:
  /// **'بدء التجهيز'**
  String get supplyStartPreparing;

  /// No description provided for @supplyReadyForDispatch.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للشحن'**
  String get supplyReadyForDispatch;

  /// No description provided for @supplyAssignRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'إسناد لمندوب'**
  String get supplyAssignRepresentative;

  /// No description provided for @supplyConfirmReceipt.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد استلام الشحنة'**
  String get supplyConfirmReceipt;

  /// No description provided for @supplyReturnItem.
  ///
  /// In ar, this message translates to:
  /// **'طلب إرجاع صنف'**
  String get supplyReturnItem;

  /// No description provided for @supplyOrderUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الطلب.'**
  String get supplyOrderUpdated;

  /// No description provided for @supplyAssignShipment.
  ///
  /// In ar, this message translates to:
  /// **'إسناد الشحنة'**
  String get supplyAssignShipment;

  /// No description provided for @supplyRepresentativeLabel.
  ///
  /// In ar, this message translates to:
  /// **'المندوب'**
  String get supplyRepresentativeLabel;

  /// No description provided for @supplyPackagesCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الطرود'**
  String get supplyPackagesCount;

  /// No description provided for @supplyAssign.
  ///
  /// In ar, this message translates to:
  /// **'إسناد'**
  String get supplyAssign;

  /// No description provided for @supplyShipmentAssigned.
  ///
  /// In ar, this message translates to:
  /// **'تم إسناد الشحنة للمندوب.'**
  String get supplyShipmentAssigned;

  /// No description provided for @supplyReceiptCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاستلام'**
  String get supplyReceiptCode;

  /// No description provided for @supplyReceiptNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة الاستلام'**
  String get supplyReceiptNote;

  /// No description provided for @supplyReceiptConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد استلام الشحنة.'**
  String get supplyReceiptConfirmed;

  /// No description provided for @supplyItemLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصنف'**
  String get supplyItemLabel;

  /// No description provided for @supplyReturnReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الإرجاع'**
  String get supplyReturnReason;

  /// No description provided for @supplyReturnSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الإرجاع.'**
  String get supplyReturnSent;

  /// No description provided for @supplyNoRepresentatives.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد مندوبون.'**
  String get supplyNoRepresentatives;

  /// No description provided for @supplyDeliveryTeam.
  ///
  /// In ar, this message translates to:
  /// **'فريق التوصيل'**
  String get supplyDeliveryTeam;

  /// No description provided for @supplyTeamSummary.
  ///
  /// In ar, this message translates to:
  /// **'{available} متاح الآن · {tasks} مهمة نشطة'**
  String supplyTeamSummary(Object available, Object tasks);

  /// No description provided for @supplyNoVehicle.
  ///
  /// In ar, this message translates to:
  /// **'دون مركبة'**
  String get supplyNoVehicle;

  /// No description provided for @supplyOnShift.
  ///
  /// In ar, this message translates to:
  /// **'ضمن الوردية'**
  String get supplyOnShift;

  /// No description provided for @supplyOffShift.
  ///
  /// In ar, this message translates to:
  /// **'خارج الوردية'**
  String get supplyOffShift;

  /// No description provided for @supplyActiveShort.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get supplyActiveShort;

  /// No description provided for @supplyCompletedShort.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get supplyCompletedShort;

  /// No description provided for @supplyAddRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مندوب'**
  String get supplyAddRepresentative;

  /// No description provided for @supplyEmployeeCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الموظف'**
  String get supplyEmployeeCode;

  /// No description provided for @supplyVehiclePlate.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المركبة'**
  String get supplyVehiclePlate;

  /// No description provided for @supplyCreate.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء'**
  String get supplyCreate;

  /// No description provided for @supplyRepresentativeCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء حساب المندوب.'**
  String get supplyRepresentativeCreated;

  /// No description provided for @supplyInvoicesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get supplyInvoicesLabel;

  /// No description provided for @supplyReturnsLabel.
  ///
  /// In ar, this message translates to:
  /// **'المرتجعات'**
  String get supplyReturnsLabel;

  /// No description provided for @supplyRecallsLabel.
  ///
  /// In ar, this message translates to:
  /// **'السحب'**
  String get supplyRecallsLabel;

  /// No description provided for @supplyFinanceTitle.
  ///
  /// In ar, this message translates to:
  /// **'المالية والرقابة'**
  String get supplyFinanceTitle;

  /// No description provided for @supplyFinanceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير والتحصيل والمرتجعات وسحب التشغيلات'**
  String get supplyFinanceSubtitle;

  /// No description provided for @supplyPharmacySupplyTitle.
  ///
  /// In ar, this message translates to:
  /// **'توريد الصيدلية'**
  String get supplyPharmacySupplyTitle;

  /// No description provided for @supplyWarehousesLabel.
  ///
  /// In ar, this message translates to:
  /// **'المستودعات'**
  String get supplyWarehousesLabel;

  /// No description provided for @supplyStockNeeds.
  ///
  /// In ar, this message translates to:
  /// **'احتياج المخزون'**
  String get supplyStockNeeds;

  /// No description provided for @supplyNoWarehouses.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مستودعات متاحة.'**
  String get supplyNoWarehouses;

  /// No description provided for @supplyAvailableWarehouses.
  ///
  /// In ar, this message translates to:
  /// **'المستودعات المتاحة'**
  String get supplyAvailableWarehouses;

  /// No description provided for @supplyAvailableWarehousesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تصفح المستودعات واطلب الأدوية المطلوبة'**
  String get supplyAvailableWarehousesSubtitle;

  /// No description provided for @supplyAvailableMedicinesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} دواء'**
  String supplyAvailableMedicinesCount(Object count);

  /// No description provided for @supplyDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'توصيل {fee} ل.س'**
  String supplyDeliveryFee(Object fee);

  /// No description provided for @supplySelectQuantities.
  ///
  /// In ar, this message translates to:
  /// **'حدد الكميات المطلوبة ثم أرسل الطلب.'**
  String get supplySelectQuantities;

  /// No description provided for @supplyCatalogItem.
  ///
  /// In ar, this message translates to:
  /// **'{price} ل.س · متاح {qty}'**
  String supplyCatalogItem(Object price, Object qty);

  /// No description provided for @supplySending.
  ///
  /// In ar, this message translates to:
  /// **'جاري الإرسال...'**
  String get supplySending;

  /// No description provided for @supplySupplyOrderSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب التوريد.'**
  String get supplySupplyOrderSent;

  /// No description provided for @supplyStockAdequate.
  ///
  /// In ar, this message translates to:
  /// **'المخزون ضمن الحدود المناسبة.'**
  String get supplyStockAdequate;

  /// No description provided for @supplyStockNeedsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية التي تحتاج إلى إعادة توريد'**
  String get supplyStockNeedsSubtitle;

  /// No description provided for @supplyCurrentQty.
  ///
  /// In ar, this message translates to:
  /// **'الحالي {qty}'**
  String supplyCurrentQty(Object qty);

  /// No description provided for @supplySuggestedQty.
  ///
  /// In ar, this message translates to:
  /// **'المقترح {qty}'**
  String supplySuggestedQty(Object qty);

  /// No description provided for @supplyDeliveryTasks.
  ///
  /// In ar, this message translates to:
  /// **'مهام التوصيل'**
  String get supplyDeliveryTasks;

  /// No description provided for @supplyTodaySchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدولك الميداني اليوم'**
  String get supplyTodaySchedule;

  /// No description provided for @supplyRefreshTasks.
  ///
  /// In ar, this message translates to:
  /// **'تحديث المهام'**
  String get supplyRefreshTasks;

  /// No description provided for @supplyLoadingTasks.
  ///
  /// In ar, this message translates to:
  /// **'جاري تجهيز مهامك...'**
  String get supplyLoadingTasks;

  /// No description provided for @supplyAssignedShipments.
  ///
  /// In ar, this message translates to:
  /// **'الشحنات المسندة'**
  String get supplyAssignedShipments;

  /// No description provided for @supplyNoTasksNow.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهمة جديدة في الوقت الحالي'**
  String get supplyNoTasksNow;

  /// No description provided for @supplyUpdateTaskStatus.
  ///
  /// In ar, this message translates to:
  /// **'حدّث حالة المهمة عند كل مرحلة'**
  String get supplyUpdateTaskStatus;

  /// No description provided for @supplySafeJourney.
  ///
  /// In ar, this message translates to:
  /// **'رحلة آمنة ومنظمة'**
  String get supplySafeJourney;

  /// No description provided for @supplySafeJourneySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع العنوان وحدّث حالة الشحنة أثناء التوصيل'**
  String get supplySafeJourneySubtitle;

  /// No description provided for @supplyTasksLabel.
  ///
  /// In ar, this message translates to:
  /// **'المهام'**
  String get supplyTasksLabel;

  /// No description provided for @supplyDeliveryItems.
  ///
  /// In ar, this message translates to:
  /// **'{code} · {count} أصناف'**
  String supplyDeliveryItems(Object code, Object count);

  /// No description provided for @supplyDeliveredSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسليم الشحنة بنجاح'**
  String get supplyDeliveredSuccess;

  /// No description provided for @supplyStepPickup.
  ///
  /// In ar, this message translates to:
  /// **'استلام'**
  String get supplyStepPickup;

  /// No description provided for @supplyStepLoading.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get supplyStepLoading;

  /// No description provided for @supplyStepOnWay.
  ///
  /// In ar, this message translates to:
  /// **'بالطريق'**
  String get supplyStepOnWay;

  /// No description provided for @supplyStepArrival.
  ///
  /// In ar, this message translates to:
  /// **'وصول'**
  String get supplyStepArrival;

  /// No description provided for @supplyStepDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تسليم'**
  String get supplyStepDelivered;

  /// No description provided for @supplyNoData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات.'**
  String get supplyNoData;

  /// No description provided for @supplyInvoiceRemaining.
  ///
  /// In ar, this message translates to:
  /// **'{name} · متبقي {amount} ل.س'**
  String supplyInvoiceRemaining(Object name, Object amount);

  /// No description provided for @supplyInvoiceSummary.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي {total} ل.س · المدفوع {paid} ل.س'**
  String supplyInvoiceSummary(Object total, Object paid);

  /// No description provided for @supplyEditInvoiceTerms.
  ///
  /// In ar, this message translates to:
  /// **'تعديل شروط الفاتورة'**
  String get supplyEditInvoiceTerms;

  /// No description provided for @supplyRecordPayment.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة'**
  String get supplyRecordPayment;

  /// No description provided for @supplyAmountLabel.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get supplyAmountLabel;

  /// No description provided for @supplyPaymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get supplyPaymentMethod;

  /// No description provided for @supplyCashOnDelivery.
  ///
  /// In ar, this message translates to:
  /// **'نقدي عند التسليم'**
  String get supplyCashOnDelivery;

  /// No description provided for @supplyBankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get supplyBankTransfer;

  /// No description provided for @supplyCredit.
  ///
  /// In ar, this message translates to:
  /// **'آجل'**
  String get supplyCredit;

  /// No description provided for @supplyReferenceOptional.
  ///
  /// In ar, this message translates to:
  /// **'رقم المرجع (اختياري)'**
  String get supplyReferenceOptional;

  /// No description provided for @supplyPaymentRecorded.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدفعة.'**
  String get supplyPaymentRecorded;

  /// No description provided for @supplyEditInvoice.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الفاتورة'**
  String get supplyEditInvoice;

  /// No description provided for @supplyDiscountLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحسم'**
  String get supplyDiscountLabel;

  /// No description provided for @supplyTaxLabel.
  ///
  /// In ar, this message translates to:
  /// **'الضريبة'**
  String get supplyTaxLabel;

  /// No description provided for @supplyWarehouseNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة المستودع'**
  String get supplyWarehouseNote;

  /// No description provided for @supplyDueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get supplyDueDate;

  /// No description provided for @supplyInvoiceUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الفاتورة.'**
  String get supplyInvoiceUpdated;

  /// No description provided for @supplyReturnDetails.
  ///
  /// In ar, this message translates to:
  /// **'{qty} عبوات · {reason}'**
  String supplyReturnDetails(Object qty, Object reason);

  /// No description provided for @supplyAcceptReturn.
  ///
  /// In ar, this message translates to:
  /// **'قبول المرتجع'**
  String get supplyAcceptReturn;

  /// No description provided for @supplyRejectReturn.
  ///
  /// In ar, this message translates to:
  /// **'رفض المرتجع'**
  String get supplyRejectReturn;

  /// No description provided for @supplyCollectedFromPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام من الصيدلية'**
  String get supplyCollectedFromPharmacy;

  /// No description provided for @supplyCompleteReturn.
  ///
  /// In ar, this message translates to:
  /// **'إكمال المرتجع'**
  String get supplyCompleteReturn;

  /// No description provided for @supplyReturnUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المرتجع.'**
  String get supplyReturnUpdated;

  /// No description provided for @supplyCreateRecallAlert.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء تنبيه سحب'**
  String get supplyCreateRecallAlert;

  /// No description provided for @supplyRecallBatch.
  ///
  /// In ar, this message translates to:
  /// **'سحب تشغيلة دوائية'**
  String get supplyRecallBatch;

  /// No description provided for @supplySeverityLabel.
  ///
  /// In ar, this message translates to:
  /// **'درجة الخطورة'**
  String get supplySeverityLabel;

  /// No description provided for @supplySeverityLow.
  ///
  /// In ar, this message translates to:
  /// **'منخفضة'**
  String get supplySeverityLow;

  /// No description provided for @supplySeverityMedium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get supplySeverityMedium;

  /// No description provided for @supplySeverityHigh.
  ///
  /// In ar, this message translates to:
  /// **'عالية'**
  String get supplySeverityHigh;

  /// No description provided for @supplySeverityCritical.
  ///
  /// In ar, this message translates to:
  /// **'حرجة'**
  String get supplySeverityCritical;

  /// No description provided for @supplyRecallReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب السحب'**
  String get supplyRecallReason;

  /// No description provided for @supplyCreateAlertButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء التنبيه'**
  String get supplyCreateAlertButton;

  /// No description provided for @supplyRecallAlertCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء تنبيه السحب.'**
  String get supplyRecallAlertCreated;

  /// No description provided for @supplyBatchNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم التشغيلة {number}'**
  String supplyBatchNumberLabel(Object number);

  /// No description provided for @supplyAvailableShort.
  ///
  /// In ar, this message translates to:
  /// **'المتاح'**
  String get supplyAvailableShort;

  /// No description provided for @supplyExpiryShort.
  ///
  /// In ar, this message translates to:
  /// **'الانتهاء'**
  String get supplyExpiryShort;

  /// No description provided for @supplyHealthHealthy.
  ///
  /// In ar, this message translates to:
  /// **'سليم'**
  String get supplyHealthHealthy;

  /// No description provided for @supplyHealthLow.
  ///
  /// In ar, this message translates to:
  /// **'منخفض'**
  String get supplyHealthLow;

  /// No description provided for @supplyHealthExpiring.
  ///
  /// In ar, this message translates to:
  /// **'قرب الانتهاء'**
  String get supplyHealthExpiring;

  /// No description provided for @supplyHealthExpired.
  ///
  /// In ar, this message translates to:
  /// **'منتهي'**
  String get supplyHealthExpired;

  /// No description provided for @supplyStatusSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'مرسل'**
  String get supplyStatusSubmitted;

  /// No description provided for @supplyStatusAccepted.
  ///
  /// In ar, this message translates to:
  /// **'مقبول'**
  String get supplyStatusAccepted;

  /// No description provided for @supplyStatusPreparing.
  ///
  /// In ar, this message translates to:
  /// **'قيد التجهيز'**
  String get supplyStatusPreparing;

  /// No description provided for @supplyStatusReadyForDispatch.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للشحن'**
  String get supplyStatusReadyForDispatch;

  /// No description provided for @supplyStatusAssigned.
  ///
  /// In ar, this message translates to:
  /// **'مسند'**
  String get supplyStatusAssigned;

  /// No description provided for @supplyStatusLoading.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get supplyStatusLoading;

  /// No description provided for @supplyStatusOutForDelivery.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق'**
  String get supplyStatusOutForDelivery;

  /// No description provided for @supplyStatusArrived.
  ///
  /// In ar, this message translates to:
  /// **'وصل'**
  String get supplyStatusArrived;

  /// No description provided for @supplyStatusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get supplyStatusDelivered;

  /// No description provided for @supplyStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get supplyStatusRejected;

  /// No description provided for @supplyStatusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get supplyStatusPaid;

  /// No description provided for @supplyStatusPartiallyPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع جزئيًا'**
  String get supplyStatusPartiallyPaid;

  /// No description provided for @supplyStatusUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوع'**
  String get supplyStatusUnpaid;

  /// No description provided for @supplyStatusRequested.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get supplyStatusRequested;

  /// No description provided for @supplyStatusApproved.
  ///
  /// In ar, this message translates to:
  /// **'مقبول'**
  String get supplyStatusApproved;

  /// No description provided for @supplyStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get supplyStatusActive;

  /// No description provided for @supplyNextLoading.
  ///
  /// In ar, this message translates to:
  /// **'بدء التحميل'**
  String get supplyNextLoading;

  /// No description provided for @supplyNextOutForDelivery.
  ///
  /// In ar, this message translates to:
  /// **'بدء التوصيل'**
  String get supplyNextOutForDelivery;

  /// No description provided for @supplyNextArrived.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الوصول'**
  String get supplyNextArrived;

  /// No description provided for @supplyNextDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد التسليم'**
  String get supplyNextDelivered;

  /// No description provided for @supplyNextUpdate.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get supplyNextUpdate;

  /// No description provided for @adminCenterTitle.
  ///
  /// In ar, this message translates to:
  /// **'مركز الإدارة'**
  String get adminCenterTitle;

  /// No description provided for @adminCenterSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة منصة دوائي ومتابعة عملياتها'**
  String get adminCenterSubtitle;

  /// No description provided for @adminRefreshTooltip.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get adminRefreshTooltip;

  /// No description provided for @adminLocationServiceTooltip.
  ///
  /// In ar, this message translates to:
  /// **'خدمة مواقع الصيدليات'**
  String get adminLocationServiceTooltip;

  /// No description provided for @adminCannotApprovePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن الموافقة على الصيدلية. حالة الترخيص: {status}. يجب أن يكون الترخيص موثقاً أولاً.'**
  String adminCannotApprovePharmacy(Object status);

  /// No description provided for @adminLicenseCheckFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر التحقق من حالة الترخيص: {error}'**
  String adminLicenseCheckFailed(Object error);

  /// No description provided for @adminOrgReviewApproved.
  ///
  /// In ar, this message translates to:
  /// **'تمت مراجعة وثائق المنظمة واعتمادها.'**
  String get adminOrgReviewApproved;

  /// No description provided for @adminOrgReviewNeedsUpdate.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تحديث وثائق التحقق المطلوبة.'**
  String get adminOrgReviewNeedsUpdate;

  /// No description provided for @adminDeactivateAccount.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف الحساب'**
  String get adminDeactivateAccount;

  /// No description provided for @adminDeactivateReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الإيقاف'**
  String get adminDeactivateReason;

  /// No description provided for @adminDeactivateReasonHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب سببًا واضحًا لا يقل عن 10 أحرف.'**
  String get adminDeactivateReasonHint;

  /// No description provided for @adminLocationServiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'خدمة مواقع الصيدليات'**
  String get adminLocationServiceTitle;

  /// No description provided for @adminLocationServiceHealthy.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة تعمل بصورة طبيعية.'**
  String get adminLocationServiceHealthy;

  /// No description provided for @adminLocationServiceUnhealthy.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة لا تستجيب بالصورة المتوقعة.'**
  String get adminLocationServiceUnhealthy;

  /// No description provided for @adminCleanCache.
  ///
  /// In ar, this message translates to:
  /// **'تنظيف البيانات القديمة'**
  String get adminCleanCache;

  /// No description provided for @adminSectionSummary.
  ///
  /// In ar, this message translates to:
  /// **'الملخص'**
  String get adminSectionSummary;

  /// No description provided for @adminSectionApprovals.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات'**
  String get adminSectionApprovals;

  /// No description provided for @adminSectionAccounts.
  ///
  /// In ar, this message translates to:
  /// **'الحسابات'**
  String get adminSectionAccounts;

  /// No description provided for @adminSectionAds.
  ///
  /// In ar, this message translates to:
  /// **'الإعلانات'**
  String get adminSectionAds;

  /// No description provided for @adminTickerNewContent.
  ///
  /// In ar, this message translates to:
  /// **'محتوى جديد'**
  String get adminTickerNewContent;

  /// No description provided for @adminTickerEditContent.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المحتوى'**
  String get adminTickerEditContent;

  /// No description provided for @adminTickerAppearsHint.
  ///
  /// In ar, this message translates to:
  /// **'سيظهر هذا المحتوى في الصفحة الرئيسية للمستخدمين.'**
  String get adminTickerAppearsHint;

  /// No description provided for @adminAnnouncement.
  ///
  /// In ar, this message translates to:
  /// **'إعلان عام'**
  String get adminAnnouncement;

  /// No description provided for @adminDutyPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية مناوبة'**
  String get adminDutyPharmacy;

  /// No description provided for @adminDutyPharmacyLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصيدلية المناوبة'**
  String get adminDutyPharmacyLabel;

  /// No description provided for @adminChoosePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'اختر الصيدلية'**
  String get adminChoosePharmacy;

  /// No description provided for @adminTitleLabel.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get adminTitleLabel;

  /// No description provided for @adminEnterTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوان المحتوى'**
  String get adminEnterTitleHint;

  /// No description provided for @adminVisibleTextLabel.
  ///
  /// In ar, this message translates to:
  /// **'النص الظاهر للمستخدم'**
  String get adminVisibleTextLabel;

  /// No description provided for @adminEnterTextHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل النص المراد إظهاره'**
  String get adminEnterTextHint;

  /// No description provided for @adminPublishContent.
  ///
  /// In ar, this message translates to:
  /// **'نشر المحتوى'**
  String get adminPublishContent;

  /// No description provided for @adminVisibleNow.
  ///
  /// In ar, this message translates to:
  /// **'ظاهر حاليًا للمستخدمين'**
  String get adminVisibleNow;

  /// No description provided for @adminSavedUnpublished.
  ///
  /// In ar, this message translates to:
  /// **'محفوظ دون نشر'**
  String get adminSavedUnpublished;

  /// No description provided for @adminSaveContent.
  ///
  /// In ar, this message translates to:
  /// **'حفظ المحتوى'**
  String get adminSaveContent;

  /// No description provided for @adminLoadingIndicators.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل المؤشرات...'**
  String get adminLoadingIndicators;

  /// No description provided for @adminUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get adminUsers;

  /// No description provided for @adminActiveAccounts.
  ///
  /// In ar, this message translates to:
  /// **'حسابات نشطة'**
  String get adminActiveAccounts;

  /// No description provided for @adminPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات'**
  String get adminPharmacies;

  /// No description provided for @adminPendingPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'صيدليات معلقة'**
  String get adminPendingPharmacies;

  /// No description provided for @adminOrganizations.
  ///
  /// In ar, this message translates to:
  /// **'المنظمات'**
  String get adminOrganizations;

  /// No description provided for @adminWarehouses.
  ///
  /// In ar, this message translates to:
  /// **'المستودعات'**
  String get adminWarehouses;

  /// No description provided for @adminPendingWarehouses.
  ///
  /// In ar, this message translates to:
  /// **'مستودعات معلقة'**
  String get adminPendingWarehouses;

  /// No description provided for @adminOrganizationVerifications.
  ///
  /// In ar, this message translates to:
  /// **'تحقق منظمات'**
  String get adminOrganizationVerifications;

  /// No description provided for @adminMedicineRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الأدوية'**
  String get adminMedicineRequests;

  /// No description provided for @adminDonations.
  ///
  /// In ar, this message translates to:
  /// **'تبرعات'**
  String get adminDonations;

  /// No description provided for @adminOverviewEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'المشهد العام'**
  String get adminOverviewEyebrow;

  /// No description provided for @adminPlatformIndicators.
  ///
  /// In ar, this message translates to:
  /// **'مؤشرات المنصة'**
  String get adminPlatformIndicators;

  /// No description provided for @adminOverviewSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأرقام الأساسية وحالات الاعتماد التي تتطلب المتابعة.'**
  String get adminOverviewSubtitle;

  /// No description provided for @adminHeroPulse.
  ///
  /// In ar, this message translates to:
  /// **'نبض منصة دوائي'**
  String get adminHeroPulse;

  /// No description provided for @adminHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نظرة موحدة على الحسابات والجهات والخدمات'**
  String get adminHeroSubtitle;

  /// No description provided for @adminNeedsDecision.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج قرارًا'**
  String get adminNeedsDecision;

  /// No description provided for @adminActiveAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب نشط'**
  String get adminActiveAccount;

  /// No description provided for @adminPharmacyPoints.
  ///
  /// In ar, this message translates to:
  /// **'نقاط دوائية'**
  String get adminPharmacyPoints;

  /// No description provided for @adminLicenseVerifiedMsg.
  ///
  /// In ar, this message translates to:
  /// **'الترخيص موثق، يمكنك الموافقة على الصيدلية'**
  String get adminLicenseVerifiedMsg;

  /// No description provided for @adminLicenseManualReviewMsg.
  ///
  /// In ar, this message translates to:
  /// **'الترخيص يحتاج إلى مراجعة يدوية. يجب أن يكون الترخيص موثقاً أولاً قبل الموافقة على الصيدلية.'**
  String get adminLicenseManualReviewMsg;

  /// No description provided for @adminLicenseProcessingMsg.
  ///
  /// In ar, this message translates to:
  /// **'الترخيص قيد المعالجة.'**
  String get adminLicenseProcessingMsg;

  /// No description provided for @adminLicenseDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل ترخيص الصيدلية'**
  String get adminLicenseDetailsTitle;

  /// No description provided for @adminLicenseNameInDocument.
  ///
  /// In ar, this message translates to:
  /// **'الاسم في الوثيقة'**
  String get adminLicenseNameInDocument;

  /// No description provided for @adminMatchScore.
  ///
  /// In ar, this message translates to:
  /// **'درجة التطابق'**
  String get adminMatchScore;

  /// No description provided for @adminRejectionReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الرفض'**
  String get adminRejectionReason;

  /// No description provided for @adminReadFailure.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة القراءة'**
  String get adminReadFailure;

  /// No description provided for @adminViewDocument.
  ///
  /// In ar, this message translates to:
  /// **'عرض الوثيقة'**
  String get adminViewDocument;

  /// No description provided for @unexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع.'**
  String get unexpectedError;

  /// No description provided for @adminApprovalDecisions.
  ///
  /// In ar, this message translates to:
  /// **'قرارات الاعتماد'**
  String get adminApprovalDecisions;

  /// No description provided for @adminPendingYourReview.
  ///
  /// In ar, this message translates to:
  /// **'طلبات تحتاج مراجعتك'**
  String get adminPendingYourReview;

  /// No description provided for @adminApprovalSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من بيانات الجهة قبل منحها صلاحية العمل على المنصة.'**
  String get adminApprovalSubtitle;

  /// No description provided for @adminNoPendingRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات معلقة ضمن هذا القسم.'**
  String get adminNoPendingRequests;

  /// No description provided for @adminApprovePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الصيدلية'**
  String get adminApprovePharmacy;

  /// No description provided for @adminRejectPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'رفض الصيدلية'**
  String get adminRejectPharmacy;

  /// No description provided for @adminOwner.
  ///
  /// In ar, this message translates to:
  /// **'المالك'**
  String get adminOwner;

  /// No description provided for @adminVerificationDocsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{name} · {count} وثائق'**
  String adminVerificationDocsSubtitle(Object name, Object count);

  /// No description provided for @adminVerificationStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التحقق'**
  String get adminVerificationStatus;

  /// No description provided for @adminVerificationDocsLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوثائق'**
  String get adminVerificationDocsLabel;

  /// No description provided for @adminApproveWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد المستودع'**
  String get adminApproveWarehouse;

  /// No description provided for @adminRejectWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'رفض المستودع'**
  String get adminRejectWarehouse;

  /// No description provided for @adminMinOrderLimit.
  ///
  /// In ar, this message translates to:
  /// **'حد الطلب الأدنى'**
  String get adminMinOrderLimit;

  /// No description provided for @adminCurrencySuffix.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get adminCurrencySuffix;

  /// No description provided for @adminDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل'**
  String get adminDeliveryFee;

  /// No description provided for @adminMedicineBatches.
  ///
  /// In ar, this message translates to:
  /// **'دفعات الأدوية'**
  String get adminMedicineBatches;

  /// No description provided for @adminRepresentatives.
  ///
  /// In ar, this message translates to:
  /// **'المندوبين'**
  String get adminRepresentatives;

  /// No description provided for @adminAccountsGuide.
  ///
  /// In ar, this message translates to:
  /// **'دليل الحسابات'**
  String get adminAccountsGuide;

  /// No description provided for @adminPlatformUsers.
  ///
  /// In ar, this message translates to:
  /// **'مستخدمو المنصة'**
  String get adminPlatformUsers;

  /// No description provided for @adminAccountsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الحسابات وراجع حالتها ودورها.'**
  String get adminAccountsSubtitle;

  /// No description provided for @adminSearchByNameOrEmail.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بالاسم أو البريد الإلكتروني'**
  String get adminSearchByNameOrEmail;

  /// No description provided for @adminLoadingAccounts.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل الحسابات...'**
  String get adminLoadingAccounts;

  /// No description provided for @adminNoResultsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر كلمات البحث أو اختر دورًا آخر.'**
  String get adminNoResultsSubtitle;

  /// No description provided for @adminLiveContent.
  ///
  /// In ar, this message translates to:
  /// **'المحتوى المباشر'**
  String get adminLiveContent;

  /// No description provided for @adminHomeTicker.
  ///
  /// In ar, this message translates to:
  /// **'شريط الصفحة الرئيسية'**
  String get adminHomeTicker;

  /// No description provided for @adminTickerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدر الإعلانات العامة والصيدليات المناوبة الظاهرة للمستخدمين.'**
  String get adminTickerSubtitle;

  /// No description provided for @adminAddAd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إعلان'**
  String get adminAddAd;

  /// No description provided for @adminLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get adminLoading;

  /// No description provided for @adminNoPublishedContent.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد محتوى منشور'**
  String get adminNoPublishedContent;

  /// No description provided for @adminNoContentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أضف إعلانًا أو صيدلية مناوبة لتظهر في الرئيسية.'**
  String get adminNoContentSubtitle;

  /// No description provided for @adminReviewLicense.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الترخيص'**
  String get adminReviewLicense;

  /// No description provided for @adminApprove.
  ///
  /// In ar, this message translates to:
  /// **'اعتماد'**
  String get adminApprove;

  /// No description provided for @adminWriteReasonHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب سبب القرار (10 أحرف على الأقل)'**
  String get adminWriteReasonHint;

  /// No description provided for @adminReasonExample.
  ///
  /// In ar, this message translates to:
  /// **'مثال: تمت مراجعة البيانات والوثائق والاعتماد مطابق للمعايير المطلوبة.'**
  String get adminReasonExample;

  /// No description provided for @adminActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get adminActive;

  /// No description provided for @adminSuspended.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get adminSuspended;

  /// No description provided for @adminRole.
  ///
  /// In ar, this message translates to:
  /// **'الدور'**
  String get adminRole;

  /// No description provided for @adminLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get adminLocation;

  /// No description provided for @adminAccreditationNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الاعتماد'**
  String get adminAccreditationNumber;

  /// No description provided for @adminSuspendedAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب موقوف'**
  String get adminSuspendedAccount;

  /// No description provided for @adminAdditionalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية'**
  String get adminAdditionalInfo;

  /// No description provided for @adminPublished.
  ///
  /// In ar, this message translates to:
  /// **'منشور'**
  String get adminPublished;

  /// No description provided for @adminStopped.
  ///
  /// In ar, this message translates to:
  /// **'متوقف'**
  String get adminStopped;

  /// No description provided for @adminRoleAdmin.
  ///
  /// In ar, this message translates to:
  /// **'إدارة'**
  String get adminRoleAdmin;

  /// No description provided for @adminRolePharmacy.
  ///
  /// In ar, this message translates to:
  /// **'صيدلية'**
  String get adminRolePharmacy;

  /// No description provided for @adminRoleOrganization.
  ///
  /// In ar, this message translates to:
  /// **'منظمة'**
  String get adminRoleOrganization;

  /// No description provided for @adminRoleWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'مستودع'**
  String get adminRoleWarehouse;

  /// No description provided for @adminRoleRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'مندوب'**
  String get adminRoleRepresentative;

  /// No description provided for @adminRoleUser.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get adminRoleUser;

  /// No description provided for @warehouseHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'توريد منظم من المخزون للتسليم'**
  String get warehouseHeroTitle;

  /// No description provided for @warehouseHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راقب التشغيلات والطلبات والشحنات قبل أن تتحول إلى تأخير.'**
  String get warehouseHeroSubtitle;

  /// No description provided for @warehousePendingOrders.
  ///
  /// In ar, this message translates to:
  /// **'{count} طلبات توريد بانتظارك'**
  String warehousePendingOrders(Object count);

  /// No description provided for @warehouseOrdersUpToDate.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات محدثة'**
  String get warehouseOrdersUpToDate;

  /// No description provided for @warehouseOpsStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة التشغيل'**
  String get warehouseOpsStatus;

  /// No description provided for @warehouseOpsStatusSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مؤشرات حية من مخزون المستودع'**
  String get warehouseOpsStatusSubtitle;

  /// No description provided for @warehouseInventoryValueTitle.
  ///
  /// In ar, this message translates to:
  /// **'قيمة المخزون الحالية'**
  String get warehouseInventoryValueTitle;

  /// No description provided for @warehouseInventoryValueMessage.
  ///
  /// In ar, this message translates to:
  /// **'{money} ل.س ضمن التشغيلات النشطة'**
  String warehouseInventoryValueMessage(Object money);

  /// No description provided for @warehouseQuickOps.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل سريع'**
  String get warehouseQuickOps;

  /// No description provided for @warehouseQuickOpsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختصارات لأهم أعمال المستودع'**
  String get warehouseQuickOpsSubtitle;

  /// No description provided for @warehouseManage.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المستودع'**
  String get warehouseManage;

  /// No description provided for @warehouseManageSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التشغيلات والمخزون'**
  String get warehouseManageSubtitle;

  /// No description provided for @warehouseSupplyOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات التوريد'**
  String get warehouseSupplyOrders;

  /// No description provided for @warehouseSupplyOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قبول وتجهيز وإسناد الطلبات'**
  String get warehouseSupplyOrdersSubtitle;

  /// No description provided for @warehouseShipping.
  ///
  /// In ar, this message translates to:
  /// **'الشحن والتوصيل'**
  String get warehouseShipping;

  /// No description provided for @warehouseShippingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'المندوبون وحالة الشحنات'**
  String get warehouseShippingSubtitle;

  /// No description provided for @warehouseInventoryAnalysis.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المخزون'**
  String get warehouseInventoryAnalysis;

  /// No description provided for @warehouseInventoryAnalysisSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'توقع النفاد ودعم قرار التوريد'**
  String get warehouseInventoryAnalysisSubtitle;

  /// No description provided for @warehouseAlertsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات المخزون'**
  String get warehouseAlertsTitle;

  /// No description provided for @warehouseAlertsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التشغيلات التي تحتاج تدخلاً قريباً'**
  String get warehouseAlertsSubtitle;

  /// No description provided for @warehouseBatchAlert.
  ///
  /// In ar, this message translates to:
  /// **'تشغيلة {batchNumber} · {qty} عبوات متاحة'**
  String warehouseBatchAlert(Object batchNumber, Object qty);

  /// No description provided for @warehouseRecentOrders.
  ///
  /// In ar, this message translates to:
  /// **'أحدث الطلبات'**
  String get warehouseRecentOrders;

  /// No description provided for @warehouseRecentOrdersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر طلبات التوريد الواردة للمستودع'**
  String get warehouseRecentOrdersSubtitle;

  /// No description provided for @warehouseOrderSummary.
  ///
  /// In ar, this message translates to:
  /// **'{code} · {status} · {amount} ل.س'**
  String warehouseOrderSummary(Object code, Object status, Object amount);

  /// No description provided for @warehouseCurrencySuffix.
  ///
  /// In ar, this message translates to:
  /// **'ل.س'**
  String get warehouseCurrencySuffix;

  /// No description provided for @representativeLoadingSchedule.
  ///
  /// In ar, this message translates to:
  /// **'نجهّز جدول التوصيل...'**
  String get representativeLoadingSchedule;

  /// No description provided for @representativeReadyForNextTask.
  ///
  /// In ar, this message translates to:
  /// **'جاهز لمهمتك القادمة'**
  String get representativeReadyForNextTask;

  /// No description provided for @representativeCurrentTaskTo.
  ///
  /// In ar, this message translates to:
  /// **'مهمتك الحالية إلى {pharmacyName}'**
  String representativeCurrentTaskTo(Object pharmacyName);

  /// No description provided for @representativeNoTaskSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا أي شحنة جديدة يسندها المستودع إليك.'**
  String get representativeNoTaskSubtitle;

  /// No description provided for @representativeTaskLocation.
  ///
  /// In ar, this message translates to:
  /// **'{area}، {city} · {status}'**
  String representativeTaskLocation(Object area, Object city, Object status);

  /// No description provided for @representativeNoActiveTask.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهمة نشطة'**
  String get representativeNoActiveTask;

  /// No description provided for @representativeActiveTasksCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مهام نشطة'**
  String representativeActiveTasksCount(Object count);

  /// No description provided for @representativeTripsSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الرحلات'**
  String get representativeTripsSummary;

  /// No description provided for @representativeTripsSummarySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة الشحنات المسندة إلى حسابك'**
  String get representativeTripsSummarySubtitle;

  /// No description provided for @representativeTotalTasks.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المهام'**
  String get representativeTotalTasks;

  /// No description provided for @representativeActiveTasks.
  ///
  /// In ar, this message translates to:
  /// **'مهام نشطة'**
  String get representativeActiveTasks;

  /// No description provided for @representativeFailedTasks.
  ///
  /// In ar, this message translates to:
  /// **'متعثرة'**
  String get representativeFailedTasks;

  /// No description provided for @representativeQuickAccess.
  ///
  /// In ar, this message translates to:
  /// **'وصول سريع'**
  String get representativeQuickAccess;

  /// No description provided for @representativeQuickAccessSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختصارات لمهام المندوب'**
  String get representativeQuickAccessSubtitle;

  /// No description provided for @representativeDeliveryTasksSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'العناوين وتحديث حالة الشحنة'**
  String get representativeDeliveryTasksSubtitle;

  /// No description provided for @representativeNotificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التكليفات وآخر تحديثات المستودع'**
  String get representativeNotificationsSubtitle;

  /// No description provided for @representativeActiveTasksTitle.
  ///
  /// In ar, this message translates to:
  /// **'المهام النشطة'**
  String get representativeActiveTasksTitle;

  /// No description provided for @representativeNoActionRequired.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد رحلة تتطلب إجراء الآن'**
  String get representativeNoActionRequired;

  /// No description provided for @representativeStartOldest.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بالأقدم وحدّث الحالة عند كل مرحلة'**
  String get representativeStartOldest;

  /// No description provided for @representativeAvailableForNewTask.
  ///
  /// In ar, this message translates to:
  /// **'أنت متاح لمهمة جديدة'**
  String get representativeAvailableForNewTask;

  /// No description provided for @representativeAvailableForNewTaskSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عند إسناد شحنة ستصلك عبر الإشعارات وتظهر في هذه الصفحة.'**
  String get representativeAvailableForNewTaskSubtitle;

  /// No description provided for @representativeDeliveryCardSummary.
  ///
  /// In ar, this message translates to:
  /// **'{code} · {area}، {city} · {status}'**
  String representativeDeliveryCardSummary(
    Object code,
    Object area,
    Object city,
    Object status,
  );

  /// No description provided for @representativeStatusFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر التسليم'**
  String get representativeStatusFailed;

  /// No description provided for @representativeStatusReturned.
  ///
  /// In ar, this message translates to:
  /// **'أُعيدت للمستودع'**
  String get representativeStatusReturned;

  /// No description provided for @adminHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'منصة واضحة تحت إدارتك'**
  String get adminHeroTitle;

  /// No description provided for @adminHeroDescription.
  ///
  /// In ar, this message translates to:
  /// **'تابع الاعتمادات والحسابات ونشاط المنصة من نقطة واحدة.'**
  String get adminHeroDescription;

  /// No description provided for @adminPendingReviewCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عناصر بانتظار المراجعة'**
  String adminPendingReviewCount(Object count);

  /// No description provided for @adminReviewsUpToDate.
  ///
  /// In ar, this message translates to:
  /// **'جميع المراجعات محدثة'**
  String get adminReviewsUpToDate;

  /// No description provided for @adminOverviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظرة المنصة'**
  String get adminOverviewTitle;

  /// No description provided for @adminOverviewLiveSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إحصاءات مباشرة من قاعدة البيانات'**
  String get adminOverviewLiveSubtitle;

  /// No description provided for @adminApprovedShort.
  ///
  /// In ar, this message translates to:
  /// **'معتمد'**
  String get adminApprovedShort;

  /// No description provided for @adminControlCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز التحكم'**
  String get adminControlCenter;

  /// No description provided for @adminControlCenterSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'انتقل مباشرة إلى العملية المطلوبة'**
  String get adminControlCenterSubtitle;

  /// No description provided for @adminApprovalsActionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'صيدليات ومنظمات ومستودعات'**
  String get adminApprovalsActionSubtitle;

  /// No description provided for @adminAccountsActionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الحالة والصلاحية'**
  String get adminAccountsActionSubtitle;

  /// No description provided for @adminPlatformBar.
  ///
  /// In ar, this message translates to:
  /// **'شريط المنصة'**
  String get adminPlatformBar;

  /// No description provided for @adminPlatformBarSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعلانات والصيدليات المناوبة'**
  String get adminPlatformBarSubtitle;

  /// No description provided for @adminMedicineGuide.
  ///
  /// In ar, this message translates to:
  /// **'دليل الأدوية'**
  String get adminMedicineGuide;

  /// No description provided for @adminMedicineGuideSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة وإضافة بيانات الدواء'**
  String get adminMedicineGuideSubtitle;

  /// No description provided for @adminOpenOperations.
  ///
  /// In ar, this message translates to:
  /// **'العمليات المفتوحة'**
  String get adminOpenOperations;

  /// No description provided for @adminOpenOperationsMessage.
  ///
  /// In ar, this message translates to:
  /// **'{medicineRequests} طلب دواء معلق · {assistanceRequests} طلب مساعدة مفتوح · {donationOffers} عروض تبرع'**
  String adminOpenOperationsMessage(
    Object medicineRequests,
    Object assistanceRequests,
    Object donationOffers,
  );

  /// No description provided for @adminAiServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات المعالجة الذكية'**
  String get adminAiServices;

  /// No description provided for @adminRefreshStatus.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الحالة'**
  String get adminRefreshStatus;

  /// No description provided for @adminAiHealthReadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر قراءة حالة الخدمات حالياً.'**
  String get adminAiHealthReadFailed;

  /// No description provided for @adminAiDrugSearch.
  ///
  /// In ar, this message translates to:
  /// **'البحث الدوائي'**
  String get adminAiDrugSearch;

  /// No description provided for @adminAiWorking.
  ///
  /// In ar, this message translates to:
  /// **'يعمل'**
  String get adminAiWorking;

  /// No description provided for @dashboardWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا، {name}'**
  String dashboardWelcome(Object name);

  /// No description provided for @dashboardUserSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل ما تحتاجه لصحتك ودوائك في مكان واحد.'**
  String get dashboardUserSubtitle;

  /// No description provided for @dashboardPharmacySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع عمل الصيدلية والطلبات بسهولة.'**
  String get dashboardPharmacySubtitle;

  /// No description provided for @dashboardOrganizationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدر المبادرات وطلبات المساعدة بوضوح.'**
  String get dashboardOrganizationSubtitle;

  /// No description provided for @dashboardAdminSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'راقب المنصة وأدر العمليات الأساسية.'**
  String get dashboardAdminSubtitle;

  /// No description provided for @dashboardWarehouseSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدر المخزون والطلبات والتوزيع من مكان واحد.'**
  String get dashboardWarehouseSubtitle;

  /// No description provided for @dashboardRepresentativeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع الشحنات المسندة إليك خطوة بخطوة.'**
  String get dashboardRepresentativeSubtitle;

  /// No description provided for @dashboardBannerUser.
  ///
  /// In ar, this message translates to:
  /// **'صحتك تبدأ بخطوة'**
  String get dashboardBannerUser;

  /// No description provided for @dashboardBannerPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'خدمة أسرع للمستخدمين'**
  String get dashboardBannerPharmacy;

  /// No description provided for @dashboardBannerOrganization.
  ///
  /// In ar, this message translates to:
  /// **'أثر يصل لمن يحتاجه'**
  String get dashboardBannerOrganization;

  /// No description provided for @dashboardBannerAdmin.
  ///
  /// In ar, this message translates to:
  /// **'نظرة موحدة على المنصة'**
  String get dashboardBannerAdmin;

  /// No description provided for @dashboardBannerWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'توريد منظم وموثوق'**
  String get dashboardBannerWarehouse;

  /// No description provided for @dashboardBannerRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'كل شحنة في موعدها'**
  String get dashboardBannerRepresentative;

  /// No description provided for @dashboardBannerDescUser.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الدواء واعثر على أقرب صيدلية بثقة.'**
  String get dashboardBannerDescUser;

  /// No description provided for @dashboardBannerDescPharmacy.
  ///
  /// In ar, this message translates to:
  /// **'حدّث المخزون وتابع الطلبات من لوحة واحدة.'**
  String get dashboardBannerDescPharmacy;

  /// No description provided for @dashboardBannerDescOrganization.
  ///
  /// In ar, this message translates to:
  /// **'تابع الحملات والتبرعات وطلبات المساعدة.'**
  String get dashboardBannerDescOrganization;

  /// No description provided for @dashboardBannerDescAdmin.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات والحسابات والإعلانات بين يديك.'**
  String get dashboardBannerDescAdmin;

  /// No description provided for @dashboardBannerDescWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'تابع التشغيلات والطلبات والشحنات والمدفوعات.'**
  String get dashboardBannerDescWarehouse;

  /// No description provided for @dashboardBannerDescRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'حدّث حالة التوصيل حتى استلام الصيدلية.'**
  String get dashboardBannerDescRepresentative;

  /// No description provided for @dashboardServicesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} خدمات'**
  String dashboardServicesCount(Object count);

  /// No description provided for @homeShellSupply.
  ///
  /// In ar, this message translates to:
  /// **'التوريد'**
  String get homeShellSupply;

  /// No description provided for @homeShellAdmin.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة'**
  String get homeShellAdmin;

  /// No description provided for @homeShellMedicines.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get homeShellMedicines;

  /// No description provided for @homeShellOrgManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المنظمة'**
  String get homeShellOrgManagement;

  /// No description provided for @homeShellWarehouse.
  ///
  /// In ar, this message translates to:
  /// **'المستودع'**
  String get homeShellWarehouse;

  /// No description provided for @homeShellMyTasks.
  ///
  /// In ar, this message translates to:
  /// **'مهامي'**
  String get homeShellMyTasks;

  /// No description provided for @modulesTitle.
  ///
  /// In ar, this message translates to:
  /// **'خدماتك'**
  String get modulesTitle;

  /// No description provided for @modulesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل ما تحتاجه في مكان واضح وسريع'**
  String get modulesSubtitle;

  /// No description provided for @moduleSearchMedicine.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن دواء'**
  String get moduleSearchMedicine;

  /// No description provided for @moduleSearchMedicineDesc.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في الصيدليات القريبة'**
  String get moduleSearchMedicineDesc;

  /// No description provided for @moduleNearbyPharmacies.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات القريبة'**
  String get moduleNearbyPharmacies;

  /// No description provided for @moduleNearbyPharmaciesDesc.
  ///
  /// In ar, this message translates to:
  /// **'اعرض الأقرب والمسار إليها'**
  String get moduleNearbyPharmaciesDesc;

  /// No description provided for @moduleMyPrescriptions.
  ///
  /// In ar, this message translates to:
  /// **'وصفاتي'**
  String get moduleMyPrescriptions;

  /// No description provided for @moduleMyPrescriptionsDesc.
  ///
  /// In ar, this message translates to:
  /// **'حلّل الوصفة وتابع الحجز'**
  String get moduleMyPrescriptionsDesc;

  /// No description provided for @moduleMyRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get moduleMyRequests;

  /// No description provided for @moduleMyRequestsDesc.
  ///
  /// In ar, this message translates to:
  /// **'تابع طلبات توفر الأدوية'**
  String get moduleMyRequestsDesc;

  /// No description provided for @moduleMyHealthProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الصحي'**
  String get moduleMyHealthProfile;

  /// No description provided for @moduleMyHealthProfileDesc.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك الصحية والبطاقة'**
  String get moduleMyHealthProfileDesc;

  /// No description provided for @moduleDonationsDesc.
  ///
  /// In ar, this message translates to:
  /// **'عروض الدواء وطلبات المساعدة'**
  String get moduleDonationsDesc;

  /// No description provided for @moduleOrganizations.
  ///
  /// In ar, this message translates to:
  /// **'المنظمات'**
  String get moduleOrganizations;

  /// No description provided for @moduleOrganizationsDesc.
  ///
  /// In ar, this message translates to:
  /// **'الحملات والمنظمات المعتمدة'**
  String get moduleOrganizationsDesc;

  /// No description provided for @modulePharmacyAssistant.
  ///
  /// In ar, this message translates to:
  /// **'المساعد الدوائي'**
  String get modulePharmacyAssistant;

  /// No description provided for @modulePharmacyAssistantDesc.
  ///
  /// In ar, this message translates to:
  /// **'مساعدة سريعة ومعلومات موثوقة'**
  String get modulePharmacyAssistantDesc;

  /// No description provided for @moduleMedicineAlternatives.
  ///
  /// In ar, this message translates to:
  /// **'البدائل الدوائية'**
  String get moduleMedicineAlternatives;

  /// No description provided for @moduleMedicineAlternativesDesc.
  ///
  /// In ar, this message translates to:
  /// **'اعرض خيارات مشابهة ومعلومات المقارنة'**
  String get moduleMedicineAlternativesDesc;

  /// No description provided for @moduleInventoryDesc.
  ///
  /// In ar, this message translates to:
  /// **'الكميات والأسعار والتوفر'**
  String get moduleInventoryDesc;

  /// No description provided for @moduleUserRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات المستخدمين'**
  String get moduleUserRequests;

  /// No description provided for @moduleUserRequestsDesc.
  ///
  /// In ar, this message translates to:
  /// **'راجع الطلبات وأرسل الرد'**
  String get moduleUserRequestsDesc;

  /// No description provided for @modulePrescriptionOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الوصفات'**
  String get modulePrescriptionOrders;

  /// No description provided for @modulePrescriptionOrdersDesc.
  ///
  /// In ar, this message translates to:
  /// **'جهّز الحجوزات وتابع حالتها'**
  String get modulePrescriptionOrdersDesc;

  /// No description provided for @modulePharmacyLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقع الصيدلية'**
  String get modulePharmacyLocation;

  /// No description provided for @modulePharmacyLocationDesc.
  ///
  /// In ar, this message translates to:
  /// **'الموقع والبيانات العامة'**
  String get modulePharmacyLocationDesc;

  /// No description provided for @moduleWorkingHoursDesc.
  ///
  /// In ar, this message translates to:
  /// **'أوقات الدوام وحالة الفتح'**
  String get moduleWorkingHoursDesc;

  /// No description provided for @moduleMedicineCatalog.
  ///
  /// In ar, this message translates to:
  /// **'دليل الأدوية'**
  String get moduleMedicineCatalog;

  /// No description provided for @moduleMedicineCatalogDesc.
  ///
  /// In ar, this message translates to:
  /// **'اختر الأدوية لإضافتها للمخزون'**
  String get moduleMedicineCatalogDesc;

  /// No description provided for @moduleMedicineCatalogAdminDesc.
  ///
  /// In ar, this message translates to:
  /// **'إدارة بيانات الأدوية'**
  String get moduleMedicineCatalogAdminDesc;

  /// No description provided for @moduleDonationVerification.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من التبرعات'**
  String get moduleDonationVerification;

  /// No description provided for @moduleDonationVerificationDesc.
  ///
  /// In ar, this message translates to:
  /// **'فحص العبوات واعتماد استلامها'**
  String get moduleDonationVerificationDesc;

  /// No description provided for @moduleSupplyChain.
  ///
  /// In ar, this message translates to:
  /// **'توريد الصيدلية'**
  String get moduleSupplyChain;

  /// No description provided for @moduleSupplyChainDesc.
  ///
  /// In ar, this message translates to:
  /// **'المستودعات والطلبات واحتياج المخزون'**
  String get moduleSupplyChainDesc;

  /// No description provided for @moduleInventoryAnalysis.
  ///
  /// In ar, this message translates to:
  /// **'تحليل المخزون'**
  String get moduleInventoryAnalysis;

  /// No description provided for @moduleInventoryAnalysisDesc.
  ///
  /// In ar, this message translates to:
  /// **'بدائل الأدوية وتوقع الاحتياج القادم'**
  String get moduleInventoryAnalysisDesc;

  /// No description provided for @moduleInventoryAnalysisWarehouseDesc.
  ///
  /// In ar, this message translates to:
  /// **'توقع النفاد وتخطيط إعادة الطلب'**
  String get moduleInventoryAnalysisWarehouseDesc;

  /// No description provided for @moduleCampaignsDesc.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ الحملات وتابع حالتها'**
  String get moduleCampaignsDesc;

  /// No description provided for @moduleAssistanceDesc.
  ///
  /// In ar, this message translates to:
  /// **'تابع الطلبات وحدّث حالتها'**
  String get moduleAssistanceDesc;

  /// No description provided for @moduleApprovals.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات'**
  String get moduleApprovals;

  /// No description provided for @moduleApprovalsDesc.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات والمنظمات المعلقة'**
  String get moduleApprovalsDesc;

  /// No description provided for @moduleAccounts.
  ///
  /// In ar, this message translates to:
  /// **'الحسابات'**
  String get moduleAccounts;

  /// No description provided for @moduleAccountsDesc.
  ///
  /// In ar, this message translates to:
  /// **'عرض الحسابات وإدارة حالتها'**
  String get moduleAccountsDesc;

  /// No description provided for @moduleHomeTicker.
  ///
  /// In ar, this message translates to:
  /// **'شريط الإعلانات'**
  String get moduleHomeTicker;

  /// No description provided for @moduleHomeTickerDesc.
  ///
  /// In ar, this message translates to:
  /// **'الإعلانات والصيدليات المناوبة'**
  String get moduleHomeTickerDesc;

  /// No description provided for @moduleAnalysisServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات التحليل'**
  String get moduleAnalysisServices;

  /// No description provided for @moduleAnalysisServicesDesc.
  ///
  /// In ar, this message translates to:
  /// **'اختبار البدائل وتوقع نفاد المخزون'**
  String get moduleAnalysisServicesDesc;

  /// No description provided for @moduleWarehouseManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المستودع'**
  String get moduleWarehouseManagement;

  /// No description provided for @moduleWarehouseManagementDesc.
  ///
  /// In ar, this message translates to:
  /// **'المخزون والطلبات والشحنات والفواتير'**
  String get moduleWarehouseManagementDesc;

  /// No description provided for @moduleDeliveryTasks.
  ///
  /// In ar, this message translates to:
  /// **'مهام التوصيل'**
  String get moduleDeliveryTasks;

  /// No description provided for @moduleDeliveryTasksDesc.
  ///
  /// In ar, this message translates to:
  /// **'تابع الشحنات المسندة وحدّث حالتها'**
  String get moduleDeliveryTasksDesc;

  /// No description provided for @errorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الاتصال، حاول مجددًا.'**
  String get errorTimeout;

  /// No description provided for @errorConnection.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بالخادم. تحقق من الشبكة وتشغيل الخدمة.'**
  String get errorConnection;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إكمال العملية حاليًا.'**
  String get errorGeneric;

  /// No description provided for @errorLocationRequired.
  ///
  /// In ar, this message translates to:
  /// **'حدد موقعك أولًا لعرض الصيدليات القريبة.'**
  String get errorLocationRequired;

  /// No description provided for @errorLocationCoordinates.
  ///
  /// In ar, this message translates to:
  /// **'يجب إدخال خط العرض وخط الطول معًا.'**
  String get errorLocationCoordinates;

  /// No description provided for @errorAwaitingApproval.
  ///
  /// In ar, this message translates to:
  /// **'حسابك بانتظار موافقة الإدارة.'**
  String get errorAwaitingApproval;

  /// No description provided for @errorAlreadyApproved.
  ///
  /// In ar, this message translates to:
  /// **'تم الاعتماد مسبقًا.'**
  String get errorAlreadyApproved;

  /// No description provided for @errorAlreadyRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الطلب مسبقًا.'**
  String get errorAlreadyRejected;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'العنصر غير موجود.'**
  String get errorNotFound;

  /// No description provided for @errorAlreadyTaken.
  ///
  /// In ar, this message translates to:
  /// **'القيمة مستخدمة مسبقًا.'**
  String get errorAlreadyTaken;

  /// No description provided for @errorLocationServiceDisabled.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع متوقفة. فعّلها من إعدادات الجهاز ثم حاول مجددًا.'**
  String get errorLocationServiceDisabled;

  /// No description provided for @errorLocationPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم السماح بالوصول إلى الموقع.'**
  String get errorLocationPermissionDenied;

  /// No description provided for @errorLocationPermissionForever.
  ///
  /// In ar, this message translates to:
  /// **'إذن الموقع موقوف لهذا التطبيق. يمكنك تفعيله من إعدادات الجهاز.'**
  String get errorLocationPermissionForever;

  /// No description provided for @errorLoginResponseIncomplete.
  ///
  /// In ar, this message translates to:
  /// **'استجابة تسجيل الدخول غير مكتملة.'**
  String get errorLoginResponseIncomplete;

  /// No description provided for @errorSessionReadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر قراءة بيانات الجلسة.'**
  String get errorSessionReadFailed;

  /// No description provided for @errorRegisterResponseIncomplete.
  ///
  /// In ar, this message translates to:
  /// **'استجابة إنشاء الحساب غير مكتملة.'**
  String get errorRegisterResponseIncomplete;

  /// No description provided for @errorNewAccountReadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر قراءة بيانات الحساب الجديد.'**
  String get errorNewAccountReadFailed;

  /// No description provided for @errorInvalidListResponse.
  ///
  /// In ar, this message translates to:
  /// **'استجابة القائمة من الخادم غير صالحة.'**
  String get errorInvalidListResponse;

  /// No description provided for @adminCacheCleared.
  ///
  /// In ar, this message translates to:
  /// **'تم تنظيف بيانات المواقع القديمة.'**
  String get adminCacheCleared;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
