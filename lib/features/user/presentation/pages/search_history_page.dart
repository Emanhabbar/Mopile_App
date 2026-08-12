import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/user_request_models.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/user_providers.dart';

class SearchHistoryPage extends ConsumerStatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  ConsumerState<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends ConsumerState<SearchHistoryPage> {
  final Set<String> _deleting = {};
  bool _clearing = false;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(userSearchHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل البحث'),
        actions: [
          if (history.valueOrNull?.isNotEmpty == true)
            TextButton.icon(
              onPressed: _clearing ? null : _confirmClear,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(_clearing ? 'جاري المسح' : 'مسح الكل'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: history.when(
        loading: () => const AppLoadingState(label: 'جاري تحميل سجل البحث...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(userSearchHistoryProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(userSearchHistoryProvider.future),
          child: items.isEmpty
              ? const _EmptyHistory()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _HistoryCard(
                      item: item,
                      deleting: _deleting.contains(item.id),
                      onRepeat: () => _repeat(item),
                      onDelete: () => _delete(item.id),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _repeat(UserSearchRecord item) {
    if (_isMedicine(item.searchType) && item.query.trim().isNotEmpty) {
      context.push('/user/search', extra: item.query.trim());
    } else {
      context.push('/user/nearby-pharmacies');
    }
  }

  Future<void> _delete(String id) async {
    setState(() => _deleting.add(id));
    try {
      await ref.read(userRepositoryProvider).deleteSearchHistoryItem(id);
      ref
        ..invalidate(userSearchHistoryProvider)
        ..invalidate(userDashboardProvider)
        ..invalidate(userProfileProvider);
    } catch (error) {
      _message(error);
    } finally {
      if (mounted) setState(() => _deleting.remove(id));
    }
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.delete_sweep_outlined,
          color: context.appColors.danger,
          size: 38,
        ),
        title: const Text('مسح سجل البحث؟'),
        content: const Text(
          'سيتم حذف جميع عمليات البحث المحفوظة في حسابك.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: context.appColors.danger),
            child: const Text('مسح السجل'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _clearing = true);
    try {
      await ref.read(userRepositoryProvider).clearSearchHistory();
      ref
        ..invalidate(userSearchHistoryProvider)
        ..invalidate(userDashboardProvider)
        ..invalidate(userProfileProvider);
    } catch (error) {
      _message(error);
    } finally {
      if (mounted) setState(() => _clearing = false);
    }
  }

  void _message(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error is ApiException ? error.message : 'تعذر حذف سجل البحث حاليًا.',
        ),
        backgroundColor: context.appColors.danger,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.item,
    required this.deleting,
    required this.onRepeat,
    required this.onDelete,
  });

  final UserSearchRecord item;
  final bool deleting;
  final VoidCallback onRepeat;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final medicine = _isMedicine(item.searchType);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onRepeat,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: context.appColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  medicine
                      ? Icons.medication_outlined
                      : Icons.local_pharmacy_outlined,
                  color: context.appColors.primary,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.query.trim().isEmpty
                          ? 'بحث عن صيدليات قريبة'
                          : item.query,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.resultCount} نتيجة · ${_date(item.searchedAtUtc)}'
                      '${item.radiusInMeters == null ? '' : ' · ${_radius(item.radiusInMeters!)}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: deleting ? null : onDelete,
                tooltip: 'حذف',
                icon: deleting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline_rounded),
                color: context.appColors.danger,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(32),
    children: [
      const SizedBox(height: 90),
      Icon(Icons.history_rounded, color: context.appColors.textMuted, size: 48),
      const SizedBox(height: 14),
      Text(
        'لا يوجد سجل بحث',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 6),
      Text(
        'ستظهر عمليات البحث التي تجريها هنا.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}

bool _isMedicine(String type) => type.toLowerCase().contains('medicine');
String _radius(int meters) =>
    meters < 1000 ? '$meters م' : '${meters ~/ 1000} كم';
String _date(DateTime? value) =>
    value == null ? '—' : '${value.year}/${value.month}/${value.day}';
