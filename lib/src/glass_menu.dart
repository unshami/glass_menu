import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_container.dart';
import 'glass_menu_item.dart';
import 'glass_menu_style.dart';
import 'glass_menu_types.dart';

/// A production-grade, highly customizable Frosted Glass Menu / Navigation Bar.
///
/// Supports:
/// - Sizing modes: [GlassMenuSizeMode.wrapContent], [GlassMenuSizeMode.fullWidth],
///   and [GlassMenuSizeMode.expandable].
/// - Dynamic item counts with smooth horizontal mouse & touch scrolling without overflows.
/// - Rich styling (typography, custom icons, custom widgets, badges, active indicators).
/// - Position anchors (top, bottom, left, right).
/// - Detached action buttons (such as the circular search glass button).
/// - Flexible spacing and separation between the menu and action buttons.
class GlassMenu extends StatefulWidget {
  /// The list of items displayed in the menu.
  final List<GlassMenuItem> items;

  /// Index of currently selected item.
  final int currentIndex;

  /// Callback when a menu item is tapped.
  final ValueChanged<int> onItemSelected;

  /// Sizing behavior: wrapContent, fullWidth, or expandable.
  final GlassMenuSizeMode sizeMode;

  /// Styling configuration.
  final GlassMenuStyle style;

  /// Optional trailing action widget (e.g., the circular search glass button).
  final Widget? trailingAction;

  /// Optional leading action widget.
  final Widget? leadingAction;

  /// Spacing between the menu capsule and the action buttons.
  /// Defaults to 12.0.
  final double actionSpacing;

  /// When true, expands the space between the menu and action buttons to push
  /// them to opposite sides (e.g. menu left-aligned, search right-aligned, or vice-versa).
  /// Defaults to false.
  final bool expandSpaceBetween;

  /// Whether the menu is currently expanded (used when [sizeMode] is [GlassMenuSizeMode.expandable]).
  /// If null, [GlassMenu] manages its own expansion state internally.
  final bool? isExpanded;

  /// Callback when expanded state changes.
  final ValueChanged<bool>? onExpandChanged;

  /// Maximum visible width constraint for the menu bar in wrapContent mode.
  final double? maxWidth;

  /// Creates a customizable frosted glass menu.
  const GlassMenu({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.sizeMode = GlassMenuSizeMode.wrapContent,
    this.style = const GlassMenuStyle(),
    this.trailingAction,
    this.leadingAction,
    this.actionSpacing = 12.0,
    this.expandSpaceBetween = false,
    this.isExpanded,
    this.onExpandChanged,
    this.maxWidth,
  });

  /// Factory constructor to position [GlassMenu] easily inside a [Stack].
  static Widget positioned({
    Key? key,
    required List<GlassMenuItem> items,
    required int currentIndex,
    required ValueChanged<int> onItemSelected,
    GlassMenuPosition position = GlassMenuPosition.bottomCenter,
    GlassMenuSizeMode sizeMode = GlassMenuSizeMode.wrapContent,
    GlassMenuStyle style = const GlassMenuStyle(),
    Widget? trailingAction,
    Widget? leadingAction,
    double actionSpacing = 12.0,
    bool expandSpaceBetween = false,
    bool? isExpanded,
    ValueChanged<bool>? onExpandChanged,
    EdgeInsets? margin,
    double? maxWidth,
  }) {
    return _PositionedGlassMenu(
      key: key,
      position: position,
      margin: margin,
      child: GlassMenu(
        items: items,
        currentIndex: currentIndex,
        onItemSelected: onItemSelected,
        sizeMode: sizeMode,
        style: style,
        trailingAction: trailingAction,
        leadingAction: leadingAction,
        actionSpacing: actionSpacing,
        expandSpaceBetween: expandSpaceBetween,
        isExpanded: isExpanded,
        onExpandChanged: onExpandChanged,
        maxWidth: maxWidth,
      ),
    );
  }

  @override
  State<GlassMenu> createState() => _GlassMenuState();
}

