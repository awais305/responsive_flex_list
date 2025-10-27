import 'package:flutter/material.dart';

import 'package:responsive_flex_list/src/core/core.dart';
import 'package:responsive_flex_list/src/models/models.dart';
import 'package:responsive_flex_list/src/widgets/animate_item_wrapper.dart';
import 'package:responsive_flex_list/src/widgets/flex_empty_state.dart';
import 'package:responsive_flex_list/src/widgets/flex_error_widget.dart';
import 'package:responsive_flex_list/src/widgets/lists_row_builder.dart';

/// Abstract base class for all responsive flex list layouts
///
/// This class provides common properties and behaviors shared across
/// all layout implementations, ensuring consistency and reducing code duplication.
abstract class BaseResponsiveLayout<T> extends StatelessWidget {
  // Core list properties
  final GlobalKey? listKey;
  final List<T> items;
  final ItemBuilder<T>? itemBuilder;
  final int crossAxisCount;

  // Scroll-related properties
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final bool? primary;
  final double? cacheExtent;

  // Spacing and layout properties
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final SeparatorBuilder? mainAxisSeparator;
  final SeparatorBuilder? crossAxisSeparator;

  // RTL and accessibility
  final bool isRTL;
  final bool useIntrinsicHeight;
  final RTLOptions rtlOptions;
  final double? maxRowHeight;

  // Animation properties
  final AnimationFlow animationFlow;
  final List<Animation<double>> animations;
  final ResponsiveAnimationType animationType;
  final int maxStaggeredItems;
  final CustomAnimationBuilder? customAnimationBuilder;

  // Layout-specific properties
  final MainAxisSeparatorMode? mainAxisSeparatorMode;

  const BaseResponsiveLayout({
    super.key,
    this.listKey,
    required this.items,
    this.itemBuilder,
    required this.crossAxisCount,
    this.padding,
    this.physics,
    this.controller,
    required this.shrinkWrap,
    required this.reverse,
    this.primary,
    this.cacheExtent,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.mainAxisSeparator,
    this.crossAxisSeparator,
    required this.isRTL,
    required this.useIntrinsicHeight,
    required this.rtlOptions,
    this.maxRowHeight,
    required this.animationFlow,
    required this.animations,
    required this.animationType,
    required this.maxStaggeredItems,
    this.customAnimationBuilder,
    this.mainAxisSeparatorMode,
  });

  /// Abstract method that must be implemented by concrete layout classes
  /// This is where each layout defines its specific building logic
  @protected
  Widget buildLayout(BuildContext context);

  /// Template method that provides common error handling and empty state logic
  @override
  Widget build(BuildContext context) {
    // Common validation logic
    final validationError = validateConfiguration();
    if (validationError != null) {
      return FlexErrorWidget(error: validationError);
    }

    // Empty state handling
    if (items.isEmpty) {
      return buildEmptyState();
    }

    // Delegate to specific layout implementation
    return buildLayout(context);
  }

  /// Validates the configuration and returns error message if invalid
  @protected
  String? validateConfiguration() {
    if (itemBuilder == null) {
      return getItemBuilderNullError();
    }

    if (crossAxisCount <= 0) {
      return 'crossAxisCount must be greater than 0';
    }

    return null;
  }

  /// Returns the appropriate error message for null itemBuilder
  /// Can be overridden by subclasses for specific error messages
  @protected
  String getItemBuilderNullError() => 'itemBuilder cannot be null';

  /// Builds the empty state widget
  /// Can be overridden by subclasses for custom empty states
  @protected
  Widget buildEmptyState() => const FlexEmptyState();

  /// Helper method to calculate animation index based on animation flow
  @protected
  int calculateAnimationIndex({
    required int itemIndex,
    required int rowIndex,
    required int columnIndex,
  }) {
    switch (animationFlow) {
      case AnimationFlow.individual:
        return itemIndex;
      case AnimationFlow.byRow:
        return rowIndex;
      case AnimationFlow.byColumn:
        return columnIndex;
      case AnimationFlow.simultaneous:
        return 0;
    }
  }

  /// Helper method to get effective main axis spacing
  @protected
  double getEffectiveMainAxisSpacing() {
    if (mainAxisSpacing == null) {
      return kDefaultMainAxisSpacing;
    }
    return mainAxisSpacing!;
  }

  /// Helper method to get effective cross axis spacing
  @protected
  double getEffectiveCrossAxisSpacing() {
    if (crossAxisSpacing == null) {
      return kDefaultCrossAxisSpacing;
    }
    return crossAxisSpacing!;
  }

