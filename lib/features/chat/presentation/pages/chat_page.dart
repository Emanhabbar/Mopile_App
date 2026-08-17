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

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _message = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;
  bool _ending = false;
  List<ChatAction> _actions = const [];
  List<ChatAiSource> _sources = const [];

  @override
  void dispose() {
    _message.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatSessionProvider(widget.sessionId));
    final session = state.valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session?.title.isNotEmpty == true
                  ? session!.title
                  : 'المساعد الدوائي',
            ),
            Text(
              session?.isEnded == true ? 'محادثة منتهية' : 'جاهز لمساعدتك',
              style: TextStyle(
                color: session?.isEnded == true
                    ? context.appColors.textMuted
                    : context.appColors.success,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          if (session != null && !session.isEnded)
            IconButton(
              onPressed: _ending ? null : _endSession,
              tooltip: 'إنهاء المحادثة',
              icon: const Icon(Icons.stop_circle_outlined),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => const AppLoadingState(label: 'جاري تحميل الرسائل...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(chatSessionProvider(widget.sessionId)),
        ),
        data: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  itemCount: data.messages.length + 1,
                  itemBuilder: (context, index) => index == 0
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: _ConversationNotice(),
                        )
                      : AppReveal(
                          child: _MessageBubble(
                            message: data.messages[index - 1],
                          ),
                        ),
                ),
              ),
              if (_actions.isNotEmpty)
                SizedBox(
                  height: 48,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: _actions
                        .map(
                          (action) => Padding(
                            padding: const EdgeInsetsDirectional.only(end: 7),
                            child: ActionChip(
                              label: Text(action.label),
                              onPressed: () => _openAction(action),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              if (_sources.isNotEmpty) _SourcesPanel(sources: _sources),
              _Composer(
                controller: _message,
                disabled: data.isEnded || _sending,
                sending: _sending,
                onSend: _send,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _send() async {
    final text = _message.text.trim();
    if (text.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _sending = true);
    try {
      final reply = await ref
          .read(chatRepositoryProvider)
          .sendMessage(widget.sessionId, message: text);
      _message.clear();
      setState(() {
        _actions = reply.suggestedActions;
        _sources = reply.aiSources;
      });
      ref
        ..invalidate(chatSessionProvider(widget.sessionId))
        ..invalidate(chatSessionsProvider);
      await ref.read(chatSessionProvider(widget.sessionId).future);
      _scrollToEnd();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _endSession() async {
    setState(() => _ending = true);
    try {
      await ref.read(chatRepositoryProvider).endSession(widget.sessionId);
      ref
        ..invalidate(chatSessionProvider(widget.sessionId))
        ..invalidate(chatSessionsProvider);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _ending = false);
    }
  }

  void _openAction(ChatAction action) {
    final key = '${action.actionType} ${action.endpoint} ${action.label}'
        .toLowerCase();
    if (key.contains('pharmac') || key.contains('صيدلي')) {
      context.go('/user/nearby-pharmacies');
    } else if (key.contains('medicine') || key.contains('دواء')) {
      context.go('/user/search');
    } else if (key.contains('health') || key.contains('صحي')) {
      context.push('/user/health');
    } else if (key.contains('donat') || key.contains('تبرع')) {
      context.push('/user/donations');
    }
  }

  void _scrollToEnd() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error is ApiException ? error.message : 'تعذر إرسال الرسالة.',
        ),
        backgroundColor: context.appColors.danger,
      ),
    );
  }
}

class _SourcesPanel extends StatelessWidget {
  const _SourcesPanel({required this.sources});
  final List<ChatAiSource> sources;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.appColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: Color(0xFF216474), size: 18),
            SizedBox(width: 7),
            Text(
              'مراجع دوائية مرتبطة بالإجابة',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sources.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final source = sources[index];
              final details = [
                source.activeIngredient,
                source.strength,
              ].where((value) => value.trim().isNotEmpty).join(' · ');
              return Container(
                width: 205,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details.isEmpty ? 'بيانات دوائية مرجعية' : details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF668087),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _ConversationNotice extends StatelessWidget {
  const _ConversationNotice();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: context.appColors.surfaceWarm,
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          color: Color(0xFFB7791F),
          size: 19,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'اكتب سؤالك بوضوح لتحصل على نتيجة أدق، ولا تعتمد على المحادثة في الحالات الطارئة.',
            style: TextStyle(fontSize: 10, color: Color(0xFF668087)),
          ),
        ),
      ],
    ),
  );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: message.isUser
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        if (!message.isUser) ...[
          CircleAvatar(
            radius: 15,
            backgroundColor: context.appColors.primary,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: context.appColors.secondary,
              size: 15,
            ),
          ),
          const SizedBox(width: 7),
        ],
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: message.isUser
                ? context.appColors.primary
                : context.appColors.surface,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(18),
              topEnd: const Radius.circular(18),
              bottomStart: Radius.circular(message.isUser ? 5 : 18),
              bottomEnd: Radius.circular(message.isUser ? 18 : 5),
            ),
            border: message.isUser
                ? null
                : Border.all(color: context.appColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: message.isUser ? Colors.white : context.appColors.text,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${message.sentAtUtc.hour.toString().padLeft(2, '0')}:'
                '${message.sentAtUtc.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white60
                      : context.appColors.textMuted,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        if (message.isUser) ...[
          const SizedBox(width: 7),
          const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFFEEF6F5),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFF216474),
              size: 16,
            ),
          ),
        ],
      ],
    ),
  );
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.disabled,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool disabled;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFD9E4E5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !disabled,
              maxLength: 2000,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: disabled ? 'تم إنهاء هذه المحادثة' : 'اكتب رسالتك...',
                counterText: '',
                filled: true,
                fillColor: context.appColors.surfaceSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: disabled ? null : onSend,
            icon: sending
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send_rounded),
          ),
        ],
      ),
    ),
  );
}
