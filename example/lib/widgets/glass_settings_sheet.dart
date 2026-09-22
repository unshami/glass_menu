import 'package:flutter/material.dart';
import 'package:glass_menu/glass_menu.dart';

/// Modal bottom sheet that lets users adjust glass parameters and test
/// library modes (wrapContent, expandable, item count, positioning, search options).
class GlassSettingsSheet extends StatelessWidget {
  final double blur;
  final double opacity;
  final bool isDarkMode;
  final GlassMenuSizeMode sizeMode;
  final GlassMenuPosition position;
  final int itemCount;
  final double iconSize;
  final double fontSize;
  final bool showSearchButton;
  final bool expandSpaceBetween;
  final GlassActionPosition actionPosition;
  final double actionSpacing;

  final ValueChanged<double> onBlurChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<GlassMenuSizeMode> onSizeModeChanged;
  final ValueChanged<GlassMenuPosition> onPositionChanged;
  final ValueChanged<int> onItemCountChanged;
  final ValueChanged<double> onIconSizeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onShowSearchChanged;
  final ValueChanged<bool> onExpandSpaceChanged;
  final ValueChanged<GlassActionPosition> onActionPositionChanged;
  final ValueChanged<double> onActionSpacingChanged;

  const GlassSettingsSheet({
    super.key,
    required this.blur,
    required this.opacity,
    required this.isDarkMode,
    required this.sizeMode,
    required this.position,
    required this.itemCount,
    required this.iconSize,
    required this.fontSize,
    required this.showSearchButton,
    required this.expandSpaceBetween,
    required this.actionPosition,
    required this.actionSpacing,
    required this.onBlurChanged,
    required this.onOpacityChanged,
    required this.onThemeModeChanged,
    required this.onSizeModeChanged,
    required this.onPositionChanged,
    required this.onItemCountChanged,
    required this.onIconSizeChanged,
    required this.onFontSizeChanged,
    required this.onShowSearchChanged,
    required this.onExpandSpaceChanged,
    required this.onActionPositionChanged,
    required this.onActionSpacingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      blur: 30,
      opacity: isDark ? 0.85 : 0.92,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Glass Menu Customizer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // 1. Sizing Mode (wrapContent vs expandable vs fullWidth)
              const Text(
                '1. Sizing & Expandable Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              SegmentedButton<GlassMenuSizeMode>(
                segments: const [
                  ButtonSegment(
                    value: GlassMenuSizeMode.wrapContent,
                    label: Text('Wrap Content'),
                    icon: Icon(Icons.fit_screen_rounded, size: 16),
                  ),
                  ButtonSegment(
                    value: GlassMenuSizeMode.expandable,
                    label: Text('Expandable'),
                    icon: Icon(Icons.unfold_more_rounded, size: 16),
                  ),
                  ButtonSegment(
                    value: GlassMenuSizeMode.fullWidth,
                    label: Text('Full Width'),
                    icon: Icon(Icons.fullscreen_rounded, size: 16),
                  ),
                ],
                selected: {sizeMode},
                onSelectionChanged: (val) => onSizeModeChanged(val.first),
              ),
              const SizedBox(height: 16),

              // 2. Search Button & Alignment (User's new options!)
              const Text(
                '2. Search Button & Alignment Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show Search Button (Optional)'),
                subtitle: const Text('Search button visible by default'),
                value: showSearchButton,
                activeThumbColor: const Color(0xFFC41200),
                onChanged: onShowSearchChanged,
              ),
              if (showSearchButton) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Expand Space Between (Opposite Edges)'),
                  subtitle: const Text(
                    'Menu on one side, search button on the other side',
                  ),
                  value: expandSpaceBetween,
                  activeThumbColor: const Color(0xFFC41200),
                  onChanged: onExpandSpaceChanged,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Search Position: '),
                    ChoiceChip(
                      label: const Text('Trailing (Right)'),
                      selected: actionPosition == GlassActionPosition.trailing,
                      onSelected: (_) =>
                          onActionPositionChanged(GlassActionPosition.trailing),
                    ),
                    ChoiceChip(
                      label: const Text('Leading (Left)'),
                      selected: actionPosition == GlassActionPosition.leading,
                      onSelected: (_) =>
                          onActionPositionChanged(GlassActionPosition.leading),
                    ),
                  ],
                ),
                if (!expandSpaceBetween) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Space Between Menu & Search:'),
                      Text(
                        '${actionSpacing.toInt()}px',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: actionSpacing,
                    min: 4.0,
                    max: 48.0,
                    divisions: 22,
                    activeColor: const Color(0xFFC41200),
                    onChanged: onActionSpacingChanged,
                  ),
                ],
              ],
              const SizedBox(height: 16),

              // 3. Menu Item Count (2 items vs 5 items vs 9 items)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '3. Item Count (Horizontal Scroll Test)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '$itemCount items',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC41200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('2 Items (Screenshot)'),
                    selected: itemCount == 2,
                    onSelected: (_) => onItemCountChanged(2),
                  ),
                  ChoiceChip(
                    label: const Text('5 Items'),
                    selected: itemCount == 5,
                    onSelected: (_) => onItemCountChanged(5),
                  ),
                  ChoiceChip(
                    label: const Text('9 Items (Scrollable)'),
                    selected: itemCount == 9,
                    onSelected: (_) => onItemCountChanged(9),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Screen Position
              const Text(
                '4. Screen Position Anchor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ChoiceChip(
                    label: const Text('Bottom Center'),
                    selected: position == GlassMenuPosition.bottomCenter,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.bottomCenter),
                  ),
                  ChoiceChip(
                    label: const Text('Bottom Left'),
                    selected: position == GlassMenuPosition.bottomLeft,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.bottomLeft),
                  ),
                  ChoiceChip(
                    label: const Text('Bottom Right'),
                    selected: position == GlassMenuPosition.bottomRight,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.bottomRight),
                  ),
                  ChoiceChip(
                    label: const Text('Top Center'),
                    selected: position == GlassMenuPosition.topCenter,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.topCenter),
                  ),
                  ChoiceChip(
                    label: const Text('Top Left'),
                    selected: position == GlassMenuPosition.topLeft,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.topLeft),
                  ),
                  ChoiceChip(
                    label: const Text('Top Right'),
                    selected: position == GlassMenuPosition.topRight,
                    onSelected: (_) =>
                        onPositionChanged(GlassMenuPosition.topRight),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Typography & Icon Size
              const Text(
                '5. Icon & Font Customization',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Icon Size: ${iconSize.toInt()}px'),
                        Slider(
                          value: iconSize,
                          min: 18.0,
                          max: 32.0,
                          divisions: 14,
                          activeColor: const Color(0xFFC41200),
                          onChanged: onIconSizeChanged,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Font Size: ${fontSize.toInt()}px'),
                        Slider(
                          value: fontSize,
                          min: 10.0,
                          max: 18.0,
                          divisions: 8,
                          activeColor: const Color(0xFFC41200),
                          onChanged: onFontSizeChanged,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 6. Blur & Opacity Sliders
              const Text(
                '6. Glass Material Properties',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Blur (Sigma): ${blur.toStringAsFixed(1)}'),
                  Text('Opacity: ${(opacity * 100).toInt()}%'),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: blur,
                      min: 4.0,
                      max: 40.0,
                      divisions: 36,
                      activeColor: const Color(0xFFC41200),
                      onChanged: onBlurChanged,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: opacity,
                      min: 0.15,
                      max: 0.90,
                      divisions: 15,
                      activeColor: const Color(0xFFC41200),
                      onChanged: onOpacityChanged,
                    ),
                  ),
                ],
              ),

              // Theme Mode
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Test against dark background themes'),
                value: isDarkMode,
                activeThumbColor: const Color(0xFFC41200),
                onChanged: onThemeModeChanged,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
