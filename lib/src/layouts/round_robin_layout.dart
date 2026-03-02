import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/core/constants.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';

/// Ultra-optimized round-robin layout that distributes items across columns sequentially.
///
/// Items are distributed column by column in a round-robin fashion (item 0 goes to column 0,
/// item 1 to column 1, etc.). Best for scenarios where items should be evenly distributed
/// across columns without height balancing.
class RoundRobinLayout extends BaseResponsiveLayout {
  /// Whether to hide all separators and use spacing instead.
  final bool hideSeparators;

  const RoundRobinLayout({
    super.key,
    super.physics,
    super.controller,
    super.primary,
    super.cacheExtent,
    super.crossAxisSpacing,
    super.padding,
    super.crossAxisSeparator,
    required super.mainAxisSpacing,
    required super.mainAxisSeparator,
    required super.maxStaggeredItems,
    required super.crossAxisCount,
    required super.itemCount,
    super.itemBuilder,
    required super.isRTL,
    this.hideSeparators = false,
    required super.useIntrinsicHeight,
    required super.rtlOptions,
    required super.animationFlow,
    required super.animations,
    required super.animationType,
    super.customAnimationBuilder,
    required super.shrinkWrap,
    required super.reverse,
    super.items,
  });

  @override
  Widget buildLayout(BuildContext context) {
    // Performance warning for large lists with IntrinsicHeight
    if (useIntrinsicHeight && itemCount > 100) {
      debugPrint(
        '⚠️ WARNING: IntrinsicHeight with $itemCount items will cause '
        'severe performance issues. Consider setting useIntrinsicHeight=false',
      );
    }

    return CustomScrollView(
      physics: physics,
      primary: primary,
      controller: controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverToBoxAdapter(
            child: useIntrinsicHeight
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      textDirection: getTextDirection(),
                      children: _buildAllColumns(context),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: getTextDirection(),
                    children: _buildAllColumns(context),
                  ),
          ),
        ),
      ],
    );
  }

  /// Builds all columns with items distributed in round-robin fashion.
  List<Widget> _buildAllColumns(BuildContext context) {
    if (itemCount == 0) return [];

    final List<Widget> columns = [];

    for (int columnIndex = 0; columnIndex < crossAxisCount; columnIndex++) {
      final Widget column = _buildSingleColumn(context, columnIndex);
      columns.add(Expanded(child: column));

      // Add vertical separator between columns
      if (columnIndex < crossAxisCount - 1) {
        final bool isNextEmpty = itemCount <= columnIndex + 1;

        columns.add(
          buildAnimatedItem(
            animationIndex: columnIndex,
            child: _buildCrossAxisSeparator(
              isNextEmpty: isNextEmpty,
              crossAxisSeparator: hideSeparators
                  ? null
                  : buildDefaultCrossAxisSeparator(columnIndex, crossAxisCount),
              crossAxisSpacing: getEffectiveCrossAxisSpacing(),
            ),
          ),
        );
      }
    }

    return columns;
  }

  /// Builds a single column with its assigned items from the round-robin distribution.
  Widget _buildSingleColumn(BuildContext context, int columnIndex) {
    List<int> globalIndices = [];

    // Collect items for this column (every nth item where n = crossAxisCount)
    for (int i = columnIndex; i < itemCount; i += crossAxisCount) {
      globalIndices.add(i);
    }

    // Reverse items for RTL if needed
    if (isRTL && (rtlOptions.reverseList || !rtlOptions.reverseRowOrder)) {
      globalIndices = globalIndices.reversed.toList();
    }

    final List<Widget> columnChildren = [];

    for (int i = 0; i < globalIndices.length; i++) {
      final int globalIndex = globalIndices[i];
      final int rowIndex = globalIndex ~/ crossAxisCount;
      final int totalRows = (itemCount / crossAxisCount).ceil();

      final int animationIndex = calculateAnimationIndex(
        itemIndex: i,
        rowIndex: rowIndex,
        columnIndex: columnIndex,
      );

      // Add the item widget
      columnChildren.add(
        buildAnimatedItem(
          animationIndex: animationIndex,
          child: itemBuilder!(context, globalIndex),
        ),
      );

      // Add horizontal separator between items
      if (i < globalIndices.length - 1) {
        final double leftPadding = columnIndex == 0
            ? 0
            : (crossAxisSpacing ?? kDefaultCrossAxisSpacing);
        final double rightPadding = columnIndex == (crossAxisCount - 1)
            ? 0
            : (crossAxisSpacing ?? kDefaultCrossAxisSpacing);

        columnChildren.add(
          buildAnimatedItem(
            animationIndex: animationIndex,
            child: hideSeparators
                ? SizedBox(height: mainAxisSpacing)
                : Padding(
                    padding: EdgeInsets.only(
                      left: isRTL ? rightPadding : leftPadding,
                      right: isRTL ? leftPadding : rightPadding,
                    ),
                    child: mainAxisSeparator?.call(rowIndex, totalRows) ??
                        const Divider(height: 2, thickness: 2),
                  ),
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      textDirection: getTextDirection(),
      children: columnChildren,
    );
  }

  /// Builds a vertical separator between columns with proper visibility handling.
  Widget _buildCrossAxisSeparator({
    required bool isNextEmpty,
    Widget? crossAxisSeparator,
    required double crossAxisSpacing,
  }) {
    final Widget separator =
        crossAxisSeparator ?? SizedBox(width: crossAxisSpacing);
    // Hide separator if next item is empty, but preserve layout space
    return isNextEmpty ? Opacity(opacity: 0, child: separator) : separator;
  }
}
