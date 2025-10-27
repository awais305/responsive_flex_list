import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

import 'package:responsive_flex_list/src/widgets/animate_item_wrapper.dart';

/// Builds a single row in a responsive list with proper spacing and animations.
class ListsRowBuilder<T> extends StatelessWidget {
  final bool isWhiteSpaceDivider;
  final double? crossAxisSpacing;
  final double mainAxisSpacing;
  final SeparatorBuilder? crossAxisSeparator;
  final SeparatorBuilder? mainAxisSeparator;
  final int rowIndex;
  final int maxStaggeredItems;
  final double? maxRowHeight;
  final int crossAxisCount;
  final List<T> items;
  final ItemBuilder<T>? itemBuilder;
  final bool useIntrinsicHeight;
  final bool isRTL;
  final MainAxisSeparatorMode mainAxisSeparatorMode;
  final RTLOptions rtlOptions;
  final AnimationFlow animationFlow;
  final List<Animation<double>> animations;
  final ResponsiveAnimationType animationType;
  final CustomAnimationBuilder? customAnimationBuilder;

  const ListsRowBuilder({
    super.key,
    required this.isWhiteSpaceDivider,
    this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.crossAxisSeparator,
    this.mainAxisSeparator,
    required this.rowIndex,
    required this.maxStaggeredItems,
    required this.crossAxisCount,
    required this.items,
    required this.itemBuilder,
    required this.useIntrinsicHeight,
    required this.isRTL,
    required this.mainAxisSeparatorMode,
    required this.rtlOptions,
    required this.animationFlow,
    required this.animations,
    required this.animationType,
    this.maxRowHeight,
    this.customAnimationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate which items belong to this row
    final int startIndex = rowIndex * crossAxisCount;
    final int endIndex = (startIndex + crossAxisCount).clamp(0, items.length);

    // Extract items for this row
    List<T> rowItems = items.sublist(startIndex, endIndex);

    // Reverse items for RTL if needed
    if (isRTL && (rtlOptions.reverseList || !rtlOptions.reverseRowOrder)) {
      rowItems = rowItems.reversed.toList();
    }

    // Pad with nulls to maintain consistent row structure
    final List<T?> paddedItems = [
      ...rowItems,
      ...List.filled(crossAxisCount - rowItems.length, null),
    ];

    final List<Widget> children = <Widget>[];

    final int totalRows = (items.length / crossAxisCount).ceil();
    final bool isNotLastRow = rowIndex != totalRows - 1;

    for (int i = 0; i < paddedItems.length; i++) {
      final T? item = paddedItems[i];
      final double leftPadding =
          i == 0 ? 0 : (crossAxisSpacing ?? kDefaultCrossAxisSpacing);
      final double rightPadding = i == (crossAxisCount - 1)
          ? 0
          : (crossAxisSpacing ?? kDefaultCrossAxisSpacing);

      // Calculate animation index based on animation flow mode
      final int animationIndex = () {
        switch (animationFlow) {
          case AnimationFlow.individual:
            return startIndex + i;
          case AnimationFlow.byRow:
            return rowIndex;
          case AnimationFlow.byColumn:
            return i;
          case AnimationFlow.simultaneous:
            return 0;
        }
      }();

      switch (mainAxisSeparatorMode) {
        case MainAxisSeparatorMode.itemWidth:
          children.add(
            Expanded(
              child: item == null
                  ? const SizedBox.shrink()
                  : AnimateItemWrapper(
                      animations: animations,
                      index: animationIndex,
                      maxStaggeredItems: maxStaggeredItems,
                      animationType: animationType,
                      rtlOptions: rtlOptions,
                      customAnimationBuilder: customAnimationBuilder,
                      child: Column(
                        children: [
                          // Add separator above item (except for first row)
                          if (rowIndex != 0)
                            Padding(
                              // Add horizontal padding to match item spacing
                              padding: EdgeInsets.only(
                                left: isRTL ? rightPadding : leftPadding,
                                right: isRTL ? leftPadding : rightPadding,
                              ),
                              child: mainAxisSeparator?.call(
                                rowIndex - 1, // Start index from 0
                                totalRows,
                              ),
                            ),
                          if (itemBuilder != null)
                            itemBuilder!(item, startIndex + i),
                        ],
                      ),
                    ),
            ),
          );

          break;

        case MainAxisSeparatorMode.fullWidth:
          children.add(
            Expanded(
              child: item == null
                  ? const SizedBox.shrink()
                  : AnimateItemWrapper(
                      animations: animations,
                      index: animationIndex,
                      maxStaggeredItems: maxStaggeredItems,
                      animationType: animationType,
                      rtlOptions: rtlOptions,
                      customAnimationBuilder: customAnimationBuilder,
                      child: itemBuilder == null
                          ? const SizedBox.shrink()
                          // this index is item index
                          : itemBuilder!(item, startIndex + i),
                    ),
            ),
          );
          break;
      }

      // Add vertical separator between items (except after last item)
      if (i < paddedItems.length - 1) {
        final T? nextItem = paddedItems[i + 1];

        children.add(
          AnimateItemWrapper(
            index: animationIndex,
            animations: animations,
            maxStaggeredItems: maxStaggeredItems,
            animationType: animationType,
            rtlOptions: rtlOptions,
            customAnimationBuilder: customAnimationBuilder,
            child: _buildCrossAxisSeparator(
              columnIndex: i,
              isNotLastRow: isNotLastRow,
              isNextEmpty: nextItem == null,
              crossAxisSeparator: crossAxisSeparator,
              isWhiteSpaceDivider: isWhiteSpaceDivider,
              mainAxisSeparatorMode: mainAxisSeparatorMode,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing ?? kDefaultCrossAxisSpacing,
            ),
          ),
        );
      }
    }

    // Return row with appropriate height constraint
    return useIntrinsicHeight
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: children,
            ),
          )
        : maxRowHeight != null
            ? SizedBox(
                height: maxRowHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: children,
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: children,
              );
  }

  /// Builds a vertical separator between columns with proper spacing.
  Widget _buildCrossAxisSeparator({
    required bool isNotLastRow,
    required bool isNextEmpty,
    required bool isWhiteSpaceDivider,
    required double crossAxisSpacing,
    required MainAxisSeparatorMode mainAxisSeparatorMode,
    required double mainAxisSpacing,
    required int columnIndex,
    SeparatorBuilder? crossAxisSeparator,
  }) {
    Widget separator;

    if (isWhiteSpaceDivider) {
      separator = SizedBox(width: crossAxisSpacing);
    } else {
      separator = Padding(
        // Compensate for horizontal separator spacing to maintain visual balance
        padding: EdgeInsets.only(
          top: rowIndex == 0 ? 0 : mainAxisSpacing,
          bottom: mainAxisSpacing,
        ),
        child: crossAxisSeparator?.call(columnIndex, crossAxisCount) ??
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: VerticalDivider(thickness: 2, width: 2),
            ),
      );
    }

    // Hide separator if next item is empty, but preserve layout space
    return isNextEmpty ? Opacity(opacity: 0, child: separator) : separator;
  }
}
