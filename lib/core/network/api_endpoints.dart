abstract final class ApiEndpoints {
  // Authentication and shared account.
  static const authLogin = 'Auth/login';
  static const authRegisterUser = 'Auth/register/user';
  static const authRegisterPharmacy = 'Auth/register/pharmacy';
  static const authRegisterOrganization = 'Auth/register/organization';
  static const authRegisterWarehouse = 'Auth/register/warehouse';
  static const authForgotPassword = 'Auth/password/forgot';
  static const authResetPassword = 'Auth/password/reset';
  static const accountMe = 'account/me';
  static const accountProfile = 'account/me/profile';
  static const accountPassword = 'account/me/password';
  static const accountAvatar = 'account/me/avatar';
  static String accountAvatarByUser(String userId) => 'account/avatar/$userId';

  // User.
  static const userMe = 'Users/me';
  static const userDashboard = 'Users/me/dashboard';
  static const userMedicalProfile = 'Users/me/medical-profile';
  static const userHealthCard = 'Users/me/health-card';
  static const userLocation = 'Users/me/location';
  static const userLocationContext = 'Users/me/location-context';
  static const userNearestPharmacyRoute = 'Users/me/nearest-pharmacy-route';
  static const userMedicineSearch = 'Users/me/search-medicines';
  static const userNearestPharmacies = 'Users/me/nearest-pharmacies';
  static const userMedicineRequests = 'Users/me/medicine-requests';
  static const userSearchHistory = 'Users/me/search-history';
  static String userSearchHistoryItem(String historyId) =>
      'Users/me/search-history/$historyId';
  static String userPharmacy(String pharmacyId) =>
      'Users/me/pharmacies/$pharmacyId';
  static String userPharmacyRequest(String pharmacyId) =>
      'Users/me/pharmacies/$pharmacyId/medicine-requests';
  static String userMedicineRequest(String requestId) =>
      'Users/me/medicine-requests/$requestId';
  static String userCancelMedicineRequest(String requestId) =>
      'Users/me/medicine-requests/$requestId/cancel';
  static String userRatePharmacy(String pharmacyId) =>
      'Users/me/pharmacies/$pharmacyId/rating';

  // Public pharmacy discovery.
  static const pharmaciesRegisteredNearby = 'Pharmacies/registered/nearby';
  static const pharmaciesNearby = 'Pharmacies/nearby';
  static const pharmaciesSearch = 'Pharmacies/search';
  static const pharmaciesClosest = 'Pharmacies/closest';
  static const pharmaciesExternalClosest = 'Pharmacies/external/closest';
  static const pharmaciesPhoto = 'Pharmacies/photo';
  static const pharmaciesHealth = 'Pharmacies/health';
  static const pharmaciesCacheClear = 'Pharmacies/cache/clear';
  static String registeredPharmacy(String pharmacyId) =>
      'Pharmacies/registered/$pharmacyId';
  static String externalPharmacyDetails(String placeId) =>
      'Pharmacies/details/$placeId';

  // Pharmacy account.
  static const pharmacyMe = 'pharmacy/me';
  static const pharmacyDashboard = 'pharmacy/me/dashboard';
  static const pharmacyProfile = 'pharmacy/me/profile';
  static const pharmacyLocation = 'pharmacy/me/location';
  static const pharmacyLocationCandidates = 'pharmacy/me/location/candidates';
  static const pharmacyLocationLink = 'pharmacy/me/location/link';
  static const pharmacyOpenStatus = 'pharmacy/me/open-status';
  static const pharmacyWorkingHours = 'pharmacy/me/working-hours';
  static const pharmacyMedicines = 'pharmacy/me/medicines';
  static const pharmacyMedicinesManual = 'pharmacy/me/medicines/manual';
  static const pharmacyMedicinesBatch = 'pharmacy/me/medicines/batch';
  static const pharmacyRequests = 'pharmacy/me/requests';
  static const pharmacyMedicineCatalog = 'pharmacy/catalog/medicines';
  static String pharmacyMedicine(String inventoryItemId) =>
      'pharmacy/me/medicines/$inventoryItemId';
  static String pharmacyRequest(String requestId) =>
      'pharmacy/me/requests/$requestId';
  static String pharmacyRequestResponse(String requestId) =>
      'pharmacy/me/requests/$requestId/response';

  // Medicines.
  static const medicines = 'Medicines';
  static String medicine(String id) => 'Medicines/$id';

  // Notifications.
  static const notifications = 'Notifications/me';
  static const notificationSummary = 'Notifications/me/summary';
  static const notificationUnreadCount = 'Notifications/me/unread-count';
  static const notificationReadAll = 'Notifications/me/read-all';
  static String notificationRead(String id) => 'Notifications/$id/read';

  // Donations.
  static const donationOffers = 'donations/offers';
  static const myDonationOffers = 'donations/my/offers';
  static const assistanceRequests = 'donations/assistance-requests';
  static const myAssistanceRequests = 'donations/my/assistance-requests';
  static const donationVerificationPharmacies =
      'donations/verification-pharmacies';
  static const pharmacyDonationOffers = 'pharmacy/donations/offers';
  static String pharmacyDonationReview(String id) =>
      'pharmacy/donations/offers/$id/review';

  // Organization.
  static const organizationMe = 'organization/me';
  static const organizationDashboard = 'organization/me/dashboard';
  static const organizationProfile = 'organization/me/profile';
  static const organizationVerification = 'organization/me/verification';
  static const organizationVerificationDocuments =
      'organization/me/verification/documents';
  static const organizationCampaigns = 'organization/me/campaigns';
  static const organizationDonationOffers = 'organization/me/donation-offers';
  static const organizationAssistanceRequests =
      'organization/me/assistance-requests';
  static String organizationCampaignStatus(String id) =>
      'organization/me/campaigns/$id/status';
  static String organizationDonationReview(String id) =>
      'organization/me/donation-offers/$id/review';
  static String organizationAssistanceStatus(String id) =>
      'organization/me/assistance-requests/$id/status';
  static String organizationVerificationDocument(String id) =>
      'organization/me/verification/documents/$id';

  // Public organizations.
  static const organizations = 'organizations';
  static const activeCampaigns = 'organizations/campaigns/active';
  static String organization(String id) => 'organizations/$id';

  // Chat.
  static const chatSessions = 'Chat/sessions';
  static String chatSession(String id) => 'Chat/sessions/$id';
  static String chatMessages(String id) => 'Chat/sessions/$id/messages';
  static String chatEnd(String id) => 'Chat/sessions/$id/end';

  // Prescriptions.
  static const prescriptionAnalyze = 'prescriptions/analyze';
  static const myPrescriptions = 'prescriptions/mine';
  static const pharmacyPrescriptionOrders = 'prescriptions/pharmacy/orders';
  static String prescription(String id) => 'prescriptions/$id';
  static String prescriptionReserve(String id) => 'prescriptions/$id/reserve';
  static String prescriptionCancel(String id) => 'prescriptions/$id/cancel';
  static String prescriptionReminders(String id) =>
      'prescriptions/$id/reminders';
  static String pharmacyPrescriptionStatus(String id) =>
      'prescriptions/pharmacy/orders/$id/status';

  // Administration.
  static const adminDashboard = 'admin/dashboard';
  static const adminPendingPharmacies = 'admin/pharmacies/pending';
  static const adminPendingOrganizations = 'admin/organizations/pending';
  static const adminPendingWarehouses = 'admin/warehouses/pending';
  static const adminAccounts = 'admin/accounts';
  static const adminHomeTicker = 'admin/home-ticker';
  static const adminHomeTickerPharmacies = 'admin/home-ticker/pharmacies';
  static String adminPharmacyApproval(String id) =>
      'admin/pharmacies/$id/approval';
  static String adminOrganizationApproval(String id) =>
      'admin/organizations/$id/approval';
  static String adminWarehouseApproval(String id) =>
      'admin/warehouses/$id/approval';
  static String adminOrganizationVerification(String id) =>
      'admin/organizations/$id/verification';
  static String adminOrganizationVerificationDocument(
    String organizationId,
    String documentId,
  ) => 'admin/organizations/$organizationId/verification/documents/$documentId';
  static String adminAccount(String id) => 'admin/accounts/$id';
  static String adminAccountStatus(String id) => 'admin/accounts/$id/status';
  static String adminHomeTickerItem(String id) => 'admin/home-ticker/$id';

  static const homeTicker = 'home-ticker';

  // Supply chain.
  static const supplyWarehouseDashboard = 'supply-chain/warehouse/dashboard';
  static const supplyWarehouseBatches = 'supply-chain/warehouse/batches';
  static const supplyMarketplace = 'supply-chain/marketplace';
  static String supplyWarehouseCatalog(String id) =>
      'supply-chain/marketplace/$id/catalog';
  static const supplyOrders = 'supply-chain/orders';
  static const supplyRepresentatives = 'supply-chain/warehouse/representatives';
  static const supplyInvoices = 'supply-chain/invoices';
  static const supplyReturns = 'supply-chain/returns';
  static const supplyRecalls = 'supply-chain/recalls';
  static const supplyRestockSuggestions =
      'supply-chain/pharmacy/restock-suggestions';
  static String supplyBatch(String id) => 'supply-chain/warehouse/batches/$id';
  static String supplyOrderStatus(String id) =>
      'supply-chain/warehouse/orders/$id/status';
  static String supplyAssignShipment(String id) =>
      'supply-chain/warehouse/orders/$id/shipment';
  static String supplyRepresentative(String id) =>
      'supply-chain/warehouse/representatives/$id';
  static String supplyInvoice(String id) => 'supply-chain/invoices/$id';
  static String supplyWarehouseInvoice(String id) =>
      'supply-chain/warehouse/invoices/$id';
  static String supplyInvoicePayments(String id) =>
      'supply-chain/invoices/$id/payments';
  static String supplyRepresentativeShipment(String id) =>
      'supply-chain/representative/shipments/$id/status';
  static String supplyConfirmShipment(String id) =>
      'supply-chain/pharmacy/shipments/$id/confirm';
  static String supplyCreateReturn(String id) =>
      'supply-chain/pharmacy/orders/$id/returns';
  static String supplyReviewReturn(String id) =>
      'supply-chain/warehouse/returns/$id';
  static const supplyCreateRecall = 'supply-chain/warehouse/recalls';

  // Intelligence.
  static const intelligenceHealth = 'intelligence/health';
  static const intelligenceAlternatives = 'intelligence/alternatives';
  static const intelligenceStockout = 'intelligence/stockout';
}
