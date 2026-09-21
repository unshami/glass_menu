import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_menu/glass_menu/glass_menu.dart';
import 'package:glass_menu/main.dart';

void main() {
  testWidgets('GlassMenu wrapContent and navigation smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GlassMenuApp());
    await tester.pumpAndSettle();

    // Verify GlassMenu is rendered
    expect(find.byType(GlassMenu), findsOneWidget);

    // Verify tabs are present inside the nav bar
    expect(
      find.descendant(of: find.byType(GlassMenu), matching: find.text('Home')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(GlassMenu),
        matching: find.text('My News'),
      ),
      findsOneWidget,
    );

    // Verify search icon is present
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // Tap Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Verify search button tap opens search overlay
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();
    expect(find.text('TRENDING SEARCHES'), findsOneWidget);

    // Close search overlay
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('GlassMenu expandable mode test', (WidgetTester tester) async {
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

    // Verify first items are present and scroll view exists
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Drag horizontally
    await tester.drag(find.text('Item 0'), const Offset(-200, 0));
    await tester.pumpAndSettle();

    // Later item should be visible
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
