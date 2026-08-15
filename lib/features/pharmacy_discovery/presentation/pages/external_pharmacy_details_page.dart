import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_discovery_models.dart';
import '../controllers/pharmacy_discovery_providers.dart';

class ExternalPharmacyDetailsPage extends ConsumerWidget {
  const ExternalPharmacyDetailsPage({required this.placeId, super.key});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(externalPharmacyDetailsProvider(placeId));
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الصيدلية')),
      body: state.when(
        loading: () =>
            const AppLoadingState(label: 'جاري تحميل بيانات الصيدلية...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(externalPharmacyDetailsProvider(placeId)),
        ),
        data: (pharmacy) => RefreshIndicator(
          onRefresh: () =>
              ref.refresh(externalPharmacyDetailsProvider(placeId).future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
            children: [
              _PhotoHeader(pharmacy: pharmacy),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: pharmacy.address,
                      ),
                      const SizedBox(height: 10),
                      _InfoLine(
                        icon: Icons.schedule_rounded,
                        text: pharmacy.isOpenNow ? 'مفتوحة الآن' : 'مغلقة الآن',
                        color: pharmacy.isOpenNow
                            ? context.appColors.primary
                            : context.appColors.danger,
                      ),
                      if (pharmacy.rating > 0) ...[
                        const SizedBox(height: 10),
                        _InfoLine(
                          icon: Icons.star_rounded,
                          text:
                              '${pharmacy.rating.toStringAsFixed(1)} من ${pharmacy.totalRatings} تقييم',
                          color: context.appColors.secondary,
                        ),
                      ],
                      if (pharmacy.distanceMeters > 0) ...[
                        const SizedBox(height: 10),
                        _InfoLine(
                          icon: Icons.route_outlined,
                          text: _distance(pharmacy.distanceMeters),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: pharmacy.googleMapsUrl.isEmpty
                    ? null
                    : () => _openDirections(pharmacy.googleMapsUrl),
                icon: const Icon(Icons.navigation_rounded),
                label: const Text('فتح الاتجاهات'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'هذه الصيدلية معروضة من خدمة الخرائط وقد لا تكون مسجلة داخل منصة دوائي.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDirections(String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PhotoHeader extends StatelessWidget {
  const _PhotoHeader({required this.pharmacy});

  final ExternalPharmacy pharmacy;

  @override
  Widget build(BuildContext context) {
    final photoUri = pharmacy.photoUrl == null
        ? null
        : Uri.parse(AppConfig.apiBaseUrl).resolve(pharmacy.photoUrl!);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 210,
        child: photoUri == null
            ? ColoredBox(
                color: context.appColors.surfaceSoft,
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: context.appColors.primary,
                    size: 65,
                  ),
                ),
              )
            : Image.network(
                photoUri.toString(),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: context.appColors.surfaceSoft,
                  child: Center(
                    child: Icon(
                      Icons.local_pharmacy_rounded,
                      color: context.appColors.primary,
                      size: 65,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: color ?? context.appColors.textMuted, size: 21),
      const SizedBox(width: 9),
      Expanded(child: Text(text)),
    ],
  );
}

String _distance(double meters) => meters < 1000
    ? '${meters.round()} متر'
    : '${(meters / 1000).toStringAsFixed(1)} كم';
