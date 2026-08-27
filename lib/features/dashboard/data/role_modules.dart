import 'package:flutter/material.dart';

import '../../../core/constants/app_roles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/feature_module.dart';

const Color _modulePrimary = Color(0xFF216474);

List<FeatureModule> modulesForRole(AppLocalizations l10n, AppRole role) {
  return switch (role) {
    AppRole.user => [
      FeatureModule(
        title: l10n.moduleSearchMedicine,
        description: l10n.moduleSearchMedicineDesc,
        icon: Icons.medication_liquid_rounded,
        color: _modulePrimary,
        routeName: 'medicine-search',
      ),
      FeatureModule(
        title: l10n.moduleNearbyPharmacies,
        description: l10n.moduleNearbyPharmaciesDesc,
        icon: Icons.map_rounded,
        color: _modulePrimary,
        routeName: 'nearby-pharmacies',
      ),
      FeatureModule(
        title: l10n.moduleMyPrescriptions,
        description: l10n.moduleMyPrescriptionsDesc,
        icon: Icons.receipt_long_rounded,
        color: _modulePrimary,
        routeName: 'prescriptions',
      ),
      FeatureModule(
        title: l10n.moduleMyRequests,
        description: l10n.moduleMyRequestsDesc,
        icon: Icons.inventory_2_rounded,
        color: _modulePrimary,
        routeName: 'medicine-requests',
      ),
      FeatureModule(
        title: l10n.moduleMyHealthProfile,
        description: l10n.moduleMyHealthProfileDesc,
        icon: Icons.health_and_safety_rounded,
        color: _modulePrimary,
        routeName: 'health-profile',
      ),
      FeatureModule(
        title: l10n.donationsLabel,
        description: l10n.moduleDonationsDesc,
        icon: Icons.volunteer_activism_rounded,
        color: _modulePrimary,
        routeName: 'donations',
      ),
      FeatureModule(
        title: l10n.moduleOrganizations,
        description: l10n.moduleOrganizationsDesc,
        icon: Icons.apartment_rounded,
        color: _modulePrimary,
        routeName: 'organizations',
      ),
      FeatureModule(
        title: l10n.modulePharmacyAssistant,
        description: l10n.modulePharmacyAssistantDesc,
        icon: Icons.chat_bubble_rounded,
        color: _modulePrimary,
        routeName: 'chat',
      ),
      FeatureModule(
        title: l10n.moduleMedicineAlternatives,
        description: l10n.moduleMedicineAlternativesDesc,
        icon: Icons.compare_arrows_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.pharmacy => [
      FeatureModule(
        title: l10n.inventoryTitle,
        description: l10n.moduleInventoryDesc,
        icon: Icons.inventory_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-inventory',
      ),
      FeatureModule(
        title: l10n.moduleUserRequests,
        description: l10n.moduleUserRequestsDesc,
        icon: Icons.assignment_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-requests',
      ),
      FeatureModule(
        title: l10n.modulePrescriptionOrders,
        description: l10n.modulePrescriptionOrdersDesc,
        icon: Icons.receipt_long_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-prescriptions',
      ),
      FeatureModule(
        title: l10n.modulePharmacyLocation,
        description: l10n.modulePharmacyLocationDesc,
        icon: Icons.location_on_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-profile',
      ),
      FeatureModule(
        title: l10n.workingHours,
        description: l10n.moduleWorkingHoursDesc,
        icon: Icons.schedule_rounded,
        color: _modulePrimary,
        routeName: 'working-hours',
      ),
      FeatureModule(
        title: l10n.moduleMedicineCatalog,
        description: l10n.moduleMedicineCatalogDesc,
        icon: Icons.medication_rounded,
        color: _modulePrimary,
        routeName: 'medicine-catalog',
      ),
      FeatureModule(
        title: l10n.moduleDonationVerification,
        description: l10n.moduleDonationVerificationDesc,
        icon: Icons.verified_outlined,
        color: _modulePrimary,
        routeName: 'pharmacy-donations',
      ),
      FeatureModule(
        title: l10n.moduleSupplyChain,
        description: l10n.moduleSupplyChainDesc,
        icon: Icons.local_shipping_outlined,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
      FeatureModule(
        title: l10n.moduleInventoryAnalysis,
        description: l10n.moduleInventoryAnalysisDesc,
        icon: Icons.auto_graph_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.organization => [
      FeatureModule(
        title: l10n.campaignsLabel,
        description: l10n.moduleCampaignsDesc,
        icon: Icons.campaign_rounded,
        color: _modulePrimary,
        routeName: 'campaigns',
      ),
      FeatureModule(
        title: l10n.donationOffersTitle,
        description: l10n.reviewOfferedMedicines,
        icon: Icons.volunteer_activism_rounded,
        color: _modulePrimary,
        routeName: 'donation-offers',
      ),
      FeatureModule(
        title: l10n.assistanceRequestsTitle,
        description: l10n.moduleAssistanceDesc,
        icon: Icons.support_agent_rounded,
        color: _modulePrimary,
        routeName: 'assistance-requests',
      ),
      FeatureModule(
        title: l10n.orgProfile,
        description: l10n.dataAndVerificationDocs,
        icon: Icons.verified_rounded,
        color: _modulePrimary,
        routeName: 'organization-profile',
      ),
    ],
    AppRole.admin => [
      FeatureModule(
        title: l10n.moduleApprovals,
        description: l10n.moduleApprovalsDesc,
        icon: Icons.fact_check_rounded,
        color: _modulePrimary,
        routeName: 'approvals',
      ),
      FeatureModule(
        title: l10n.moduleAccounts,
        description: l10n.moduleAccountsDesc,
        icon: Icons.manage_accounts_rounded,
        color: _modulePrimary,
        routeName: 'accounts',
      ),
      FeatureModule(
        title: l10n.moduleHomeTicker,
        description: l10n.moduleHomeTickerDesc,
        icon: Icons.campaign_rounded,
        color: _modulePrimary,
        routeName: 'home-ticker',
      ),
      FeatureModule(
        title: l10n.moduleMedicineCatalog,
        description: l10n.moduleMedicineCatalogAdminDesc,
        icon: Icons.medication_rounded,
        color: _modulePrimary,
        routeName: 'medicine-catalog',
      ),
      FeatureModule(
        title: l10n.moduleAnalysisServices,
        description: l10n.moduleAnalysisServicesDesc,
        icon: Icons.psychology_alt_outlined,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.warehouse => [
      FeatureModule(
        title: l10n.moduleWarehouseManagement,
        description: l10n.moduleWarehouseManagementDesc,
        icon: Icons.warehouse_rounded,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
      FeatureModule(
        title: l10n.moduleInventoryAnalysis,
        description: l10n.moduleInventoryAnalysisWarehouseDesc,
        icon: Icons.auto_graph_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.representative => [
      FeatureModule(
        title: l10n.moduleDeliveryTasks,
        description: l10n.moduleDeliveryTasksDesc,
        icon: Icons.delivery_dining_rounded,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
    ],
  };
}
