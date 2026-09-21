import 'package:flutter/material.dart';
import '../models/news_article.dart';

/// News card widget rendering both Hero cards (like the flight cancellation story)
/// and compact thumbnail cards (like the RNLI rescue story).
class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF121212);
    final secondaryTextColor = isDark
        ? Colors.white70
        : const Color(0xFF4A4A4A);
    final accentRed = const Color(0xFFC41200);

    if (article.isHero) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image with graceful fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(
                          isDark: isDark,
                          icon: Icons.flight_takeoff_rounded,
                          label: 'Airport Terminal Disruption',
                        ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoading(isDark);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Live Indicator if applicable
              if (article.isLive) ...[
                Row(
                  children: [
                    Container(
                      width: 13,
                      height: 13,
                      decoration: const BoxDecoration(
                        color: Color(0xFF006633),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Color(0xFF006633),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 0.5,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              // Main Headline
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor,
                  height: 1.22,
                  letterSpacing: -0.4,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const SizedBox(height: 8),

              // Summary
              if (article.summary != null) ...[
                Text(
                  article.summary!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                    height: 1.35,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Category tag
              Text(
                article.category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: accentRed,
                ),
              ),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                thickness: 0.8,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ],
          ),
        ),
      );
    }

    // Standard list item (thumbnail + text)
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    width: 135,
                    height: 85,
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(
                            isDark: isDark,
                            icon: Icons.sailing_rounded,
                            label: 'News Image',
                          ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoading(isDark);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Headline & Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor,
                          height: 1.25,
                          letterSpacing: -0.3,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            article.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentRed,
                            ),
                          ),
                          Text(
                            '  •  ${article.timeAgo}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 0.8,
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({
    required bool isDark,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
              : [const Color(0xFFE5E5EA), const Color(0xFFD1D1D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
