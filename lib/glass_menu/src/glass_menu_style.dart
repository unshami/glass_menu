import 'package:flutter/material.dart';

/// Comprehensive styling configuration for [GlassMenu].
class GlassMenuStyle {
  /// Frosted glass background blur intensity (sigma).
  final double blur;

  /// Frosted glass surface opacity (0.0 to 1.0).
  final double opacity;

  /// Custom surface tint color. When null, adapts automatically to light/dark themes.
  final Color? tintColor;

  /// Specular rim highlight border color.
  final Color? borderColor;

  /// Specular rim highlight border width.
  final double borderWidth;

  /// Outer border radius of the menu pill.
  final BorderRadius? borderRadius;

  /// Ambient drop shadows for elevation.
  final List<BoxShadow>? shadows;

  /// Total height of the menu capsule.
  final double height;

  /// Internal padding for each menu item.
  final EdgeInsetsGeometry itemPadding;

  /// Spacing between consecutive items.
  final double itemSpacing;

  /// Background color or tint for the active item capsule.
  final Color? activeIndicatorColor;

  /// Border radius for the active item capsule.
  final BorderRadius? activeIndicatorBorderRadius;

  /// Padding for the active indicator capsule.
  final EdgeInsetsGeometry? activeIndicatorPadding;

  /// Primary active accent color (for active icon and text).
  final Color activeColor;

  /// Inactive color for icons and labels.
  final Color? inactiveColor;

  /// Size of menu icons.
  final double iconSize;

  /// Base text style for item labels (controls fontFamily, fontSize, etc.).
  final TextStyle? textStyle;

  /// Text style override for the active item.
  final TextStyle? activeTextStyle;

  /// Icon shown on the collapsed "Menu" button when `GlassMenuSizeMode.expandable` is active.
  final IconData collapsedIcon;

  /// Text label shown on the collapsed button. Defaults to "Menu".
  final String collapsedLabel;

  /// Text style for the collapsed "Menu" button.
  final TextStyle? collapsedTextStyle;

  /// Icon shown to collapse/close the menu when expanded in expandable mode.
  final IconData closeIcon;

  /// Duration for expansion, collapse, and tab animations.
  final Duration animationDuration;

  /// Curve for smooth expansion, collapse, and tab transitions.
  final Curve animationCurve;

  const GlassMenuStyle({
    this.blur = 24.0,
    this.opacity = 0.52,
    this.tintColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.borderRadius,
    this.shadows,
    this.height = 68.0,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: 14.0,
      vertical: 6.0,
    ),
    this.itemSpacing = 4.0,
    this.activeIndicatorColor,
    this.activeIndicatorBorderRadius,
    this.activeIndicatorPadding,
    this.activeColor = const Color(0xFFC41200),
    this.inactiveColor,
    this.iconSize = 24.0,
    this.textStyle,
    this.activeTextStyle,
    this.collapsedIcon = Icons.menu_rounded,
    this.collapsedLabel = 'Menu',
    this.collapsedTextStyle,
    this.closeIcon = Icons.close_rounded,
    this.animationDuration = const Duration(milliseconds: 320),
    this.animationCurve = Curves.easeOutCubic,
  });

  GlassMenuStyle copyWith({
    double? blur,
    double? opacity,
    Color? tintColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    double? height,
    EdgeInsetsGeometry? itemPadding,
    double? itemSpacing,
    Color? activeIndicatorColor,
    BorderRadius? activeIndicatorBorderRadius,
    EdgeInsetsGeometry? activeIndicatorPadding,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
    IconData? collapsedIcon,
    String? collapsedLabel,
    TextStyle? collapsedTextStyle,
    IconData? closeIcon,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return GlassMenuStyle(
      blur: blur ?? this.blur,
      opacity: opacity ?? this.opacity,
      tintColor: tintColor ?? this.tintColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      height: height ?? this.height,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      activeIndicatorBorderRadius:
          activeIndicatorBorderRadius ?? this.activeIndicatorBorderRadius,
      activeIndicatorPadding:
          activeIndicatorPadding ?? this.activeIndicatorPadding,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      collapsedIcon: collapsedIcon ?? this.collapsedIcon,
      collapsedLabel: collapsedLabel ?? this.collapsedLabel,
      collapsedTextStyle: collapsedTextStyle ?? this.collapsedTextStyle,
      closeIcon: closeIcon ?? this.closeIcon,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}
