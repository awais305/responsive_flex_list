import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';

import 'package:responsive_flex_list/src/widgets/flex_empty_state.dart';

/// Responsive layout that displays pre-built widget children in a grid without using items or itemBuilder.
///
/// Unlike other layouts that build widgets from a data list, this layout directly accepts
/// a list of Widget children and arranges them in a responsive grid. Useful when you have
/// pre-constructed widgets or when widget construction doesn't follow a simple data-to-widget pattern.
/// Displays an empty state when no children are provided.
class ChildrenLayout<T> extends BaseResponsiveLayout<T> {
  /// Pre-built widgets to display in the grid layout.
  final List<Widget> children;

  const ChildrenLayout({
    super.key,
    super.listKey,
    super.padding,
    required super.shrinkWrap,
    super.controller,
    super.physics,
    required super.reverse,
    super.primary,
    super.cacheExtent,
    required super.crossAxisCount,
    required super.maxStaggeredItems,
    super.crossAxisSpacing,
    super.mainAxisSpacing,
    required super.isRTL,
    required super.useIntrinsicHeight,
    required super.rtlOptions,
    required super.animationFlow,
    required super.animations,
    required super.animationType,
    super.customAnimationBuilder,
    required this.children,
  }) : super(
          // Children layout doesn't use items and itemBuilder
          items: const [],
          itemBuilder: null,
        );

  @override
  Widget build(BuildContext context) {
    // Show empty state when no children to display
    if (children.isEmpty) {
      return const FlexEmptyState();
    }

    return buildLayout(context);
  }

  @override
  Widget buildLayout(BuildContext context) {
    return CustomScrollView(
      key: listKey,
      shrinkWrap: shrinkWrap,
      controller: controller,
      physics: physics,
      reverse: reverse,
      primary: primary,
      cacheExtent: cacheExtent,
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildChildrenRow(index),
              childCount: (children.length / crossAxisCount).ceil(),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a single row of children widgets with proper spacing and animation wrappers.
  ///
  /// Handles RTL reversal, applies animations, and pads incomplete rows with empty widgets
  /// to maintain consistent grid structure.
  @protected
  Widget buildChildrenRow(int rowIndex) {
    final int startIndex = rowIndex * crossAxisCount;
    final int endIndex =
        (startIndex + crossAxisCount).clamp(0, children.length);

    // Extract and animate children for this row
    List<Widget> rowItems = children
        .asMap()
        .entries
        .map((entry) {
          final animationIndex = calculateAnimationIndex(
            itemIndex: entry.key,
            rowIndex: rowIndex,
            columnIndex: entry.key % crossAxisCount,
          );

          return buildAnimatedItem(
            animationIndex: animationIndex,
            child: entry.value,
          );
        })
        .toList()
        .sublist(startIndex, endIndex);

    // Reverse order for RTL layouts
    rowItems = applyRTLReversal(rowItems);

    // Pad incomplete rows with null to maintain grid structure
    final List<Widget?> paddedItems = <Widget?>[
      ...rowItems,
      ...List.filled(crossAxisCount - rowItems.length, null),
    ];

    final List<Widget> rowChildren = <Widget>[];

    for (int i = 0; i < paddedItems.length; i++) {
      final Widget? child = paddedItems[i];

      // Add child or empty placeholder for incomplete rows
      rowChildren.add(Expanded(child: child ?? const SizedBox.shrink()));

      // Add invisible separator placeholder between items
      if (i < paddedItems.length - 1) {
        final Widget? nextItem = paddedItems[i + 1];
        rowChildren.add(
          buildAnimatedItem(
            animationIndex: calculateAnimationIndex(
              itemIndex: startIndex + i,
              rowIndex: rowIndex,
              columnIndex: i,
            ),
            // Use invisible placeholder to maintain spacing structure
            child: nextItem == null
                ? const Opacity(opacity: 0, child: SizedBox.shrink())
                : const SizedBox.shrink(),
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: getEffectiveMainAxisSpacing()),
      child: Row(
        spacing: getEffectiveCrossAxisSpacing() / 2,
        textDirection: getTextDirection(),
        children: rowChildren,
      ),
    );
  }
}
