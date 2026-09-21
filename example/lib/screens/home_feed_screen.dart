import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_menu/glass_menu.dart';
import '../models/news_article.dart';
import '../widgets/glass_settings_sheet.dart';
import '../widgets/news_card.dart';
import 'search_overlay.dart';

class HomeFeedScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeModeChanged;

  const HomeFeedScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeModeChanged,
  });

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  int _currentTabIndex = 1; // Default to 'My News' as shown in the screenshot
  double _glassBlur = 24.0;
  double _glassOpacity = 0.52;
  GlassMenuSizeMode _sizeMode = GlassMenuSizeMode.wrapContent;
  GlassMenuPosition _position = GlassMenuPosition.bottomCenter;
  int _itemCount = 2; // Default to 2 items (Home & My News)
  double _iconSize = 24.0;
  double _fontSize = 12.0;

  // Search button & spacing options
  bool _showSearchButton = true;
  bool _expandSpaceBetween = false;
  GlassActionPosition _actionPosition = GlassActionPosition.trailing;
  double _actionSpacing = 12.0;

  final ScrollController _scrollController = ScrollController();

  // Full catalog of available menu items
  List<GlassMenuItem> get _allMenuItems => [
    const GlassMenuItem(
      icon: CupertinoIcons.house_fill,
      label: 'Home',
      tooltip: 'Home Feed',
    ),
    const GlassMenuItem(
      icon: Icons.newspaper_rounded,
      activeIcon: Icons.newspaper_rounded,
      label: 'My News',
      activeColor: Color(0xFFC41200),
      tooltip: 'Personalized News',
    ),
    GlassMenuItem(
      icon: Icons.sensors_rounded,
      label: 'Live',
      activeColor: const Color(0xFF008844),
      badge: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF008844),
          shape: BoxShape.circle,
        ),
      ),
      tooltip: 'Live Broadcasts',
    ),
    const GlassMenuItem(
      icon: Icons.play_circle_fill_rounded,
      label: 'Videos',
      tooltip: 'Video Clips',
    ),
    const GlassMenuItem(
      icon: Icons.bookmark_rounded,
      label: 'Saved',
      tooltip: 'Bookmarks',
    ),
    const GlassMenuItem(
      icon: Icons.public_rounded,
      label: 'World',
      tooltip: 'World News',
    ),
    const GlassMenuItem(
      icon: Icons.trending_up_rounded,
      label: 'Business',
      tooltip: 'Financial Markets',
    ),
    const GlassMenuItem(
      icon: Icons.memory_rounded,
      label: 'Tech',
      tooltip: 'Technology',
    ),
    const GlassMenuItem(
      icon: Icons.sports_soccer_rounded,
      label: 'Sport',
      tooltip: 'Sports Coverage',
    ),
  ];

  List<GlassMenuItem> get _activeMenuItems {
    final list = _allMenuItems.take(_itemCount).toList();
    if (_currentTabIndex >= list.length) {
      _currentTabIndex = 0;
    }
    return list;
  }

  void _openGlassSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return GlassSettingsSheet(
            blur: _glassBlur,
            opacity: _glassOpacity,
            isDarkMode: widget.isDarkMode,
            sizeMode: _sizeMode,
            position: _position,
            itemCount: _itemCount,
            iconSize: _iconSize,
            fontSize: _fontSize,
            showSearchButton: _showSearchButton,
            expandSpaceBetween: _expandSpaceBetween,
            actionPosition: _actionPosition,
            actionSpacing: _actionSpacing,
            onBlurChanged: (val) {
              setModalState(() => _glassBlur = val);
              setState(() => _glassBlur = val);
            },
            onOpacityChanged: (val) {
              setModalState(() => _glassOpacity = val);
              setState(() => _glassOpacity = val);
            },
            onThemeModeChanged: (val) {
              setModalState(() {});
              widget.onThemeModeChanged(val);
            },
            onSizeModeChanged: (val) {
              setModalState(() => _sizeMode = val);
              setState(() => _sizeMode = val);
            },
            onPositionChanged: (val) {
              setModalState(() => _position = val);
              setState(() => _position = val);
            },
            onItemCountChanged: (val) {
              setModalState(() => _itemCount = val);
              setState(() => _itemCount = val);
            },
            onIconSizeChanged: (val) {
              setModalState(() => _iconSize = val);
              setState(() => _iconSize = val);
            },
            onFontSizeChanged: (val) {
              setModalState(() => _fontSize = val);
              setState(() => _fontSize = val);
            },
            onShowSearchChanged: (val) {
              setModalState(() => _showSearchButton = val);
              setState(() => _showSearchButton = val);
            },
            onExpandSpaceChanged: (val) {
              setModalState(() => _expandSpaceBetween = val);
              setState(() => _expandSpaceBetween = val);
            },
            onActionPositionChanged: (val) {
              setModalState(() => _actionPosition = val);
              setState(() => _actionPosition = val);
            },
            onActionSpacingChanged: (val) {
              setModalState(() => _actionSpacing = val);
              setState(() => _actionSpacing = val);
            },
          );
        },
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: SearchOverlay(blur: _glassBlur, opacity: _glassOpacity),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFFFFFFF);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111111);

    final glassStyle = GlassMenuStyle(
      blur: _glassBlur,
      opacity: _glassOpacity,
      iconSize: _iconSize,
      height: 68.0,
      activeColor: const Color(0xFFC41200),
      textStyle: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        fontFamily: 'SF Pro Display',
      ),
      activeTextStyle: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        fontFamily: 'SF Pro Display',
      ),
    );

    final searchWidget = _showSearchButton
        ? SearchGlassButton(
            blur: _glassBlur,
            opacity: _glassOpacity,
            onTap: _openSearch,
          )
        : null;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. Scrollable News Feed that passes underneath the frosted glass bar
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Custom iOS-style App Bar matching screenshot
              SliverAppBar(
                backgroundColor: backgroundColor,
                surfaceTintColor: Colors.transparent,
                pinned: true,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    color: isDark ? Colors.white70 : Colors.black87,
                    size: 22,
                  ),
                  tooltip: 'Tune Glass Parameters & Library Options',
                  onPressed: _openGlassSettings,
                ),
                title: Text(
                  'My News',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                    letterSpacing: -0.3,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                            width: 1.2,
                          ),
                          color: isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.03),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Section Heading: "Latest from your follows"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Latest from your follows',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                      letterSpacing: -0.5,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
              ),

              // List of News Articles
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final article = sampleNewsArticles[index];
                  return NewsCard(
                    article: article,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opened: ${article.title}'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                }, childCount: sampleNewsArticles.length),
              ),

              // Extra bottom padding so last article scrolls completely clear of floating bar
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),

          // 2. Floating Frosted Glass Menu with configurable search and alignment
          GlassMenu.positioned(
            position: _position,
            sizeMode: _sizeMode,
            style: glassStyle,
            items: _activeMenuItems,
            currentIndex: _currentTabIndex,
            actionSpacing: _actionSpacing,
            expandSpaceBetween: _expandSpaceBetween,
            leadingAction: _actionPosition == GlassActionPosition.leading
                ? searchWidget
                : null,
            trailingAction: _actionPosition == GlassActionPosition.trailing
                ? searchWidget
                : null,
            onItemSelected: (index) {
              setState(() => _currentTabIndex = index);
              if (index == 0) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
