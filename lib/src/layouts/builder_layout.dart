import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';

/// Builder layout implementation extending the base abstract class
class BuilderLayout<T> extends BaseResponsiveLayout<T> {
  const BuilderLayout({
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
    required double mainAxisSpacing,
    super.crossAxisSpacing,
    required super.useIntrinsicHeight,
    required super.isRTL,
    required super.rtlOptions,
    required super.animationFlow,
    required super.mainAxisSeparatorMode,
    required super.animations,
    required super.animationType,
    required super.maxStaggeredItems,
    super.customAnimationBuilder,
  }) : super(mainAxisSpacing: mainAxisSpacing);

  @override
  String getItemBuilderNullError() {
    return 'itemBuilder cannot be null for builder constructor';
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
              (context, index) =>
                  buildPaddedRow(rowIndex: index, isWhiteSpaceDivider: true),
              childCount: calculateRowCount(),
            ),
          ),
        ),
      ],
    );
  }
}
