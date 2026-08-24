import 'package:flutter/material.dart';

import '../../data/models/onboarding_item.dart';

class OnboardingItemWidget extends StatelessWidget {
  const OnboardingItemWidget({required this.item, super.key});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: const Alignment(0, -0.6),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.72,
              ),
              child: AspectRatio(
                aspectRatio: 9 / 19.5,
                child: _PhoneFrame(
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.phone_android_rounded,
                        color: item.accentColor,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF142E35),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: ClipRRect(borderRadius: BorderRadius.circular(26), child: child),
    );
  }
}
