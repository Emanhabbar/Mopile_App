// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dawaai';

  @override
  String get home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get account => 'Account';

  @override
  String get notifications => 'Notifications';

  @override
  String get signOut => 'Sign out';

  @override
  String get sessionExpired => 'Your session expired, please sign in again.';

  @override
  String get loadingDefault => 'Loading data...';

  @override
  String get loadFailedTitle => 'Failed to load';

  @override
  String get loadFailedMessage => 'Unable to load data right now.';

  @override
  String get retry => 'Retry';

  @override
  String get appTagline => 'Your medicine is closer';

  @override
  String get loginFailed =>
      'Unable to sign in. Check your details and try again.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Enter your account details to access your services.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailInvalid => 'Enter a valid email address.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginPasswordRequired => 'Enter your password.';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get orDivider => 'Or';

  @override
  String get loginTermsPrefix => 'By continuing, you agree to ';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get andWord => ' and';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get noAccountYet => 'Don\'t have an account yet?';

  @override
  String get createAccount => 'Create account';

  @override
  String welcomeName(Object name) {
    return 'Welcome $name';
  }

  @override
  String get accountCreatedTitle => 'Your account has been created';

  @override
  String get goToHome => 'Go to home';

  @override
  String get splashAppLogoLabel => 'Dawaai app logo';

  @override
  String get splashTagline =>
      'Your medicine is closer, and your care is easier';

  @override
  String get splashPreparing => 'Preparing your experience';

  @override
  String get splashTopCaption => 'Pharmaceutical care closer to you';

  @override
  String get splashLoadingLabel => 'Preparing the app';

  @override
  String splashPercent(Object percent) {
    return '$percent percent';
  }

  @override
  String get forgotOperationFailed =>
      'Unable to complete the operation right now. Try again.';

  @override
  String get forgotBack => 'Back';

  @override
  String get forgotTitle => 'Recover account';

  @override
  String get forgotSubtitle =>
      'Enter your email and we\'ll help you set a new password securely.';

  @override
  String get forgotEmailLabel => 'Email';

  @override
  String get forgotVerifying => 'Verifying...';

  @override
  String get forgotContinue => 'Continue';

  @override
  String get forgotSetNewTitle => 'Set a new password';

  @override
  String get forgotResetSubtitle =>
      'Enter the code sent to your email, then choose a new password.';

  @override
  String get forgotTokenLabel => 'Recovery code';

  @override
  String get forgotTokenRequired => 'Enter the recovery code.';

  @override
  String get forgotNewPasswordLabel => 'New password';

  @override
  String get forgotConfirmPasswordLabel => 'Confirm password';

  @override
  String get forgotPasswordsMismatch => 'The two passwords don\'t match.';

  @override
  String get forgotPasswordHint =>
      'Use at least 8 characters with an uppercase and lowercase letter, a number, and a symbol.';

  @override
  String get forgotSaving => 'Saving...';

  @override
  String get forgotSavePassword => 'Save password';

  @override
  String get forgotSendNewCode => 'Send a new code';

  @override
  String get forgotSuccessTitle => 'Password updated';

  @override
  String get forgotSuccessSubtitle =>
      'You can now sign in using your new password.';

  @override
  String get forgotBackToLogin => 'Back to sign in';

  @override
  String get forgotEmailInvalid => 'Enter a valid email address.';

  @override
  String get forgotPasswordRequirements =>
      'The password doesn\'t meet the requirements.';

  @override
  String get registerTypeAccount => 'Choose account type';

  @override
  String get registerAccountData => 'Account details';

  @override
  String get registerPharmacyData => 'Pharmacy details';

  @override
  String get registerOrganizationData => 'Organization details';

  @override
  String get registerWarehouseData => 'Warehouse details';

  @override
  String get registerTypeSubtitle =>
      'Choose the account type that suits your needs.';

  @override
  String get registerAccountSubtitle =>
      'Enter your account details to continue.';

  @override
  String get registerEntitySubtitle =>
      'Complete the entity details to create your account.';

  @override
  String get registerFailed => 'Unable to create the account right now.';

  @override
  String get registerCoordsTogether => 'Enter latitude and longitude together.';

  @override
  String get registerCoordsInvalid => 'Check the entered coordinate values.';

  @override
  String get registerIntro =>
      'Each account has a workspace and services designed around its needs.';

  @override
  String get registerTypeUser => 'User';

  @override
  String get registerTypeUserDesc =>
      'Search for your medicine and keep up with your requests and health info.';

  @override
  String get registerTypePharmacy => 'Pharmacy';

  @override
  String get registerTypePharmacyDesc =>
      'Manage inventory, working hours, and user requests.';

  @override
  String get registerTypeOrganization => 'Organization';

  @override
  String get registerTypeOrganizationDesc =>
      'Organize campaigns, receive donation offers, and assistance requests.';

  @override
  String get registerTypeWarehouse => 'Medicine warehouse';

  @override
  String get registerTypeWarehouseDesc =>
      'Manage shipments, pharmacy orders, shipping, and invoices.';

  @override
  String get registerAccountInfo =>
      'Enter correct information so we can set up your account properly.';

  @override
  String get registerFullName => 'Full name';

  @override
  String get registerFullNameHint => 'Name as it appears on the account';

  @override
  String get registerFullNameRequired => 'Enter the full name.';

  @override
  String get registerPhoneLabel => 'Phone number';

  @override
  String get registerPhoneOptionalLabel => 'Phone number (optional)';

  @override
  String get registerPhoneRequired => 'Enter the phone number.';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailInvalid => 'Enter a valid email address.';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint =>
      'Use at least 8 characters with an uppercase and lowercase letter, a number, and a symbol.';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerPasswordsMismatch => 'The two passwords don\'t match.';

  @override
  String get registerAccountHelp =>
      'Correct account details help provide a suitable and secure experience.';

  @override
  String get registerPharmacyName => 'Pharmacy name';

  @override
  String get registerWarehouseName => 'Warehouse name';

  @override
  String get registerOrgName => 'Organization name';

  @override
  String get registerLicenseNumber => 'License number';

  @override
  String get registerRegNumber => 'Registration number';

  @override
  String get registerPharmacyNameHint => 'Enter the pharmacy name.';

  @override
  String get registerWarehouseNameHint => 'Enter the warehouse name.';

  @override
  String get registerOrgNameHint => 'Enter the organization name.';

  @override
  String get registerLicenseHint => 'Enter the license number.';

  @override
  String get registerRegNumberHint => 'Enter the registration number.';

  @override
  String registerBusinessIntro(Object entityType) {
    return 'Enter the $entityType details; they will be reviewed before activating account services.';
  }

  @override
  String get registerPharmacyWord => 'pharmacy';

  @override
  String get registerWarehouseWord => 'warehouse';

  @override
  String get registerOrgWord => 'organization';

  @override
  String get registerCity => 'City';

  @override
  String get registerCityRequired => 'Enter the city.';

  @override
  String get registerArea => 'Area';

  @override
  String get registerAreaRequired => 'Enter the area.';

  @override
  String get registerAddress => 'Address';

  @override
  String get registerAddressRequired => 'Enter the address.';

  @override
  String get registerDescription => 'Short description (optional)';

  @override
  String get registerDeliveryService => 'Delivery service';

  @override
  String get registerDeliveryServiceSub =>
      'Select it if the pharmacy provides delivery';

  @override
  String get registerLocationTitle => 'Pharmacy location (optional)';

  @override
  String get registerLocationHint =>
      'You can save the location now or add it later from the pharmacy profile.';

  @override
  String get registerLatitude => 'Latitude';

  @override
  String get registerLongitude => 'Longitude';

  @override
  String get registerLocating => 'Locating...';

  @override
  String get registerLocateAuto => 'Locate automatically';

  @override
  String get registerLocationFailed =>
      'Unable to determine your location. Try again.';

  @override
  String get registerMinOrder => 'Minimum order amount';

  @override
  String get registerDeliveryFee => 'Delivery fee';

  @override
  String get registerInvalidValue => 'Enter a valid value.';

  @override
  String get continueAction => 'Continue';

  @override
  String get registerCreate => 'Create account';

  @override
  String get settingsProfileSubtitle => 'Your data and app usage preferences';

  @override
  String get settingsPrefsSection => 'Preferences and account';

  @override
  String get settingsPrefsSubtitle =>
      'Manage your data and how you use the app';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsProfileDesc => 'Name, phone number, and photo';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsLanguageAr => 'العربية';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsAppearanceDesc => 'Light, dark, or follow device';

  @override
  String get settingsNotifications => 'Notification preferences';

  @override
  String get settingsNotificationsDesc => 'Requests, reminders, and campaigns';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsChangePasswordDesc => 'Update your account password';

  @override
  String get settingsPrivacyHelpSection => 'Privacy and help';

  @override
  String get settingsPrivacyHelpSubtitle =>
      'Permissions and important info about using Dawaai';

  @override
  String get settingsNotificationCenter => 'Notification center';

  @override
  String get settingsNotificationCenterDesc =>
      'View incoming alerts and their status';

  @override
  String get settingsPermissions => 'Device permissions';

  @override
  String get settingsPermissionsDesc => 'Location, camera, and files';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyDesc => 'Your secure data and privacy';

  @override
  String get settingsTermsDesc => 'General terms and conditions';

  @override
  String get settingsHelp => 'Help';

  @override
  String get settingsHelpDesc => 'Technical support and FAQ';

  @override
  String get settingsAbout => 'About Dawaai';

  @override
  String get settingsVersion => 'Version 1.0.0';

  @override
  String get logoutConfirm => 'Do you want to sign out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get roleRepresentative => 'Warehouse representative';

  @override
  String get roleAdmin => 'Platform administration';

  @override
  String get verifiedAccount => 'Verified account';

  @override
  String get unverifiedAccount => 'Unverified account';

  @override
  String get accountProfileTitle => 'Profile';

  @override
  String get accountProfileSubtitle => 'Your account data and photo';

  @override
  String get accountLoadingProfile => 'Loading your data...';

  @override
  String get accountBasicData => 'Basic data';

  @override
  String get accountFullName => 'Full name';

  @override
  String get accountFullNameRequired => 'Enter the full name';

  @override
  String get accountFullNameTooLong =>
      'The name must not exceed 150 characters';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPhoneLabel => 'Phone number';

  @override
  String get accountOptionalHint => 'Optional';

  @override
  String get accountPhoneTooLong => 'The number must not exceed 30 characters';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get accountSaved => 'Account data saved';

  @override
  String get accountImagesGroup => 'Images';

  @override
  String get accountImageTooLarge => 'The image size must not exceed 5 MB';

  @override
  String get accountAvatarUpdated => 'Profile photo updated';

  @override
  String get deleteImageTitle => 'Delete photo';

  @override
  String get deleteImageConfirm => 'Do you want to remove your profile photo?';

  @override
  String get delete => 'Delete';

  @override
  String get accountAvatarDeleted => 'Profile photo deleted';

  @override
  String get accountOperationFailed =>
      'Unable to complete the operation right now.';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get removePhoto => 'Remove';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordSubtitle => 'Keep your account secure';

  @override
  String get changePasswordCurrent => 'Current password';

  @override
  String get changePasswordCurrentRequired => 'Enter the current password';

  @override
  String get changePasswordNew => 'New password';

  @override
  String get changePasswordMinLength => 'Must be at least 8 characters';

  @override
  String get changePasswordMaxLength => 'Must not exceed 128 characters';

  @override
  String get changePasswordConfirm => 'Confirm new password';

  @override
  String get changePasswordMismatch => 'The two passwords don\'t match';

  @override
  String get changePasswordDone => 'Password changed successfully';

  @override
  String get changePasswordFailed => 'Unable to change the password right now.';

  @override
  String get changePasswordHeroTitle => 'Update password';

  @override
  String get changePasswordHeroSubtitle =>
      'Choose a different strong password of at least 8 characters.';

  @override
  String get appearanceIntroTitle => 'A comfortable look for you';

  @override
  String get appearanceIntroSubtitle =>
      'Choose the app\'s appearance or let it follow your device settings.';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeSystemDesc =>
      'Changes automatically with your phone\'s appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeLightDesc => 'Clear and bright colors';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDarkDesc => 'More comfortable in low light';

  @override
  String get notifIntroTitle => 'Stay informed';

  @override
  String get notifIntroSubtitle =>
      'Control the types of alerts the app shows you. Notification permission is managed from your phone settings.';

  @override
  String get notifInApp => 'In-app notifications';

  @override
  String get notifInAppDesc => 'Enable or disable showing alerts';

  @override
  String get notifRequestUpdates => 'Request updates';

  @override
  String get notifRequestUpdatesDesc =>
      'Medicine request status, preparation, and response';

  @override
  String get notifHealthReminders => 'Health reminders';

  @override
  String get notifHealthRemindersDesc =>
      'Medicine times and alerts related to your health';

  @override
  String get notifCampaigns => 'Campaigns and initiatives';

  @override
  String get notifCampaignsDesc => 'News about donations and campaigns';

  @override
  String get permIntroTitle => 'You are in control';

  @override
  String get permIntroSubtitle =>
      'Dawaai only asks for permission when needed, and you can change it from your phone settings.';

  @override
  String get permLocation => 'Location';

  @override
  String get permLocationAllowed => 'Allowed while using the app';

  @override
  String get permLocationServiceOff =>
      'Permission granted, but the location service is off';

  @override
  String get permLocationNotAllowed => 'Not allowed right now';

  @override
  String get permAllow => 'Allow';

  @override
  String get permCameraFiles => 'Camera and files';

  @override
  String get permCameraFilesDesc =>
      'Only requested when choosing an image or document to send';

  @override
  String get permOpenLocationSettings => 'Open location settings';

  @override
  String get permOpenAppSettings => 'Open the app\'s settings on your phone';

  @override
  String get infoAccountData => 'Account data';

  @override
  String get infoAccountDataDesc =>
      'We use account data to provide services related to your role within the system.';

  @override
  String get infoLocation => 'Location';

  @override
  String get infoLocationDesc =>
      'Your location is used when searching for nearby pharmacies or calculating the route, and you can turn off the permission from your phone.';

  @override
  String get infoHealthData => 'Health data';

  @override
  String get infoHealthDataDesc =>
      'The data you enter is sent to the server to provide the requested health features, and you should never share your login details with anyone.';

  @override
  String get infoControl => 'Control';

  @override
  String get infoControlDesc =>
      'You can edit your data, password, and device permissions from the account and settings pages.';

  @override
  String get infoInfoAccuracy => 'Information accuracy';

  @override
  String get infoInfoAccuracyDesc =>
      'Rely on the packaging and the pharmacist or doctor for medical decisions; the information in the app is supportive and not a substitute for a professional.';

  @override
  String get infoResponsibleUse => 'Responsible use';

  @override
  String get infoResponsibleUseDesc =>
      'You must enter correct data and not misuse requests, donations, or entity accounts.';

  @override
  String get infoEmergency => 'Emergencies';

  @override
  String get infoEmergencyDesc =>
      'The app is not used to request an ambulance or treat an emergency; contact local emergency services immediately.';

  @override
  String get infoAccount => 'Account';

  @override
  String get infoAccountDesc =>
      'You are responsible for keeping your login details confidential and reporting any unusual use.';

  @override
  String get infoMapNotShown => 'The map doesn\'t appear';

  @override
  String get infoMapNotShownDesc =>
      'Make sure the location service is on and the app has location permission, then reload the page.';

  @override
  String get infoConnectionFailed => 'Unable to connect';

  @override
  String get infoConnectionFailedDesc =>
      'Make sure your phone and the server are on the same network and that the server address is correct and available.';

  @override
  String get infoRecoveryCodeMissing => 'Recovery code didn\'t arrive';

  @override
  String get infoRecoveryCodeMissingDesc =>
      'Check your spam folder, then request a new code. During local development the code appears inside the recovery page.';

  @override
  String get infoAccountIssue => 'Account problem';

  @override
  String get infoAccountIssueDesc =>
      'Try signing out and signing back in, and make sure your entity account is approved if it requires admin approval.';

  @override
  String get infoDawaaiDesc =>
      'A platform that connects users with pharmacies, organizations, and the medicine supply chain in one unified experience.';

  @override
  String get infoProjectGoal => 'Project goal';

  @override
  String get infoProjectGoalDesc =>
      'Make finding medicine easier, track requests, support medicine initiatives, and organize the work of participating entities.';

  @override
  String get infoMedicalNotice => 'Medical notice';

  @override
  String get infoMedicalNoticeDesc =>
      'The app does not provide a medical diagnosis; consult your doctor or pharmacist when needed.';

  @override
  String get searchHistoryTitle => 'Search history';

  @override
  String get searchClearing => 'Clearing';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchLoading => 'Loading search history...';

  @override
  String get searchNearbyPharmacy => 'Search for nearby pharmacies';

  @override
  String searchResultCount(Object count) {
    return '$count results';
  }

  @override
  String get searchDelete => 'Delete';

  @override
  String get searchEmptyTitle => 'No search history';

  @override
  String get searchEmptySubtitle => 'Searches you run will appear here.';

  @override
  String get searchClearTitle => 'Clear search history?';

  @override
  String get searchClearConfirm =>
      'All saved searches in your account will be deleted.';

  @override
  String get searchClearAction => 'Clear history';

  @override
  String get searchClearFailed => 'Could not delete search history right now.';

  @override
  String distanceMeters(String value) {
    return '$value m';
  }

  @override
  String distanceKm(String value) {
    return '$value km';
  }

  @override
  String get statusAll => 'All';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusUnavailable => 'Unavailable';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get requestsTitle => 'My requests';

  @override
  String get requestsLoading => 'Loading your requests...';

  @override
  String get requestsIntroTitle => 'Track your medicine requests';

  @override
  String get requestsIntroSubtitle =>
      'See the pharmacy\'s response and the status of each request.';

  @override
  String get newRequest => 'New request';

  @override
  String get requestNumber => 'Request number';

  @override
  String get requestQuantity => 'Quantity';

  @override
  String get requestDate => 'Date';

  @override
  String get requestsEmptyTitle => 'No requests in this category';

  @override
  String get requestsEmptySubtitle =>
      'Search for your medicine and choose the right pharmacy to send a request.';

  @override
  String get medicineAvailable => 'Medicine is available';

  @override
  String get requestDetailsTitle => 'Request details';

  @override
  String get requestDetailsLoading => 'Loading request details...';

  @override
  String get yourNoteToPharmacy => 'Your note to the pharmacy';

  @override
  String get cancellingProgress => 'Cancelling...';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get cancelRequestTitle => 'Cancel request?';

  @override
  String get cancelRequestConfirm =>
      'The pharmacy will not be able to follow up on this request after it is cancelled.';

  @override
  String get back => 'Back';

  @override
  String get confirmCancellation => 'Confirm cancellation';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get cancelRequestFailed => 'Could not cancel the request right now.';

  @override
  String get requestStepSent => 'Sent';

  @override
  String get requestStepCancelled => 'Cancelled';

  @override
  String get underReview => 'Under review';

  @override
  String get responded => 'Responded';

  @override
  String get waitingForResponse => 'Waiting for response';

  @override
  String get quantityRequested => 'Requested quantity';

  @override
  String get createdDate => 'Creation date';

  @override
  String get lastUpdate => 'Last update';

  @override
  String get currentAvailability => 'Current availability';

  @override
  String get availableInStock => 'Available in stock';

  @override
  String get notAvailableNow => 'Not available right now';

  @override
  String get pharmacyResponse => 'Pharmacy response';

  @override
  String get suggestedAlternative => 'Suggested alternative';

  @override
  String get thePharmacy => 'The pharmacy';

  @override
  String get directions => 'Directions';

  @override
  String get medicineUnavailable => 'Medicine is not available';

  @override
  String get waitingForPharmacyResponse =>
      'Waiting for the pharmacy\'s response';

  @override
  String get pharmacyDetailsTitle => 'Pharmacy details';

  @override
  String get pharmacyDetailsLoading => 'Loading pharmacy data...';

  @override
  String get availableMedicines => 'Available medicines';

  @override
  String medicinesAvailableCount(Object count) {
    return '$count medicines available for request';
  }

  @override
  String get deliveryAvailable => 'Delivery available';

  @override
  String get call => 'Call';

  @override
  String get requiresPrescription => 'Requires prescription';

  @override
  String get requestMedicineTitle => 'Send a medicine request';

  @override
  String get requestMedicineSubtitle =>
      'The pharmacy will review your request and respond to it';

  @override
  String get medicineLabel => 'Medicine';

  @override
  String get noteToPharmacyOptional => 'Note to the pharmacy (optional)';

  @override
  String get sendingProgress => 'Sending...';

  @override
  String get sendRequest => 'Send request';

  @override
  String get rateExperienceTitle => 'Rate your experience';

  @override
  String get rateExperienceSubtitle => 'Share your opinion to help other users';

  @override
  String get ratingHint => 'Write your opinion briefly (optional)';

  @override
  String get savingProgress => 'Saving...';

  @override
  String get saveRating => 'Save rating';

  @override
  String get workingHours => 'Working hours';

  @override
  String get workingHoursSubtitle => 'The pharmacy\'s weekly schedule';

  @override
  String get dayFallback => 'Day';

  @override
  String get closed => 'Closed';

  @override
  String get daySunday => 'Sunday';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get chooseMedicineFirst => 'Choose a medicine first.';

  @override
  String get requestSentTitle => 'Request sent';

  @override
  String requestSentContent(Object code) {
    return 'Request number $code\nYou can follow the pharmacy\'s response from the My Requests page.';
  }

  @override
  String get close => 'Close';

  @override
  String get viewRequest => 'View request';

  @override
  String get chooseStarsFirst => 'Choose the number of stars first.';

  @override
  String get ratingSaved => 'Thank you, your rating has been saved.';

  @override
  String get operationFailed => 'Could not complete the operation right now.';

  @override
  String get noMedicinesAvailable => 'No medicines available right now';

  @override
  String get priceNotAnnounced => 'Price not announced';

  @override
  String currencySYP(String value) {
    return 'SYP $value';
  }

  @override
  String get medicineSearchTitle => 'Search for a medicine';

  @override
  String get nearbyPharmacies => 'Nearby pharmacies';

  @override
  String get searchStartTitle => 'Start by typing the medicine name';

  @override
  String get searchStartMessage =>
      'Pharmacies that have the medicine will appear with price and distance.';

  @override
  String get searchLoadingNearby => 'Searching nearby pharmacies...';

  @override
  String get searchNoResultsTitle => 'No matching results found';

  @override
  String get searchNoResultsMessage =>
      'Try the scientific name, widen the search range, and check the spelling.';

  @override
  String get searchResultsTitle => 'Search results';

  @override
  String searchResultsSubtitle(Object results, Object pharmacies) {
    return '$results results at $pharmacies pharmacies';
  }

  @override
  String get searchEmptyQuery => 'Type a medicine name to search.';

  @override
  String get setLocationFirst => 'Set your location first';

  @override
  String get setLocationDesc =>
      'We use your location to show the medicine and the nearest pharmacies to you.';

  @override
  String get setLocationAction => 'Set location';

  @override
  String get searchHeroTitle => 'Search for your medicine easily';

  @override
  String get searchHeroSubtitle => 'Compare availability, price, and distance.';

  @override
  String get medicineNameLabel => 'Medicine name';

  @override
  String get medicineNameHint => 'Medicine name or scientific name';

  @override
  String get radiusLabel => 'Range';

  @override
  String get sortLabel => 'Sort';

  @override
  String get searchingProgress => 'Searching...';

  @override
  String get searchAction => 'Show where the medicine is available';

  @override
  String get sortBestMatch => 'Best match';

  @override
  String get sortDistance => 'Nearest';

  @override
  String get sortOpenNow => 'Open now';

  @override
  String get sortRating => 'Highest rated';

  @override
  String get sortPriceLowToHigh => 'Lowest price';

  @override
  String get priceLabel => 'Price';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get viewPharmacyAndRequest => 'View pharmacy and request medicine';

  @override
  String get priceUnannounced => 'Not announced';

  @override
  String get medicalProfileTitle => 'My health profile';

  @override
  String get healthProfileSaveFailed => 'Could not save the health profile.';

  @override
  String get medicalProfileLoading => 'Loading your health profile...';

  @override
  String get healthCardLoading => 'Preparing your health card...';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get selectDate => 'Choose';

  @override
  String get choose => 'Choose';

  @override
  String get medicalProfileSaved => 'Health profile saved successfully.';

  @override
  String get healthDataTab => 'Health data';

  @override
  String get healthCardTab => 'Health card';

  @override
  String get healthIntroTitle => 'Information that helps you when needed';

  @override
  String get healthIntroSubtitle =>
      'Keep your allergies, current medications, and essential contact details up to date.';

  @override
  String get basicInfoTitle => 'Basic information';

  @override
  String get chooseDate => 'Choose the date';

  @override
  String get healthDetailsTitle => 'Health details';

  @override
  String get allergiesLabel => 'Allergies';

  @override
  String get allergiesHint => 'Example: penicillin';

  @override
  String get chronicConditionsLabel => 'Chronic conditions';

  @override
  String get chronicConditionsHint => 'Example: diabetes';

  @override
  String get currentMedicationsLabel => 'Current medications';

  @override
  String get currentMedicationsHint => 'Type the medicine name';

  @override
  String get emergencyContactTitle => 'Emergency contact';

  @override
  String get emergencyNameLabel => 'Contact name';

  @override
  String get emergencyNameHint => 'Full name';

  @override
  String get nameTooLong => 'The name is too long.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => 'Example: 09XXXXXXXX';

  @override
  String get phoneTooLong => 'The phone number is too long.';

  @override
  String get importantNotesLabel => 'Important notes';

  @override
  String get importantNotesHint => 'Any information that helps the contact';

  @override
  String get notesTooLong => 'The notes exceed the allowed limit.';

  @override
  String get bloodTypeLabel => 'Blood type';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get noAllergies => 'No allergies recorded';

  @override
  String get noConditions => 'No chronic conditions recorded';

  @override
  String get noMedications => 'No current medications recorded';

  @override
  String get textTooLong => 'The text must not exceed 150 characters.';

  @override
  String get addTag => 'Add';

  @override
  String get emergencyContactEmpty => 'No emergency contact added yet.';

  @override
  String get dashboardLoading => 'Preparing your personal space...';

  @override
  String get metricActiveRequests => 'Active requests';

  @override
  String get metricCompletedRequests => 'Completed requests';

  @override
  String get metricOpenPharmacies => 'Open pharmacies';

  @override
  String get quickAccessTitle => 'Quick access';

  @override
  String get quickAccessSubtitle => 'Services you might need today';

  @override
  String get myPrescriptions => 'My prescriptions';

  @override
  String get myPrescriptionsSubtitle => 'Manage prescriptions and requests';

  @override
  String get donations => 'Donations';

  @override
  String get donationsSubtitle => 'Donate medicine or ask for help';

  @override
  String get organizations => 'Organizations';

  @override
  String get organizationsSubtitle => 'Discover active campaigns';

  @override
  String get pharmacyAssistant => 'Pharmacy assistant';

  @override
  String get pharmacyAssistantSubtitle => 'Ask and follow your conversations';

  @override
  String get medicineAlternatives => 'Medicine alternatives';

  @override
  String get medicineAlternativesSubtitle => 'Compare available alternatives';

  @override
  String get searchHistorySubtitle => 'Go back to previous searches';

  @override
  String get locationSectionTitle => 'Location and pharmacies';

  @override
  String get locationSectionSubtitle =>
      'Nearby results based on your saved location';

  @override
  String get latestRequestsTitle => 'Latest requests';

  @override
  String get latestRequestsSubtitle =>
      'The latest updates on medicine requests';

  @override
  String get emptyRequestsActivity =>
      'No requests yet. You can start by searching for your medicine.';

  @override
  String get searchActivityTitle => 'Search activity';

  @override
  String get searchActivitySubtitle => 'Recent searches';

  @override
  String get emptySearchActivity => 'You haven\'t searched yet.';

  @override
  String get healthSpace => 'Your health space';

  @override
  String get heroSubtitle =>
      'Search for your medicine, track your requests, and keep\nyour health information in one place.';

  @override
  String get searchPlaceholder => 'Search for a medicine...';

  @override
  String get searchCta => 'Search';

  @override
  String get locationSavedHero =>
      'Your location is saved — results nearest to you';

  @override
  String get addLocationHero => 'Add your location to view nearby pharmacies';

  @override
  String get locationSavedTitle => 'Your location is saved';

  @override
  String get setLocationTitle => 'Set your location';

  @override
  String locationSummarySubtitle(Object radius, Object count) {
    return 'Range $radius km — $count registered pharmacies';
  }

  @override
  String get addLocationSubtitle =>
      'Add your location from the nearby pharmacies service';

  @override
  String get openLabel => 'Open';

  @override
  String get closedLabel => 'Closed';

  @override
  String get searchForMedicine => 'Search for a medicine';

  @override
  String get searchForPharmacy => 'Search for a pharmacy';

  @override
  String get medicineRequestType => 'Medicine request';

  @override
  String get updateMyLocation => 'Update my location';

  @override
  String get locatingPharmacies => 'Locating the nearest pharmacies for you...';

  @override
  String get discoverNearest => 'Discover the nearest to you';

  @override
  String get nearbyHeaderSubtitle =>
      'View the three nearest pharmacies and the route to the closest option.';

  @override
  String get locatingNow => 'Locating...';

  @override
  String get myCurrentLocation => 'My current location';

  @override
  String get manualLabel => 'Manual';

  @override
  String get searchRangeLabel => 'Search range';

  @override
  String get dragMapHint => 'Drag the map to explore';

  @override
  String get locationUpdated =>
      'Your location was updated and the nearest results are shown.';

  @override
  String get locationUpdateFailed => 'Could not update the location right now.';

  @override
  String get mapLoadFailed => 'Could not load the map';

  @override
  String get mapLoadFailedSubtitle =>
      'Check your internet connection and try again.';

  @override
  String get backToMyLocation => 'Back to my location';

  @override
  String get showAllLocations => 'Show all locations';

  @override
  String get shrinkMap => 'Shrink map';

  @override
  String get expandMap => 'Expand map';

  @override
  String get mapOpenFailed => 'Could not open the maps app.';

  @override
  String routeToNearest(String distance, String time) {
    return '$distance$time to the nearest';
  }

  @override
  String get minuteUnit => 'min';

  @override
  String get exploreMapHint => 'Explore pharmacies on the map';

  @override
  String routeMinutes(Object minutes) {
    return 'about $minutes minutes';
  }

  @override
  String get startDirections => 'Start directions';

  @override
  String get yourCurrentLocation => 'Your current location';

  @override
  String pharmacyMarkerSemantics(Object number, String name) {
    return 'Pharmacy number $number, $name';
  }

  @override
  String get nearestThreePharmacies => '3 nearest pharmacies';

  @override
  String resultsSummaryCounts(Object registered, Object external) {
    return '$registered registered · $external additional options';
  }

  @override
  String get nearestLabel => 'Nearest';

  @override
  String get manualLocationTitle => 'Enter location manually';

  @override
  String get manualLocationSubtitle =>
      'Enter the exact coordinates of your current location.';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get latitudeInvalid => 'Enter a latitude between -90 and 90.';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get longitudeInvalid => 'Enter a longitude between -180 and 180.';

  @override
  String get saveLocation => 'Save location';

  @override
  String get noLocationTitle => 'Location not set';

  @override
  String get noLocationMessage =>
      'Use the device location or enter coordinates to view pharmacies.';

  @override
  String get noNearbyTitle => 'No pharmacies within range';

  @override
  String get noNearbyMessage =>
      'Widen the search distance or update your location and try again.';
}
