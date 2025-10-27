import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

void main() {
  setUpAll(() {
    ResponsiveConfig.init(breakpoints: Breakpoints.defaultBreakpoints);
  });

  // ============================================
  // GROUP 1: Default Constructor Tests
  // ============================================
  group('ResponsiveFlexList (default constructor)', () {
    group('basic functionality', () {
      testWidgets('builds with required children parameter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              children: [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });

      testWidgets('renders single child correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              children: [
                Text('Single Item'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Single Item'), findsOneWidget);
      });

      testWidgets('handles empty children list', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              children: [],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        expect(find.text('No items to display'), findsOneWidget);
      });
    });

    group('spacing customization', () {
      testWidgets('accepts custom crossAxisSpacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList(
              crossAxisSpacing: 20,
              children: [
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.blue),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts custom mainAxisSpacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList(
              mainAxisSpacing: 15,
              children: [
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.blue),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts both spacing parameters together', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList(
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
              children: [
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.blue),
                Container(height: 100, color: Colors.green),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('padding and layout', () {
      testWidgets('accepts padding parameter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              padding: EdgeInsets.all(16),
              children: [
                Text('Padded Item'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Padded Item'), findsOneWidget);
      });

      testWidgets('respects shrinkWrap parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList(
              shrinkWrap: true,
              children: [
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.blue),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('respects reverse parameter', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              reverse: true,
              children: [
                Text('First'),
                Text('Second'),
                Text('Third'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('animations', () {
      testWidgets(
          'throws assertion error when animationDuration is set without animation',
          (tester) async {
        expect(
          () => ResponsiveFlexList(
            animationDuration: const Duration(milliseconds: 300),
            animationType: ResponsiveAnimationType.none,
            children: const [Text('Item')],
          ),
          throwsAssertionError,
        );
      });

      testWidgets('builds with fade animation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              animationDuration: Duration(milliseconds: 300),
              animationType: ResponsiveAnimationType.fade,
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('builds with slide animation', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              animationDuration: Duration(milliseconds: 300),
              animationType: ResponsiveAnimationType.slide,
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts stagger delay for animations', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              animationDuration: Duration(milliseconds: 300),
              animationType: ResponsiveAnimationType.fade,
              staggerDelay: Duration(milliseconds: 50),
              children: [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('RTL support', () {
      testWidgets('builds with RTL options', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              rtlOptions: RTLOptions(
                mirrorAnimations: true,
                reverseRowOrder: true,
              ),
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('scrolling behavior', () {
      testWidgets('accepts custom ScrollController', (tester) async {
        final controller = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList(
              controller: controller,
              children: List.generate(
                20,
                (i) => SizedBox(height: 100, child: Text('Item $i')),
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        controller.dispose();
      });

      testWidgets('accepts custom ScrollPhysics', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('breakpoints', () {
      testWidgets('accepts custom breakpoints', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ResponsiveFlexList(
              breakpoints: Breakpoints(
                mobile: 400,
                mobileColumns: 2,
                tablet: 800,
                tabletColumns: 4,
              ),
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });
  });

  // ============================================
  // GROUP 2: Builder Constructor Tests
  // ============================================
  group('ResponsiveFlexList.builder', () {
    group('basic functionality', () {
      testWidgets('builds items from data list', (tester) async {
        final items = ['Apple', 'Banana', 'Cherry'];

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: items,
              itemBuilder: (item, index) => Text(item!),
            ),
          ),
        );

        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);
      });

      testWidgets('itemBuilder receives correct index and item',
          (tester) async {
        final items = [1, 2, 3];

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: items,
              itemBuilder: (item, index) => Text('Index: $index, Value: $item'),
            ),
          ),
        );

        expect(find.text('Index: 0, Value: 1'), findsOneWidget);
        expect(find.text('Index: 1, Value: 2'), findsOneWidget);
        expect(find.text('Index: 2, Value: 3'), findsOneWidget);
      });

      testWidgets('handles empty items list', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const [],
              itemBuilder: (item, index) => Text('Item $item'),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        expect(find.text('No items to display'), findsOneWidget);
      });

      testWidgets('handles single item', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const ['Single'],
              itemBuilder: (item, index) => Text(item!),
            ),
          ),
        );

        expect(find.text('Single'), findsOneWidget);
      });

      testWidgets('handles large item list', (tester) async {
        final items = List.generate(100, (i) => 'Item $i');

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: items,
              itemBuilder: (item, index) => SizedBox(
                height: 100,
                child: Text(item!),
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        // Only visible items will be found
        expect(find.text('Item 0'), findsOneWidget);
      });
    });

    group('default spacing', () {
      testWidgets('applies default spacing (10, 10)', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Container(
                height: 100,
                color: Colors.blue,
                child: Text('Item $item'),
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('custom spacing', () {
      testWidgets('accepts custom mainAxisSpacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSpacing: 20,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts custom crossAxisSpacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              crossAxisSpacing: 15,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('animations', () {
      testWidgets(
          'throws assertion error when animationDuration is set without animation',
          (tester) async {
        expect(
          () => ResponsiveFlexList.builder(
            items: const [1, 2, 3],
            itemBuilder: (item, index) => Text('Item $item'),
            animationDuration: const Duration(milliseconds: 300),
            animationType: ResponsiveAnimationType.none,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('builds with animation enabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              animationDuration: const Duration(milliseconds: 300),
              animationType: ResponsiveAnimationType.fade,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('complex data types', () {
      testWidgets('works with Map data', (tester) async {
        final items = [
          {'name': 'John', 'age': 30},
          {'name': 'Jane', 'age': 25},
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: items,
              itemBuilder: (item, index) =>
                  Text('${item!['name']} - ${item['age']}'),
            ),
          ),
        );

        expect(find.text('John - 30'), findsOneWidget);
        expect(find.text('Jane - 25'), findsOneWidget);
      });

      testWidgets('works with custom objects', (tester) async {
        final items = [
          {'name': 'Laptop', 'price': 999},
          {'name': 'Mouse', 'price': 29}
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              items: items,
              itemBuilder: (item, index) =>
                  Text('${item!['name']}: \$${item['price']}'),
            ),
          ),
        );

        expect(find.text('Laptop: \$999'), findsOneWidget);
        expect(find.text('Mouse: \$29'), findsOneWidget);
      });
    });
  });

  // ============================================
  // GROUP 3: WithSeparators Constructor Tests
  // ============================================
  group('ResponsiveFlexList.withSeparators', () {
    group('basic functionality', () {
      testWidgets('builds with separators', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(thickness: 2),
              crossAxisSeparator: (index, total) =>
                  const VerticalDivider(thickness: 1),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);

        expect(find.byType(VerticalDivider), findsWidgets);
      });

      testWidgets('mainAxisSeparator is required', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2],
              // assures it behave like list (so it can create divider)
              crossAxisCount: 1,
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
            ),
          ),
        );

        expect(find.byType(Divider), findsWidgets);
      });

      testWidgets('crossAxisSeparator is required', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
            ),
          ),
        );

        expect(find.byType(VerticalDivider), findsWidgets);
      });
    });

    group('separator customization', () {
      testWidgets('accepts custom Divider styles', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              crossAxisCount: 1,
              mainAxisSeparator: (index, total) => const Divider(
                thickness: 3,
                color: Colors.red,
                height: 20,
              ),
              crossAxisSeparator: (index, total) => const VerticalDivider(
                thickness: 2,
                color: Colors.blue,
              ),
            ),
          ),
        );

        expect(find.byType(Divider), findsWidgets);
      });

      testWidgets('accepts custom separator widgets', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => Container(
                height: 2,
                color: Colors.grey,
              ),
              crossAxisSeparator: (index, total) => Container(
                width: 2,
                color: Colors.grey,
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('separator modes', () {
      testWidgets('accepts mainAxisSeparatorMode parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              mainAxisSeparatorMode: MainAxisSeparatorMode.itemWidth,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('with animations', () {
      testWidgets('supports animations with separators', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              animationDuration: const Duration(milliseconds: 300),
              animationType: ResponsiveAnimationType.fade,
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('layout options', () {
      testWidgets('accepts useIntrinsicHeight parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => SizedBox(
                height: item! * 50.0,
                child: Text('Item $item'),
              ),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              useIntrinsicHeight: true,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts maxRowHeight parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3],
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              maxRowHeight: 200,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });

      testWidgets('accepts roundRobinLayout parameter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              items: const [1, 2, 3, 4, 5],
              itemBuilder: (item, index) => SizedBox(
                height: 100,
                child: Text('Item $item'),
              ),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              roundRobinLayout: true,
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });
  });

  // ============================================
  // GROUP 4: Common/Edge Cases
  // ============================================
  group('ResponsiveFlexList edge cases', () {
    testWidgets('builds with all optional parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList.builder(
            items: const [1, 2, 3],
            itemBuilder: (item, index) => Text('Item $item'),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            reverse: false,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            animationDuration: const Duration(milliseconds: 500),
            animationType: ResponsiveAnimationType.slide,
            staggerDelay: const Duration(milliseconds: 50),
            rtlOptions: const RTLOptions(
              mirrorAnimations: true,
              reverseRowOrder: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ResponsiveFlexList), findsOneWidget);
    });

    testWidgets('handles very large item counts', (tester) async {
      final largeList = List.generate(1000, (i) => i);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList.builder(
            items: largeList,
            itemBuilder: (item, index) => SizedBox(
              height: 50,
              child: Text('Item $item'),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexList), findsOneWidget);
    });

    testWidgets('works within nested scrollables', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Header'),
                ResponsiveFlexList.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  items: const [1, 2, 3],
                  itemBuilder: (item, index) => SizedBox(
                    height: 100,
                    child: Text('Item $item'),
                  ),
                ),
                const Text('Footer'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
      expect(find.byType(ResponsiveFlexList), findsOneWidget);
    });
  });
}
