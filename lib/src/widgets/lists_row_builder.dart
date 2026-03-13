import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

import 'package:responsive_flex_list/src/widgets/animate_item_wrapper.dart';

/// Builds a single row in a responsive list with proper spacing and animations.
class ListsRowBuilder extends StatelessWidget {
  final bool isWhiteSpaceDivider;
  final double? crossAxisSpacing;
  final double mainAxisSpacing;
  final SeparatorBuilder? crossAxisSeparator;
  final SeparatorBuilder? mainAxisSeparator;
  final int rowIndex;
  final int maxStaggeredItems;
  final double? maxRowHeight;
  final int crossAxisCount;
  final int itemCount;
  final ItemBuilder? itemBuilder;
  final bool useIntrinsicHeight;
  final bool isRTL;
  final MainAxisSeparatorMode mainAxisSeparatorMode;
  final RTLOptions rtlOptions;
  final AnimationFlow animationFlow;
  final List<Animation<double>> animations;
  final AnimationType animationType;
  final CustomAnimationBuilder? customAnimationBuilder;
  final double? childAspectRatio;
  final double? mainAxisExtent;

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
    required this.itemCount,
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
    this.childAspectRatio,
    this.mainAxisExtent,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate which items belong to this row
    final int startIndex = rowIndex * crossAxisCount;

    final List<Widget> children = <Widget>[];

    final int totalRows = (itemCount / crossAxisCount).ceil();
    final bool isNotLastRow = rowIndex != totalRows - 1;

    for (int i = 0; i < crossAxisCount; i++) {
      final int itemIndex = startIndex + i;
      final bool hasItem = itemIndex < itemCount;

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
              child: Column(
                children: [
                  // Add separator above item (except for first row)
                  if (rowIndex != 0)
                    AnimateItemWrapper(
                      animations: animations,
                      index: animationIndex,
                      maxStaggeredItems: maxStaggeredItems,
                      animationType: animationType,
                      rtlOptions: rtlOptions,
                      customAnimationBuilder: customAnimationBuilder,
                      child: Padding(
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
                    ),
                  // Only show item if it exists
                  if (hasItem)
                    AnimateItemWrapper(
                      animations: animations,
                      index: animationIndex,
                      maxStaggeredItems: maxStaggeredItems,
                      animationType: animationType,
                      rtlOptions: rtlOptions,
                      customAnimationBuilder: customAnimationBuilder,
                      child: _buildSizedItem(
                        context,
                        itemIndex,
                      ),
                    ),
                ],
              ),
            ),
          );

          break;

        case MainAxisSeparatorMode.fullWidth:
          children.add(
            Expanded(
              child: !hasItem
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
                          : _buildSizedItem(context, itemIndex),
                    ),
            ),
          );
          break;
      }

      // Add vertical separator between items (except after last item)
      // Only add separator if current item exists AND it's not the last column
      if (i < crossAxisCount - 1 && hasItem) {
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

    // Apply RTL reverse order if needed
    if (isRTL && (rtlOptions.reverseList || !rtlOptions.reverseRowOrder)) {
      // Note: We need to be careful with vertical separators if they are in the list.
      // However, usually we can just reverse the resulting children list if they are all widgets.
      // But separators are between items. Reversing correctly is tricky.
      // Actually, if we just want to reverse the items, we should have done it before building the widget list.
      // Let's stick to the previous logic of reversing the data, but since we don't have data,
      // we just reverse the built widgets (items and separators).
      return useIntrinsicHeight
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: children.reversed.toList(),
              ),
            )
          : maxRowHeight != null
              ? SizedBox(
                  height: maxRowHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection:
                        isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: children.reversed.toList(),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: children.reversed.toList(),
                );
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

    // Always show separator after actual items
    return separator;
  }

  Widget _buildSizedItem(BuildContext context, int index) {
    Widget item = itemBuilder?.call(context, index) ?? const SizedBox.shrink();

    if (mainAxisExtent != null) {
      item = SizedBox(
        height: mainAxisExtent,
        child: item,
      );
    } else if (childAspectRatio != null) {
      item = AspectRatio(
        aspectRatio: childAspectRatio!,
        child: item,
      );
    }

    return item;
  }
}
