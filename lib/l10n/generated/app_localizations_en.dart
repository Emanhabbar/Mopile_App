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
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingIntroTitle => 'Welcome to Dawaai';

  @override
  String get onboardingIntroDesc =>
      'An integrated pharmaceutical platform connecting users, pharmacies, warehouses and organizations for faster, easier access to medicine.';

  @override
  String get onboardingSearchTitle => 'Find your medicine';

  @override
  String get onboardingSearchDesc =>
      'Search any medicine, check availability and prices, and place your order in one tap.';

  @override
  String get onboardingPharmaciesTitle => 'Nearby pharmacies';

  @override
  String get onboardingPharmaciesDesc =>
      'Discover the nearest pharmacies, their working hours and details before you visit.';

  @override
  String get onboardingInventoryTitle => 'Inventory & barcode';

  @override
  String get onboardingInventoryDesc =>
      'Manage your inventory, scan barcodes, and track quantities and expiry dates with ease.';

  @override
  String get onboardingDonationsTitle => 'Donate and help others';

  @override
  String get onboardingDonationsDesc =>
      'Join donation campaigns, offer assistance, and get smart support from the assistant.';

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
  String get donationsSubtitle => 'Medicine reaches those who need it';

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

  @override
  String get chatAssistantSubtitle => 'Quick guidance to reach Dawaai services';

  @override
  String get chatLoadingSessions => 'Loading conversations...';

  @override
  String get previousChats => 'Previous conversations';

  @override
  String get newChat => 'New conversation';

  @override
  String get chatTitleOptional => 'Conversation title (optional)';

  @override
  String get start => 'Start';

  @override
  String get startChatFailed => 'Could not start the conversation right now.';

  @override
  String get howCanIHelp => 'How can I help you?';

  @override
  String get chatHeroSubtitle =>
      'Search for a medicine, a nearby pharmacy, or a service inside the app.';

  @override
  String get nearbyPharmacy => 'Nearby pharmacy';

  @override
  String get healthServicesHint => 'Health services';

  @override
  String get chatSessionTitle => 'Pharmacy conversation';

  @override
  String messageCount(Object count) {
    return '$count messages';
  }

  @override
  String get noPreviousChats => 'No previous conversations';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle => 'Everything new in one place';

  @override
  String get markingAllRead => 'Updating...';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notificationsLoading => 'Loading notifications...';

  @override
  String get notifUpdateFailed => 'Could not update the notification.';

  @override
  String markedReadCount(Object count) {
    return '$count notifications marked as read.';
  }

  @override
  String get notificationsUpdateFailed => 'Could not update the notifications.';

  @override
  String get notifStatTotal => 'Total';

  @override
  String get notifStatNew => 'New';

  @override
  String get notifStatRead => 'Read';

  @override
  String get unreadOnlyLabel => 'Unread only';

  @override
  String get notificationTypeHint => 'Notification type';

  @override
  String get allNotifications => 'All notifications';

  @override
  String get notifTypePrescriptions => 'Prescriptions';

  @override
  String get notifTypeRequests => 'Requests';

  @override
  String get notifTypeReminders => 'Reminders';

  @override
  String get notifTypeApprovals => 'Approvals';

  @override
  String get notifTypeVerification => 'Verification';

  @override
  String get notifTypeGeneral => 'General';

  @override
  String get noNotifications => 'No notifications to show';

  @override
  String get endedConversation => 'Ended conversation';

  @override
  String get readyToHelp => 'Ready to help you';

  @override
  String get endConversation => 'End conversation';

  @override
  String get chatLoadingMessages => 'Loading messages...';

  @override
  String get sendMessageFailed => 'Could not send the message.';

  @override
  String get referencesTitle =>
      'Pharmaceutical references related to the answer';

  @override
  String get referenceFallback => 'Reference pharmaceutical data';

  @override
  String get conversationNotice =>
      'Write your question clearly for a more accurate result, and do not rely on the conversation in emergencies.';

  @override
  String get conversationEndedHint => 'This conversation has ended';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get intelligenceTitle => 'Smart pharmaceutical information';

  @override
  String get searchAlternativesTitle => 'Search for alternatives';

  @override
  String get medicineAlternativesHint =>
      'Enter the medicine name to search for alternatives';

  @override
  String get showAlternatives => 'Show alternatives';

  @override
  String get noAlternativesFound => 'No suitable alternatives found.';

  @override
  String get stockoutPredictionTitle => 'Stock-out prediction';

  @override
  String get stockLabel => 'Stock';

  @override
  String get soldLabel => 'Sold';

  @override
  String get averageDailyLabel => 'Daily average';

  @override
  String get sales7DaysLabel => '7-day sales';

  @override
  String get sales30DaysLabel => '30-day sales';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analyzeStock => 'Analyze stock';

  @override
  String get enterMedicineFirst => 'Enter the medicine name first.';

  @override
  String get intelligenceUnavailable =>
      'The smart service is unavailable right now. Try again later.';

  @override
  String get intelligenceIntro =>
      'Results to help with decision-making; consult a specialist before replacing any medicine.';

  @override
  String predictionResult(String days, Object quantity) {
    return 'Expected to run out within $days days\nThe suggested order quantity: $quantity';
  }

  @override
  String get openNow => 'Open now';

  @override
  String get closedNow => 'Closed now';

  @override
  String ratingOf(String rating, Object count) {
    return '$rating of $count ratings';
  }

  @override
  String get openDirections => 'Open directions';

  @override
  String get externalPharmacyNotice =>
      'This pharmacy is shown from the maps service and may not be registered on the Dawaai platform.';

  @override
  String distanceMetersFull(String value) {
    return '$value meters';
  }

  @override
  String get organizationsAndCampaignsTitle => 'Organizations and campaigns';

  @override
  String get activeCampaignsTitle => 'Active campaigns';

  @override
  String get activeCampaignsSubtitle =>
      'Pharmaceutical initiatives available to contribute to';

  @override
  String get campaignsLoading => 'Loading campaigns...';

  @override
  String get noActiveCampaigns => 'No active campaigns right now.';

  @override
  String get approvedOrganizationsTitle => 'Approved organizations';

  @override
  String get approvedOrganizationsSubtitle =>
      'Browse organizations and their current campaigns';

  @override
  String get organizationsLoading => 'Loading organizations...';

  @override
  String get noApprovedOrganizations => 'No approved organizations right now.';

  @override
  String get medicineReachesWhoNeedsIt => 'Medicine reaches those who need it';

  @override
  String orgCampaignSummary(String orgs, String campaigns) {
    return '$orgs organizations • $campaigns active campaigns';
  }

  @override
  String activeCampaignCount(Object count) {
    return '$count active campaigns';
  }

  @override
  String get urgent => 'Urgent';

  @override
  String needLabel(String summary) {
    return 'Need: $summary';
  }

  @override
  String get organizationDetailsTitle => 'Organization details';

  @override
  String get organizationLoading => 'Loading organization...';

  @override
  String get approvedOrganizationLabel => 'Approved organization';

  @override
  String registrationNumber(Object number) {
    return 'Registration number: $number';
  }

  @override
  String requestedMedicinesLabel(String summary) {
    return 'Requested medicines: $summary';
  }

  @override
  String get donateOffer => 'Submit a donation offer';

  @override
  String get prescriptionStatusReserved => 'Reserved';

  @override
  String get prescriptionStatusReady => 'Ready for pickup';

  @override
  String get prescriptionStatusCollected => 'Collected';

  @override
  String get prescriptionStatusExpired => 'Expired';

  @override
  String get prescriptionStatusCancelled => 'Cancelled';

  @override
  String get prescriptionStatusAnalyzed => 'Analyzed';

  @override
  String get myPrescriptionsTitle => 'My prescriptions';

  @override
  String get prescriptionsLoading => 'Loading prescriptions...';

  @override
  String get previousPrescriptions => 'Previous prescriptions';

  @override
  String get prescriptionFileTooLarge =>
      'The prescription file must not exceed 10 MB.';

  @override
  String get prescriptionAnalyzeFailed =>
      'Could not analyze the prescription right now.';

  @override
  String get addNewPrescription => 'Add a new prescription';

  @override
  String get uploadPrescriptionHint =>
      'Choose a clear image or PDF file of a printed prescription, up to 10 MB.';

  @override
  String get choosePrescription => 'Choose prescription';

  @override
  String get prescriptionFallbackTitle => 'Prescription';

  @override
  String prescriptionItemsCount(Object count) {
    return '$count medicines';
  }

  @override
  String get noPrescriptions => 'No prescription added yet';

  @override
  String get prescriptionOrdersTitle => 'Prescription orders';

  @override
  String get refreshOrders => 'Refresh orders';

  @override
  String get ordersLoading => 'Loading orders...';

  @override
  String matchPercentage(String percent) {
    return '$percent% match';
  }

  @override
  String get confirmDeliveryTitle => 'Confirm prescription delivery';

  @override
  String get pickupCodeLabel => 'Pickup code';

  @override
  String get pickupCodeHint => 'Enter the 8-digit pickup code';

  @override
  String get confirm => 'Confirm';

  @override
  String get invalidPickupCode => 'Enter the 8-digit pickup code.';

  @override
  String get prescriptionCollectedMsg => 'Prescription pickup confirmed.';

  @override
  String get prescriptionReadyMsg =>
      'The order was updated to ready for pickup.';

  @override
  String get prescriptionStatusUpdateFailed =>
      'Could not update the prescription status.';

  @override
  String get markReadyAction => 'Mark as ready for pickup';

  @override
  String get confirmDeliveryWithCode => 'Confirm delivery with code';

  @override
  String get pharmacyPrescriptionsTitle => 'Pharmacy prescriptions';

  @override
  String get pharmacyPrescriptionsSubtitle =>
      'Prepare the prescription then confirm delivery with the code';

  @override
  String get orderFactActive => 'Active';

  @override
  String get orderFactReady => 'Ready';

  @override
  String get noPharmacyOrders => 'No prescription orders for the pharmacy';

  @override
  String get prescriptionDetailsTitle => 'Prescription details';

  @override
  String get prescriptionDetailsLoading => 'Loading prescription...';

  @override
  String get medicinesTitle => 'Medicines';

  @override
  String itemsCount(Object count) {
    return '$count items';
  }

  @override
  String get availablePharmaciesTitle => 'Available pharmacies';

  @override
  String get availablePharmaciesSubtitle =>
      'Choose a pharmacy to reserve available medicines';

  @override
  String get noMatchingPharmacy => 'No matching pharmacy right now.';

  @override
  String get editReminders => 'Edit reminders';

  @override
  String get activateMedicineReminders => 'Enable medicine reminders';

  @override
  String get cancelPrescription => 'Cancel prescription';

  @override
  String reservedAt(String name) {
    return 'The prescription was reserved at $name.';
  }

  @override
  String get reserveFailed => 'Could not reserve the prescription.';

  @override
  String get cancelPrescriptionTitle => 'Cancel prescription?';

  @override
  String get cancelPrescriptionConfirm =>
      'The reservation will be cancelled and quantities returned to the pharmacy\'s stock.';

  @override
  String get prescriptionCancelled => 'Prescription cancelled.';

  @override
  String get cancelFailed => 'Could not cancel the prescription.';

  @override
  String get remindersSaved => 'Reminder settings saved.';

  @override
  String get remindersSaveFailed => 'Could not save the reminders.';

  @override
  String get importantWarnings => 'Important warnings';

  @override
  String prescriptionMedicinesAvailable(Object available, Object total) {
    return '$available/$total medicines available';
  }

  @override
  String get reserveFullPrescription => 'Reserve full prescription';

  @override
  String get reserveAvailableMedicines => 'Reserve available medicines';

  @override
  String get pickupCodeTitle => 'Prescription pickup code';

  @override
  String get pickupCodeNote => 'Present this code to the pharmacy upon pickup.';

  @override
  String get reminderSettingsTitle => 'Reminder settings';

  @override
  String get dailyDoseReminder => 'Daily dose reminder';

  @override
  String get refillReminder => 'Refill reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get treatmentDurationLabel => 'Treatment duration in days';

  @override
  String get refillAfterLabel => 'Refill after days';

  @override
  String get save => 'Save';

  @override
  String get medicinesCatalogTitle => 'Medicine catalog';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get catalogLoading => 'Loading the medicine catalog...';

  @override
  String get catalogSubtitle => 'Search for medicines and view their details';

  @override
  String get searchLabel => 'Search';

  @override
  String get catalogSearchHint =>
      'Search by medicine name, scientific name, or company';

  @override
  String get byPrescriptionTag => 'By prescription';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get emptyCatalogTitle => 'The medicine catalog is empty';

  @override
  String get noSearchResultsTitle => 'No matching results';

  @override
  String get emptyCatalogNoSearch => 'Registered medicines will appear here.';

  @override
  String get noSearchResultsHint =>
      'Try another name or part of the scientific name.';

  @override
  String get medicineDetailsTitle => 'Medicine details';

  @override
  String get medicineDetailsLoading => 'Loading medicine data...';

  @override
  String get withoutPrescription => 'Without prescription';

  @override
  String get pharmaInfoTitle => 'Pharmaceutical information';

  @override
  String get arabicScientificNameLabel => 'Arabic scientific name';

  @override
  String get englishScientificNameLabel => 'English scientific name';

  @override
  String get englishNameLabel => 'English name';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get compositionLabel => 'Composition';

  @override
  String get dosageFormLabel => 'Dosage form';

  @override
  String get capacityLabel => 'Capacity or concentration';

  @override
  String get packageSizeLabel => 'Package size';

  @override
  String get manufacturingTitle => 'Manufacturing and availability';

  @override
  String get manufacturerLabel => 'Manufacturer';

  @override
  String get referenceQuantityLabel => 'Reference quantity';

  @override
  String get sellingPriceLabel => 'Selling price';

  @override
  String get purchasePriceLabel => 'Purchase price';

  @override
  String get editArabicNames => 'Edit Arabic name and search names';

  @override
  String get medicineArabicDataTitle => 'Medicine Arabic data';

  @override
  String get arabicNameLabel => 'Arabic name';

  @override
  String get otherSearchNamesLabel => 'Other search names';

  @override
  String get aliasesSeparatorHint => 'Separate names with a comma';

  @override
  String get arabicDataUpdated => 'Medicine Arabic data updated.';

  @override
  String get dataSaveFailed => 'Could not save the data.';

  @override
  String get quickFormLabel => 'Form';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get disclaimerText =>
      'This data is informational. Follow your doctor\'s or pharmacist\'s instructions and do not change your treatment without consulting a specialist.';

  @override
  String get createMedicineIntro =>
      'Enter the medicine data accurately. The medicine will become available for pharmacies to add to their stock after saving.';

  @override
  String get basicDataTitle => 'Basic data';

  @override
  String get englishTradeNameLabel => 'English trade name';

  @override
  String get englishTradeNameHint => 'Example: Paracetamol 500';

  @override
  String get medicineNameRequired => 'Medicine name is required.';

  @override
  String get arabicTradeNameLabel => 'Arabic trade name';

  @override
  String get arabicTradeNameHint => 'Example: Paracetamol 500';

  @override
  String get barcodeHint => 'Numbers, letters, or dashes';

  @override
  String get optionalHint => 'Optional';

  @override
  String get categoryManufacturingTitle => 'Category and manufacturing';

  @override
  String get capacityFieldLabel => 'Capacity';

  @override
  String get capacityHint => '500 mg';

  @override
  String get packageSizeHint => 'Example: 20 tablets';

  @override
  String get detailedInfoTitle => 'Detailed information';

  @override
  String get compositionHint => 'Active ingredients and composition';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'A brief, accurate medicine description';

  @override
  String get saveMedicine => 'Save medicine';

  @override
  String get medicineAdded => 'Medicine added successfully.';

  @override
  String get medicineAddFailed => 'Could not add the medicine right now.';

  @override
  String get requiresPrescriptionSwitchTitle =>
      'Requires a medical prescription';

  @override
  String get requiresPrescriptionSwitchSubtitle =>
      'Enable this if dispensing the medicine requires a prescription';

  @override
  String maxLengthMessage(Object max) {
    return 'Maximum $max characters.';
  }

  @override
  String get maxLength64 => 'Maximum 64 characters.';

  @override
  String get barcodeInvalidChars =>
      'Use only numbers, English letters, or dashes.';

  @override
  String get enterValidNumber => 'Enter a valid number.';

  @override
  String get valueNotNegative => 'The value cannot be negative.';

  @override
  String get enterValidInteger => 'Enter a valid integer.';

  @override
  String get donationsTitle => 'Donations and assistance';

  @override
  String get donationOfferAction => 'Donation offer';

  @override
  String get assistanceRequestAction => 'Assistance request';

  @override
  String get givingStartsWithStep => 'Giving starts with a step';

  @override
  String get donationHeroSubtitle =>
      'Donate valid medicine or ask for help through participating organizations.';

  @override
  String get donationOffersTab => 'Donation offers';

  @override
  String get assistanceRequestsTab => 'Assistance requests';

  @override
  String get offersLoading => 'Loading your offers...';

  @override
  String get noDonationOffers =>
      'No donation offers directed to the organization.';

  @override
  String get noAssistanceRequests => 'No assistance requests at the moment.';

  @override
  String get donationStatusApproved => 'Approved';

  @override
  String get donationStatusReceived => 'Received';

  @override
  String get donationStatusRejected => 'Rejected';

  @override
  String get donationStatusFulfilled => 'Assisted';

  @override
  String get donationStatusCancelled => 'Cancelled';

  @override
  String get donationStatusUnderReview => 'Under review';

  @override
  String get donationStatusOpen => 'Open';

  @override
  String get statusOpen => 'Open';

  @override
  String packagesCount(Object count) {
    return '$count packages';
  }

  @override
  String get targetOrganization => 'Organization';

  @override
  String campaignLabel(String title) {
    return 'Campaign: $title';
  }

  @override
  String organizationNoteLabel(String note) {
    return 'Organization note: $note';
  }

  @override
  String neededBeforeLabel(String date) {
    return 'Needed before $date';
  }

  @override
  String organizationResponseLabel(String note) {
    return 'Organization response: $note';
  }

  @override
  String get verifyDonationsTitle => 'Verify donations';

  @override
  String get verifyDonationsSubtitle =>
      'Medicine safety before it reaches the beneficiary';

  @override
  String get donationOffersLoading => 'Loading donation offers...';

  @override
  String get noDonationsToVerify => 'No donations awaiting verification.';

  @override
  String get reviewNoteLabel => 'Inspection note (optional)';

  @override
  String get reviewNoteHint => 'Add notes about the donation inspection';

  @override
  String get donationStatusUpdated => 'Donation status updated successfully.';

  @override
  String get donationUpdateFailed => 'Could not update the donation.';

  @override
  String get pharmacyReviewTitle => 'Accurate and safe review';

  @override
  String get pharmacyReviewSubtitle =>
      'Inspect the packages then update their status based on the verification result.';

  @override
  String donorLabel(String name) {
    return 'Donor: $name';
  }

  @override
  String beneficiaryLabel(String name) {
    return 'Beneficiary organization: $name';
  }

  @override
  String expiryLabel(String date) {
    return 'Expiry: $date';
  }

  @override
  String get acceptAfterInspection => 'Accept after inspection';

  @override
  String get reject => 'Reject';

  @override
  String get confirmReceivePackages => 'Confirm receipt of packages';

  @override
  String get statusPendingInspection => 'Awaiting inspection';

  @override
  String get actionApproveDonation => 'Approve donation';

  @override
  String get actionRejectDonation => 'Reject donation';

  @override
  String get actionConfirmReceipt => 'Confirm receipt';

  @override
  String get actionUpdateDonation => 'Update donation';

  @override
  String get offerDonationTitle => 'Submit a donation offer';

  @override
  String get assistanceRequestPageTitle => 'Request medicine assistance';

  @override
  String get chooseMedicineSection => 'Choose the medicine';

  @override
  String get chooseMedicineSectionSubtitle =>
      'Search the medicine catalog and select the required item';

  @override
  String get medicineSearchLabel => 'Search for a medicine';

  @override
  String get medicineSearchHint =>
      'Search by medicine name then choose from the results';

  @override
  String get catalogLoadFailed => 'Could not load the medicine catalog.';

  @override
  String get medicineDropdownLabel => 'Medicine';

  @override
  String get medicineDropdownHint => 'Choose the medicine from the catalog';

  @override
  String get chooseMedicineFromCatalog =>
      'Choose the medicine from the catalog.';

  @override
  String get verificationPharmacySection => 'Verification and pickup pharmacy';

  @override
  String get verificationPharmacySectionSubtitle =>
      'The pharmacy will verify the safety of the packages before delivery';

  @override
  String get verificationPharmaciesLoadFailed =>
      'Could not load approved verification pharmacies.';

  @override
  String get verificationPharmacyLabel => 'Verification pharmacy';

  @override
  String get verificationPharmacyHint => 'Choose the approved pharmacy';

  @override
  String get chooseVerificationPharmacy =>
      'Choose the pharmacy that will verify the donation.';

  @override
  String get organizationSection => 'Organization and details';

  @override
  String get organizationSectionOfferSubtitle =>
      'Specify the beneficiary organization and package data';

  @override
  String get organizationSectionRequestSubtitle =>
      'Specify the target organization and your medicine need';

  @override
  String get organizationsLoadFailed => 'Could not load organizations.';

  @override
  String get organizationDropdownLabel => 'Organization';

  @override
  String get organizationDropdownOfferHint =>
      'Choose the beneficiary organization';

  @override
  String get organizationDropdownRequestHint =>
      'Choose the target organization';

  @override
  String get noSpecificOrganization => 'No specific organization';

  @override
  String get chooseTargetOrganization => 'Choose the target organization.';

  @override
  String get campaignOptionalLabel => 'Campaign (optional)';

  @override
  String get noSpecificCampaign => 'No specific campaign';

  @override
  String get donatedPackagesLabel => 'Number of donated packages';

  @override
  String get requestedPackagesLabel => 'Number of requested packages';

  @override
  String get packageCountHint => 'Enter a quantity between 1 and 1000';

  @override
  String get packageCountInvalid => 'Enter a number between 1 and 1000.';

  @override
  String get medicineExpiryDate => 'Medicine expiry date';

  @override
  String get neededBeforeDate => 'Needed before date';

  @override
  String get sealedPackagesTitle => 'Packages are sealed and unopened';

  @override
  String get sealedPackagesSubtitle =>
      'Make sure the package is intact before submitting the offer.';

  @override
  String get notesOptionalLabel => 'Notes (optional)';

  @override
  String get notesHint => 'Add any additional details';

  @override
  String get offerSubmitted =>
      'The offer was sent to the verification pharmacy successfully.';

  @override
  String get assistanceSubmitted =>
      'The assistance request was sent to the organization.';

  @override
  String get submitFailed => 'Could not submit the data right now.';

  @override
  String get donationOfferHeroTitle => 'Medicine donation offer';

  @override
  String get donationOfferHeroSubtitle =>
      'Enter accurate data to make verification and pickup easier.';

  @override
  String get assistanceHeroTitle => 'Medicine assistance request';

  @override
  String get assistanceHeroSubtitle =>
      'Enter your need and choose the right organization for the request.';

  @override
  String get scanMedicineBarcode => 'Scan medicine barcode';

  @override
  String get toggleFlash => 'Turn on the light';

  @override
  String get cameraError =>
      'Could not start the camera. Allow the app to use it or enter the barcode manually.';

  @override
  String get placeBarcodeInFrame =>
      'Place the code inside the frame and hold the phone still for a moment';

  @override
  String get enterBarcodeManually => 'Enter barcode manually';

  @override
  String get enterBarcodeTitle => 'Enter barcode';

  @override
  String get barcodeNumberLabel => 'Barcode number';

  @override
  String get use => 'Use';

  @override
  String get medicineRequestsTitle => 'Medicine requests';

  @override
  String get searchRequestField => 'Search by medicine, user name, or phone';

  @override
  String get requestsOverviewTitle => 'Track requests';

  @override
  String pendingNeedReply(Object count) {
    return '$count requests need your reply now';
  }

  @override
  String get noPendingRequests => 'No pending requests in this list';

  @override
  String get overviewAvailable => 'Available';

  @override
  String get overviewOrders => 'Orders';

  @override
  String quantityRequestedValue(Object count) {
    return 'Quantity $count';
  }

  @override
  String get replyNow => 'Reply now';

  @override
  String get requestStatusWaitingReply => 'Waiting for reply';

  @override
  String get noMatchingRequests => 'No matching requests';

  @override
  String get noMatchingRequestsSubtitle =>
      'New medicine requests from users will appear here.';

  @override
  String get statusWaitingYou => 'Awaiting you';

  @override
  String get workingHoursTitle => 'Working hours';

  @override
  String get saveTooltip => 'Save';

  @override
  String get restoreSavedHours => 'Restore saved hours';

  @override
  String get workingHoursLoading => 'Loading working hours...';

  @override
  String get overnightHint =>
      'For shifts after midnight, choose a closing time earlier than the opening time, and it will be saved for the next day automatically.';

  @override
  String get pharmacyClosed => 'Pharmacy closed';

  @override
  String get overnightShift => 'Extended shift to the next day';

  @override
  String get timeFrom => 'From';

  @override
  String get timeTo => 'To';

  @override
  String get endsNextDay => 'The shift ends the next day';

  @override
  String get openingTimeHelp => 'Shift start time';

  @override
  String get closingTimeHelp => 'Shift end time';

  @override
  String get timesMustDiffer =>
      'The opening and closing times must be different.';

  @override
  String get workingHoursSaved => 'Working hours saved.';

  @override
  String get workingHoursSaveFailed => 'Could not save the working hours.';

  @override
  String get scheduleTitle => 'Pharmacy schedule';

  @override
  String get scheduleSubtitle => 'Set the times for receiving user requests';

  @override
  String get workDays => 'Work days';

  @override
  String get overnightLabel => 'Overnight';

  @override
  String get refreshRequest => 'Refresh request';

  @override
  String get openingRequest => 'Opening request...';

  @override
  String get confirmingProgress => 'Confirming...';

  @override
  String get confirmUserPickup => 'Confirm user pickup of the medicine';

  @override
  String get respondToRequest => 'Reply to request';

  @override
  String get replyWillReachUser => 'Your choice and note will reach the user';

  @override
  String get suggestAlternativeHint =>
      'You can suggest an available alternative instead';

  @override
  String get availableAlternativeLabel => 'Available alternative (optional)';

  @override
  String get noteToUserOptional => 'Note to the user (optional)';

  @override
  String get sendReply => 'Send reply';

  @override
  String get replySent => 'Reply sent to the user.';

  @override
  String get sendReplyFailed => 'Could not send the reply.';

  @override
  String get pickupConfirmed => 'User pickup confirmed.';

  @override
  String get confirmPickupFailed => 'Could not confirm medicine pickup.';

  @override
  String get medicineDataTitle => 'Medicine data';

  @override
  String get scientificNameLabel => 'Scientific name';

  @override
  String get notRegistered => 'Not registered';

  @override
  String get formConcentrationLabel => 'Form and concentration';

  @override
  String userNoteLabel(String note) {
    return 'User note: $note';
  }

  @override
  String get userDataTitle => 'User data';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get requestProcessed => 'This request has been processed';

  @override
  String get licenseVerificationTitle => 'Pharmacy license verification';

  @override
  String get refreshStatus => 'Refresh status';

  @override
  String get reviewingStatus => 'Reviewing status...';

  @override
  String get selectLicenseImage => 'Choose and send license image';

  @override
  String get sendNewLicenseImage => 'Send a newer license image';

  @override
  String get imageTooLarge => 'The image size must not exceed 8 MB.';

  @override
  String get licenseSubmitted =>
      'The license was sent; you can follow the review result here.';

  @override
  String get licenseSubmitFailed => 'Could not send the license image.';

  @override
  String get sendLicenseIntro =>
      'Send a clear image of the license to start the review.';

  @override
  String lastFileLabel(String name) {
    return 'Last file: $name';
  }

  @override
  String get beforeSendingTitle => 'Before sending';

  @override
  String get tipFullLicense =>
      'Capture the full license without cropping the edges.';

  @override
  String get tipClearDetails =>
      'Make sure the name, number, and stamps are clear.';

  @override
  String get tipAcceptedFormats => 'Accepted formats: JPG, PNG, or WEBP.';

  @override
  String get reviewDetailsTitle => 'Review details';

  @override
  String get registeredNameLabel => 'Registered name';

  @override
  String get licenseNameLabel => 'Name on license';

  @override
  String get registryNumberLabel => 'Registry number';

  @override
  String get documentNumberLabel => 'Document number';

  @override
  String get attemptCountLabel => 'Attempt count';

  @override
  String get manualReviewNoteLabel => 'Review note';

  @override
  String get licenseStatusVerified => 'License verified';

  @override
  String get licenseStatusRejected => 'The license needs to be resubmitted';

  @override
  String get licenseStatusFailed => 'Could not read the license';

  @override
  String get licenseStatusManualReview => 'Under review';

  @override
  String get licenseStatusProcessing => 'Reviewing license';

  @override
  String get licenseStatusDefault => 'Pharmacy license verification';

  @override
  String get prepareMedicinesTitle => 'Prepare selected medicines';

  @override
  String get prepareMedicinesSubtitle =>
      'Enter the price for each medicine, then review the rest of the stock data.';

  @override
  String get applyCommonSettings => 'Apply common settings to all';

  @override
  String pricesProgress(Object completed, Object total) {
    return '$completed/$total prices';
  }

  @override
  String addMedicinesToStock(Object count) {
    return 'Add $count medicines to stock';
  }

  @override
  String get removeFromList => 'Remove from list';

  @override
  String get concentrationLabel => 'Concentration';

  @override
  String get formLabel => 'Form';

  @override
  String get packageLabel => 'Package';

  @override
  String get sellingPriceFieldLabel => 'Selling price for this medicine *';

  @override
  String get priceHint => 'Example: 8500';

  @override
  String get currencySuffix => 'SYP';

  @override
  String get enterPositivePrice => 'Enter a price greater than zero.';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get enterQuantity => 'Enter a quantity';

  @override
  String get thresholdLabel => 'Alert threshold';

  @override
  String get expiryDateLabel => 'Expiry date';

  @override
  String get removeDate => 'Remove date';

  @override
  String get availableForOrder => 'Available for order';

  @override
  String get showPriceToUser => 'Show price to the user';

  @override
  String get priceHiddenHint =>
      'The price can be kept internally and hidden when needed';

  @override
  String get commonSettingsTitle => 'Common settings';

  @override
  String get commonSettingsDesc =>
      'These values will be applied to all medicines, while the price remains independent for each medicine.';

  @override
  String get lowStockThresholdLabel => 'Low stock threshold';

  @override
  String get applyToAll => 'Apply to all';

  @override
  String get pharmacyDataTitle => 'Pharmacy data';

  @override
  String get refreshData => 'Refresh data';

  @override
  String get pharmacyProfileLoading => 'Loading pharmacy profile...';

  @override
  String get generalDataTitle => 'General data';

  @override
  String get generalDataSubtitle =>
      'Information shown to the user when opening the pharmacy';

  @override
  String get pharmacyNameLabel => 'Pharmacy name';

  @override
  String get cityLabel => 'City';

  @override
  String get areaLabel => 'Area';

  @override
  String get detailedAddressLabel => 'Detailed address';

  @override
  String get pharmacyDescriptionLabel => 'Pharmacy description';

  @override
  String get deliveryServiceTitle => 'Medicine delivery service';

  @override
  String get deliveryServiceSubtitle => 'Let users know delivery is available';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get pharmacyLocationTitle => 'Pharmacy location';

  @override
  String get pharmacyLocationSubtitle =>
      'An accurate location helps the user find you easily';

  @override
  String get automaticLocation => 'Automatic location';

  @override
  String get useDeviceLocation => 'Use this device\'s location';

  @override
  String get orEnterCoordinates => 'Or enter the coordinates manually';

  @override
  String get saveCoordinates => 'Save coordinates';

  @override
  String get matchRegisteredPlace => 'Match location with the registered place';

  @override
  String get completeProfileFields =>
      'Complete the pharmacy name, city, area, and address.';

  @override
  String get pharmacyProfileSaved => 'Pharmacy data saved.';

  @override
  String get invalidLatitude => 'Enter a valid latitude between -90 and 90.';

  @override
  String get invalidLongitude =>
      'Enter a valid longitude between -180 and 180.';

  @override
  String get locationSaved => 'Location saved.';

  @override
  String get chooseCorrectPlace => 'Choose the correct place';

  @override
  String get noMatchingPlace => 'No matching place found near the coordinates.';

  @override
  String get matchRegisteredPlaceSuccess =>
      'The pharmacy location was linked to the registered place.';

  @override
  String get approvedAccount => 'Approved account';

  @override
  String get pendingApproval => 'Pending approval';

  @override
  String get locationSavedBadge => 'Location saved';

  @override
  String get locationIncomplete => 'Location incomplete';

  @override
  String get inventoryTitle => 'Medicine inventory';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get arabicLabel => 'Arabic';

  @override
  String get showArabicNamesTooltip => 'Show Arabic names';

  @override
  String get refreshInventoryTooltip => 'Refresh inventory';

  @override
  String get searchByMedicineOrScientificName =>
      'Search by medicine or scientific name';

  @override
  String get inventoryLoading => 'Loading inventory...';

  @override
  String inventoryBatchAdded(Object count) {
    return '$count medicines added to inventory.';
  }

  @override
  String get manualMedicineCreated =>
      'Medicine created and added to inventory.';

  @override
  String get inventoryItemAdded => 'Medicine added.';

  @override
  String get inventoryItemUpdated => 'Item updated.';

  @override
  String get inventoryItemDeleted => 'Item deleted.';

  @override
  String get deleteItemTitle => 'Delete item?';

  @override
  String deleteItemConfirm(Object name) {
    return '$name will be deleted from the pharmacy inventory.';
  }

  @override
  String get inventoryManagement => 'Inventory management';

  @override
  String inventoryOverviewSummary(Object count, Object available) {
    return '$count items · $available available for order';
  }

  @override
  String get availableLabel => 'Available';

  @override
  String get lowLabel => 'Low';

  @override
  String get outOfStockLabel => 'Out of stock';

  @override
  String get itemOptions => 'Item options';

  @override
  String get editLabel => 'Edit';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get hiddenLabel => 'Hidden';

  @override
  String get statusLabel => 'Status';

  @override
  String concentrationChip(Object value) {
    return 'Concentration: $value';
  }

  @override
  String dosageFormChip(Object value) {
    return 'Form: $value';
  }

  @override
  String get notAvailable => 'Not available';

  @override
  String expiresOn(Object date) {
    return 'Expires $date';
  }

  @override
  String get lowStockLabel => 'Low stock';

  @override
  String get addToInventoryTitle => 'Add to inventory';

  @override
  String get addToInventorySubtitle =>
      'Choose the most suitable way to add the medicine.';

  @override
  String get chooseFromCatalog => 'Choose from the medicine catalog';

  @override
  String get chooseFromCatalogSubtitle =>
      'Choose one or several medicines at once';

  @override
  String get scanPackageBarcode => 'Scan package barcode';

  @override
  String get scanPackageBarcodeSubtitle =>
      'Find the medicine directly with the camera';

  @override
  String get addMedicineManually => 'Add medicine manually';

  @override
  String get addMedicineManuallySubtitle =>
      'Use this when you cannot find the medicine in the catalog';

  @override
  String get newMedicineDataTitle => 'New medicine data';

  @override
  String get newMedicineDataSubtitle =>
      'Enter the data as it appears on the medicine package to make it easier to find.';

  @override
  String get medicineNameEnglishLabel => 'Medicine name in English *';

  @override
  String get medicineNameArabicLabel => 'Medicine name in Arabic';

  @override
  String get scanWithCamera => 'Scan with camera';

  @override
  String get scientificNameEnglishLabel => 'Scientific name in English';

  @override
  String get scientificNameArabicLabel => 'Scientific name in Arabic';

  @override
  String get concentrationOrCapacityLabel => 'Concentration or capacity';

  @override
  String get continueToInventoryData => 'Continue to inventory data';

  @override
  String get additionalDescriptionLabel => 'Additional description';

  @override
  String get catalogSelectionTitle => 'Select medicines from the catalog';

  @override
  String get catalogSelectionSubtitle =>
      'You can select one or several medicines and add them at once.';

  @override
  String get showArabicName => 'Show Arabic name';

  @override
  String selectedMedicinesCount(Object count) {
    return '$count medicines selected';
  }

  @override
  String get catalogOpening => 'Opening the medicine catalog...';

  @override
  String get noMatchingMedicines => 'No medicines match your search.';

  @override
  String get selectAtLeastOneMedicine => 'Select at least one medicine';

  @override
  String continueWithSelectedCount(Object count) {
    return 'Continue with $count medicines';
  }

  @override
  String get reloadMore => 'Reload more';

  @override
  String get scrollForMore => 'Scroll down to see more';

  @override
  String shownCountOfTotal(Object loaded, Object total) {
    return 'Showing $loaded of $total medicines';
  }

  @override
  String get enterInventoryAvailability =>
      'Enter the medicine availability data in your pharmacy.';

  @override
  String get updateInventoryData =>
      'Update quantity, price, and visibility to users.';

  @override
  String get priceInSyrianPounds => 'Price in Syrian pounds';

  @override
  String priceValue(Object value) {
    return '$value SYP';
  }

  @override
  String get invalidNumbersError =>
      'Enter valid numbers; quantity, price, and stock threshold cannot be less than zero.';

  @override
  String get saveItem => 'Save item';

  @override
  String get noMatchingItems => 'No matching items';

  @override
  String get noMatchingItemsSubtitle =>
      'Change the search or add a new medicine from the catalog.';

  @override
  String get allLabel => 'All';

  @override
  String get dashboardPreparingPharmacy =>
      'Preparing the pharmacy operations center...';

  @override
  String get pharmacyOperationsSection => 'Pharmacy operations';

  @override
  String get pharmacyOperationsSectionSubtitle =>
      'Shortcuts for your most important daily tasks';

  @override
  String get quickOverviewSection => 'Quick overview';

  @override
  String get quickOverviewSectionSubtitle =>
      'Current inventory and orders indicators';

  @override
  String get inventoryAlertsSection => 'Inventory alerts';

  @override
  String get inventoryAlertsSectionSubtitle =>
      'Items that need your attention soon';

  @override
  String get viewAll => 'View all';

  @override
  String get verifyPharmacyLicense => 'Verify pharmacy license';

  @override
  String get managePrescriptions => 'Manage prescriptions';

  @override
  String get donationsLabel => 'Donations';

  @override
  String get analyzeInventory => 'Analyze inventory';

  @override
  String get inventoryLabel => 'Inventory';

  @override
  String get manageItems => 'Manage items';

  @override
  String lowStockCount(Object count) {
    return '$count low';
  }

  @override
  String get ordersLabel => 'Orders';

  @override
  String get followReplies => 'Follow replies';

  @override
  String pendingRequestsBadge(Object count) {
    return '$count waiting for you';
  }

  @override
  String get organizeHours => 'Organize hours';

  @override
  String get pharmacyProfile => 'Pharmacy profile';

  @override
  String get locationAndData => 'Location and data';

  @override
  String get inventoryItemsLabel => 'Inventory items';

  @override
  String get addPharmacyLocation =>
      'Add the pharmacy location so users can find you';

  @override
  String get newLabel => 'New';

  @override
  String get activeRequests => 'Active requests';

  @override
  String get approvePharmacyAccount => 'Approve pharmacy account';

  @override
  String get completedLabel => 'Completed';

  @override
  String get pendingReview => 'Pending review';

  @override
  String get locationSet => 'Set';

  @override
  String get requiredToAppear => 'Required to appear to users';

  @override
  String get hoursConfigured => 'Configured';

  @override
  String get setWorkingHours => 'Set working hours';

  @override
  String inventoryItemsCountValue(Object count) {
    return '$count items';
  }

  @override
  String get addFirstMedicine => 'Add your first medicine';

  @override
  String get pharmacyReadiness => 'Pharmacy readiness';

  @override
  String profileCompletionValue(Object percent) {
    return '$percent% of the profile completed';
  }

  @override
  String inventoryAlertLowStock(Object quantity, Object threshold) {
    return 'Quantity $quantity · Min $threshold';
  }

  @override
  String inventoryAlertExpiry(Object days) {
    return '$days days left until expiry';
  }

  @override
  String get inventoryHealthy => 'Inventory is stable with no urgent alerts';

  @override
  String profileCompletionLabel(Object value) {
    return 'Profile completion $value%';
  }

  @override
  String get organizationManagement => 'Organization management';

  @override
  String get orgManagementSubtitle =>
      'Initiatives, donations, and beneficiaries';

  @override
  String get refreshDataTooltip => 'Refresh data';

  @override
  String get moreLabel => 'More';

  @override
  String get editOrganizationData => 'Edit organization data';

  @override
  String get uploadVerificationDocument => 'Upload verification document';

  @override
  String get newCampaign => 'New campaign';

  @override
  String get addCampaignInfoSubtitle => 'Add clear information to help donors.';

  @override
  String get campaignTitleField => 'Campaign title';

  @override
  String get campaignDescriptionField => 'Campaign description';

  @override
  String get requestedMedicinesField => 'Requested medicines (optional)';

  @override
  String get urgentCampaign => 'Urgent campaign';

  @override
  String get urgentCampaignSubtitle => 'Shows with higher visual priority.';

  @override
  String get acceptPublicDonations => 'Accept public donations';

  @override
  String get acceptPublicDonationsSubtitle =>
      'Users can support the campaign directly.';

  @override
  String get startDateLabel => 'Start date';

  @override
  String get endDateLabel => 'End date';

  @override
  String get createCampaign => 'Create campaign';

  @override
  String get organizationData => 'Organization data';

  @override
  String get organizationNameField => 'Organization name';

  @override
  String get registrationNumberField => 'Registration number';

  @override
  String get addressLabel => 'Address';

  @override
  String get organizationDescriptionField => 'Organization description';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get documentSizeLimit => 'The document size must not exceed 10 MB.';

  @override
  String get documentTypeTitle => 'Document type';

  @override
  String get updateSaved => 'Update saved.';

  @override
  String get summaryLabel => 'Summary';

  @override
  String get campaignsLabel => 'Campaigns';

  @override
  String get assistanceLabel => 'Assistance';

  @override
  String get profileLabel => 'Profile';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get whatDoYouWantToDo => 'What would you like to do?';

  @override
  String get orgOperationsReady =>
      'The organization\'s key operations are ready from one place.';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get editProfileLabel => 'Edit profile';

  @override
  String get currentImpact => 'Current impact';

  @override
  String get workSummary => 'Work summary';

  @override
  String get workSummarySubtitle =>
      'A quick read of initiative and request activity.';

  @override
  String get allCampaigns => 'All campaigns';

  @override
  String get activeCampaigns => 'Active campaigns';

  @override
  String get pendingOffers => 'Pending offers';

  @override
  String get openRequests => 'Open requests';

  @override
  String get latestUpdates => 'Latest updates';

  @override
  String get recentCampaigns => 'Recent campaigns';

  @override
  String get recentCampaignsSubtitle =>
      'The latest initiatives the organization worked on.';

  @override
  String get startFirstCampaign =>
      'Start by creating the organization\'s first campaign.';

  @override
  String get manageInitiatives => 'Manage initiatives';

  @override
  String get orgCampaigns => 'Organization campaigns';

  @override
  String get orgCampaignsSubtitle =>
      'Create campaigns and set their status as work progresses.';

  @override
  String get createCampaignTooltip => 'Create campaign';

  @override
  String get noCampaignsYet =>
      'No campaigns yet. Create the first initiative now.';

  @override
  String get givingNetwork => 'Giving network';

  @override
  String get donationOffersTitle => 'Donation offers';

  @override
  String get donationOffersSubtitle =>
      'Review the offers that passed verification and follow up on receiving them.';

  @override
  String get beneficiaryCare => 'Beneficiary care';

  @override
  String get assistanceRequestsTitle => 'Assistance requests';

  @override
  String get assistanceRequestsSubtitle =>
      'Follow cases from the first request until the assistance is completed.';

  @override
  String get reliableData => 'Reliable data';

  @override
  String get orgProfile => 'Organization profile';

  @override
  String get orgProfileSubtitle =>
      'Keep contact data and accreditation documents accurate.';

  @override
  String get documentsLabel => 'Documents';

  @override
  String get accreditationDocs => 'Accreditation documents';

  @override
  String uploadedDocsCount(Object count) {
    return '$count files uploaded for review.';
  }

  @override
  String get noAccreditationDocs => 'No accreditation documents uploaded yet.';

  @override
  String get createNewCampaign => 'Create new campaign';

  @override
  String get activateCampaign => 'Activate campaign';

  @override
  String get closeCampaign => 'Close campaign';

  @override
  String get cancelCampaign => 'Cancel campaign';

  @override
  String get urgentLabel => 'Urgent';

  @override
  String get acceptsDonationsLabel => 'Accepts donations';

  @override
  String campaignEndsOn(Object date) {
    return 'Ends on $date';
  }

  @override
  String offerPackages(Object count, Object name) {
    return '$count packages · $name';
  }

  @override
  String verifiedViaPharmacy(Object name) {
    return 'Verified via $name';
  }

  @override
  String validUntil(Object date) {
    return 'Valid until $date';
  }

  @override
  String get acceptOffer => 'Accept offer';

  @override
  String get confirmDonationReceived => 'Confirm donation received';

  @override
  String requestPackages(Object count, Object name) {
    return '$count packages · $name';
  }

  @override
  String neededBefore(Object date) {
    return 'Needed before $date';
  }

  @override
  String get startReview => 'Start review';

  @override
  String get assistanceCompleted => 'Assistance completed';

  @override
  String get cannotFulfill => 'Cannot fulfill';

  @override
  String get contactLabel => 'Contact';

  @override
  String get aboutLabel => 'About';

  @override
  String get optionalLabel => 'Optional';

  @override
  String documentsUploaded(Object count) {
    return '$count documents uploaded';
  }

  @override
  String get orgVerified => 'Organization verified';

  @override
  String get orgVerificationRejected => 'Verification rejected';

  @override
  String get orgVerificationUnderReview => 'Verification under review';

  @override
  String get orgVerificationIncomplete => 'Verification incomplete';

  @override
  String get verifiedShort => 'Verified';

  @override
  String get rejectedShort => 'Rejected';

  @override
  String get underReviewShort => 'Under review';

  @override
  String get incompleteShort => 'Incomplete';

  @override
  String get campaignActive => 'Active';

  @override
  String get campaignClosed => 'Closed';

  @override
  String get campaignCancelled => 'Cancelled';

  @override
  String get campaignDraft => 'Draft';

  @override
  String get docRegistrationCertificate => 'Registration certificate';

  @override
  String get docOperatingLicense => 'Operating license';

  @override
  String get docManagerIdentity => 'Manager identity';

  @override
  String get docTaxOrLegal => 'Legal document';

  @override
  String get docOther => 'Other';

  @override
  String get docLicensedDocument => 'License document';

  @override
  String get docIdentityDocument => 'Identity proof';

  @override
  String get docAccreditation => 'Accreditation document';

  @override
  String get orgHomeLoading => 'Preparing the organization space...';

  @override
  String get orgHeroSubtitle =>
      'Track your campaigns\' impact and your response to beneficiary needs clearly.';

  @override
  String verifiedBadge(Object label) {
    return 'Approved organization · $label';
  }

  @override
  String get accountPendingApproval => 'Account pending approval';

  @override
  String get orgImpactSection => 'Organization impact';

  @override
  String get orgImpactSectionSubtitle =>
      'Current campaign and request indicators';

  @override
  String get totalCampaigns => 'Total campaigns';

  @override
  String get offersWaiting => 'Offers waiting for you';

  @override
  String get assistanceRequests => 'Assistance requests';

  @override
  String get workManagement => 'Work management';

  @override
  String get workManagementSubtitle =>
      'Each path opens directly in its section';

  @override
  String get createUpdateCampaigns => 'Create and update campaign status';

  @override
  String get reviewOfferedMedicines => 'Review offered medicines';

  @override
  String get followCasesAndRespond => 'Follow and respond to cases';

  @override
  String get dataAndVerificationDocs => 'Data and verification documents';

  @override
  String get verificationStatusTitle => 'Verification status';

  @override
  String verificationDocsCount(Object label, Object count) {
    return '$label · $count documents uploaded';
  }

  @override
  String get completeVerificationDocs =>
      'Complete the verification documents to strengthen the organization\'s credibility.';

  @override
  String get recentCampaignsAddedSubtitle =>
      'The latest initiatives added to the organization account';

  @override
  String get needsUpdate => 'Needs update';

  @override
  String get notApproved => 'Not approved';

  @override
  String get verificationStatusUnknown => 'Verification status unknown';

  @override
  String get campaignPaused => 'Paused';

  @override
  String get campaignCompleted => 'Completed';

  @override
  String get supplyWarehouseTitle => 'Warehouse Management';

  @override
  String get supplyWarehouseSubtitle => 'Supply and distribution center';

  @override
  String get supplySummaryLabel => 'Summary';

  @override
  String get supplyBatchesLabel => 'Batches';

  @override
  String get supplyOrdersLabel => 'Orders';

  @override
  String get supplyRepresentativesLabel => 'Representatives';

  @override
  String get supplyFinanceLabel => 'Finance';

  @override
  String get supplyLoadingWarehouse => 'Loading warehouse...';

  @override
  String get supplyWarehouseOpsTitle => 'Warehouse Operations Center';

  @override
  String supplyInventoryValue(Object money) {
    return 'Inventory value $money SYP';
  }

  @override
  String supplyNewOrdersCount(Object count) {
    return '$count new orders';
  }

  @override
  String get supplyTodayIndicators => 'Today\'s indicators';

  @override
  String get supplyTodayIndicatorsSubtitle =>
      'Quick view of operations and inventory status';

  @override
  String get supplyActiveBatches => 'Active batches';

  @override
  String get supplyLowStock => 'Low stock';

  @override
  String get supplyExpiringSoon => 'Expiring soon';

  @override
  String get supplyActiveDeliveries => 'Active deliveries';

  @override
  String get supplyNeedsAttention => 'Needs attention';

  @override
  String get supplyNeedsAttentionSubtitle =>
      'Batches that are low or close to expiry';

  @override
  String get supplyNoBatches => 'No pharmaceutical batches yet.';

  @override
  String get supplyBatchesStockTitle => 'Batch stock';

  @override
  String get supplyBatchesStockSubtitle =>
      'Track quantities, prices and expiry dates';

  @override
  String get supplyBatchLabel => 'Batch';

  @override
  String get supplyAddBatch => 'Add batch';

  @override
  String get supplyBatchNumber => 'Batch number';

  @override
  String get supplyPurchasePrice => 'Purchase price';

  @override
  String get supplyWholesalePrice => 'Wholesale price';

  @override
  String get supplyStorageLocation => 'Storage location';

  @override
  String get supplyBatchAdded => 'Batch added.';

  @override
  String get supplyLoadingOrders => 'Loading orders...';

  @override
  String get supplyPharmacyOrdersTitle => 'Pharmacy orders';

  @override
  String get supplyMyOrders => 'My orders';

  @override
  String get supplyPharmacyOrdersSubtitle =>
      'Processing the order from receipt to delivery';

  @override
  String get supplyMyOrdersSubtitle =>
      'Track the status of supply and shipping orders';

  @override
  String get supplyNewOrdersFilter => 'New';

  @override
  String get supplyActiveOrdersFilter => 'In progress';

  @override
  String get supplyNoOrdersInCategory => 'No orders in this category.';

  @override
  String supplyOrderItemsTotal(Object count, Object amount) {
    return '$count items · $amount SYP';
  }

  @override
  String supplyShipmentInfo(Object code, Object status) {
    return 'Shipment: $code · $status';
  }

  @override
  String get supplyAccept => 'Accept';

  @override
  String get supplyStartPreparing => 'Start preparing';

  @override
  String get supplyReadyForDispatch => 'Ready for dispatch';

  @override
  String get supplyAssignRepresentative => 'Assign to representative';

  @override
  String get supplyConfirmReceipt => 'Confirm shipment receipt';

  @override
  String get supplyReturnItem => 'Request item return';

  @override
  String get supplyOrderUpdated => 'Order updated.';

  @override
  String get supplyAssignShipment => 'Assign shipment';

  @override
  String get supplyRepresentativeLabel => 'Representative';

  @override
  String get supplyPackagesCount => 'Number of packages';

  @override
  String get supplyAssign => 'Assign';

  @override
  String get supplyShipmentAssigned => 'Shipment assigned to representative.';

  @override
  String get supplyReceiptCode => 'Receipt code';

  @override
  String get supplyReceiptNote => 'Receipt note';

  @override
  String get supplyReceiptConfirmed => 'Shipment receipt confirmed.';

  @override
  String get supplyItemLabel => 'Item';

  @override
  String get supplyReturnReason => 'Return reason';

  @override
  String get supplyReturnSent => 'Return request sent.';

  @override
  String get supplyNoRepresentatives => 'No representatives.';

  @override
  String get supplyDeliveryTeam => 'Delivery team';

  @override
  String supplyTeamSummary(Object available, Object tasks) {
    return '$available available now · $tasks active tasks';
  }

  @override
  String get supplyNoVehicle => 'No vehicle';

  @override
  String get supplyOnShift => 'On shift';

  @override
  String get supplyOffShift => 'Off shift';

  @override
  String get supplyActiveShort => 'Active';

  @override
  String get supplyCompletedShort => 'Completed';

  @override
  String get supplyAddRepresentative => 'Add representative';

  @override
  String get supplyEmployeeCode => 'Employee code';

  @override
  String get supplyVehiclePlate => 'Vehicle plate';

  @override
  String get supplyCreate => 'Create';

  @override
  String get supplyRepresentativeCreated => 'Representative account created.';

  @override
  String get supplyInvoicesLabel => 'Invoices';

  @override
  String get supplyReturnsLabel => 'Returns';

  @override
  String get supplyRecallsLabel => 'Recalls';

  @override
  String get supplyFinanceTitle => 'Finance and control';

  @override
  String get supplyFinanceSubtitle =>
      'Invoices, collections, returns and batch recalls';

  @override
  String get supplyPharmacySupplyTitle => 'Pharmacy supply';

  @override
  String get supplyWarehousesLabel => 'Warehouses';

  @override
  String get supplyStockNeeds => 'Stock needs';

  @override
  String get supplyNoWarehouses => 'No warehouses available.';

  @override
  String get supplyAvailableWarehouses => 'Available warehouses';

  @override
  String get supplyAvailableWarehousesSubtitle =>
      'Browse warehouses and order the required medicines';

  @override
  String supplyAvailableMedicinesCount(Object count) {
    return '$count medicines';
  }

  @override
  String supplyDeliveryFee(Object fee) {
    return 'Delivery $fee SYP';
  }

  @override
  String get supplySelectQuantities =>
      'Select the required quantities then send the order.';

  @override
  String supplyCatalogItem(Object price, Object qty) {
    return '$price SYP · $qty available';
  }

  @override
  String get supplySending => 'Sending...';

  @override
  String get supplySupplyOrderSent => 'Supply order sent.';

  @override
  String get supplyStockAdequate => 'Stock is within the appropriate limits.';

  @override
  String get supplyStockNeedsSubtitle => 'Medicines that need to be restocked';

  @override
  String supplyCurrentQty(Object qty) {
    return 'Current $qty';
  }

  @override
  String supplySuggestedQty(Object qty) {
    return 'Suggested $qty';
  }

  @override
  String get supplyDeliveryTasks => 'Delivery tasks';

  @override
  String get supplyTodaySchedule => 'Your field schedule today';

  @override
  String get supplyRefreshTasks => 'Refresh tasks';

  @override
  String get supplyLoadingTasks => 'Preparing your tasks...';

  @override
  String get supplyAssignedShipments => 'Assigned shipments';

  @override
  String get supplyNoTasksNow => 'No new tasks at the moment';

  @override
  String get supplyUpdateTaskStatus => 'Update task status at each stage';

  @override
  String get supplySafeJourney => 'Safe and organized journey';

  @override
  String get supplySafeJourneySubtitle =>
      'Check the address and update the shipment status while delivering';

  @override
  String get supplyTasksLabel => 'Tasks';

  @override
  String supplyDeliveryItems(Object code, Object count) {
    return '$code · $count items';
  }

  @override
  String get supplyDeliveredSuccess => 'Shipment delivered successfully';

  @override
  String get supplyStepPickup => 'Pickup';

  @override
  String get supplyStepLoading => 'Loading';

  @override
  String get supplyStepOnWay => 'On the way';

  @override
  String get supplyStepArrival => 'Arrival';

  @override
  String get supplyStepDelivered => 'Delivered';

  @override
  String get supplyNoData => 'No data.';

  @override
  String supplyInvoiceRemaining(Object name, Object amount) {
    return '$name · $amount SYP remaining';
  }

  @override
  String supplyInvoiceSummary(Object total, Object paid) {
    return 'Total $total SYP · Paid $paid SYP';
  }

  @override
  String get supplyEditInvoiceTerms => 'Edit invoice terms';

  @override
  String get supplyRecordPayment => 'Record payment';

  @override
  String get supplyAmountLabel => 'Amount';

  @override
  String get supplyPaymentMethod => 'Payment method';

  @override
  String get supplyCashOnDelivery => 'Cash on delivery';

  @override
  String get supplyBankTransfer => 'Bank transfer';

  @override
  String get supplyCredit => 'Credit';

  @override
  String get supplyReferenceOptional => 'Reference number (optional)';

  @override
  String get supplyPaymentRecorded => 'Payment recorded.';

  @override
  String get supplyEditInvoice => 'Edit invoice';

  @override
  String get supplyDiscountLabel => 'Discount';

  @override
  String get supplyTaxLabel => 'Tax';

  @override
  String get supplyWarehouseNote => 'Warehouse note';

  @override
  String get supplyDueDate => 'Due date';

  @override
  String get supplyInvoiceUpdated => 'Invoice updated.';

  @override
  String supplyReturnDetails(Object qty, Object reason) {
    return '$qty packs · $reason';
  }

  @override
  String get supplyAcceptReturn => 'Accept return';

  @override
  String get supplyRejectReturn => 'Reject return';

  @override
  String get supplyCollectedFromPharmacy => 'Collected from pharmacy';

  @override
  String get supplyCompleteReturn => 'Complete return';

  @override
  String get supplyReturnUpdated => 'Return updated.';

  @override
  String get supplyCreateRecallAlert => 'Create recall alert';

  @override
  String get supplyRecallBatch => 'Recall pharmaceutical batch';

  @override
  String get supplySeverityLabel => 'Severity level';

  @override
  String get supplySeverityLow => 'Low';

  @override
  String get supplySeverityMedium => 'Medium';

  @override
  String get supplySeverityHigh => 'High';

  @override
  String get supplySeverityCritical => 'Critical';

  @override
  String get supplyRecallReason => 'Recall reason';

  @override
  String get supplyCreateAlertButton => 'Create alert';

  @override
  String get supplyRecallAlertCreated => 'Recall alert created.';

  @override
  String supplyBatchNumberLabel(Object number) {
    return 'Batch number $number';
  }

  @override
  String get supplyAvailableShort => 'Available';

  @override
  String get supplyExpiryShort => 'Expiry';

  @override
  String get supplyHealthHealthy => 'Healthy';

  @override
  String get supplyHealthLow => 'Low';

  @override
  String get supplyHealthExpiring => 'Expiring soon';

  @override
  String get supplyHealthExpired => 'Expired';

  @override
  String get supplyStatusSubmitted => 'Submitted';

  @override
  String get supplyStatusAccepted => 'Accepted';

  @override
  String get supplyStatusPreparing => 'Preparing';

  @override
  String get supplyStatusReadyForDispatch => 'Ready for dispatch';

  @override
  String get supplyStatusAssigned => 'Assigned';

  @override
  String get supplyStatusLoading => 'Loading';

  @override
  String get supplyStatusOutForDelivery => 'Out for delivery';

  @override
  String get supplyStatusArrived => 'Arrived';

  @override
  String get supplyStatusDelivered => 'Delivered';

  @override
  String get supplyStatusRejected => 'Rejected';

  @override
  String get supplyStatusPaid => 'Paid';

  @override
  String get supplyStatusPartiallyPaid => 'Partially paid';

  @override
  String get supplyStatusUnpaid => 'Unpaid';

  @override
  String get supplyStatusRequested => 'Requested';

  @override
  String get supplyStatusApproved => 'Approved';

  @override
  String get supplyStatusActive => 'Active';

  @override
  String get supplyNextLoading => 'Start loading';

  @override
  String get supplyNextOutForDelivery => 'Start delivery';

  @override
  String get supplyNextArrived => 'Confirm arrival';

  @override
  String get supplyNextDelivered => 'Confirm delivery';

  @override
  String get supplyNextUpdate => 'Update';

  @override
  String get adminCenterTitle => 'Admin Center';

  @override
  String get adminCenterSubtitle =>
      'Manage the Dawaai platform and follow up on its operations';

  @override
  String get adminRefreshTooltip => 'Refresh';

  @override
  String get adminLocationServiceTooltip => 'Pharmacy locations service';

  @override
  String adminCannotApprovePharmacy(Object status) {
    return 'Cannot approve the pharmacy. License status: $status. The license must be verified first.';
  }

  @override
  String adminLicenseCheckFailed(Object error) {
    return 'Could not verify the license status: $error';
  }

  @override
  String get adminOrgReviewApproved =>
      'The organization documents were reviewed and approved.';

  @override
  String get adminOrgReviewNeedsUpdate =>
      'Please update the required verification documents.';

  @override
  String get adminDeactivateAccount => 'Deactivate account';

  @override
  String get adminDeactivateReason => 'Reason for deactivation';

  @override
  String get adminDeactivateReasonHint =>
      'Write a clear reason of at least 10 characters.';

  @override
  String get adminLocationServiceTitle => 'Pharmacy locations service';

  @override
  String get adminLocationServiceHealthy => 'The service is working normally.';

  @override
  String get adminLocationServiceUnhealthy =>
      'The service is not responding as expected.';

  @override
  String get adminCleanCache => 'Clean old data';

  @override
  String get adminSectionSummary => 'Summary';

  @override
  String get adminSectionApprovals => 'Approvals';

  @override
  String get adminSectionAccounts => 'Accounts';

  @override
  String get adminSectionAds => 'Ads';

  @override
  String get adminTickerNewContent => 'New content';

  @override
  String get adminTickerEditContent => 'Edit content';

  @override
  String get adminTickerAppearsHint =>
      'This content will appear on the users\' home page.';

  @override
  String get adminAnnouncement => 'Public announcement';

  @override
  String get adminDutyPharmacy => 'Duty pharmacy';

  @override
  String get adminDutyPharmacyLabel => 'Duty pharmacy';

  @override
  String get adminChoosePharmacy => 'Choose the pharmacy';

  @override
  String get adminTitleLabel => 'Title';

  @override
  String get adminEnterTitleHint => 'Enter the content title';

  @override
  String get adminVisibleTextLabel => 'Text visible to the user';

  @override
  String get adminEnterTextHint => 'Enter the text to show';

  @override
  String get adminPublishContent => 'Publish content';

  @override
  String get adminVisibleNow => 'Currently visible to users';

  @override
  String get adminSavedUnpublished => 'Saved without publishing';

  @override
  String get adminSaveContent => 'Save content';

  @override
  String get adminLoadingIndicators => 'Loading indicators...';

  @override
  String get adminUsers => 'Users';

  @override
  String get adminActiveAccounts => 'Active accounts';

  @override
  String get adminPharmacies => 'Pharmacies';

  @override
  String get adminPendingPharmacies => 'Pending pharmacies';

  @override
  String get adminOrganizations => 'Organizations';

  @override
  String get adminWarehouses => 'Warehouses';

  @override
  String get adminPendingWarehouses => 'Pending warehouses';

  @override
  String get adminOrganizationVerifications => 'Organization verifications';

  @override
  String get adminMedicineRequests => 'Medicine requests';

  @override
  String get adminDonations => 'Donations';

  @override
  String get adminOverviewEyebrow => 'General overview';

  @override
  String get adminPlatformIndicators => 'Platform indicators';

  @override
  String get adminOverviewSubtitle =>
      'Core numbers and approval statuses that need attention.';

  @override
  String get adminHeroPulse => 'Dawaai platform pulse';

  @override
  String get adminHeroSubtitle =>
      'A unified view of accounts, entities, and services';

  @override
  String get adminNeedsDecision => 'Need a decision';

  @override
  String get adminActiveAccount => 'Active account';

  @override
  String get adminPharmacyPoints => 'Pharmacy points';

  @override
  String get adminLicenseVerifiedMsg =>
      'The license is verified; you can approve the pharmacy';

  @override
  String get adminLicenseManualReviewMsg =>
      'The license needs manual review. The license must be verified first before approving the pharmacy.';

  @override
  String get adminLicenseProcessingMsg => 'The license is being processed.';

  @override
  String get adminLicenseDetailsTitle => 'Pharmacy license details';

  @override
  String get adminLicenseNameInDocument => 'Name in document';

  @override
  String get adminMatchScore => 'Match score';

  @override
  String get adminRejectionReason => 'Rejection reason';

  @override
  String get adminReadFailure => 'Read problem';

  @override
  String get adminViewDocument => 'View document';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get adminApprovalDecisions => 'Approval decisions';

  @override
  String get adminPendingYourReview => 'Requests awaiting your review';

  @override
  String get adminApprovalSubtitle =>
      'Check the entity data before granting it permission to work on the platform.';

  @override
  String get adminNoPendingRequests => 'No pending requests in this section.';

  @override
  String get adminApprovePharmacy => 'Approve pharmacy';

  @override
  String get adminRejectPharmacy => 'Reject pharmacy';

  @override
  String get adminOwner => 'Owner';

  @override
  String adminVerificationDocsSubtitle(Object name, Object count) {
    return '$name · $count documents';
  }

  @override
  String get adminVerificationStatus => 'Verification status';

  @override
  String get adminVerificationDocsLabel => 'Documents';

  @override
  String get adminApproveWarehouse => 'Approve warehouse';

  @override
  String get adminRejectWarehouse => 'Reject warehouse';

  @override
  String get adminMinOrderLimit => 'Minimum order amount';

  @override
  String get adminCurrencySuffix => 'SYP';

  @override
  String get adminDeliveryFee => 'Delivery fee';

  @override
  String get adminMedicineBatches => 'Medicine batches';

  @override
  String get adminRepresentatives => 'Representatives';

  @override
  String get adminAccountsGuide => 'Accounts guide';

  @override
  String get adminPlatformUsers => 'Platform users';

  @override
  String get adminAccountsSubtitle =>
      'Search for accounts and review their status and role.';

  @override
  String get adminSearchByNameOrEmail => 'Search by name or email';

  @override
  String get adminLoadingAccounts => 'Loading accounts...';

  @override
  String get adminNoResultsSubtitle =>
      'Change your search terms or choose another role.';

  @override
  String get adminLiveContent => 'Live content';

  @override
  String get adminHomeTicker => 'Home page ticker';

  @override
  String get adminTickerSubtitle =>
      'Manage the public announcements and duty pharmacies shown to users.';

  @override
  String get adminAddAd => 'Add announcement';

  @override
  String get adminLoading => 'Loading...';

  @override
  String get adminNoPublishedContent => 'No published content';

  @override
  String get adminNoContentSubtitle =>
      'Add an announcement or a duty pharmacy to show on the home page.';

  @override
  String get adminReviewLicense => 'Review license';

  @override
  String get adminApprove => 'Approve';

  @override
  String get adminWriteReasonHint =>
      'Write the decision reason (at least 10 characters)';

  @override
  String get adminReasonExample =>
      'Example: The data and documents were reviewed and the approval matches the required standards.';

  @override
  String get adminActive => 'Active';

  @override
  String get adminSuspended => 'Suspended';

  @override
  String get adminRole => 'Role';

  @override
  String get adminLocation => 'Location';

  @override
  String get adminAccreditationNumber => 'Accreditation number';

  @override
  String get adminSuspendedAccount => 'Suspended account';

  @override
  String get adminAdditionalInfo => 'Additional information';

  @override
  String get adminPublished => 'Published';

  @override
  String get adminStopped => 'Stopped';

  @override
  String get adminRoleAdmin => 'Admin';

  @override
  String get adminRolePharmacy => 'Pharmacy';

  @override
  String get adminRoleOrganization => 'Organization';

  @override
  String get adminRoleWarehouse => 'Warehouse';

  @override
  String get adminRoleRepresentative => 'Representative';

  @override
  String get adminRoleUser => 'User';

  @override
  String get warehouseHeroTitle =>
      'Organized supply from inventory for delivery';

  @override
  String get warehouseHeroSubtitle =>
      'Track batches, orders and shipments before they turn into delays.';

  @override
  String warehousePendingOrders(Object count) {
    return '$count supply orders waiting for you';
  }

  @override
  String get warehouseOrdersUpToDate => 'Orders are up to date';

  @override
  String get warehouseOpsStatus => 'Operations status';

  @override
  String get warehouseOpsStatusSubtitle =>
      'Live indicators from the warehouse inventory';

  @override
  String get warehouseInventoryValueTitle => 'Current inventory value';

  @override
  String warehouseInventoryValueMessage(Object money) {
    return '$money SYP within active batches';
  }

  @override
  String get warehouseQuickOps => 'Quick operations';

  @override
  String get warehouseQuickOpsSubtitle =>
      'Shortcuts to the most important warehouse tasks';

  @override
  String get warehouseManage => 'Manage warehouse';

  @override
  String get warehouseManageSubtitle => 'Batches and inventory';

  @override
  String get warehouseSupplyOrders => 'Supply orders';

  @override
  String get warehouseSupplyOrdersSubtitle =>
      'Accept, prepare and assign orders';

  @override
  String get warehouseShipping => 'Shipping and delivery';

  @override
  String get warehouseShippingSubtitle => 'Representatives and shipment status';

  @override
  String get warehouseInventoryAnalysis => 'Inventory analysis';

  @override
  String get warehouseInventoryAnalysisSubtitle =>
      'Predict stockouts and support supply decisions';

  @override
  String get warehouseAlertsTitle => 'Inventory alerts';

  @override
  String get warehouseAlertsSubtitle => 'Batches that need attention soon';

  @override
  String warehouseBatchAlert(Object batchNumber, Object qty) {
    return 'Batch $batchNumber · $qty packages available';
  }

  @override
  String get warehouseRecentOrders => 'Recent orders';

  @override
  String get warehouseRecentOrdersSubtitle =>
      'Latest supply orders received at the warehouse';

  @override
  String warehouseOrderSummary(Object code, Object status, Object amount) {
    return '$code · $status · $amount SYP';
  }

  @override
  String get warehouseCurrencySuffix => 'SYP';

  @override
  String get representativeLoadingSchedule =>
      'Preparing your delivery schedule...';

  @override
  String get representativeReadyForNextTask => 'Ready for your next task';

  @override
  String representativeCurrentTaskTo(Object pharmacyName) {
    return 'Your current task to $pharmacyName';
  }

  @override
  String get representativeNoTaskSubtitle =>
      'Any new shipment assigned by the warehouse will appear here.';

  @override
  String representativeTaskLocation(Object area, Object city, Object status) {
    return '$area, $city · $status';
  }

  @override
  String get representativeNoActiveTask => 'No active task';

  @override
  String representativeActiveTasksCount(Object count) {
    return '$count active tasks';
  }

  @override
  String get representativeTripsSummary => 'Trips summary';

  @override
  String get representativeTripsSummarySubtitle =>
      'Status of shipments assigned to your account';

  @override
  String get representativeTotalTasks => 'Total tasks';

  @override
  String get representativeActiveTasks => 'Active tasks';

  @override
  String get representativeFailedTasks => 'Failed';

  @override
  String get representativeQuickAccess => 'Quick access';

  @override
  String get representativeQuickAccessSubtitle =>
      'Shortcuts for the representative tasks';

  @override
  String get representativeDeliveryTasksSubtitle =>
      'Addresses and shipment status updates';

  @override
  String get representativeNotificationsSubtitle =>
      'Assignments and latest warehouse updates';

  @override
  String get representativeActiveTasksTitle => 'Active tasks';

  @override
  String get representativeNoActionRequired =>
      'No trip requires action right now';

  @override
  String get representativeStartOldest =>
      'Start with the oldest and update the status at each stage';

  @override
  String get representativeAvailableForNewTask =>
      'You are available for a new task';

  @override
  String get representativeAvailableForNewTaskSubtitle =>
      'When a shipment is assigned it will reach you via notifications and appear on this page.';

  @override
  String representativeDeliveryCardSummary(
    Object code,
    Object area,
    Object city,
    Object status,
  ) {
    return '$code · $area, $city · $status';
  }

  @override
  String get representativeStatusFailed => 'Delivery failed';

  @override
  String get representativeStatusReturned => 'Returned to warehouse';

  @override
  String get adminHeroTitle => 'A clear platform under your management';

  @override
  String get adminHeroDescription =>
      'Track approvals, accounts and platform activity from one place.';

  @override
  String adminPendingReviewCount(Object count) {
    return '$count items awaiting review';
  }

  @override
  String get adminReviewsUpToDate => 'All reviews are up to date';

  @override
  String get adminOverviewTitle => 'Platform overview';

  @override
  String get adminOverviewLiveSubtitle => 'Live statistics from the database';

  @override
  String get adminApprovedShort => 'Approved';

  @override
  String get adminControlCenter => 'Control center';

  @override
  String get adminControlCenterSubtitle =>
      'Go directly to the required operation';

  @override
  String get adminApprovalsActionSubtitle =>
      'Pharmacies, organizations and warehouses';

  @override
  String get adminAccountsActionSubtitle => 'Track status and validity';

  @override
  String get adminPlatformBar => 'Platform ticker';

  @override
  String get adminPlatformBarSubtitle => 'Ads and duty pharmacies';

  @override
  String get adminMedicineGuide => 'Medicine guide';

  @override
  String get adminMedicineGuideSubtitle => 'Review and add medicine data';

  @override
  String get adminOpenOperations => 'Open operations';

  @override
  String adminOpenOperationsMessage(
    Object medicineRequests,
    Object assistanceRequests,
    Object donationOffers,
  ) {
    return '$medicineRequests pending medicine requests · $assistanceRequests open assistance requests · $donationOffers donation offers';
  }

  @override
  String get adminAiServices => 'Smart processing services';

  @override
  String get adminRefreshStatus => 'Update status';

  @override
  String get adminAiHealthReadFailed =>
      'Unable to read the services status right now.';

  @override
  String get adminAiDrugSearch => 'Drug search';

  @override
  String get adminAiWorking => 'Working';

  @override
  String dashboardWelcome(Object name) {
    return 'Welcome, $name';
  }

  @override
  String get dashboardUserSubtitle =>
      'Everything you need for your health and medicine in one place.';

  @override
  String get dashboardPharmacySubtitle =>
      'Track your pharmacy work and requests easily.';

  @override
  String get dashboardOrganizationSubtitle =>
      'Manage initiatives and assistance requests clearly.';

  @override
  String get dashboardAdminSubtitle =>
      'Monitor the platform and manage core operations.';

  @override
  String get dashboardWarehouseSubtitle =>
      'Manage inventory, orders and distribution from one place.';

  @override
  String get dashboardRepresentativeSubtitle =>
      'Follow the shipments assigned to you step by step.';

  @override
  String get dashboardBannerUser => 'Your health starts with a step';

  @override
  String get dashboardBannerPharmacy => 'Faster service for users';

  @override
  String get dashboardBannerOrganization =>
      'Impact that reaches those who need it';

  @override
  String get dashboardBannerAdmin => 'A unified view of the platform';

  @override
  String get dashboardBannerWarehouse => 'Organized and reliable supply';

  @override
  String get dashboardBannerRepresentative => 'Every shipment on time';

  @override
  String get dashboardBannerDescUser =>
      'Search for your medicine and find the nearest pharmacy with confidence.';

  @override
  String get dashboardBannerDescPharmacy =>
      'Update inventory and track requests from one panel.';

  @override
  String get dashboardBannerDescOrganization =>
      'Track campaigns, donations and assistance requests.';

  @override
  String get dashboardBannerDescAdmin =>
      'Approvals, accounts and ads at your fingertips.';

  @override
  String get dashboardBannerDescWarehouse =>
      'Track batches, orders, shipments and payments.';

  @override
  String get dashboardBannerDescRepresentative =>
      'Update the delivery status until the pharmacy receives it.';

  @override
  String dashboardServicesCount(Object count) {
    return '$count services';
  }

  @override
  String get homeShellSupply => 'Supply';

  @override
  String get homeShellAdmin => 'Admin';

  @override
  String get homeShellMedicines => 'Medicines';

  @override
  String get homeShellOrgManagement => 'Organization management';

  @override
  String get homeShellWarehouse => 'Warehouse';

  @override
  String get homeShellMyTasks => 'My tasks';

  @override
  String get modulesTitle => 'Your services';

  @override
  String get modulesSubtitle =>
      'Everything you need in one clear and fast place';

  @override
  String get moduleSearchMedicine => 'Search for medicine';

  @override
  String get moduleSearchMedicineDesc => 'Search in nearby pharmacies';

  @override
  String get moduleNearbyPharmacies => 'Nearby pharmacies';

  @override
  String get moduleNearbyPharmaciesDesc =>
      'Show the nearest ones and the route to them';

  @override
  String get moduleMyPrescriptions => 'My prescriptions';

  @override
  String get moduleMyPrescriptionsDesc =>
      'Analyze the prescription and track the booking';

  @override
  String get moduleMyRequests => 'My requests';

  @override
  String get moduleMyRequestsDesc => 'Track medicine availability requests';

  @override
  String get moduleMyHealthProfile => 'My health profile';

  @override
  String get moduleMyHealthProfileDesc => 'Your health data and card';

  @override
  String get moduleDonationsDesc => 'Medicine offers and assistance requests';

  @override
  String get moduleOrganizations => 'Organizations';

  @override
  String get moduleOrganizationsDesc => 'Campaigns and approved organizations';

  @override
  String get modulePharmacyAssistant => 'Pharmacy assistant';

  @override
  String get modulePharmacyAssistantDesc =>
      'Quick help and reliable information';

  @override
  String get moduleMedicineAlternatives => 'Medicine alternatives';

  @override
  String get moduleMedicineAlternativesDesc =>
      'Show similar options and comparison information';

  @override
  String get moduleInventoryDesc => 'Quantities, prices, and availability';

  @override
  String get moduleUserRequests => 'User requests';

  @override
  String get moduleUserRequestsDesc => 'Review requests and send your reply';

  @override
  String get modulePrescriptionOrders => 'Prescription orders';

  @override
  String get modulePrescriptionOrdersDesc =>
      'Prepare bookings and track their status';

  @override
  String get modulePharmacyLocation => 'Pharmacy location';

  @override
  String get modulePharmacyLocationDesc => 'Location and public data';

  @override
  String get moduleWorkingHoursDesc => 'Working hours and opening status';

  @override
  String get moduleMedicineCatalog => 'Medicine catalog';

  @override
  String get moduleMedicineCatalogDesc =>
      'Choose medicines to add to the inventory';

  @override
  String get moduleMedicineCatalogAdminDesc => 'Manage medicine data';

  @override
  String get moduleDonationVerification => 'Donation verification';

  @override
  String get moduleDonationVerificationDesc =>
      'Inspect packages and approve receiving them';

  @override
  String get moduleSupplyChain => 'Pharmacy supply';

  @override
  String get moduleSupplyChainDesc => 'Warehouses, orders, and inventory needs';

  @override
  String get moduleInventoryAnalysis => 'Inventory analysis';

  @override
  String get moduleInventoryAnalysisDesc =>
      'Medicine alternatives and upcoming needs forecast';

  @override
  String get moduleInventoryAnalysisWarehouseDesc =>
      'Forecast depletion and plan reordering';

  @override
  String get moduleCampaignsDesc => 'Create campaigns and track their status';

  @override
  String get moduleAssistanceDesc => 'Follow requests and update their status';

  @override
  String get moduleApprovals => 'Approvals';

  @override
  String get moduleApprovalsDesc => 'Pending pharmacies and organizations';

  @override
  String get moduleAccounts => 'Accounts';

  @override
  String get moduleAccountsDesc => 'View accounts and manage their status';

  @override
  String get moduleHomeTicker => 'Announcement ticker';

  @override
  String get moduleHomeTickerDesc => 'Announcements and on-call pharmacies';

  @override
  String get moduleAnalysisServices => 'Analysis services';

  @override
  String get moduleAnalysisServicesDesc =>
      'Test alternatives and forecast stock depletion';

  @override
  String get moduleWarehouseManagement => 'Warehouse management';

  @override
  String get moduleWarehouseManagementDesc =>
      'Inventory, orders, shipments, and invoices';

  @override
  String get moduleDeliveryTasks => 'Delivery tasks';

  @override
  String get moduleDeliveryTasksDesc =>
      'Track assigned shipments and update their status';

  @override
  String get errorTimeout => 'Connection timed out, please try again.';

  @override
  String get errorConnection =>
      'Could not connect to the server. Check your network and that the service is running.';

  @override
  String get errorGeneric => 'Could not complete the operation right now.';

  @override
  String get errorLocationRequired =>
      'Set your location first to view nearby pharmacies.';

  @override
  String get errorLocationCoordinates =>
      'Latitude and longitude must both be provided.';

  @override
  String get errorAwaitingApproval =>
      'Your account is awaiting administration approval.';

  @override
  String get errorAlreadyApproved => 'Already approved.';

  @override
  String get errorAlreadyRejected => 'The request was already rejected.';

  @override
  String get errorNotFound => 'Item not found.';

  @override
  String get errorAlreadyTaken => 'Value already in use.';

  @override
  String get errorLocationServiceDisabled =>
      'Location service is disabled. Enable it from device settings and try again.';

  @override
  String get errorLocationPermissionDenied =>
      'Location access was not allowed.';

  @override
  String get errorLocationPermissionForever =>
      'Location permission is disabled for this app. You can enable it from device settings.';

  @override
  String get errorLoginResponseIncomplete => 'Login response is incomplete.';

  @override
  String get errorSessionReadFailed => 'Could not read session data.';

  @override
  String get errorRegisterResponseIncomplete =>
      'Account creation response is incomplete.';

  @override
  String get errorNewAccountReadFailed =>
      'Could not read the new account data.';

  @override
  String get errorInvalidListResponse =>
      'The list response from the server is invalid.';

  @override
  String get adminCacheCleared => 'Old location data has been cleared.';
}
