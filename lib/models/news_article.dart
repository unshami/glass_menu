class NewsArticle {
  final String id;
  final String title;
  final String? summary;
  final String category;
  final String timeAgo;
  final String imageUrl;
  final bool isLive;
  final bool isHero;

  const NewsArticle({
    required this.id,
    required this.title,
    this.summary,
    required this.category,
    required this.timeAgo,
    required this.imageUrl,
    this.isLive = false,
    this.isHero = false,
  });
}

/// Sample data reproducing the BBC-style news feed seen in the screenshot.
final List<NewsArticle> sampleNewsArticles = [
  const NewsArticle(
    id: '1',
    title:
        'Hundreds of flights cancelled at UK airports as air traffic control issue causes widespread disruption',
    summary:
        'EasyJet and British Airways are among airlines reporting issues, with Ryanair saying 65,000 of its passengers have been delayed by up to eight hours.',
    category: 'UK',
    timeAgo: 'Just now',
    imageUrl:
        'https://images.unsplash.com/photo-1542296332-2e4473faf563?auto=format&fit=crop&w=1200&q=80',
    isLive: true,
    isHero: true,
  ),
  const NewsArticle(
    id: '2',
    title: "RNLI volunteers facing 'unacceptable' abuse, chief says",
    summary: null,
    category: 'England',
    timeAgo: '14m ago',
    imageUrl:
        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=800&q=80',
    isLive: false,
    isHero: false,
  ),
  const NewsArticle(
    id: '3',
    title:
        'US announces sanctions against extremist Israeli settlers in West Bank prompting international debate',
    summary:
        'The unprecedented executive order targets four individuals accused of escalating violence.',
    category: 'Middle East',
    timeAgo: '42m ago',
    imageUrl:
        'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=800&q=80',
    isLive: false,
    isHero: false,
  ),
  const NewsArticle(
    id: '4',
    title:
        'Breakthrough in clean energy: Researchers achieve sustained fusion reaction milestone',
    summary:
        'Scientists at the National Ignition Facility duplicate net energy gain with improved laser confinement.',
    category: 'Science & Tech',
    timeAgo: '1h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1507413245164-6160d8298b31?auto=format&fit=crop&w=800&q=80',
    isLive: false,
    isHero: false,
  ),
  const NewsArticle(
    id: '5',
    title: 'Global stock markets rally following central bank rate cut signals',
    summary:
        'Wall Street and European indices record strongest single-day rally in six months.',
    category: 'Business',
    timeAgo: '2h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=800&q=80',
    isLive: false,
    isHero: false,
  ),
  const NewsArticle(
    id: '6',
    title:
        'Electric aviation test flight completes historic zero-emission channel crossing',
    summary:
        'Next-generation battery cells enable commercial prototype to fly 220 miles with zero emissions.',
    category: 'Technology',
    timeAgo: '3h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=800&q=80',
    isLive: false,
    isHero: false,
  ),
];
