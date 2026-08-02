import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_reveal.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/chat_models.dart';
import '../../data/repositories/chat_repository.dart';
import '../controllers/chat_providers.dart';

class ChatSessionsPage extends ConsumerStatefulWidget {
  const ChatSessionsPage({super.key});

  @override
  ConsumerState<ChatSessionsPage> createState() => _ChatSessionsPageState();
}

class _ChatSessionsPageState extends ConsumerState<ChatSessionsPage> {
  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(chatSessionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المساعد الدوائي'),
            Text(
              'إرشاد سريع للوصول إلى خدمات دوائي',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: sessions.when(
        loading: () => const AppLoadingState(label: 'جاري تحميل المحادثات...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(chatSessionsProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(chatSessionsProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
            children: [
              const AppReveal(child: _InfoCard()),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Icon(Icons.history_rounded, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'المحادثات السابقة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const _EmptySessions()
              else
                ...items.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: AppReveal(
                      child: _SessionCard(
                        session: session,
                        onTap: () =>
                            context.push('/user/chat/${session.sessionId}'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _creating ? null : _startSession,
        icon: _creating
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add_comment_rounded),
        label: const Text('محادثة جديدة'),
      ),
    );
  }

  Future<void> _startSession() async {
    final title = TextEditingController();
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: TextField(
          controller: title,
          maxLength: 200,
          decoration: const InputDecoration(
            labelText: 'عنوان المحادثة (اختياري)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('بدء'),
          ),
        ],
      ),
    );
    if (accepted != true) {
      title.dispose();
      return;
    }
    setState(() => _creating = true);
    try {
      final session = await ref
          .read(chatRepositoryProvider)
          .startSession(title: title.text);
      ref.invalidate(chatSessionsProvider);
      if (mounted) context.push('/user/chat/${session.sessionId}');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is ApiException
                  ? error.message
                  : 'تعذر بدء المحادثة حاليًا.',
            ),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      title.dispose();
      if (mounted) setState(() => _creating = false);
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryDeep, AppColors.primary],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryDeep.withValues(alpha: .15),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'كيف يمكنني مساعدتك؟',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'ابحث عن دواء، صيدلية قريبة، أو خدمة داخل التطبيق.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            _HeroHint(icon: Icons.medication_outlined, label: 'البحث عن دواء'),
            _HeroHint(
              icon: Icons.local_pharmacy_outlined,
              label: 'صيدلية قريبة',
            ),
            _HeroHint(icon: Icons.favorite_outline, label: 'خدمات صحية'),
          ],
        ),
      ],
    ),
  );
}

class _HeroHint extends StatelessWidget {
  const _HeroHint({required this.icon, required this.label});
  final IconData icon;
  final String label;
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
        Icon(icon, color: AppColors.secondary, size: 15),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    ),
  );
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, required this.onTap});
  final ChatSessionSummary session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: session.isEnded
                    ? AppColors.surfaceSoft
                    : AppColors.primary.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                session.isEnded ? Icons.forum_outlined : Icons.chat_rounded,
                color: session.isEnded
                    ? AppColors.textMuted
                    : AppColors.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title.isEmpty ? 'محادثة دوائية' : session.title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    session.lastMessagePreview ??
                        '${session.messagesCount} رسائل',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _chatDate(session.lastActivityAtUtc),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 6),
                Icon(
                  Icons.chevron_left_rounded,
                  color: session.isEnded
                      ? AppColors.textMuted
                      : AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

String _chatDate(DateTime value) =>
    '${value.day}/${value.month} · '
    '${value.hour.toString().padLeft(2, '0')}:'
    '${value.minute.toString().padLeft(2, '0')}';

class _EmptySessions extends StatelessWidget {
  const _EmptySessions();
  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(Icons.forum_outlined, color: AppColors.textMuted, size: 38),
          SizedBox(height: 10),
          Text('لا توجد محادثات سابقة'),
        ],
      ),
    ),
  );
}
