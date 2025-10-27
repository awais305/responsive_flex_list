import 'package:flutter/material.dart';

import 'package:responsive_flex_list/src/core/core.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';

/// A masonry layout inspired by Instagram's Explore page.
///
/// Useful for:
/// - Photo galleries
/// - Content discovery sections
/// - Social media feeds
///
/// This layout adapts rows dynamically based on incoming data and screen size.
class InstagramLayout<T> extends BaseResponsiveLayout<T> {
  /// Multiplier to determine row height relative to column width.
  /// For example, 1.5 means row height = column width * 1.5 * 2
  final double maxRowHeightMultiplier;

  const InstagramLayout({
    super.key,
    required super.crossAxisCount,
    required this.maxRowHeightMultiplier,
    super.crossAxisSpacing,
    required super.mainAxisSpacing,
    required super.maxStaggeredItems,
    required super.items,
    required super.itemBuilder,
    required super.isRTL,
    required super.rtlOptions,
    required super.animationFlow,
    required super.animations,
    required super.animationType,
    super.customAnimationBuilder,
    super.padding,
  }) : super(shrinkWrap: false, reverse: false, useIntrinsicHeight: false);

  @override
  Widget buildLayout(BuildContext context) {
    // Build a CustomScrollView with sliver-based layout for efficient scrolling
    return CustomScrollView(
      key: listKey,
      primary: primary,
      reverse: reverse,
      physics: physics,
      shrinkWrap: shrinkWrap,
      controller: controller,
      cacheExtent: cacheExtent,
      slivers: [
        // Wrap the grid in SliverPadding to apply optional padding
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverInstagramGrid<T>(
            items: items,
            itemBuilder: itemBuilder!,
            crossAxisCount: crossAxisCount,
            maxRowHeightMultiplier: maxRowHeightMultiplier,
            mainAxisSpacing: mainAxisSpacing ?? kDefaultMainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing ?? kDefaultCrossAxisSpacing,
            isRTL: isRTL,
            buildAnimatedItem: buildAnimatedItem,
            calculateAnimationIndex: calculateAnimationIndex,
          ),
        ),
      ],
    );
  }
}

/// Internal sliver implementation for Instagram-style grid layout.
/// Handles the actual rendering of items in varied patterns.
class SliverInstagramGrid<T> extends StatelessWidget {
  /// List of data items to display
  final List<T> items;

  /// Function to build each item widget
  final ItemBuilder<T> itemBuilder;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Height multiplier for calculating row heights
  final double maxRowHeightMultiplier;

  /// Vertical spacing between rows
  final double mainAxisSpacing;

  /// Horizontal spacing between columns
  final double crossAxisSpacing;

  /// Whether to use right-to-left layout direction
  final bool isRTL;

  /// Function to wrap items with animation
  final Widget Function({required int animationIndex, required Widget child})
      buildAnimatedItem;

  /// Function to calculate animation index for staggered animations
  final int Function({
    required int itemIndex,
    required int rowIndex,
    required int columnIndex,
  }) calculateAnimationIndex;

