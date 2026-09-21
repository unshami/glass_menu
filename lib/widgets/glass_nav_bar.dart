import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../glass_menu/glass_menu.dart';

/// Backward-compatible model matching [GlassNavItem] to [GlassMenuItem].
class GlassNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Color? activeColor;
  final Color? inactiveColor;

  const GlassNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.activeColor,
    this.inactiveColor,
  });

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

/// Floating Frosted Glass Navigation Bar built on top of [GlassMenu].
class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onSearchTap;
  final List<GlassNavItem> items;
  final double blur;
  final double opacity;
  final GlassMenuSizeMode sizeMode;
  final GlassMenuPosition position;
  final bool? isExpanded;
  final ValueChanged<bool>? onExpandChanged;
  final GlassMenuStyle? customStyle;

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

/// Standalone detached frosted glass circular button (e.g. for search).
class SearchGlassButton extends StatefulWidget {
  final double blur;
  final double opacity;
  final VoidCallback onTap;
  final IconData icon;
  final double size;

  const SearchGlassButton({
    super.key,
    this.blur = 24.0,
    this.opacity = 0.52,
    required this.onTap,
    this.icon = Icons.search_rounded,
    this.size = 68.0,
  });

  @override
  State<SearchGlassButton> createState() => _SearchGlassButtonState();
}

class _SearchGlassButtonState extends State<SearchGlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOut,
        child: GlassContainer(
          width: widget.size,
          height: widget.size,
          shape: BoxShape.circle,
          blur: widget.blur,
          opacity: widget.opacity,
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.size * 0.4,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : const Color(0xFF1E1E1E),
            ),
          ),
        ),
      ),
    );
  }
}