  /// Helper method to build animated item wrapper
  Widget buildAnimatedItem({
    required int animationIndex,
    required Widget child,
  }) {
    if (animationType == ResponsiveAnimationType.none &&
        customAnimationBuilder == null) {
      return child;
    }

    // skip if beyond max staggered items
    if (animationIndex >= maxStaggeredItems) {
      return child;
    }

    // Only create wrapper if actually needed
    return AnimateItemWrapper(
      index: animationIndex,
      maxStaggeredItems: maxStaggeredItems,
      animationType: animationType,
      animations: animations,
      rtlOptions: rtlOptions,
      customAnimationBuilder: customAnimationBuilder,
      child: child,
    );
  }

  /// Helper method to calculate total number of rows
  @protected
  int calculateRowCount() {
    return (items.length / crossAxisCount).ceil();
  }

  /// Helper method to get items for a specific row
  @protected
  List<T> getRowItems(int rowIndex) {
    final int startIndex = rowIndex * crossAxisCount;
    final int endIndex = (startIndex + crossAxisCount).clamp(0, items.length);
    return items.sublist(startIndex, endIndex);
  }

  /// Helper method to apply RTL reversal to a list if needed
  @protected
  List<U> applyRTLReversal<U>(List<U> list) {
    if (isRTL && rtlOptions.reverseList) {
      return list.reversed.toList();
    }
    return list;
  }

  /// Helper method to get text direction
  @protected
  TextDirection getTextDirection() {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Helper method to build default main axis separator
  @protected
  Widget buildDefaultMainAxisSeparator(int rowIndex, int totalRows) {
    return mainAxisSeparator?.call(rowIndex, totalRows) ??
        const Padding(
          padding: EdgeInsets.symmetric(vertical: kDefaultMainAxisSpacing),
          child: Divider(thickness: 2, height: 2),
        );
  }

  /// Helper method to build default cross axis separator
  @protected
  Widget buildDefaultCrossAxisSeparator(int columnIndex, int totalColumns) {
    return crossAxisSeparator?.call(columnIndex, totalColumns) ??
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: VerticalDivider(thickness: 2, width: 2),
        );
  }

  /// Helper method to build a row using ListsRowBuilder
  /// This is a PRIVATE helper used internally by other methods
  Widget _buildStandardRow({
    required int rowIndex,
    bool isWhiteSpaceDivider = false,
  }) {
    return ListsRowBuilder<T>(
      isWhiteSpaceDivider: isWhiteSpaceDivider,
      crossAxisSpacing: crossAxisSpacing,
      crossAxisSeparator: crossAxisSeparator,
      mainAxisSpacing: getEffectiveMainAxisSpacing(),
      mainAxisSeparator: mainAxisSeparator,
      rowIndex: rowIndex,
      maxStaggeredItems: maxStaggeredItems,
      crossAxisCount: crossAxisCount,
      items: items,
      itemBuilder: itemBuilder,
      useIntrinsicHeight: useIntrinsicHeight,
      isRTL: isRTL,
      mainAxisSeparatorMode:
          mainAxisSeparatorMode ?? MainAxisSeparatorMode.fullWidth,
      rtlOptions: rtlOptions,
      animationFlow: animationFlow,
      animations: animations,
      animationType: animationType,
      customAnimationBuilder: customAnimationBuilder,
      maxRowHeight: maxRowHeight,
    );
  }

  /// Helper method to build a padded row (commonly used pattern)
  /// Used by: BuilderLayout
  @protected
  Widget buildPaddedRow({
    required int rowIndex,
    bool isWhiteSpaceDivider = true,
    EdgeInsets? customPadding,
  }) {
    return Padding(
      padding: customPadding ??
          EdgeInsets.only(bottom: getEffectiveMainAxisSpacing()),
      child: _buildStandardRow(
        rowIndex: rowIndex,
        isWhiteSpaceDivider: isWhiteSpaceDivider,
      ),
    );
  }

  /// Helper method to check if a row is the last row
  @protected
  bool isLastRow(int rowIndex) {
    return rowIndex >= calculateRowCount() - 1;
  }

  /// Helper method to build row with conditional separator
  /// Used by layouts that add separators between rows
  /// (AxisSeparatorLayout)
  @protected
  Widget buildRowWithSeparator({
    required int rowIndex,
    required int totalRows,
    bool isWhiteSpaceDivider = false,
  }) {
    final row = _buildStandardRow(
      rowIndex: rowIndex,
      isWhiteSpaceDivider: isWhiteSpaceDivider,
    );

    // Return just the row if it's the last row
    if (isLastRow(rowIndex)) {
      return row;
    }

    // For full width separators, wrap in Column
    if (mainAxisSeparatorMode == MainAxisSeparatorMode.fullWidth) {
      return Column(
        children: [
          row,
          buildAnimatedItem(
            animationIndex: calculateAnimationIndex(
              itemIndex: rowIndex * crossAxisCount,
              rowIndex: rowIndex,
              columnIndex: 0,
            ),
            child: buildDefaultMainAxisSeparator(rowIndex, totalRows),
          ),
          const SizedBox.shrink(),
        ],
      );
    }

    return row;
  }
}