  const SliverInstagramGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.crossAxisCount,
    required this.maxRowHeightMultiplier,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.isRTL,
    required this.buildAnimatedItem,
    required this.calculateAnimationIndex,
  });

  /// Predefined layout patterns for different column counts.
  /// Each number represents how many items appear in that column:
  /// - 1 = one item taking full row height
  /// - 2 = two items stacked, each taking half row height
  ///
  /// Example for 3 columns with pattern [2, 2, 1]:
  /// Column 0: 2 items stacked vertically
  /// Column 1: 2 items stacked vertically
  /// Column 2: 1 item taking full height
  static const Map<int, List<List<int>>> _patterns = {
    // pattern that perfectly mimics instagram
    3: [
      [2, 2, 1], // Two stacked items, one single
      [1, 2, 2], // One single, two stacked items
    ],
    // patterns w.r.t columns count
    4: [
      [1, 2, 2, 1], // Alternating pattern
      [2, 1, 1, 2], // Reverse alternating
      [1, 1, 2, 2], // Split pattern
    ],
    5: [
      [1, 2, 1, 2, 2],
      [2, 1, 2, 1, 2],
      [1, 2, 1, 2, 2],
    ],
    6: [
      [1, 2, 2, 1, 2, 2],
      [2, 1, 1, 2, 1, 1],
      [1, 1, 2, 2, 1, 1],
    ],
    7: [
      [1, 2, 1, 2, 1, 2, 1],
      [2, 1, 2, 1, 2, 1, 2],
      [1, 1, 2, 1, 1, 2, 1],
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get patterns for current column count, fallback to uniform grid if not defined
    final patterns =
        _patterns[crossAxisCount] ?? [List.filled(crossAxisCount, 1)];

    // Build a sliver list where each child is a row following a pattern
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildRow(context, index, patterns),
        childCount: _calculateRowCount(patterns),
      ),
    );
  }

  /// Calculate total number of rows needed to display all items.
  /// Iterates through patterns to count how many items fit in each row.
  int _calculateRowCount(List<List<int>> patterns) {
    if (items.isEmpty) return 0;

    int itemIndex = 0;
    int rowCount = 0;

    // Keep adding rows until all items are accounted for
    while (itemIndex < items.length) {
      // Get pattern for current row (cycles through available patterns)
      final pattern = patterns[rowCount % patterns.length];

      // Sum up items in this row (each column contributes 1 or 2 items)
      final itemsInRow = pattern.fold(0, (sum, itemsInCol) => sum + itemsInCol);
      itemIndex += itemsInRow;
      rowCount++;
    }

    return rowCount;
  }

  /// Build a single row of the grid following the pattern for this row index.
  Widget _buildRow(
    BuildContext context,
    int rowIndex,
    List<List<int>> patterns,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine which pattern to use (cycles through available patterns)
        final pattern = patterns[rowIndex % patterns.length];

        // Calculate column width after accounting for spacing
        final availableWidth =
            constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing;
        final columnWidth = availableWidth / crossAxisCount;

        // Calculate row height based on column width and multiplier
        final rowHeight = columnWidth * (maxRowHeightMultiplier * 2);

        // Calculate which item index this row starts at
        // by summing items from all previous rows
        int startItemIndex = 0;
        for (int r = 0; r < rowIndex; r++) {
          final rowPattern = patterns[r % patterns.length];
          startItemIndex += rowPattern.fold(
            0,
            (sum, itemsInCol) => sum + itemsInCol,
          );
        }

        final List<Widget> rowChildren = [];
        int currentItemIndex = startItemIndex;

        // Build each column in the row
        for (int col = 0; col < crossAxisCount; col++) {
          // Get number of items for this column from pattern
          final itemsInColumn = col < pattern.length ? pattern[col] : 1;

          // Calculate item height:
          // - Single item takes full row height
          // - Stacked items split height with spacing in between
          final itemHeight = itemsInColumn == 1
              ? rowHeight
              : (rowHeight - mainAxisSpacing) / 2;

          final List<Widget> columnChildren = [];

          // Build each item in this column
          for (int i = 0; i < itemsInColumn; i++) {
            // Stop if we've run out of items
            if (currentItemIndex >= items.length) break;

            final item = items[currentItemIndex];

            // Wrap item in animation and sized box
            columnChildren.add(
              buildAnimatedItem(
                animationIndex: calculateAnimationIndex(
                  itemIndex: currentItemIndex,
                  rowIndex: rowIndex,
                  columnIndex: col,
                ),
                child: SizedBox(
                  height: itemHeight,
                  child: itemBuilder(item, currentItemIndex),
                ),
              ),
            );

            // Add spacing between stacked items (but not after last item)
            if (i < itemsInColumn - 1 && currentItemIndex < items.length - 1) {
              columnChildren.add(SizedBox(height: mainAxisSpacing));
            }

            currentItemIndex++;
          }

          // Wrap column items in Expanded so columns share width equally
          rowChildren.add(
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: columnChildren,
              ),
            ),
          );

          // Add horizontal spacing between columns (but not after last column)
          if (col < crossAxisCount - 1) {
            rowChildren.add(SizedBox(width: crossAxisSpacing));
          }
        }

        // Wrap columns in a Row with fixed height and bottom margin
        return Container(
          height: rowHeight,
          margin: EdgeInsets.only(bottom: mainAxisSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: rowChildren,
          ),
        );
      },
    );
  }
}
