/// Sizing and expansion modes for [GlassMenu].
enum GlassMenuSizeMode {
  /// Sizes snugly around menu items (wrap content), centered or aligned.
  /// Ideal for floating pill navigation bars on mobile, tablet, and desktop.
  wrapContent,

  /// Expands to fill the maximum available width of its parent container.
  fullWidth,

  /// Starts collapsed as a compact frosted glass button showing "Menu"
  /// (or custom label/icon). When tapped, smoothly animates open to show
  /// all options.
  expandable,
}

/// Screen positioning anchors for [GlassMenu].
enum GlassMenuPosition {
  bottomCenter,
  bottomLeft,
  bottomRight,
  topCenter,
  topLeft,
  topRight,
  centerLeft,
  centerRight,
}

/// Position of the action button (e.g. search button) relative to the menu.
enum GlassActionPosition {
  /// Action button is positioned after the menu (right side in LTR).
  trailing,

  /// Action button is positioned before the menu (left side in LTR).
  leading,
}