class _GlassMenuState extends State<GlassMenu>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded ?? false;
  }

  @override
  void didUpdateWidget(covariant GlassMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null && widget.isExpanded != _expanded) {
      setState(() => _expanded = widget.isExpanded!);
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    HapticFeedback.lightImpact();
    setState(() {
      _expanded = !_expanded;
    });
    widget.onExpandChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = widget.style;

    Widget menuContent;

    if (widget.sizeMode == GlassMenuSizeMode.expandable && !_expanded) {
      // Collapsed State: A compact frosted glass "Menu" pill
      menuContent = _buildCollapsedButton(isDark, style);
    } else {
      // Expanded or Normal State: Menu items
      menuContent = _buildExpandedMenu(isDark, style);
    }

    final hasActions =
        widget.leadingAction != null || widget.trailingAction != null;
    final effectiveExpandSpace = widget.expandSpaceBetween && hasActions;

    final effectiveMainAxisSize =
        (widget.sizeMode == GlassMenuSizeMode.fullWidth || effectiveExpandSpace)
            ? MainAxisSize.max
            : MainAxisSize.min;

    final mainAxisAlignment = effectiveExpandSpace
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.start;

    final List<Widget> rowChildren = [];

    if (widget.leadingAction != null) {
      if (effectiveExpandSpace) {
        rowChildren.add(
          Padding(
            padding: EdgeInsets.only(right: widget.actionSpacing),
            child: widget.leadingAction!,
          ),
        );
      } else {
        rowChildren.add(widget.leadingAction!);
        rowChildren.add(SizedBox(width: widget.actionSpacing));
      }
    }

    if (widget.sizeMode == GlassMenuSizeMode.fullWidth) {
      rowChildren.add(Expanded(child: menuContent));
    } else {
      rowChildren.add(Flexible(child: menuContent));
    }

    if (widget.trailingAction != null) {
      if (effectiveExpandSpace) {
        rowChildren.add(
          Padding(
            padding: EdgeInsets.only(left: widget.actionSpacing),
            child: widget.trailingAction!,
          ),
        );
      } else {
        rowChildren.add(SizedBox(width: widget.actionSpacing));
        rowChildren.add(widget.trailingAction!);
      }
    }

    // Outer layout with optional leading and trailing action buttons
    Widget row = Row(
      mainAxisSize: effectiveMainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );

    if (widget.maxWidth != null) {
      row = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: row,
      );
    }

    return AnimatedSize(
      duration: style.animationDuration,
      curve: style.animationCurve,
      child: row,
    );
  }

  Widget _buildCollapsedButton(bool isDark, GlassMenuStyle style) {
    final effectiveTextColor =
        style.inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.9)
            : const Color(0xFF1E1E1E));

    return GlassContainer(
      height: style.height,
      blur: style.blur,
      opacity: style.opacity,
      tintColor: style.tintColor,
      borderColor: style.borderColor,
      borderWidth: style.borderWidth,
      borderRadius:
          style.borderRadius ?? BorderRadius.circular(style.height / 2),
      customShadows: style.shadows,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: _toggleExpanded,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            style.collapsedIcon,
            size: style.iconSize,
            color: effectiveTextColor,
          ),
          const SizedBox(width: 10),
          Text(
            style.collapsedLabel,
            style:
                style.collapsedTextStyle ??
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: effectiveTextColor,
                  letterSpacing: -0.2,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedMenu(bool isDark, GlassMenuStyle style) {
    final isExpandable = widget.sizeMode == GlassMenuSizeMode.expandable;

    // Enable mouse dragging on Web & Desktop for seamless horizontal scroll
    Widget scrollableList = ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.items.length; i++) ...[
              if (i > 0) SizedBox(width: style.itemSpacing),
              _GlassMenuItemWidget(
                item: widget.items[i],
                isSelected: i == widget.currentIndex,
                isDark: isDark,
                style: style,
                isExpandMode:
                    widget.sizeMode == GlassMenuSizeMode.fullWidth &&
                    widget.items.length <= 4,
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onItemSelected(i);
                  widget.items[i].onTap?.call();
                },
              ),
            ],

            // Close button when in expandable mode
            if (isExpandable) ...[
              const SizedBox(width: 8),
              _CloseMenuButton(
                style: style,
                isDark: isDark,
                onTap: _toggleExpanded,
              ),
            ],
          ],
        ),
      ),
    );

    return GlassContainer(
      height: style.height,
      blur: style.blur,
      opacity: style.opacity,
      tintColor: style.tintColor,
      borderColor: style.borderColor,
      borderWidth: style.borderWidth,
      borderRadius:
          style.borderRadius ?? BorderRadius.circular(style.height / 2),
      customShadows: style.shadows,
      child: scrollableList,
    );
  }
}

class _GlassMenuItemWidget extends StatelessWidget {
  final GlassMenuItem item;
  final bool isSelected;
  final bool isDark;
  final GlassMenuStyle style;
  final bool isExpandMode;
  final VoidCallback onTap;

