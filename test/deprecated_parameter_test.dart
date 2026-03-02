import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

void main() {
  group('Deprecated items parameter backward compatibility', () {
    testWidgets('should use items.length when itemCount is not provided',
        (WidgetTester tester) async {
      final items = ['A', 'B', 'C'];
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.builder(
              // ignore: deprecated_member_use
              items: items,
              itemBuilder: (context, index) {
                callCount++;
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      // Initially, it might build only visible items, but since it's a small list,
      // and default crossAxisCount is null (auto), it will build all.
      expect(callCount, equals(3));
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('should prioritize itemCount over items.length',
        (WidgetTester tester) async {
      final items = ['A', 'B', 'C'];
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.builder(
              itemCount: 2,
              // ignore: deprecated_member_use
              items: items,
              itemBuilder: (context, index) {
                callCount++;
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      expect(callCount, equals(2));
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsNothing);
    });

    testWidgets('Masonry should also support deprecated items',
        (WidgetTester tester) async {
      final items = ['A', 'B', 'C', 'D'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexMasonry.pinterest(
              // ignore: deprecated_member_use
              items: items,
              itemBuilder: (context, index) => Text('Masonry $index'),
            ),
          ),
        ),
      );

      // Need an extra pump because Pinterest layout builds children in addPostFrameCallback
      await tester.pump();

      expect(find.text('Masonry 0'), findsOneWidget);
      expect(find.text('Masonry 3'), findsOneWidget);
    });

    testWidgets('Instagram should also support deprecated items',
        (WidgetTester tester) async {
      final items = ['A', 'B', 'C', 'D', 'E', 'F'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexMasonry.instagram(
              // ignore: deprecated_member_use
              items: items,
              itemBuilder: (context, index) => Text('Insta $index'),
            ),
          ),
        ),
      );

      expect(find.text('Insta 0'), findsOneWidget);
      expect(find.text('Insta 5'), findsOneWidget);
    });
  });
}
