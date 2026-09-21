import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_menu/glass_menu.dart';

void main() {
  testWidgets('GlassMenu wrapContent mode renders items properly', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return GlassMenu(
                sizeMode: GlassMenuSizeMode.wrapContent,
                currentIndex: selectedIndex,
                onItemSelected: (idx) => setState(() => selectedIndex = idx),
                items: const [
                  GlassMenuItem(icon: Icons.home, label: 'Home'),
                  GlassMenuItem(icon: Icons.article, label: 'My News'),
                ],
                trailingAction: SearchGlassButton(onTap: () {}),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify GlassMenu is rendered
    expect(find.byType(GlassMenu), findsOneWidget);

    // Verify items are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My News'), findsOneWidget);

    // Verify trailing search button
    expect(find.byType(SearchGlassButton), findsOneWidget);

    // Tap Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(selectedIndex, 0);
  });

  testWidgets('GlassMenu expandable mode toggles correctly', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 0;
    bool expanded = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return GlassMenu(
                sizeMode: GlassMenuSizeMode.expandable,
                isExpanded: expanded,
                onExpandChanged: (val) => setState(() => expanded = val),
                currentIndex: selectedIndex,
                onItemSelected: (idx) => setState(() => selectedIndex = idx),
                items: const [
                  GlassMenuItem(icon: Icons.home, label: 'Home'),
                  GlassMenuItem(icon: Icons.article, label: 'News'),
                  GlassMenuItem(icon: Icons.settings, label: 'Settings'),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Initially collapsed: shows "Menu" text
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('News'), findsNothing);

    // Tap "Menu" to expand
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();

    // Now expanded: shows all options
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Tap close button to collapse
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Back to collapsed state
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('News'), findsNothing);
  });

  testWidgets('GlassMenu horizontal scroll with many items test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: GlassMenu(
              sizeMode: GlassMenuSizeMode.wrapContent,
              currentIndex: 0,
              onItemSelected: (_) {},
              items: List.generate(
                10,
                (i) => GlassMenuItem(icon: Icons.star, label: 'Item $i'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Drag horizontally
    await tester.drag(find.text('Item 0'), const Offset(-200, 0));
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('GlassNavBar search visibility and positioning test', (
    WidgetTester tester,
  ) async {
    // 1. By default, search button IS visible
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              GlassNavBar(
                currentIndex: 0,
                onTap: (_) {},
                items: const [
                  GlassNavItem(icon: Icons.home, label: 'Home'),
                  GlassNavItem(icon: Icons.feed, label: 'Feed'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchGlassButton), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    // 2. When showSearchButton: false, search button is hidden
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              GlassNavBar(
                currentIndex: 0,
                showSearchButton: false,
                onTap: (_) {},
                items: const [
                  GlassNavItem(icon: Icons.home, label: 'Home'),
                  GlassNavItem(icon: Icons.feed, label: 'Feed'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchGlassButton), findsNothing);

    // 3. When actionPosition: GlassActionPosition.leading and expandSpaceBetween: true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              GlassNavBar(
                currentIndex: 0,
                showSearchButton: true,
                actionPosition: GlassActionPosition.leading,
                expandSpaceBetween: true,
                actionSpacing: 20.0,
                onTap: (_) {},
                items: const [
                  GlassNavItem(icon: Icons.home, label: 'Home'),
                  GlassNavItem(icon: Icons.feed, label: 'Feed'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchGlassButton), findsOneWidget);
    expect(find.byType(Spacer), findsOneWidget);
  });
}
