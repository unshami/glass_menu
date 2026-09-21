import 'package:flutter/widgets.dart';

/// Represents a single item within a [GlassMenu].
class GlassMenuItem {
  /// Primary icon or widget displayed for this menu option.
  final dynamic icon;

  /// Optional active icon or widget displayed when selected.
  final dynamic activeIcon;

  /// Text or custom widget label for this menu option.
  final dynamic label;

  /// Custom active color override for this item.
  final Color? activeColor;

  /// Custom inactive color override for this item.
  final Color? inactiveColor;

  /// Optional badge widget displayed on top of the icon (e.g. unread count).
  final Widget? badge;

  /// Optional tooltip message.
  final String? tooltip;

  /// Optional item-specific tap callback.
  final VoidCallback? onTap;

  const GlassMenuItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.activeColor,
    this.inactiveColor,
    this.badge,
    this.tooltip,
    this.onTap,
  }) : assert(
         icon is IconData || icon is Widget,
         'icon must be an IconData or a Widget',
       ),
       assert(
         label is String || label is Widget,
         'label must be a String or a Widget',
       );
}
