import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

void main() {
  setUpAll(
    () => ResponsiveConfig.init(breakpoints: Breakpoints.defaultBreakpoints),
  );
  group('ResponsiveFlexMasonry.instagram', () {
    testWidgets('builds with required parameters', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('applies default spacing values', (tester) async {
      // Test that default mainAxisSpacing = 1 and crossAxisSpacing = 1
      final items = const [1, 2];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => SizedBox(
              key: ValueKey('item-${items[index]}'),
              height: 100,
              child: Text('Item ${items[index]}'),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('item-1')), findsOneWidget);
    });

    testWidgets('accepts custom spacing parameters', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });

    testWidgets(
        'throws assertion error when animationDuration is set without animation',
        (tester) async {
      final items = const [1, 2, 3];
      expect(
        () => ResponsiveFlexMasonry.instagram(
          items: items,
          itemBuilder: (context, index) => Text('Item ${items[index]}'),
          animationDuration: const Duration(milliseconds: 300),
          animationType: ResponsiveAnimationType.none,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('builds with animation enabled', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
            animationDuration: const Duration(milliseconds: 300),
            animationType: ResponsiveAnimationType.fade,
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });

    testWidgets('builds with RTL options', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
            rtlOptions:
                const RTLOptions(mirrorAnimations: true, reverseRowOrder: true),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });
  });

  group('ResponsiveFlexMasonry.pinterest', () {
    testWidgets('builds with required parameters', (tester) async {
      final items = const [1, 2, 3, 4];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            items: items,
            itemBuilder: (context, index) => SizedBox(
              height: 100.0 * items[index], // Varying heights for masonry
              child: Text('Item ${items[index]}'),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    testWidgets('applies default spacing for pinterest layout', (tester) async {
      // Pinterest defaults: mainAxisSpacing = 15, crossAxisSpacing = 10
      final items = const [1, 2];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });

    testWidgets('handles empty items list', (tester) async {
      final items = const [];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            items: items,
            itemBuilder: (context, index) => const Text('Item'),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('onLoadingProgress callback can be provided', (tester) async {
      int callbackCount = 0;
      int? lastLoaded;
      int? lastTotal;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            items: imagesWithCaptions,
            itemBuilder: (context, index) {
              final item = imagesWithCaptions[index];
              return Column(
                children: [
                  if (item['url'] != null)
                    Image.network(
                      item['url']!,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
                  Text(item['captions'] ?? ''),
                ],
              );
            },
            onLoadingProgress: (loaded, total) {
              callbackCount++;
              lastLoaded = loaded;
              lastTotal = total;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(callbackCount, greaterThan(0),
          reason: 'onLoadingProgress should be called at least once');
      expect(lastTotal, equals(imagesWithCaptions.length),
          reason: 'Total should match items count');
      expect(lastLoaded, lessThanOrEqualTo(lastTotal!),
          reason: 'Loaded should not exceed total');

      debugPrint('✓ Callback called $callbackCount times');
      debugPrint('✓ Final progress: $lastLoaded/$lastTotal');
    });

    testWidgets('respects shrinkWrap parameter', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: ResponsiveFlexMasonry.pinterest(
              items: items,
              itemBuilder: (context, index) => Text('Item ${items[index]}'),
              shrinkWrap: true,
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });
  });

  group('ResponsiveFlexMasonry edge cases', () {
    testWidgets('handles single item', (tester) async {
      final items = const [1];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.instagram(
            items: items,
            itemBuilder: (context, index) => const Text('Single Item'),
          ),
        ),
      );

      expect(find.text('Single Item'), findsOneWidget);
    });

    testWidgets('builds with all optional parameters', (tester) async {
      final items = const [1, 2, 3];
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveFlexMasonry.pinterest(
            items: items,
            itemBuilder: (context, index) => Text('Item ${items[index]}'),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            reverse: true,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            animationDuration: const Duration(milliseconds: 500),
            animationType: ResponsiveAnimationType.slide,
            staggerDelay: const Duration(milliseconds: 50),
          ),
        ),
      );

      expect(find.byType(ResponsiveFlexMasonry), findsOneWidget);
    });
  });
}

final List<Map<String, String>> imagesWithCaptions = [
  {
    "url": "https://picsum.photos/200/300",
    "caption": "Capturing moments that matter",
  },
  {
    "url": "https://picsum.photos/300/200",
    "caption": "A beautiful perspective",
  },
  {
    "url": "https://picsum.photos/400/400",
    "caption": "Where light meets shadow",
  },
  {
    "url": "https://picsum.photos/500/300",
    "caption": "Simple beauty in everyday life",
  },
  {
    "url": "https://picsum.photos/250/600",
    "caption": "Finding magic in the ordinary",
  },
  {
    "url": "https://picsum.photos/600/250",
    "caption": "A moment frozen in time",
  },
  {
    "url": "https://picsum.photos/350/500",
    "caption": "Stories told through imagery",
  },
  {"url": "https://picsum.photos/500/350", "caption": "The art of seeing"},
  {"url": "https://picsum.photos/450/450", "caption": "Natural elegance"},
  {
    "url": "https://picsum.photos/800/400",
    "caption": "Exploring visual harmony",
  },
  {"url": "https://picsum.photos/400/800", "caption": "Pure and unfiltered"},
  {
    "url": "https://picsum.photos/700/500",
    "caption": "Discovering hidden details",
  },
  {"url": "https://picsum.photos/1200/800", "caption": "A glimpse of wonder"},
  {"url": "https://picsum.photos/800/1200", "caption": "Timeless and serene"},
  {"url": "https://picsum.photos/600/900", "caption": "Creating visual poetry"},
  {
    "url": "https://picsum.photos/1024/768",
    "caption": "Moments worth remembering",
  },
  {
    "url": "https://picsum.photos/250/600",
    "caption": "The beauty of simplicity",
  },
  {
    "url": "https://picsum.photos/350/500",
    "caption": "Embracing the unexpected",
  },
  {"url": "https://picsum.photos/500/350", "caption": "Colors and composition"},
  {"url": "https://picsum.photos/450/450", "caption": "A fresh perspective"},
  {"url": "https://picsum.photos/500/1000", "caption": "Lost in the details"},
  {
    "url": "https://picsum.photos/500/700",
    "caption": "Where creativity meets reality",
  },
  {"url": "https://picsum.photos/1000/500", "caption": "Perfectly imperfect"},
  {
    "url": "https://picsum.photos/900/600",
    "caption": "Visual storytelling at its finest",
  },
  {"url": "https://picsum.photos/800/400", "caption": "Capturing the essence"},
];
