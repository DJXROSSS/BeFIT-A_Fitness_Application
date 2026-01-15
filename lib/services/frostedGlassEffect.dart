import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Liquid glass / frosted glass effect widget for modern UI
class FrostedGlassBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double blurAmount;
  final double borderRadius;

  const FrostedGlassBox({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.color,
    this.padding,
    this.blurAmount = 10.0,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Liquid glass effect with semi-transparent background
            color:
                color ??
                (AppTheme.isDarkMode
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(borderRadius),
            // Subtle border for definition
            border: Border.all(
              color: AppTheme.isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Alternative minimal glass box without blur
class MinimalGlassBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const MinimalGlassBox({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.padding,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.glassBlurColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppTheme.dividerColor, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}
