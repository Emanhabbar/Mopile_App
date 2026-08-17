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
  /// **'قدّم دواءً أو اطلب مساعدة'**
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
