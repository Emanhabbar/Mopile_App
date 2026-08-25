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
          final reveal = _phase(value, 0.0, 0.7, Curves.easeOut);
          final l10n = AppLocalizations.of(context);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/brand/newback.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Positioned.fill(child: _FlowingLines(progress: reveal)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: AppLocalizations.of(context).splashAppLogoLabel,
                        image: true,
                        child: _LogoReveal(progress: logo),
                      ),
                      const SizedBox(height: 8),
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
  const _FlowingLines({required this.progress});
  final double progress;

  @override
  State<_FlowingLines> createState() => _FlowingLinesState();
}

class _FlowingLinesState extends State<_FlowingLines>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flow;

  @override
  void initState() {
    super.initState();
    _flow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _flow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flow,
      builder: (context, _) {
        return Semantics(
          label: AppLocalizations.of(context).splashLoadingLabel,
          value: '',
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: CustomPaint(
                  painter: _FlowingLinesPainter(
                    t: _flow.value,
                    progress: widget.progress,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FlowingLinesPainter extends CustomPainter {
  const _FlowingLinesPainter({required this.t, required this.progress});

  final double t;
  final double progress;
  static const _margin = 120.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final w = size.width;
    final shift = t * w * 0.4;

    _drawComet(canvas, w, size.height * 0.90, shift, 28, 3,
        const Color(0xFF8BD0CB), 1.2, math.pi / 2);
    _drawComet(canvas, w, size.height * 0.90, shift * 0.75, 22, 2.5,
        const Color(0xFFF5CB72), 1.2, 3 * math.pi / 2);
  }

  void _drawComet(Canvas canvas, double w, double baseY, double shift,
      double amp, double sw, Color color, double wavelength, double phase) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final fullPath = Path();
    for (double x = -_margin; x <= w + _margin; x += 1) {
      final main = (x + shift) * 2 * math.pi / (w * wavelength) + phase;
      final y = baseY +
          amp * math.sin(main) +
          0.25 * amp * math.sin(main * 2.3 + 1.1);
      if (x == -_margin) {
        fullPath.moveTo(x, y);
      } else {
        fullPath.lineTo(x, y);
      }
    }

    final metrics = fullPath.computeMetrics().first;
    final total = metrics.length;
    final visible = progress * total;
    final visiblePath = metrics.extractPath(total - visible, total);
    canvas.drawPath(visiblePath, paint);
  }

  @override
  bool shouldRepaint(_FlowingLinesPainter old) =>
      t != old.t || progress != old.progress;
}
