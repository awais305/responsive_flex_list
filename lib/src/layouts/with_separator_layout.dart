import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';
import 'package:responsive_flex_list/src/layouts/round_robin_layout.dart';

/// Responsive layout that renders items in a grid with customizable separators between rows and columns.
///
/// Supports two rendering modes: adaptive height mode using RoundRobinLayout for dynamic
/// item distribution, or fixed height mode using CustomScrollView for efficient sliver-based rendering.
/// Ideal for lists where visual separation between items is important.
class WithSeparatorLayout<T> extends BaseResponsiveLayout<T> {
  /// Enables newspaper-style column layout that distributes items naturally
  /// across columns, eliminating white gaps for balanced visual presentation.
  final bool roundRobinLayout;

  const WithSeparatorLayout({
    super.key,
    super.listKey,
    required super.items,
    super.itemBuilder,
    required super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    required super.shrinkWrap,
    required super.reverse,
    super.primary,
    super.cacheExtent,
    required super.mainAxisSeparator,
    required super.crossAxisSeparator,
    super.mainAxisSpacing,
    super.crossAxisSpacing,
    required super.useIntrinsicHeight,
    required super.isRTL,
    required this.roundRobinLayout,
    required super.rtlOptions,
    required super.animationFlow,
    required super.mainAxisSeparatorMode,
    required super.animations,
    required super.animationType,
    required super.maxStaggeredItems,
    super.customAnimationBuilder,
    super.maxRowHeight,
  });

  @override
  String getItemBuilderNullError() =>
      'itemBuilder cannot be null for `ResponsiveListType.withSeparators`';

  @override
  Widget buildLayout(BuildContext context) {
    // Use RoundRobinLayout for adaptive heights to distribute items evenly across columns
    if (roundRobinLayout) {
      return RoundRobinLayout(
        reverse: reverse,
        shrinkWrap: shrinkWrap,
        crossAxisSeparator: crossAxisSeparator,
        mainAxisSeparator: mainAxisSeparator,
        customAnimationBuilder: customAnimationBuilder,
        mainAxisSpacing: getEffectiveMainAxisSpacing(),
        crossAxisSpacing: crossAxisSpacing,
        maxStaggeredItems: maxStaggeredItems,
        crossAxisCount: crossAxisCount,
        items: items,
        itemBuilder: itemBuilder,
        isRTL: isRTL,
        useIntrinsicHeight: useIntrinsicHeight,
        rtlOptions: rtlOptions,
        animationFlow: animationFlow,
        animations: animations,
        animationType: animationType,
        padding: padding,
      );
    }

    // Use sliver-based layout for fixed height mode with efficient viewport rendering
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
              // Build each row with separators between items
              (context, index) => buildRowWithSeparator(
                totalRows: (items.length / crossAxisCount).ceil(),
                rowIndex: index,
                isWhiteSpaceDivider: false,
              ),
              childCount: calculateRowCount(),
            ),
          ),
        ),
      ],
    );
  }
}
