import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/notification_models.dart';
import '../../data/repositories/notifications_repository.dart';
import '../controllers/notifications_providers.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _unreadOnly = false;
  String? _type;
  bool _markingAll = false;

  NotificationFilter get _filter => (unreadOnly: _unreadOnly, type: _type);

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider(_filter));
    final summary = ref.watch(notificationSummaryProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإشعارات'),
            Text(
              'كل جديد في مكان واحد',
              style: TextStyle(
                color: context.appColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _markingAll || (summary?.unreadCount ?? 0) == 0
                ? null
                : _markAllRead,
            child: Text(_markingAll ? 'جاري التحديث...' : 'قراءة الكل'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: AppReveal(
              child: _NotificationsHero(
                total: summary?.totalCount ?? 0,
                unread: summary?.unreadCount ?? 0,
                read: summary?.readCount ?? 0,
              ),
            ),
          ),
          _Filters(
            unreadOnly: _unreadOnly,
            selectedType: _type,
            types: summary?.unreadByType ?? const [],
            onUnreadChanged: (value) => setState(() => _unreadOnly = value),
            onTypeChanged: (value) => setState(() => _type = value),
          ),
          Expanded(
            child: notifications.when(
              loading: () =>
                  const AppLoadingState(label: 'جاري تحميل الإشعارات...'),
              error: (error, _) => AppErrorState(
                error: error,
                onRetry: () => ref.invalidate(notificationsProvider(_filter)),
              ),
              data: (items) => RefreshIndicator(
                onRefresh: _refresh,
                child: items.isEmpty
                    ? const _EmptyNotifications()
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 9),
                        itemBuilder: (context, index) => _NotificationCard(
                          notification: items[index],
                          onTap: () => _open(items[index]),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _open(AppNotification notification) async {
    try {
      if (!notification.isRead) {
        await ref
            .read(notificationsRepositoryProvider)
            .markRead(notification.id);
        await _refresh();
      }
    } catch (error) {
      _message(error, 'تعذر تحديث الإشعار.');
      return;
    }
    if (!mounted) return;
    final entityId = notification.relatedEntityId;
    final entityType = notification.relatedEntityType?.toLowerCase();
    final role = ref.read(authControllerProvider).valueOrNull?.user.primaryRole;
    if (entityId == null) return;
    if (entityType == 'prescriptionorder') {
      if (role == AppRole.user) {
        context.push('/user/prescriptions/$entityId');
      } else if (role == AppRole.pharmacy) {
        context.push('/pharmacy/prescriptions');
      }
    } else if (entityType == 'medicinerequest') {
      if (role == AppRole.user) {
        context.push('/user/requests/$entityId');
      } else if (role == AppRole.pharmacy) {
        context.push('/pharmacy/requests/$entityId');
      }
    } else if (entityType == 'medicinedonationoffer' ||
        entityType == 'medicineassistancerequest') {
      if (role == AppRole.user) {
        context.push('/user/donations');
      }
    }
  }

  Future<void> _markAllRead() async {
    setState(() => _markingAll = true);
    try {
      final count = await ref
          .read(notificationsRepositoryProvider)
          .markAllRead();
      await _refresh();
      if (count > 0) {
        _showText('تم تعليم $count إشعارات كمقروءة.');
      }
    } catch (error) {
      _message(error, 'تعذر تحديث الإشعارات.');
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(notificationsProvider)
      ..invalidate(notificationSummaryProvider)
      ..invalidate(notificationUnreadCountProvider);
    await Future.wait([
      ref.read(notificationsProvider(_filter).future),
      ref.read(notificationSummaryProvider.future),
    ]);
  }

  void _message(Object error, String fallback) {
    _showText(error is ApiException ? error.message : fallback, error: true);
  }

  void _showText(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
  }
}

class _NotificationsHero extends StatelessWidget {
  const _NotificationsHero({
    required this.total,
    required this.unread,
    required this.read,
  });

  final int total, unread, read;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: context.appColors.primaryDeep,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appColors.primary.withValues(alpha: 0.15)),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.notifications_active_outlined,
            color: context.appColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _NotificationStat(label: 'الإجمالي', value: total),
        ),
        Expanded(
          child: _NotificationStat(label: 'جديدة', value: unread),
        ),
        Expanded(
          child: _NotificationStat(label: 'مقروءة', value: read),
        ),
      ],
    ),
  );
}

class _NotificationStat extends StatelessWidget {
  const _NotificationStat({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
    ],
  );
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.unreadOnly,
    required this.selectedType,
    required this.types,
    required this.onUnreadChanged,
    required this.onTypeChanged,
  });

  final bool unreadOnly;
  final String? selectedType;
  final List<NotificationTypeCount> types;
  final ValueChanged<bool> onUnreadChanged;
  final ValueChanged<String?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            FilterChip(
              label: const Text('الجديدة فقط'),
              selected: unreadOnly,
              onSelected: onUnreadChanged,
              showCheckmark: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String?>(
                initialValue: selectedType,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'نوع الإشعار',
                  isDense: true,
                  filled: true,
                  fillColor: context.appColors.surface,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('جميع الإشعارات'),
                  ),
                  ...types.map(
                    (item) => DropdownMenuItem<String?>(
                      value: item.type,
                      child: Text('${_typeText(item.type)} (${item.count})'),
                    ),
                  ),
                ],
                onChanged: onTypeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final info = _typeInfo(context.appColors, notification.type);
    return AppReveal(
      child: Card(
        color: notification.isRead
            ? context.appColors.surface
            : context.appColors.primary.withValues(alpha: 0.045),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: info.color.withValues(alpha: 0.1),
                  child: Icon(info.icon, color: info.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: context.appColors.text,
                                fontWeight: notification.isRead
                                    ? FontWeight.w700
                                    : FontWeight.w900,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: context.appColors.primary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _dateTime(notification.createdAtUtc),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(32),
    children: [
      SizedBox(height: 80),
      Icon(
        Icons.notifications_none_rounded,
        color: context.appColors.textMuted,
        size: 42,
      ),
      SizedBox(height: 12),
      Text('لا توجد إشعارات لعرضها', textAlign: TextAlign.center),
    ],
  );
}

({IconData icon, Color color}) _typeInfo(AppColors colors, String type) {
  final value = type.toLowerCase();
  if (value.contains('prescription')) {
    return (icon: Icons.receipt_long_rounded, color: const Color(0xFF7557B7));
  }
  if (value.contains('request')) {
    return (icon: Icons.inventory_2_rounded, color: colors.primary);
  }
  if (value.contains('reminder')) {
    return (icon: Icons.alarm_rounded, color: const Color(0xFFB47618));
  }
  if (value.contains('approval') || value.contains('verification')) {
    return (icon: Icons.verified_rounded, color: colors.success);
  }
  return (icon: Icons.notifications_rounded, color: colors.primary);
}

String _typeText(String type) {
  final value = type.toLowerCase();
  if (value.contains('prescription')) return 'الوصفات';
  if (value.contains('request')) return 'الطلبات';
  if (value.contains('reminder')) return 'التذكيرات';
  if (value.contains('approval')) return 'الموافقات';
  if (value.contains('verification')) return 'التحقق';
  return 'عام';
}

String _dateTime(DateTime value) =>
    '${value.year}/${value.month}/${value.day} '
    '${value.hour.toString().padLeft(2, '0')}:'
    '${value.minute.toString().padLeft(2, '0')}';
