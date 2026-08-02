import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/user_request_models.dart';
import '../controllers/user_providers.dart';

class MedicineRequestsPage extends ConsumerStatefulWidget {
  const MedicineRequestsPage({super.key});

  @override
  ConsumerState<MedicineRequestsPage> createState() =>
      _MedicineRequestsPageState();
}

class _MedicineRequestsPageState extends ConsumerState<MedicineRequestsPage> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(userMedicineRequestsProvider(_status));
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        actions: [
          IconButton(
            onPressed: () => context.push('/user/search-history'),
            tooltip: 'سجل البحث',
            icon: const Icon(Icons.history_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
            child: AppReveal(
              child: _RequestsIntro(
                onNewRequest: () => context.push('/user/search'),
              ),
            ),
          ),
          AppReveal(
            delay: const Duration(milliseconds: 70),
            child: _StatusFilters(
              value: _status,
              onChanged: (value) => setState(() => _status = value),
            ),
          ),
          Expanded(
            child: requests.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل طلباتك...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () =>
                    ref.invalidate(userMedicineRequestsProvider(_status)),
              ),
              data: (items) => RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(userMedicineRequestsProvider(_status).future),
                child: items.isEmpty
                    ? const _EmptyRequests()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 11),
                        itemBuilder: (context, index) => AppReveal(
                          delay: Duration(
                            milliseconds: (index.clamp(0, 5) * 45),
                          ),
                          child: _RequestCard(
                            request: items[index],
                            onTap: () => context.push(
                              '/user/requests/${items[index].requestId}',
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/user/search'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('طلب جديد'),
      ),
    );
  }
}

class _RequestsIntro extends StatelessWidget {
  const _RequestsIntro({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF174B57), Color(0xFF216474)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFF5CB72),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تابع طلبات أدويتك',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  'اطّلع على رد الصيدلية وحالة كل طلب.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNewRequest,
            tooltip: 'طلب جديد',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF5CB72),
              foregroundColor: AppColors.primaryDark,
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = <String?, String>{
      null: 'الكل',
      'Pending': 'قيد الانتظار',
      'Available': 'متوفر',
      'Unavailable': 'غير متوفر',
      'Cancelled': 'ملغى',
    };
    return SizedBox(
      height: 65,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: filters.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: value == entry.key,
                  onSelected: (_) => onChanged(entry.key),
                  showCheckmark: false,
                  avatar: Icon(
                    _filterIcon(entry.key),
                    size: 16,
                    color: value == entry.key
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

IconData _filterIcon(String? status) => switch (status) {
  'Pending' => Icons.schedule_rounded,
  'Available' => Icons.check_circle_outline_rounded,
  'Unavailable' => Icons.cancel_outlined,
  'Cancelled' => Icons.block_rounded,
  _ => Icons.grid_view_rounded,
};

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.onTap});

  final UserMedicineRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(request.status);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(status.icon, color: status.color),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.medicineName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          request.pharmacyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(text: _statusText(request), color: status.color),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _Fact(label: 'رقم الطلب', value: request.requestCode),
                    _Fact(
                      label: 'الكمية',
                      value: '${request.requestedQuantity}',
                    ),
                    _Fact(label: 'التاريخ', value: _date(request.createdAtUtc)),
                  ],
                ),
              ),
              if (request.hasPharmacyResponse &&
                  request.pharmacyResponseNote != null) ...[
                const SizedBox(height: 11),
                Text(
                  request.pharmacyResponseNote!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        const Icon(
          Icons.inventory_2_outlined,
          color: AppColors.textMuted,
          size: 48,
        ),
        const SizedBox(height: 14),
        Text(
          'لا توجد طلبات ضمن هذا التصنيف',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'ابحث عن دوائك واختر الصيدلية المناسبة لإرسال طلب.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: 10.5,
      ),
    ),
  );
}

({Color color, IconData icon}) _statusStyle(String status) => switch (status
    .toLowerCase()) {
  'available' => (color: AppColors.success, icon: Icons.check_circle_rounded),
  'unavailable' => (color: AppColors.danger, icon: Icons.cancel_rounded),
  'cancelled' => (color: AppColors.textMuted, icon: Icons.block_rounded),
  _ => (color: const Color(0xFFB47618), icon: Icons.schedule_rounded),
};

String _statusText(UserMedicineRequest request) {
  if (request.statusDisplayText.trim().isNotEmpty &&
      !request.statusDisplayText.toLowerCase().contains('waiting')) {
    return request.statusDisplayText;
  }
  return switch (request.status.toLowerCase()) {
    'available' => 'الدواء متوفر',
    'unavailable' => 'غير متوفر',
    'cancelled' => 'ملغى',
    _ => 'قيد الانتظار',
  };
}

String _date(DateTime? value) =>
    value == null ? '—' : '${value.year}/${value.month}/${value.day}';
