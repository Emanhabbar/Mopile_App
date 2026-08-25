import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 2450);

  late final AnimationController _controller;
  bool _adaptedForReducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          ref.read(splashCompletedProvider.notifier).state = true;
        }
      })
      ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_adaptedForReducedMotion && MediaQuery.disableAnimationsOf(context)) {
      _adaptedForReducedMotion = true;
      _controller.duration = const Duration(milliseconds: 450);
      _controller.forward(from: _controller.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _phase(
    double value,
    double begin,
    double end, [
    Curve curve = Curves.easeOutCubic,
  ]) {
    final progress = ((value - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final value = _controller.value;
          final logo = _phase(value, 0.05, 0.55, Curves.easeOutBack);
          final divider = _phase(value, 0.35, 0.65, Curves.easeOutCubic);
          final title = _phase(value, 0.43, 0.72);
          final subtitle = _phase(value, 0.58, 0.82);
          final progress = _phase(value, 0.68, 0.96, Curves.easeInOut);
          final l10n = AppLocalizations.of(context);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/brand/newback.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
                  child: Column(
                    children: [
                      Opacity(
                        opacity: subtitle,
                        child: Transform.translate(
                          offset: Offset(0, -10 * (1 - subtitle)),
                          child: const _TopCaption(),
                        ),
                      ),
                      const Spacer(),
                      Semantics(
                        label: AppLocalizations.of(context).splashAppLogoLabel,
                        image: true,
                        child: _LogoReveal(progress: logo),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: subtitle,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - subtitle)),
                          child: Text(
                            l10n.splashTagline,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const _FlowingLines(),
                      const SizedBox(height: 14),
                      Opacity(
                        opacity: progress,
                        child: Text(
                          l10n.splashPreparing,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.52),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopCaption extends StatelessWidget {
  const _TopCaption();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.appColors.secondary,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          AppLocalizations.of(context).splashTopCaption,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AnimatedBrandTitle extends StatelessWidget {
  const _AnimatedBrandTitle({required this.dividerProgress});

  final double dividerProgress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Right divider (animates from right to left)
        Transform(
          transform: Matrix4.translationValues(
            40 * (1 - dividerProgress),
            0,
            0,
          ),
          child: Opacity(
            opacity: dividerProgress,
            child: Container(
              width: 50 * dividerProgress,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.appColors.secondary.withValues(alpha: 0.0),
                    context.appColors.secondary.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          AppLocalizations.of(context).appTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: context.appColors.primary,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
          ),
        ),
        const SizedBox(width: 16),
        // Left divider (animates from left to right)
        Transform(
          transform: Matrix4.translationValues(
            -40 * (1 - dividerProgress),
            0,
            0,
          ),
          child: Opacity(
            opacity: dividerProgress,
            child: Container(
              width: 50 * dividerProgress,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.appColors.secondary.withValues(alpha: 0.6),
                    context.appColors.secondary.withValues(alpha: 0.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoReveal extends StatelessWidget {
  const _LogoReveal({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Transform.scale(
        scale: 0.6 + (progress * 0.4),
        child: Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Image.asset(
            'assets/brand/logo_splash.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            cacheWidth: 480,
          ),
        ),
      ),
    );
  }
}

class _FlowingLines extends StatefulWidget {
  const _FlowingLines();

  @override
  State<_FlowingLines> createState() => _FlowingLinesState();
}

class _FlowingLinesState extends State<_FlowingLines>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Semantics(
          label: AppLocalizations.of(context).splashLoadingLabel,
          value: '',
          child: SizedBox(
            width: 220,
            height: 36,
            child: CustomPaint(
              painter: _FlowingLinesPainter(t: _controller.value),
            ),
          ),
        );
      },
    );
  }
}

class _FlowingLinesPainter extends CustomPainter {
  const _FlowingLinesPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final midY = height / 2;

    // Line 1: teal/cyan flowing wave
    final paint1 = Paint()
      ..color = const Color(0xFF8BD0CB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    final shift1 = t * width;
    for (double x = 0; x <= width; x += 1) {
      final amplitude = math.sin(x / width * math.pi);
      final y = midY +
          12 * amplitude *
              math.sin(((x + shift1) * 2 * math.pi / width) + 0.5);
      if (x == 0) {
        path1.moveTo(x, y);
      } else {
        path1.lineTo(x, y);
      }
    }
    canvas.drawPath(path1, paint1);

    // Line 2: golden flowing wave (slightly offset phase)
    final paint2 = Paint()
      ..color = const Color(0xFFF5CB72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final path2 = Path();
    final shift2 = t * width;
    for (double x = 0; x <= width; x += 1) {
      final amplitude = math.sin(x / width * math.pi);
      final y = midY +
          9 * amplitude *
              math.sin(((x + shift2) * 2 * math.pi / width) - 0.3);
      if (x == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_FlowingLinesPainter oldDelegate) =>
      t != oldDelegate.t;
}
