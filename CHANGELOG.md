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
