import 'package:flutter/material.dart';
import 'glass_menu.dart';
import 'glass_menu_item.dart';
import 'glass_menu_style.dart';
import 'glass_menu_types.dart';
import 'search_glass_button.dart';

/// Navigation item model for [GlassNavBar].
class GlassNavItem {
  /// Icon displayed when inactive.
  final IconData icon;

  /// Optional icon displayed when selected.
  final IconData? activeIcon;

  /// Text label.
  final String label;

  /// Active color override.
  final Color? activeColor;

  /// Inactive color override.
  final Color? inactiveColor;

  /// Creates a navigation item for [GlassNavBar].
  const GlassNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.activeColor,
    this.inactiveColor,
  });

  /// Converts this [GlassNavItem] to a [GlassMenuItem].
  GlassMenuItem toMenuItem() {
    return GlassMenuItem(
      icon: icon,
      activeIcon: activeIcon,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }
}

/// A ready-to-use Floating Frosted Glass Navigation Bar built on top of [GlassMenu].
class GlassNavBar extends StatelessWidget {
  /// Index of the currently selected tab.
  final int currentIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTap;

  /// Optional callback when the detached circular search button is tapped.
  final VoidCallback? onSearchTap;

  /// List of items to display.
  final List<GlassNavItem> items;

  /// Frosted glass background blur intensity (sigma).
  final double blur;

  /// Frosted glass surface opacity (0.0 to 1.0).
  final double opacity;

  /// Sizing behavior mode.
  final GlassMenuSizeMode sizeMode;

  /// Screen position anchor.
  final GlassMenuPosition position;

  /// Whether the menu is currently expanded (used in expandable mode).
  final bool? isExpanded;

  /// Callback when expanded state toggles.
  final ValueChanged<bool>? onExpandChanged;

  /// Custom style overrides.
  final GlassMenuStyle? customStyle;

  /// Creates a floating frosted glass navigation bar.
  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onSearchTap,
    required this.items,
    this.blur = 24.0,
    this.opacity = 0.52,
    this.sizeMode = GlassMenuSizeMode.wrapContent,
    this.position = GlassMenuPosition.bottomCenter,
    this.isExpanded,
    this.onExpandChanged,
    this.customStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = (customStyle ?? const GlassMenuStyle()).copyWith(
      blur: blur,
      opacity: opacity,
    );

    return GlassMenu.positioned(
      position: position,
      sizeMode: sizeMode,
      style: effectiveStyle,
      currentIndex: currentIndex,
      onItemSelected: onTap,
      isExpanded: isExpanded,
      onExpandChanged: onExpandChanged,
      items: items.map((e) => e.toMenuItem()).toList(),
      trailingAction: onSearchTap != null
          ? SearchGlassButton(blur: blur, opacity: opacity, onTap: onSearchTap!)
          : null,
    );
  }
}
