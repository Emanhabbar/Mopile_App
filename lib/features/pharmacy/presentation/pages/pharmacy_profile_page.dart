import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/location/device_location_service.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyProfilePage extends ConsumerStatefulWidget {
  const PharmacyProfilePage({super.key});
  @override
  ConsumerState<PharmacyProfilePage> createState() =>
      _PharmacyProfilePageState();
}

class _PharmacyProfilePageState extends ConsumerState<PharmacyProfilePage> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _city = TextEditingController();
  final _area = TextEditingController();
  final _address = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  bool _delivery = false;
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _description,
      _city,
      _area,
      _address,
      _latitude,
      _longitude,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الصيدلية'),
        actions: [
          IconButton(
            onPressed: () {
              _initialized = false;
              ref.invalidate(pharmacyProfileProvider);
            },
            tooltip: 'تحديث البيانات',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () =>
            const AppLoadingState(label: 'جاري تحميل ملف الصيدلية...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(pharmacyProfileProvider),
        ),
        data: (data) {
          _initialize(data);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _ProfileHeader(data: data),
              const SizedBox(height: 18),
              _Section(
                title: 'البيانات العامة',
                subtitle: 'المعلومات التي تظهر للمستخدم عند فتح الصيدلية',
                icon: Icons.storefront_outlined,
                child: Column(
                  children: [
                    _Field(
                      label: 'اسم الصيدلية',
                      controller: _name,
                      icon: Icons.local_pharmacy_outlined,
                    ),
                    _Field(
                      label: 'المدينة',
                      controller: _city,
                      icon: Icons.location_city_outlined,
                    ),
                    _Field(
                      label: 'المنطقة',
                      controller: _area,
                      icon: Icons.map_outlined,
                    ),
                    _Field(
                      label: 'العنوان التفصيلي',
                      controller: _address,
                      icon: Icons.signpost_outlined,
                    ),
                    _Field(
                      label: 'وصف الصيدلية',
                      controller: _description,
                      maxLines: 4,
                      icon: Icons.notes_rounded,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SwitchListTile(
                        value: _delivery,
                        onChanged: (value) => setState(() => _delivery = value),
                        secondary: const Icon(
                          Icons.delivery_dining_outlined,
                          color: AppColors.primary,
                        ),
                        title: const Text('خدمة توصيل الأدوية'),
                        subtitle: const Text('أخبر المستخدمين بتوفر التوصيل'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _saveProfile,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('حفظ الملف'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'موقع الصيدلية',
                subtitle: 'موقع دقيق يساعد المستخدم في العثور عليك بسهولة',
                icon: Icons.location_on_outlined,
                child: Column(
                  children: [
                    _LocationMethod(
                      icon: Icons.my_location_rounded,
                      title: 'تحديد تلقائي',
                      subtitle: 'استخدم موقع هذا الجهاز',
                      onTap: _saving ? null : _useGps,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'أو أدخل الإحداثيات يدويًا',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _Field(
                            label: 'خط العرض',
                            controller: _latitude,
                            number: true,
                            icon: Icons.north_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Field(
                            label: 'خط الطول',
                            controller: _longitude,
                            number: true,
                            icon: Icons.east_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _saveLocation,
                        icon: const Icon(Icons.location_on_rounded),
                        label: const Text('حفظ الإحداثيات'),
                      ),
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _saving ? null : _findRegisteredPlace,
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('مطابقة الموقع مع المكان المسجل'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _initialize(PharmacyDashboard data) {
    if (_initialized) return;
    _name.text = data.pharmacyName;
    _description.text = data.description ?? '';
    _city.text = data.city;
    _area.text = data.area;
    _address.text = data.address;
    _latitude.text = data.latitude?.toStringAsFixed(6) ?? '';
    _longitude.text = data.longitude?.toStringAsFixed(6) ?? '';
    _delivery = data.hasDeliveryService;
    _initialized = true;
  }

  Future<void> _saveProfile() async {
    if (_name.text.trim().isEmpty ||
        _city.text.trim().isEmpty ||
        _area.text.trim().isEmpty ||
        _address.text.trim().isEmpty) {
      _message('أكمل اسم الصيدلية والمدينة والمنطقة والعنوان.', true);
      return;
    }
    await _perform(
      () => ref
          .read(pharmacyRepositoryProvider)
          .remote
          .updateProfile(
            pharmacyName: _name.text.trim(),
            city: _city.text.trim(),
            area: _area.text.trim(),
            address: _address.text.trim(),
            description: _description.text.trim(),
            hasDeliveryService: _delivery,
          ),
      'تم حفظ بيانات الصيدلية.',
    );
  }

  Future<void> _useGps() async {
    setState(() => _saving = true);
    try {
      final location = await ref
          .read(deviceLocationServiceProvider)
          .determineCurrent();
      _latitude.text = location.latitude.toStringAsFixed(7);
      _longitude.text = location.longitude.toStringAsFixed(7);
      await _updateLocation(
        location.latitude,
        location.longitude,
        location.accuracyMeters,
      );
    } catch (error) {
      _message(_error(error), true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveLocation() async {
    final lat = double.tryParse(_latitude.text.trim());
    final lng = double.tryParse(_longitude.text.trim());
    if (lat == null || lat < -90 || lat > 90) {
      _message('أدخل خط عرض صحيحًا بين -90 و90.', true);
      return;
    }
    if (lng == null || lng < -180 || lng > 180) {
      _message('أدخل خط طول صحيحًا بين -180 و180.', true);
      return;
    }
    await _perform(() => _updateLocation(lat, lng, null), 'تم حفظ الموقع.');
  }

  Future<void> _findRegisteredPlace() async {
    final lat = double.tryParse(_latitude.text.trim());
    final lng = double.tryParse(_longitude.text.trim());
    setState(() => _saving = true);
    try {
      final candidates = await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .getLocationCandidates(latitude: lat, longitude: lng);
      if (!mounted) return;
      final selected = await showModalBottomSheet<PharmacyLocationCandidate>(
        context: context,
        useSafeArea: true,
        builder: (context) => ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'اختر المكان الصحيح',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (candidates.isEmpty)
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'لم يتم العثور على مكان مطابق بالقرب من الإحداثيات.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...candidates.map(
                (candidate) => Card(
                  child: ListTile(
                    leading: Icon(
                      candidate.isBestMatch
                          ? Icons.verified_rounded
                          : Icons.location_on_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(candidate.name),
                    subtitle: Text(
                      '${candidate.address}\n'
                      '${candidate.distanceMeters.round()} م · '
                      '${candidate.rating.toStringAsFixed(1)} ★',
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.pop(context, candidate),
                  ),
                ),
              ),
          ],
        ),
      );
      if (selected == null) return;
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .linkLocation(selected.placeId);
      ref
        ..invalidate(pharmacyProfileProvider)
        ..invalidate(pharmacyDashboardProvider);
      _initialized = false;
      _message('تم ربط موقع الصيدلية بالمكان المسجل.', false);
    } catch (error) {
      _message(_error(error), true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<PharmacyDashboard> _updateLocation(
    double lat,
    double lng,
    double? accuracy,
  ) => ref
      .read(pharmacyRepositoryProvider)
      .remote
      .updateLocation(
        latitude: lat,
        longitude: lng,
        accuracyMeters: accuracy,
        city: _city.text.trim(),
        area: _area.text.trim(),
        address: _address.text.trim(),
      );

  Future<void> _perform(
    Future<PharmacyDashboard> Function() action,
    String success,
  ) async {
    setState(() => _saving = true);
    try {
      await action();
      ref
        ..invalidate(pharmacyProfileProvider)
        ..invalidate(pharmacyDashboardProvider);
      _message(success, false);
    } catch (error) {
      _message(_error(error), true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String text, bool error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? AppColors.danger : null,
      ),
    );
  }

  String _error(Object error) =>
      error is ApiException ? error.message : 'تعذر حفظ البيانات.';
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.data});
  final PharmacyDashboard data;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_pharmacy_rounded,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.pharmacyName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${data.city} · ${data.area}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              data.isApproved
                  ? Icons.verified_rounded
                  : Icons.hourglass_top_rounded,
              color: data.isApproved ? AppColors.secondary : Colors.white70,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _HeaderBadge(
              icon: Icons.shield_outlined,
              text: data.isApproved ? 'حساب معتمد' : 'بانتظار الاعتماد',
            ),
            const SizedBox(width: 8),
            _HeaderBadge(
              icon: Icons.location_on_outlined,
              text: data.hasLocation ? 'الموقع محفوظ' : 'الموقع غير مكتمل',
            ),
          ],
        ),
      ],
    ),
  );
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 15),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.number = false,
    this.icon,
  });
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool number;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: number
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
    ),
  );
}

class _LocationMethod extends StatelessWidget {
  const _LocationMethod({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surfaceSoft,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
          ],
        ),
      ),
    ),
  );
}