  const _GlassMenuItemWidget({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.style,
    required this.isExpandMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = item.activeColor ?? style.activeColor;
    final effectiveInactiveColor =
        item.inactiveColor ??
        style.inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : const Color(0xFF1E1E1E));

    final effectiveColor = isSelected
        ? effectiveActiveColor
        : effectiveInactiveColor;

    // Active pill highlight indicator
    final activeIndicatorBg =
        style.activeIndicatorColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08));

    final borderRadius =
        style.activeIndicatorBorderRadius ??
        BorderRadius.circular(style.height / 2);

    Widget iconWidget;
    final currentIcon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;
    if (currentIcon is Widget) {
      iconWidget = currentIcon;
    } else if (currentIcon is IconData) {
      iconWidget = Icon(
        currentIcon,
        size: style.iconSize,
        color: effectiveColor,
      );
    } else {
      iconWidget = const SizedBox.shrink();
    }

    if (item.badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(right: -6, top: -4, child: item.badge!),
        ],
      );
    }

    Widget labelWidget;
    if (item.label is Widget) {
      labelWidget = item.label as Widget;
    } else {
      final baseStyle = isSelected
          ? (style.activeTextStyle ??
                style.textStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: effectiveColor,
                  letterSpacing: -0.2,
                  fontFamily: 'SF Pro Display',
                ))
          : (style.textStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: effectiveColor,
                  letterSpacing: -0.2,
                  fontFamily: 'SF Pro Display',
                ));

      labelWidget = Text(
        item.label.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle.copyWith(color: effectiveColor),
      );
    }

    Widget content = AnimatedContainer(
      duration: style.animationDuration,
      curve: style.animationCurve,
      padding: style.activeIndicatorPadding ?? style.itemPadding,
      decoration: BoxDecoration(
        color: isSelected ? activeIndicatorBg : Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: iconWidget,
          ),
          const SizedBox(height: 3),
          labelWidget,
        ],
      ),
    );

    if (item.tooltip != null) {
      content = Tooltip(message: item.tooltip!, child: content);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isExpandMode ? Expanded(child: content) : content,
    );
  }
}

class _CloseMenuButton extends StatelessWidget {
  final GlassMenuStyle style;
  final bool isDark;
  final VoidCallback onTap;

  const _CloseMenuButton({
    required this.style,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
        ),
        child: Icon(
          style.closeIcon,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}

class _PositionedGlassMenu extends StatelessWidget {
  final GlassMenuPosition position;
  final EdgeInsets? margin;
  final Widget child;

  const _PositionedGlassMenu({
    super.key,
    required this.position,
    this.margin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeBottom = mediaQuery.padding.bottom;
    final safeTop = mediaQuery.padding.top;

    final defaultMargin =
        margin ??
        EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: safeBottom > 0 ? safeBottom + 8 : 20.0,
          top: safeTop > 0 ? safeTop + 8 : 20.0,
        );

    double? left;
    double? right;
    double? top;
    double? bottom;

    switch (position) {
      case GlassMenuPosition.bottomCenter:
        bottom = defaultMargin.bottom;
        left = defaultMargin.left;
        right = defaultMargin.right;
        break;
      case GlassMenuPosition.bottomLeft:
        bottom = defaultMargin.bottom;
        left = defaultMargin.left;
        break;
      case GlassMenuPosition.bottomRight:
        bottom = defaultMargin.bottom;
        right = defaultMargin.right;
        break;
      case GlassMenuPosition.topCenter:
        top = defaultMargin.top;
        left = defaultMargin.left;
        right = defaultMargin.right;
        break;
      case GlassMenuPosition.topLeft:
        top = defaultMargin.top;
        left = defaultMargin.left;
        break;
      case GlassMenuPosition.topRight:
        top = defaultMargin.top;
        right = defaultMargin.right;
        break;
      case GlassMenuPosition.centerLeft:
        left = defaultMargin.left;
        top = 0;
        bottom = 0;
        break;
      case GlassMenuPosition.centerRight:
        right = defaultMargin.right;
        top = 0;
        bottom = 0;
        break;
    }

    final isCenter =
        position == GlassMenuPosition.bottomCenter ||
        position == GlassMenuPosition.topCenter;

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: isCenter
          ? Align(
              alignment: position == GlassMenuPosition.bottomCenter
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              child: child,
            )
          : (position == GlassMenuPosition.centerLeft ||
                    position == GlassMenuPosition.centerRight
                ? Center(child: child)
                : child),
    );
  }
}
