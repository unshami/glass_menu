import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

/// Fullscreen search overlay featuring a floating glass search input and trending tags.
class SearchOverlay extends StatelessWidget {
  final double blur;
  final double opacity;

  const SearchOverlay({super.key, required this.blur, required this.opacity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final trendingSearches = [
      'UK Airport Disruption',
      'Air Traffic Control',
      'Ryanair Delays',
      'RNLI Volunteers',
      'Weather Forecast',
      'Stock Market Updates',
      'Clean Energy Fusion',
    ];

    return Scaffold(
      backgroundColor: isDark
          ? Colors.black.withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.88),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Row with Glass styling
              Row(
                children: [
                  Expanded(
                    child: GlassContainer(
                      height: 52,
                      blur: blur,
                      opacity: opacity,
                      borderRadius: BorderRadius.circular(26),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: isDark ? Colors.white60 : Colors.black54,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search topics, news, videos...',
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFC41200),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Trending searches section
              const Text(
                'TRENDING SEARCHES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Color(0xFFC41200),
                ),
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: trendingSearches.map((term) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            term,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
