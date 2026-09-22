## 1.1.0

* **Dynamic Width Sizing with `expandSpaceBetween`**:
  * Menu capsule now dynamically hugs 2 items on one side, smoothly expands to accommodate 3–5 items, and caps at available screen width for 9+ items with horizontal scrolling.
  * Replaced rigid `Spacer` with `MainAxisAlignment.spaceBetween` for responsive flex distribution.
* **Search Button Customization**:
  * Added `borderColor`, `borderWidth`, and `iconColor` customization parameters to `SearchGlassButton`.
  * `GlassNavBar` now automatically synchronizes border color, border width, inactive icon color, and circular button diameter (`height`) with the menu styling.
* **Anti-Overflow Safeguards**:
  * Added `FittedBox` scale-down safeguard on menu items to prevent vertical `RenderFlex` overflow errors when using large icon and font sizes.
* **Documentation & Gallery**:
  * Added high-resolution mobile dark mode screenshot preview.

## 1.0.2

* Featured mobile preview screenshot as the primary preview in pubspec and search cards.
* Displayed both mobile and desktop previews side-by-side in README documentation.

## 1.0.1

* Added `showSearchButton` to make the search action optional (defaults to `true`).
* Added `actionSpacing` for customizable space between the menu and search button.
* Added `expandSpaceBetween` to push menu and action button to opposite edges (left/right alignment).
* Added `actionPosition` (`GlassActionPosition.trailing` and `GlassActionPosition.leading`) for reversed alignment.
* Updated repository links and added screenshots in pub.dev gallery and README.

## 1.0.0

* Initial release of `glass_menu`.
* Pure native Flutter implementation with zero external dependencies (`BackdropFilter`, specular gradients, rim borders, elevation shadows).
* Supports sizing modes:
  * `wrapContent`: Hugs menu items snugly without stretching across wide screens.
  * `expandable`: Collapses into a compact frosted glass "Menu" pill and animates open on tap.
  * `fullWidth`: Edge-to-edge docked navigation bar.
* Anti-overflow horizontal scrolling with touch, mouse, and trackpad drag support.
* Complete typography, color, active indicator, and icon customization via `GlassMenuStyle`.
* Preset screen anchors via `GlassMenuPosition` (`bottomCenter`, `topCenter`, `bottomLeft`, etc.).
* Standalone detached circular frosted glass action button (`SearchGlassButton`).
* Pre-built `GlassNavBar` widget for instant plug-and-play usage.
