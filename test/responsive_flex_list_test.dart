import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

void main() {
  setUp(() {
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
            animationType: AnimationType.none,
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
              animationType: AnimationType.fade,
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
              animationType: AnimationType.slide,
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
              animationType: AnimationType.fade,
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
              itemCount: items.length,
              itemBuilder: (context, index) => Text(items[index]),
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
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  Text('Index: $index, Value: ${items[index]}'),
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
              itemCount: 0,
              itemBuilder: (context, index) => const Text('Item'),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        expect(find.text('No items to display'), findsOneWidget);
      });

      testWidgets('handles single item', (tester) async {
        final items = const ['Single'];
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Text(items[index]),
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
              itemCount: items.length,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                child: Text(items[index]),
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
        // Only visible items will be found
        expect(find.text('Item 0'), findsOneWidget);
      });

      testWidgets('keeps last row item width aligned with full rows',
          (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 600));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              itemCount: 4,
              itemBuilder: (context, index) => SizedBox(
                key: ValueKey('item-$index'),
                height: 80,
                child: Text('Item $index'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(const ValueKey('item-3'))).width,
          equals(tester.getSize(find.byKey(const ValueKey('item-0'))).width),
        );
      });
    });

    group('default spacing', () {
      testWidgets('applies default spacing (10, 10)', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              itemCount: const [1, 2, 3].length,
              itemBuilder: (context, index) => Container(
                height: 100,
                color: Colors.blue,
                child: Text('Item ${const [1, 2, 3][index]}'),
              ),
            ),
          ),
        );

        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('custom spacing', () {
      testWidgets('accepts custom mainAxisSpacing', (tester) async {
        final items = const [1, 2, 3];
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Text('Item ${items[index]}'),
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
              itemCount: const [1, 2, 3].length,
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
            itemCount: 3,
            itemBuilder: (context, index) => Text('Item $index'),
            animationDuration: const Duration(milliseconds: 300),
            animationType: AnimationType.none,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('builds with animation enabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.builder(
              itemCount: const [1, 2, 3].length,
              itemBuilder: (item, index) => Text('Item $item'),
              animationDuration: const Duration(milliseconds: 300),
              animationType: AnimationType.fade,
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
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Text('${item['name']} - ${item['age']}');
              },
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
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Text('${item['name']}: \$${item['price']}');
              },
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
              itemCount: const [1, 2, 3].length,
              itemBuilder: (context, index) =>
                  Text('Item ${const [1, 2, 3][index]}'),
              mainAxisSeparator: (int index, int total) =>
                  const Divider(thickness: 2),
              crossAxisSeparator: (int index, int total) =>
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
              itemCount: const [1, 2].length,
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
              itemCount: const [1, 2].length,
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
              itemCount: const [1, 2, 3].length,
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
              itemCount: const [1, 2, 3].length,
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
              itemCount: const [1, 2, 3].length,
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
              itemCount: const [1, 2, 3].length,
              itemBuilder: (item, index) => Text('Item $item'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              animationDuration: const Duration(milliseconds: 300),
              animationType: AnimationType.fade,
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveFlexList), findsOneWidget);
      });
    });

    group('layout options', () {
      testWidgets('accepts useIntrinsicHeight parameter', (tester) async {
        final items = const [1, 2, 3];
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return SizedBox(
                  height: item * 50.0,
                  child: Text('Item $item'),
                );
              },
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
              itemCount: const [1, 2, 3].length,
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
              itemCount: const [1, 2, 3, 4, 5].length,
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

      testWidgets('forwards physics when roundRobinLayout is true',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveFlexList.withSeparators(
              itemCount: 5,
              itemBuilder: (item, index) => Text('Item $index'),
              mainAxisSeparator: (index, total) => const Divider(),
              crossAxisSeparator: (index, total) => const VerticalDivider(),
              roundRobinLayout: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        );

        final customScroll = tester.widget<CustomScrollView>(
          find
              .descendant(
                of: find.byType(ResponsiveFlexList),
                matching: find.byType(CustomScrollView),
              )
              .first,
        );
        expect(customScroll.physics, isA<NeverScrollableScrollPhysics>());
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
            itemCount: 4,
            itemBuilder: (context, index) => Text('Item $index'),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            reverse: false,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            animationDuration: const Duration(milliseconds: 500),
            animationType: AnimationType.slide,
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
            itemCount: largeList.length,
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
                  itemCount: const [1, 2, 3].length,
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
    testWidgets('respects minCrossAxisCount boundary', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 600)); // Small mobile

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            minCrossAxisCount: 2,
            children: [
              SizedBox(height: 100, child: Text('Item 1')),
              SizedBox(height: 100, child: Text('Item 2')),
              SizedBox(height: 100, child: Text('Item 3')),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      final item1Pos = tester.getCenter(find.text('Item 1'));
      final item2Pos = tester.getCenter(find.text('Item 2'));

      expect(item1Pos.dy, equals(item2Pos.dy)); // Same row

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('respects maxCrossAxisCount boundary', (tester) async {
      await tester.binding
          .setSurfaceSize(const Size(1400, 600)); // Large desktop

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList(
            maxCrossAxisCount: 3,
            children: List.generate(10, (i) => Text('Item $i')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final item1Pos = tester.getCenter(find.text('Item 0'));
      final item2Pos = tester.getCenter(find.text('Item 1'));
      final item3Pos = tester.getCenter(find.text('Item 2'));
      final item4Pos = tester.getCenter(find.text('Item 3'));

      expect(item1Pos.dy, equals(item2Pos.dy));
      expect(item2Pos.dy, equals(item3Pos.dy));
      expect(item3Pos.dy,
          isNot(equals(item4Pos.dy))); // Item 3 should be on next row

      await tester.binding.setSurfaceSize(null);
    });
  });

  group('Breakpoints model', () {
    test('breakpoint_copy_with_preserves_extra_large_desktop', () {
      final copied = Breakpoints.defaultBreakpoints.copyWith(
        mobileColumns: 3,
      );

      expect(
        copied.extraLargeDesktop,
        equals(Breakpoints.defaultBreakpoints.extraLargeDesktop),
      );
      expect(
        copied.extraLargeDesktopColumns,
        equals(Breakpoints.defaultBreakpoints.extraLargeDesktopColumns),
      );
    });

    test('breakpoint_merge_with_includes_extra_large_desktop', () {
      const base = Breakpoints(
        extraLargeDesktop: 1800,
        extraLargeDesktopColumns: 9,
      );

      final merged = base.mergeWith(
        const Breakpoints(
          mobile: 420,
          mobileColumns: 2,
          extraLargeDesktop: 2000,
          extraLargeDesktopColumns: 10,
        ),
      );

      expect(merged.extraLargeDesktop, equals(2000));
      expect(merged.extraLargeDesktopColumns, equals(10));
    });

    test('breakpoint_equality_includes_extra_large_desktop', () {
      final first = Breakpoints.defaultBreakpoints.copyWith(
        extraLargeDesktopColumns: 8,
      );
      final second = Breakpoints.defaultBreakpoints.copyWith(
        extraLargeDesktopColumns: 9,
      );

      expect(first, isNot(equals(second)));
      expect(first.hashCode, isNot(equals(second.hashCode)));
    });
  });

  group('Responsive breakpoint resolution', () {
    Future<void> pumpResponsiveList(
      WidgetTester tester, {
      required double width,
      required int itemCount,
    }) async {
      await tester.binding.setSurfaceSize(Size(width, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList(
            children: List.generate(
              itemCount,
              (index) => SizedBox(height: 80, child: Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    void expectColumnCount(WidgetTester tester, int columns) {
      final firstRowY = tester.getCenter(find.text('Item 0')).dy;
      for (int index = 1; index < columns; index++) {
        expect(
          tester.getCenter(find.text('Item $index')).dy,
          equals(firstRowY),
        );
      }
      expect(
        tester.getCenter(find.text('Item $columns')).dy,
        isNot(equals(firstRowY)),
      );
    }

    testWidgets(
        'width_below_mobile_resolves_as_small_mobile_when_small_mobile_is_defined',
        (tester) async {
      await pumpResponsiveList(tester, width: 300, itemCount: 2);

      expectColumnCount(tester, 1);
    });

    testWidgets('mobile_resolves_between_mobile_and_small_tablet',
        (tester) async {
      await pumpResponsiveList(tester, width: 500, itemCount: 3);

      expectColumnCount(tester, 2);
    });

    testWidgets('desktop_resolves_between_desktop_and_large_desktop',
        (tester) async {
      await pumpResponsiveList(tester, width: 1300, itemCount: 7);

      expectColumnCount(tester, 6);
    });

    testWidgets(
        'largeDesktop_resolves_between_largeDesktop_and_extraLargeDesktop',
        (tester) async {
      await pumpResponsiveList(tester, width: 1500, itemCount: 8);

      expectColumnCount(tester, 7);
    });

    testWidgets('extraLargeDesktop_resolves_at_and_above_extraLargeDesktop',
        (tester) async {
      await pumpResponsiveList(tester, width: 1920, itemCount: 9);
      expectColumnCount(tester, 8);

      await pumpResponsiveList(tester, width: 2200, itemCount: 9);
      expectColumnCount(tester, 8);
    });

    testWidgets('default_breakpoint_boundaries_select_expected_columns',
        (tester) async {
      await pumpResponsiveList(tester, width: 1023, itemCount: 6);
      expectColumnCount(tester, Breakpoints.defaultBreakpoints.laptopColumns);

      await pumpResponsiveList(tester, width: 1024, itemCount: 7);
      expectColumnCount(tester, Breakpoints.defaultBreakpoints.desktopColumns);

      await pumpResponsiveList(tester, width: 1439, itemCount: 7);
      expectColumnCount(tester, Breakpoints.defaultBreakpoints.desktopColumns);

      await pumpResponsiveList(tester, width: 1440, itemCount: 8);
      expectColumnCount(
        tester,
        Breakpoints.defaultBreakpoints.largeDesktopColumns,
      );

      await pumpResponsiveList(tester, width: 1919, itemCount: 8);
      expectColumnCount(
        tester,
        Breakpoints.defaultBreakpoints.largeDesktopColumns,
      );

      await pumpResponsiveList(tester, width: 1920, itemCount: 9);
      expectColumnCount(
        tester,
        Breakpoints.defaultBreakpoints.extraLargeDesktopColumns,
      );
    });

    testWidgets('default_breakpoint_edges_select_expected_columns',
        (tester) async {
      final expectedColumnsByWidth = <double, int>{
        0: 1,
        599: 2,
        600: 2,
        819: 4,
        820: 5,
        1023: 5,
        1024: 6,
        1439: 6,
        1440: 7,
        1919: 7,
        1920: 8,
      };

      for (final entry in expectedColumnsByWidth.entries) {
        await pumpResponsiveList(
          tester,
          width: entry.key,
          itemCount: entry.value + 1,
        );

        expectColumnCount(tester, entry.value);
      }
    });

    testWidgets('context_helpers_use_exact_desktop_boundaries', (tester) async {
      Future<void> expectFlagsAtWidth(
        double width, {
        required bool isLaptop,
        required bool isDesktop,
        required bool isLargeDesktop,
        required bool isExtraLargeDesktop,
      }) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 600);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text('laptop:${context.isLaptop}'),
                    Text('desktop:${context.isDesktop}'),
                    Text('large:${context.isLargeDesktop}'),
                    Text('extra:${context.isExtraLargeDesktop}'),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('laptop:$isLaptop'), findsOneWidget);
        expect(find.text('desktop:$isDesktop'), findsOneWidget);
        expect(find.text('large:$isLargeDesktop'), findsOneWidget);
        expect(find.text('extra:$isExtraLargeDesktop'), findsOneWidget);
      }

      await expectFlagsAtWidth(
        1023,
        isLaptop: true,
        isDesktop: false,
        isLargeDesktop: false,
        isExtraLargeDesktop: false,
      );
      await expectFlagsAtWidth(
        1024,
        isLaptop: false,
        isDesktop: true,
        isLargeDesktop: false,
        isExtraLargeDesktop: false,
      );
      await expectFlagsAtWidth(
        1439,
        isLaptop: false,
        isDesktop: true,
        isLargeDesktop: false,
        isExtraLargeDesktop: false,
      );
      await expectFlagsAtWidth(
        1440,
        isLaptop: false,
        isDesktop: false,
        isLargeDesktop: true,
        isExtraLargeDesktop: false,
      );
      await expectFlagsAtWidth(
        1919,
        isLaptop: false,
        isDesktop: false,
        isLargeDesktop: true,
        isExtraLargeDesktop: false,
      );
      await expectFlagsAtWidth(
        1920,
        isLaptop: false,
        isDesktop: false,
        isLargeDesktop: false,
        isExtraLargeDesktop: true,
      );
    });

    testWidgets('context_extensions_use_latest_responsive_config',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(700, 600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Widget app() {
        return MaterialApp(
          home: Builder(
            builder: (context) {
              return Text(context.isTablet ? 'tablet' : 'not tablet');
            },
          ),
        );
      }

      await tester.pumpWidget(app());
      expect(find.text('not tablet'), findsOneWidget);

      ResponsiveConfig.init(
        breakpoints: Breakpoints.defaultBreakpoints.copyWith(tablet: 650),
      );

      await tester.pumpWidget(app());
      expect(find.text('tablet'), findsOneWidget);
    });
  });

  group('Layout validation', () {
    test('responsive_flex_grid_delegate_rejects_invalid_values', () {
      expect(
        () => ResponsiveFlexGridDelegate(crossAxisCount: 0),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexGridDelegate(minCrossAxisCount: 0),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexGridDelegate(maxCrossAxisCount: 0),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexGridDelegate(
          minCrossAxisCount: 4,
          maxCrossAxisCount: 2,
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexGridDelegate(crossAxisSpacing: -1),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexGridDelegate(childAspectRatio: 0),
        throwsAssertionError,
      );
    });

    test('responsive_flex_grid_delegate_has_value_semantics', () {
      const first = ResponsiveFlexGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 12,
      );
      const second = ResponsiveFlexGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 12,
      );
      const third = ResponsiveFlexGridDelegate(crossAxisCount: 4);

      expect(first, equals(second));
      expect(first.hashCode, equals(second.hashCode));
      expect(first, isNot(equals(third)));
      expect(first.toString(), contains('crossAxisCount: 3'));
    });

    testWidgets('responsive_flex_list_rejects_invalid_layout_values',
        (tester) async {
      expect(
        () => ResponsiveFlexList.builder(
          itemCount: -1,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexList.builder(
          crossAxisCount: 0,
          itemCount: 1,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexList.builder(
          minCrossAxisCount: 4,
          maxCrossAxisCount: 2,
          itemCount: 1,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveFlexList.builder(
          scrollCacheExtent: -1,
          itemCount: 1,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('with_separators_allows_null_cross_axis_separator',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList.withSeparators(
            crossAxisCount: 1,
            itemCount: 3,
            itemBuilder: (context, index) => Text('Item $index'),
            mainAxisSeparator: (index, total) => const Divider(),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
      expect(find.byType(VerticalDivider), findsNothing);
    });

    testWidgets('scroll_cache_extent_forwards_to_public_scroll_views',
        (tester) async {
      Future<void> expectForwarded(Widget widget) async {
        await tester.pumpWidget(MaterialApp(home: widget));
        await tester.pumpAndSettle();

        final scrollView = tester.widget<CustomScrollView>(
          find
              .descendant(
                of: find.byWidget(widget),
                matching: find.byType(CustomScrollView),
              )
              .first,
        );

        expect(scrollView.scrollCacheExtent, isNotNull);
      }

      await expectForwarded(
        ResponsiveFlexList.builder(
          itemCount: 3,
          scrollCacheExtent: 300,
          itemBuilder: (context, index) => Text('Builder $index'),
        ),
      );

      await expectForwarded(
        ResponsiveFlexList(
          scrollCacheExtent: 300,
          children: List.generate(3, (index) => Text('Child $index')),
        ),
      );

      await expectForwarded(
        ResponsiveFlexList.withSeparators(
          itemCount: 3,
          scrollCacheExtent: 300,
          itemBuilder: (context, index) => Text('Separator $index'),
          mainAxisSeparator: (index, total) => const Divider(),
        ),
      );

      await expectForwarded(
        ResponsiveFlexMasonry.pinterest(
          itemCount: 3,
          scrollCacheExtent: 300,
          itemBuilder: (context, index) => Text('Pinterest $index'),
        ),
      );
    });
  });

  group('Delegate behavior', () {
    testWidgets('grid_delegate_overrides_deprecated_layout_parameters',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList(
            crossAxisCount: 1,
            gridDelegate: const ResponsiveFlexGridDelegate(
              crossAxisCount: 3,
            ),
            children: List.generate(
              4,
              (index) => SizedBox(height: 80, child: Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstRowY = tester.getCenter(find.text('Item 0')).dy;
      expect(tester.getCenter(find.text('Item 1')).dy, equals(firstRowY));
      expect(tester.getCenter(find.text('Item 2')).dy, equals(firstRowY));
      expect(
          tester.getCenter(find.text('Item 3')).dy, isNot(equals(firstRowY)));
    });

    testWidgets('flex_grid_delegate_respects_min_cross_axis_count',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList.builder(
            itemCount: 4,
            gridDelegate: const ResponsiveFlexGridDelegate(
              minCrossAxisCount: 3,
            ),
            itemBuilder: (context, index) =>
                SizedBox(height: 80, child: Text('Item $index')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstRowY = tester.getCenter(find.text('Item 0')).dy;
      expect(tester.getCenter(find.text('Item 1')).dy, equals(firstRowY));
      expect(tester.getCenter(find.text('Item 2')).dy, equals(firstRowY));
      expect(
          tester.getCenter(find.text('Item 3')).dy, isNot(equals(firstRowY)));
    });

    testWidgets('flex_grid_delegate_respects_max_cross_axis_count',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexList.builder(
            itemCount: 8,
            gridDelegate: const ResponsiveFlexGridDelegate(
              maxCrossAxisCount: 4,
            ),
            itemBuilder: (context, index) =>
                SizedBox(height: 80, child: Text('Item $index')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstRowY = tester.getCenter(find.text('Item 0')).dy;
      expect(tester.getCenter(find.text('Item 1')).dy, equals(firstRowY));
      expect(tester.getCenter(find.text('Item 2')).dy, equals(firstRowY));
      expect(tester.getCenter(find.text('Item 3')).dy, equals(firstRowY));
      expect(
          tester.getCenter(find.text('Item 4')).dy, isNot(equals(firstRowY)));
    });

    testWidgets('masonry_grid_delegate_controls_column_boundaries',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            itemCount: 3,
            gridDelegate: const ResponsiveMasonryGridDelegate(
              minCrossAxisCount: 3,
            ),
            itemBuilder: (context, index) => SizedBox(
              height: 80,
              child: Text('Item $index'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstRowY = tester.getTopLeft(find.text('Item 0')).dy;
      expect(tester.getTopLeft(find.text('Item 1')).dy, equals(firstRowY));
      expect(tester.getTopLeft(find.text('Item 2')).dy, equals(firstRowY));
    });

    testWidgets('masonry_grid_delegate_respects_custom_spacing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            itemCount: 1,
            gridDelegate: const ResponsiveMasonryGridDelegate(
              mainAxisSpacing: 20,
              crossAxisSpacing: 15,
            ),
            itemBuilder: (context, index) => const SizedBox(
              height: 80,
              child: Text('Item'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item'), findsOneWidget);
    });
  });

  group('ListAnimations optimization verification', () {
    testWidgets('animates with zero stagger delay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 300),
            staggerDelay: Duration.zero,
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('animates with small and large stagger delay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 200),
            staggerDelay: Duration(milliseconds: 50),
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 200),
            staggerDelay: Duration(milliseconds: 500),
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('animates single item and max items limit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 300),
            staggerDelay: Duration(milliseconds: 100),
            animationType: AnimationType.fade,
            maxStaggeredItems: 2,
            children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('handles disposal during active animation without leaks',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 500),
            staggerDelay: Duration(milliseconds: 100),
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Dispose by pumping different widget mid-animation
      await tester.pumpWidget(const MaterialApp(home: Text('Disposed')));
      expect(find.text('Disposed'), findsOneWidget);
    });

    testWidgets('handles widget rebuilds during animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 400),
            staggerDelay: Duration(milliseconds: 100),
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Rebuild with updated parameter
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationDuration: Duration(milliseconds: 400),
            staggerDelay: Duration(milliseconds: 100),
            animationType: AnimationType.fade,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets(
        'does not throw LateInitializationError for AnimationType.none or empty list',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            animationType: AnimationType.none,
            children: [Text('Item 1')],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveFlexList(
            children: [],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No items to display'), findsOneWidget);
    });
  });

  // ============================================
  // GROUP 11: Main Axis Spacing Verification
  // ============================================
  group('mainAxisSpacing only between items/rows and not after last line', () {
    testWidgets(
        'builder constructor does not add mainAxisSpacing after the last row',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const double mainAxisSpacing = 20.0;
      const double itemHeight = 100.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ResponsiveFlexList.builder(
                shrinkWrap: true,
                crossAxisCount: 1,
                mainAxisSpacing: mainAxisSpacing,
                itemCount: 2,
                itemBuilder: (context, index) => SizedBox(
                  key: ValueKey('builder_item_$index'),
                  height: itemHeight,
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final item0Rect =
          tester.getRect(find.byKey(const ValueKey('builder_item_0')));
      final item1Rect =
          tester.getRect(find.byKey(const ValueKey('builder_item_1')));

      // Distance between item 0 bottom and item 1 top should equal mainAxisSpacing
      expect(item1Rect.top - item0Rect.bottom, equals(mainAxisSpacing));

      // Parent height of the list should equal: 2 * itemHeight + 1 * mainAxisSpacing (no trailing spacing)
      final flexListFinder = find.byType(ResponsiveFlexList);
      final flexListSize = tester.getSize(flexListFinder);
      expect(flexListSize.height, equals(2 * itemHeight + mainAxisSpacing));
    });

    testWidgets(
        'default constructor (children) does not add mainAxisSpacing after the last row',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const double mainAxisSpacing = 25.0;
      const double itemHeight = 100.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ResponsiveFlexList(
                shrinkWrap: true,
                crossAxisCount: 1,
                mainAxisSpacing: mainAxisSpacing,
                children: [
                  SizedBox(
                    key: ValueKey('child_0'),
                    height: itemHeight,
                    child: Text('Child 0'),
                  ),
                  SizedBox(
                    key: ValueKey('child_1'),
                    height: itemHeight,
                    child: Text('Child 1'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final child0Rect = tester.getRect(find.byKey(const ValueKey('child_0')));
      final child1Rect = tester.getRect(find.byKey(const ValueKey('child_1')));

      expect(child1Rect.top - child0Rect.bottom, equals(mainAxisSpacing));

      final flexListFinder = find.byType(ResponsiveFlexList);
      final flexListSize = tester.getSize(flexListFinder);
      expect(flexListSize.height, equals(2 * itemHeight + mainAxisSpacing));
    });

    testWidgets(
        'instagram layout does not add mainAxisSpacing after the last row',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const double mainAxisSpacing = 15.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ResponsiveFlexMasonry.instagram(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: mainAxisSpacing,
                itemCount: 6, // 2 rows of 3 columns
                itemBuilder: (context, index) => Container(
                  key: ValueKey('insta_$index'),
                  child: Text('Insta $index'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final flexListFinder = find.byType(ResponsiveFlexList);
      final flexListRect = tester.getRect(flexListFinder);

      // The last row items' bottom should match the flex list bottom (no trailing margin)
      final item5Rect = tester.getRect(find.byKey(const ValueKey('insta_5')));
      expect(flexListRect.bottom, equals(item5Rect.bottom));
    });
  });

  // ============================================
  // GROUP 12: Grid Item Sizing (childAspectRatio & mainAxisExtent)
  // ============================================
  group('Grid item sizing (childAspectRatio and mainAxisExtent)', () {
    testWidgets('1. Child with no explicit size + childAspectRatio',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // 600 width, crossAxisCount: 2 -> column width = 300
      // childAspectRatio: 2 -> height = 300 / 2 = 150
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: const ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 2,
              ),
              children: [
                Container(
                  key: const ValueKey('item_0'),
                  color: Colors.red,
                  child: const Text('No size'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(150));
    });

    testWidgets('2. Child with explicit height + childAspectRatio',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Child specifies height: 500, but delegate specifies childAspectRatio: 2
      // Geometry must be 300 x 150
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 2,
              ),
              children: [
                SizedBox(
                  key: ValueKey('item_0'),
                  height: 500,
                  child: Text('Explicit Height 500'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(150));
    });

    testWidgets('3. Child with explicit width + childAspectRatio',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Child specifies width: 500, but delegate specifies crossAxisCount: 2 (300) and childAspectRatio: 2 (150)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 2,
              ),
              children: [
                SizedBox(
                  key: ValueKey('item_0'),
                  width: 500,
                  child: Text('Explicit Width 500'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(150));
    });

    testWidgets('4. Child with explicit height + mainAxisExtent',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Child specifies height: 100, but mainAxisExtent: 250
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 250,
              ),
              children: [
                SizedBox(
                  key: ValueKey('item_0'),
                  height: 100,
                  child: Text('Explicit Height 100'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(250));
    });

    testWidgets('5. Child with explicit width + mainAxisExtent',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Child specifies width: 500, mainAxisExtent: 250
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 250,
              ),
              children: [
                SizedBox(
                  key: ValueKey('item_0'),
                  width: 500,
                  child: Text('Explicit Width 500'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(250));
    });

    testWidgets('6. mainAxisExtent without childAspectRatio', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.builder(
              gridDelegate: const ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 180,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(180));
    });

    testWidgets('7. childAspectRatio without mainAxisExtent', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.builder(
              gridDelegate: const ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 1.5,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                key: ValueKey('item_$index'),
                child: Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(200)); // 300 / 1.5 = 200
    });

    testWidgets('8. Both provided must fail assertion', (tester) async {
      expect(
        () => ResponsiveFlexGridDelegate(
          childAspectRatio: 1.0,
          mainAxisExtent: 200.0,
        ),
        throwsAssertionError,
      );

      expect(
        () => const ResponsiveFlexList(
          childAspectRatio: 1.0,
          mainAxisExtent: 200.0,
          children: [Text('Fail')],
        ),
        throwsAssertionError,
      );
    });

    testWidgets('9. Neither provided preserves existing default behavior',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
              ),
              children: [
                SizedBox(
                  key: ValueKey('item_0'),
                  height: 120,
                  child: Text('Natural size'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('item_0')));
      expect(itemSize.width, equals(300));
      expect(itemSize.height, equals(120));
    });

    testWidgets('10. Vertical layout sizing verification across builders',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.withSeparators(
              gridDelegate: const ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 140,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => SizedBox(
                key: ValueKey('sep_item_$index'),
                height: 500, // Explicit child height overridden
                child: Text('Item $index'),
              ),
              mainAxisSeparator: (index, count) => const Divider(),
              crossAxisSeparator: (index, count) => const VerticalDivider(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('sep_item_0')));
      expect(itemSize.width, equals(200));
      expect(itemSize.height, equals(140));
    });

    testWidgets('11. RTL layout sizing verification', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList(
              rtlOptions: RTLOptions(forceTextDirection: TextDirection.rtl),
              gridDelegate: ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 2,
              ),
              children: [
                SizedBox(
                  key: ValueKey('rtl_item_0'),
                  height: 300,
                  child: Text('RTL Item'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('rtl_item_0')));
      expect(itemSize.width, equals(200));
      expect(itemSize.height, equals(100)); // 200 / 2 = 100
    });

    testWidgets(
        '12. Verification across children, builder, and roundRobinLayout',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveFlexList.withSeparators(
              roundRobinLayout: true,
              gridDelegate: const ResponsiveFlexGridDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 160,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => SizedBox(
                key: ValueKey('rr_item_$index'),
                height: 400,
                child: Text('RR Item $index'),
              ),
              mainAxisSeparator: (index, count) => const SizedBox.shrink(),
              crossAxisSeparator: (index, count) => const SizedBox.shrink(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final itemSize = tester.getSize(find.byKey(const ValueKey('rr_item_0')));
      expect(itemSize.width, equals(200));
      expect(itemSize.height, equals(160));
    });
  });
}
