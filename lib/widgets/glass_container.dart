import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable widget that renders a frosted glass / liquid glass effect
/// using [BackdropFilter], specular gradient borders, and ambient drop shadows.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final double blur;
  final double opacity;
  final Color? tintColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? customShadows;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.blur = 24.0,
    this.opacity = 0.52,
    this.tintColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.customShadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base translucent tints for glass surface
    final defaultTint =
        tintColor ??
        (isDark
            ? Colors.black.withValues(alpha: opacity * 0.9)
            : Colors.white.withValues(alpha: opacity));

    // Specular border highlights
    final effectiveBorderColor =
        borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.75));

    final effectiveRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ?? BorderRadius.circular(32));

    // Ambient drop shadows that give the floating elevation
    final effectiveShadows =
        customShadows ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ];

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: effectiveRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            defaultTint,
            isDark
                ? defaultTint.withValues(alpha: defaultTint.a * 0.7)
                : Colors.white.withValues(alpha: opacity * 0.45),
          ],
          stops: const [0.0, 1.0],
        ),
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
      ),
      child: child,
    );

    // Apply BackdropFilter with precise clipping
    Widget glass;
    if (shape == BoxShape.circle) {
      glass = ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    } else {
      glass = ClipRRect(
        borderRadius: effectiveRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    }

    // Outer container holding shadow (shadow sits outside the clipped backdrop)
    Widget result = Container(
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: effectiveRadius,
        boxShadow: effectiveShadows,
      ),
      child: glass,
    );

    if (onTap != null) {
      result = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    return result;
  }
}
