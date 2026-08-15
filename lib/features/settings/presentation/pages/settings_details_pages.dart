import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/theme/app_colors.dart';
import '../controllers/settings_controller.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(settingsControllerProvider).themeMode;
    return Scaffold(
      appBar: AppBar(title: const Text('المظهر')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _IntroCard(
            icon: Icons.palette_outlined,
            title: 'مظهر مريح لك',
            subtitle: 'اختر مظهر التطبيق أو اجعله يتبع إعداد جهازك.',
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: ThemeMode.values.map((value) {
                final data = switch (value) {
                  ThemeMode.system => (
                    'إعداد الجهاز',
                    'يتغير تلقائيًا مع مظهر الهاتف',
                    Icons.brightness_auto_outlined,
                  ),
                  ThemeMode.light => (
                    'فاتح',
                    'ألوان واضحة ومضيئة',
                    Icons.light_mode_outlined,
                  ),
                  ThemeMode.dark => (
                    'داكن',
                    'أكثر راحة في الإضاءة المنخفضة',
                    Icons.dark_mode_outlined,
                  ),
                };
                final selected = value == mode;
                return ListTile(
                  onTap: () => ref
                      .read(settingsControllerProvider.notifier)
                      .setThemeMode(value),
                  leading: Icon(data.$3, color: context.appColors.primary),
                  title: Text(data.$1),
                  subtitle: Text(data.$2),
                  trailing: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected ? context.appColors.primary : context.appColors.border,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final enabled = preferences.notificationsEnabled;
    return Scaffold(
      appBar: AppBar(title: const Text('تفضيلات الإشعارات')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _IntroCard(
            icon: Icons.notifications_active_outlined,
            title: 'ابقَ على اطلاع',
            subtitle:
                'تحكم بأنواع التنبيهات التي يعرضها التطبيق لك. صلاحية الإشعارات تُدار من إعدادات الهاتف.',
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: enabled,
                  onChanged: controller.setNotificationsEnabled,
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('الإشعارات داخل التطبيق'),
                  subtitle: const Text('تشغيل أو إيقاف عرض التنبيهات'),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.requestUpdates,
                  onChanged: enabled ? controller.setRequestUpdates : null,
                  secondary: const Icon(Icons.receipt_long_outlined),
                  title: const Text('تحديثات الطلبات'),
                  subtitle: const Text('حالة طلب الدواء والتجهيز والاستجابة'),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.healthReminders,
                  onChanged: enabled ? controller.setHealthReminders : null,
                  secondary: const Icon(Icons.alarm_outlined),
                  title: const Text('التذكيرات الصحية'),
                  subtitle: const Text(
                    'مواعيد الدواء والتنبيهات المرتبطة بصحتك',
                  ),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SwitchListTile(
                  value: enabled && preferences.campaignUpdates,
                  onChanged: enabled ? controller.setCampaignUpdates : null,
                  secondary: const Icon(Icons.volunteer_activism_outlined),
                  title: const Text('الحملات والمبادرات'),
                  subtitle: const Text('المستجدات المتعلقة بالتبرعات والحملات'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionsSettingsPage extends StatefulWidget {
  const PermissionsSettingsPage({super.key});

  @override
  State<PermissionsSettingsPage> createState() =>
      _PermissionsSettingsPageState();
}

class _PermissionsSettingsPageState extends State<PermissionsSettingsPage> {
  LocationPermission? _locationPermission;
  bool _serviceEnabled = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final values = await Future.wait([
      Geolocator.isLocationServiceEnabled(),
      Geolocator.checkPermission(),
    ]);
    if (!mounted) return;
    setState(() {
      _serviceEnabled = values[0] as bool;
      _locationPermission = values[1] as LocationPermission;
    });
  }

  Future<void> _requestLocation() async {
    await Geolocator.requestPermission();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final granted =
        _locationPermission == LocationPermission.always ||
        _locationPermission == LocationPermission.whileInUse;
    return Scaffold(
      appBar: AppBar(title: const Text('صلاحيات الجهاز')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _IntroCard(
            icon: Icons.admin_panel_settings_outlined,
            title: 'أنت المتحكم',
            subtitle:
                'يطلب دوائي الصلاحية عند الحاجة فقط، ويمكنك تعديلها من إعدادات هاتفك.',
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.appColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('الموقع'),
                  subtitle: Text(
                    granted
                        ? _serviceEnabled
                              ? 'مسموح أثناء استخدام التطبيق'
                              : 'الصلاحية متاحة، وخدمة الموقع متوقفة'
                        : 'غير مسموح حاليًا',
                  ),
                  trailing: granted
                      ? Icon(Icons.check_circle, color: context.appColors.success)
                      : TextButton(
                          onPressed: _requestLocation,
                          child: const Text('سماح'),
                        ),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                const ListTile(
                  leading: Icon(Icons.camera_alt_outlined),
                  title: Text('الكاميرا والملفات'),
                  subtitle: Text('تُطلب فقط عند اختيار صورة أو مستند لإرساله'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!_serviceEnabled)
            OutlinedButton.icon(
              onPressed: Geolocator.openLocationSettings,
              icon: const Icon(Icons.location_searching_rounded),
              label: const Text('فتح إعدادات الموقع'),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: Geolocator.openAppSettings,
            icon: const Icon(Icons.settings_outlined),
            label: const Text('فتح إعدادات التطبيق في الهاتف'),
          ),
        ],
      ),
    );
  }
}

enum InformationPageKind { privacy, terms, help, about }

class InformationPage extends StatelessWidget {
  const InformationPage({required this.kind, super.key});

  final InformationPageKind kind;

  @override
  Widget build(BuildContext context) {
    final data = switch (kind) {
      InformationPageKind.privacy => (
        'الخصوصية',
        Icons.shield_outlined,
        <(String, String)>[
          (
            'بيانات الحساب',
            'نستخدم بيانات الحساب لتقديم الخدمات المرتبطة بدورك داخل النظام.',
          ),
          (
            'الموقع',
            'يُستخدم موقعك عند طلب البحث عن الصيدليات القريبة أو حساب المسار، ويمكنك إيقاف الصلاحية من هاتفك.',
          ),
          (
            'البيانات الصحية',
            'تُرسل البيانات التي تدخلها إلى الخادم لتقديم المزايا الصحية المطلوبة، ولا ينبغي مشاركة بيانات الدخول مع أي شخص.',
          ),
          (
            'التحكم',
            'يمكنك تعديل بياناتك وكلمة مرورك وصلاحيات الجهاز من صفحات الحساب والإعدادات.',
          ),
        ],
      ),
      InformationPageKind.terms => (
        'شروط الاستخدام',
        Icons.description_outlined,
        <(String, String)>[
          (
            'دقة المعلومات',
            'اعتمد على العبوة والصيدلي أو الطبيب في القرارات الطبية؛ المعلومات داخل التطبيق مساندة وليست بديلًا عن المختص.',
          ),
          (
            'الاستخدام المسؤول',
            'يجب إدخال بيانات صحيحة وعدم إساءة استخدام الطلبات أو التبرعات أو حسابات الجهات.',
          ),
          (
            'الطوارئ',
            'لا يُستخدم التطبيق لطلب إسعاف أو معالجة حالة طارئة؛ تواصل مع خدمات الطوارئ المحلية فورًا.',
          ),
          (
            'الحساب',
            'أنت مسؤول عن الحفاظ على سرية بيانات الدخول والإبلاغ عن أي استخدام غير معتاد.',
          ),
        ],
      ),
      InformationPageKind.help => (
        'المساعدة',
        Icons.help_outline_rounded,
        <(String, String)>[
          (
            'الخريطة لا تظهر',
            'تأكد من تشغيل خدمة الموقع ومنح التطبيق صلاحية الموقع، ثم أعد تحميل الصفحة.',
          ),
          (
            'تعذر الاتصال',
            'تأكد أن الهاتف والخادم على الشبكة نفسها وأن عنوان الخادم صحيح ومتاح.',
          ),
          (
            'لم يصل رمز الاستعادة',
            'تحقق من البريد غير المرغوب فيه ثم اطلب رمزًا جديدًا. أثناء التطوير المحلي يظهر الرمز داخل صفحة الاستعادة.',
          ),
          (
            'مشكلة في الحساب',
            'جرّب تسجيل الخروج والدخول مجددًا، وتأكد من اعتماد حساب الجهة إن كان يتطلب موافقة الإدارة.',
          ),
        ],
      ),
      InformationPageKind.about => (
        'عن دوائي',
        Icons.info_outline_rounded,
        <(String, String)>[
          (
            'دوائي',
            'منصة تربط المستخدم بالصيدليات والمنظمات وسلسلة توريد الدواء ضمن تجربة موحدة.',
          ),
          (
            'هدف المشروع',
            'تسهيل العثور على الدواء، متابعة الطلبات، دعم المبادرات الدوائية، وتنظيم عمل الجهات المشاركة.',
          ),
          ('الإصدار', '1.0.0'),
          (
            'تنبيه طبي',
            'لا يقدم التطبيق تشخيصًا طبيًا، ويجب الرجوع إلى الطبيب أو الصيدلي عند الحاجة.',
          ),
        ],
      ),
    };
    return Scaffold(
      appBar: AppBar(title: Text(data.$1)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _IntroCard(icon: data.$2, title: data.$1, subtitle: data.$3.first.$2),
          const SizedBox(height: 18),
          ...data.$3
              .skip(1)
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: context.appColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(section.$2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.appColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: context.appColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
