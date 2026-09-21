import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable widget that renders a frosted glass / liquid glass effect
/// using native [BackdropFilter], specular gradient borders, and ambient drop shadows.
class GlassContainer extends StatelessWidget {
  /// The child widget placed inside the glass surface.
  final Widget child;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Internal padding for the child.
  final EdgeInsetsGeometry? padding;

  /// Margin surrounding the outer shadow.
  final EdgeInsetsGeometry? margin;

  /// Border radius of the glass rectangle. Ignored if [shape] is [BoxShape.circle].
  final BorderRadius? borderRadius;

  /// Shape of the glass container (rectangle or circle).
  final BoxShape shape;

  /// Backdrop blur sigma intensity.
  final double blur;

  /// Surface fill opacity between 0.0 and 1.0.
  final double opacity;

  /// Optional tint color. When null, adapts to light and dark themes automatically.
  final Color? tintColor;

  /// Specular rim highlight border color.
  final Color? borderColor;

  /// Specular rim highlight border width.
  final double borderWidth;

  /// Custom list of elevation shadows.
  final List<BoxShadow>? customShadows;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Creates a frosted glass container with real-time backdrop blur.
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

    final defaultTint =
        tintColor ??
        (isDark
            ? Colors.black.withValues(alpha: opacity * 0.9)
            : Colors.white.withValues(alpha: opacity));

    final effectiveBorderColor =
        borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.75));

    final effectiveRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ?? BorderRadius.circular(32));

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
