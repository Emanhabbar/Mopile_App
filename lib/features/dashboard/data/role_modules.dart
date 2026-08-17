import 'package:flutter/material.dart';

import '../../../core/constants/app_roles.dart';
import '../../../shared/models/feature_module.dart';

const Color _modulePrimary = Color(0xFF216474);
const Color _modulePrimaryLight = Color(0xFF8BD0CB);
const Color _modulePrimaryDark = Color(0xFF174B57);

List<FeatureModule> modulesForRole(AppRole role) {
  return switch (role) {
    AppRole.user => const [
      FeatureModule(
        title: 'البحث عن دواء',
        description: 'ابحث في الصيدليات القريبة',
        icon: Icons.medication_liquid_rounded,
        color: _modulePrimary,
        routeName: 'medicine-search',
      ),
      FeatureModule(
        title: 'الصيدليات القريبة',
        description: 'اعرض الأقرب والمسار إليها',
        icon: Icons.map_rounded,
        color: _modulePrimary,
        routeName: 'nearby-pharmacies',
      ),
      FeatureModule(
        title: 'وصفاتي',
        description: 'حلّل الوصفة وتابع الحجز',
        icon: Icons.receipt_long_rounded,
        color: _modulePrimary,
        routeName: 'prescriptions',
      ),
      FeatureModule(
        title: 'طلباتي',
        description: 'تابع طلبات توفر الأدوية',
        icon: Icons.inventory_2_rounded,
        color: _modulePrimary,
        routeName: 'medicine-requests',
      ),
      FeatureModule(
        title: 'ملفي الصحي',
        description: 'بياناتك الصحية والبطاقة',
        icon: Icons.health_and_safety_rounded,
        color: _modulePrimary,
        routeName: 'health-profile',
      ),
      FeatureModule(
        title: 'التبرعات',
        description: 'عروض الدواء وطلبات المساعدة',
        icon: Icons.volunteer_activism_rounded,
        color: _modulePrimary,
        routeName: 'donations',
      ),
      FeatureModule(
        title: 'المنظمات',
        description: 'الحملات والمنظمات المعتمدة',
        icon: Icons.apartment_rounded,
        color: _modulePrimary,
        routeName: 'organizations',
      ),
      FeatureModule(
        title: 'المساعد الدوائي',
        description: 'مساعدة سريعة ومعلومات موثوقة',
        icon: Icons.chat_bubble_rounded,
        color: _modulePrimary,
        routeName: 'chat',
      ),
      FeatureModule(
        title: 'البدائل الدوائية',
        description: 'اعرض خيارات مشابهة ومعلومات المقارنة',
        icon: Icons.compare_arrows_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.pharmacy => const [
      FeatureModule(
        title: 'مخزون الأدوية',
        description: 'الكميات والأسعار والتوفر',
        icon: Icons.inventory_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-inventory',
      ),
      FeatureModule(
        title: 'طلبات المستخدمين',
        description: 'راجع الطلبات وأرسل الرد',
        icon: Icons.assignment_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-requests',
      ),
      FeatureModule(
        title: 'طلبات الوصفات',
        description: 'جهّز الحجوزات وتابع حالتها',
        icon: Icons.receipt_long_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-prescriptions',
      ),
      FeatureModule(
        title: 'موقع الصيدلية',
        description: 'الموقع والبيانات العامة',
        icon: Icons.location_on_rounded,
        color: _modulePrimary,
        routeName: 'pharmacy-profile',
      ),
      FeatureModule(
        title: 'ساعات العمل',
        description: 'أوقات الدوام وحالة الفتح',
        icon: Icons.schedule_rounded,
        color: _modulePrimary,
        routeName: 'working-hours',
      ),
      FeatureModule(
        title: 'دليل الأدوية',
        description: 'اختر الأدوية لإضافتها للمخزون',
        icon: Icons.medication_rounded,
        color: _modulePrimary,
        routeName: 'medicine-catalog',
      ),
      FeatureModule(
        title: 'التحقق من التبرعات',
        description: 'فحص العبوات واعتماد استلامها',
        icon: Icons.verified_outlined,
        color: _modulePrimary,
        routeName: 'pharmacy-donations',
      ),
      FeatureModule(
        title: 'توريد الصيدلية',
        description: 'المستودعات والطلبات واحتياج المخزون',
        icon: Icons.local_shipping_outlined,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
      FeatureModule(
        title: 'تحليل المخزون',
        description: 'بدائل الأدوية وتوقع الاحتياج القادم',
        icon: Icons.auto_graph_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.organization => const [
      FeatureModule(
        title: 'الحملات',
        description: 'أنشئ الحملات وتابع حالتها',
        icon: Icons.campaign_rounded,
        color: _modulePrimary,
        routeName: 'campaigns',
      ),
      FeatureModule(
        title: 'عروض التبرع',
        description: 'راجع الأدوية المعروضة',
        icon: Icons.volunteer_activism_rounded,
        color: _modulePrimary,
        routeName: 'donation-offers',
      ),
      FeatureModule(
        title: 'طلبات المساعدة',
        description: 'تابع الطلبات وحدّث حالتها',
        icon: Icons.support_agent_rounded,
        color: _modulePrimary,
        routeName: 'assistance-requests',
      ),
      FeatureModule(
        title: 'ملف المنظمة',
        description: 'البيانات ووثائق التحقق',
        icon: Icons.verified_rounded,
        color: _modulePrimary,
        routeName: 'organization-profile',
      ),
    ],
    AppRole.admin => const [
      FeatureModule(
        title: 'الموافقات',
        description: 'الصيدليات والمنظمات المعلقة',
        icon: Icons.fact_check_rounded,
        color: _modulePrimary,
        routeName: 'approvals',
      ),
      FeatureModule(
        title: 'الحسابات',
        description: 'عرض الحسابات وإدارة حالتها',
        icon: Icons.manage_accounts_rounded,
        color: _modulePrimary,
        routeName: 'accounts',
      ),
      FeatureModule(
        title: 'شريط الإعلانات',
        description: 'الإعلانات والصيدليات المناوبة',
        icon: Icons.campaign_rounded,
        color: _modulePrimary,
        routeName: 'home-ticker',
      ),
      FeatureModule(
        title: 'دليل الأدوية',
        description: 'إدارة بيانات الأدوية',
        icon: Icons.medication_rounded,
        color: _modulePrimary,
        routeName: 'medicine-catalog',
      ),
      FeatureModule(
        title: 'خدمات التحليل',
        description: 'اختبار البدائل وتوقع نفاد المخزون',
        icon: Icons.psychology_alt_outlined,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.warehouse => const [
      FeatureModule(
        title: 'إدارة المستودع',
        description: 'المخزون والطلبات والشحنات والفواتير',
        icon: Icons.warehouse_rounded,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
      FeatureModule(
        title: 'تحليل المخزون',
        description: 'توقع النفاد وتخطيط إعادة الطلب',
        icon: Icons.auto_graph_rounded,
        color: _modulePrimary,
        routeName: 'intelligence',
      ),
    ],
    AppRole.representative => const [
      FeatureModule(
        title: 'مهام التوصيل',
        description: 'تابع الشحنات المسندة وحدّث حالتها',
        icon: Icons.delivery_dining_rounded,
        color: _modulePrimary,
        routeName: 'supply-chain',
      ),
    ],
  };
}
