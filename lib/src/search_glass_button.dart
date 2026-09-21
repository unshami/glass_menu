import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_container.dart';

/// Standalone detached frosted glass circular button with haptic tap scaling feedback.
class SearchGlassButton extends StatefulWidget {
  /// Backdrop blur sigma intensity.
  final double blur;

  /// Surface fill opacity.
  final double opacity;

  /// Tap callback.
  final VoidCallback onTap;

  /// Icon to display in the center.
  final IconData icon;

  /// Diameter size of the circular button.
  final double size;

  /// Creates a detached circular frosted glass action button.
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
