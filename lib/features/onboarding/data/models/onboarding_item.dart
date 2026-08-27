import 'package:flutter/material.dart';

class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.accentColor,
  });

  final String title;
  final String description;
  final String imagePath;
  final Color accentColor;
}
