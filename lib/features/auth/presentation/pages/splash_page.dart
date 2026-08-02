import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
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
      backgroundColor: AppColors.primaryDeep,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final value = _controller.value;
          final background = _phase(value, 0, 1, Curves.easeInOutCubic);
          final halo = _phase(value, 0.02, 0.5, Curves.easeOutBack);
          final assembly = _phase(value, 0.08, 0.5, Curves.easeOutBack);
          final title = _phase(value, 0.43, 0.72);
          final subtitle = _phase(value, 0.58, 0.82);
          final progress = _phase(value, 0.68, 0.96, Curves.easeInOut);

          return Stack(
            fit: StackFit.expand,
            children: [
              const _SplashGradient(),
              _AmbientShapes(progress: background),
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
                        label: 'شعار تطبيق دوائي',
                        image: true,
                        child: _AssemblingLogo(assembly: assembly, halo: halo),
                      ),
                      const SizedBox(height: 30),
                      Opacity(
                        opacity: title,
                        child: Transform.translate(
                          offset: Offset(0, 22 * (1 - title)),
                          child: Text(
                            'دوائي',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.4,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: subtitle,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - subtitle)),
                          child: Text(
                            'دواؤك أقرب، ورعايتك أسهل',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      _LoadingTrack(progress: progress),
                      const SizedBox(height: 14),
                      Opacity(
                        opacity: progress,
                        child: Text(
                          'نجهّز تجربتك',
                          style: Theme.of(context).textTheme.bodySmall
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

class _SplashGradient extends StatelessWidget {
  const _SplashGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF174B57), Color(0xFF102F37), Color(0xFF0B252C)],
          stops: [0, 0.57, 1],
        ),
      ),
    );
  }
}

class _AmbientShapes extends StatelessWidget {
  const _AmbientShapes({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          PositionedDirectional(
            top: -98 + (progress * 20),
            end: -84 + (progress * 16),
            child: _Orb(
              size: 260,
              color: AppColors.primary.withValues(alpha: 0.45),
            ),
          ),
          PositionedDirectional(
            top: 82 - (progress * 9),
            start: -68 + (progress * 15),
            child: _Orb(
              size: 148,
              color: AppColors.primaryLight.withValues(alpha: 0.07),
              borderColor: AppColors.primaryLight.withValues(alpha: 0.08),
            ),
          ),
          PositionedDirectional(
            bottom: -112 + (progress * 25),
            start: -90 + (progress * 10),
            child: _Orb(
              size: 278,
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          PositionedDirectional(
            bottom: 110 + (progress * 8),
            end: -42 + (progress * 12),
            child: _Orb(
              size: 112,
              color: AppColors.secondary.withValues(alpha: 0.035),
              borderColor: AppColors.secondary.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color, this.borderColor});

  final double size;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: borderColor == null ? null : Border.all(color: borderColor!),
    ),
  );
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'رعاية دوائية أقرب إليك',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AssemblingLogo extends StatelessWidget {
  const _AssemblingLogo({required this.assembly, required this.halo});

  final double assembly;
  final double halo;

  static const _pieceOffsets = [
    Offset(-50, -46),
    Offset(50, -46),
    Offset(-50, 46),
    Offset(50, 46),
  ];

  @override
  Widget build(BuildContext context) {
    final pieceOpacity = ((assembly - 0.05) / 0.35).clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: 176,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 0.72 + (halo * 0.28),
            child: Opacity(
              opacity: halo.clamp(0.0, 1.0),
              child: Container(
                width: 176,
                height: 176,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.16),
                  ),
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: (1 - assembly) * -0.12,
            child: Opacity(
              opacity: pieceOpacity,
              child: SizedBox.square(
                dimension: 118,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(4, (index) {
                    final origin = _pieceOffsets[index];
                    return Transform.translate(
                      offset: origin * (1 - assembly),
                      child: ClipPath(
                        clipper: _LogoQuadrantClipper(index),
                        child: Image.asset(
                          'assets/brand/dawaai-icon-foreground.png',
                          width: 118,
                          height: 118,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          cacheWidth: 280,
                          excludeFromSemantics: true,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          if (assembly > 0.72)
            Opacity(
              opacity: ((assembly - 0.72) / 0.28).clamp(0.0, 1.0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogoQuadrantClipper extends CustomClipper<Path> {
  const _LogoQuadrantClipper(this.index);

  final int index;

  @override
  Path getClip(Size size) {
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;
    final rect = switch (index) {
      0 => Rect.fromLTRB(0, 0, halfWidth, halfHeight),
      1 => Rect.fromLTRB(halfWidth, 0, size.width, halfHeight),
      2 => Rect.fromLTRB(0, halfHeight, halfWidth, size.height),
      _ => Rect.fromLTRB(halfWidth, halfHeight, size.width, size.height),
    };
    return Path()..addRect(rect);
  }

  @override
  bool shouldReclip(covariant _LogoQuadrantClipper oldClipper) =>
      oldClipper.index != index;
}

class _LoadingTrack extends StatelessWidget {
  const _LoadingTrack({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'جاري تجهيز التطبيق',
      value: '${(progress * 100).round()} بالمئة',
      child: SizedBox(
        width: 148,
        height: 4,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            ClipRect(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: progress,
                child: Container(
                  width: 148,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, Color(0xFFFFE6A7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.28),
                        blurRadius: 9,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
