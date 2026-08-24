import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/onboarding_item.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_item_widget.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  List<OnboardingItem> get _items =>
      buildOnboardingItems(AppLocalizations.of(context));

  bool get _isLastPage => _currentPage == _items.length - 1;

  bool get _isFirstPage => _currentPage == 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(onboardingCompletedProvider.notifier).complete();
    if (!mounted) return;
    context.go('/login');
  }

  void _next() {
    if (_isLastPage) {
      _complete();
      return;
    }
    _pageCtrl.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _previous() {
    if (_isFirstPage) return;
    _pageCtrl.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);
    final items = _items;
    final current = items[_currentPage];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Semantics(
                  label: l10n.onboardingSkip,
                  button: true,
                  child: TextButton(
                    onPressed: _complete,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.textMuted,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      l10n.onboardingSkip,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final areaHeight = constraints.maxHeight;
                  final panelHeight = areaHeight * 0.46;
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: PageView.builder(
                          controller: _pageCtrl,
                          itemCount: items.length,
                          onPageChanged: (i) =>
                              setState(() => _currentPage = i),
                          itemBuilder: (_, i) =>
                              OnboardingItemWidget(item: items[i]),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: panelHeight,
                        child: ClipPath(
                          clipper: const _PanelClipper(depth: 30),
                          child: Container(
                            color: colors.surface,
                            padding: const EdgeInsets.fromLTRB(22, 76, 22, 20),
                            child: Column(
                              children: [
                                const Spacer(),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    current.title,
                                    key: ValueKey('title-$_currentPage'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: colors.text,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    current.description,
                                    key: ValueKey('desc-$_currentPage'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: colors.textMuted,
                                      fontSize: 14,
                                      height: 1.65,
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 2),
                                Row(
                                  children: [
                                    if (!_isFirstPage)
                                      _ArrowButton(
                                        icon: Icons.arrow_back_rounded,
                                        onTap: _previous,
                                        colors: colors,
                                      )
                                    else
                                      const SizedBox(width: 46),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(items.length, (
                                        i,
                                      ) {
                                        final active = _currentPage == i;
                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 3.5,
                                          ),
                                          width: active ? 22 : 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            color: active
                                                ? colors.primary
                                                : colors.border,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    const Spacer(),
                                    _ArrowButton(
                                      icon: _isLastPage
                                          ? Icons.check_rounded
                                          : Icons.arrow_forward_rounded,
                                      onTap: _next,
                                      colors: colors,
                                      isPrimary: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelClipper extends CustomClipper<Path> {
  const _PanelClipper({required this.depth});

  final double depth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    return Path()
      ..moveTo(0, 0)
      ..cubicTo(0, depth * 2, w, depth * 2, w, 0)
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _PanelClipper oldClipper) =>
      oldClipper.depth != depth;
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.onTap,
    required this.colors,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final AppColors colors;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? colors.primary : colors.surface,
      shape: CircleBorder(
        side: isPrimary ? BorderSide.none : BorderSide(color: colors.border),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : colors.text,
            size: 22,
          ),
        ),
      ),
    );
  }
}
