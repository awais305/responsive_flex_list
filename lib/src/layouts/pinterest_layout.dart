import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/core/constants.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';
import 'package:responsive_flex_list/src/layouts/not_lazy_pinterest_list_widget.dart';

/// Pinterest-style masonry layout that packs items into columns with minimal gaps.
///
/// Items are distributed across columns to create a visually balanced masonry grid,
/// similar to Pinterest's layout. Automatically switches to smoother scroll physics
/// for large lists (800+ items) to improve performance.
class PinterestLayout<T> extends BaseResponsiveLayout<T> {
  final void Function(int loaded, int total)? onLoadingProgress;

  const PinterestLayout({
    required this.onLoadingProgress,
    super.key,
    super.crossAxisSpacing,
    super.padding,
    super.mainAxisSpacing,
    required super.maxStaggeredItems,
    required super.crossAxisCount,
    required super.items,
    required super.itemBuilder,
    required super.isRTL,
    required super.rtlOptions,
    required super.animationFlow,
    required super.animations,
    required super.animationType,
    super.customAnimationBuilder,
  }) : super(shrinkWrap: false, reverse: false, useIntrinsicHeight: false);

  @override
  Widget buildLayout(BuildContext context) {
    return CustomScrollView(
      // Use smoother physics for large lists to prevent janky scrolling
      physics: items.length < 800 ? physics : const SmoothScrollPhysics(),
      primary: primary,
      controller: controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      slivers: [
        SliverPadding(
          padding: padding ?? const EdgeInsets.all(4),
          sliver: SliverToBoxAdapter(
            child: NotLazyPinterestListWidget<T>(
              items: items,
              itemBuilder: itemBuilder!,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing ?? kDefaultMainAxisSpacing,
              crossAxisSpacing: getEffectiveCrossAxisSpacing(),
              useIntrinsicHeight: useIntrinsicHeight,
              textDirection: getTextDirection(),
              buildAnimatedItem: buildAnimatedItem,
              calculateAnimationIndex: calculateAnimationIndex,
              onLoadingProgress: onLoadingProgress,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom scroll physics optimized for smooth scrolling in large Pinterest-style lists.
///
/// Reduces friction and adjusts fling velocity ranges to create buttery-smooth
/// scrolling behavior, especially beneficial for lists with 800+ items.
class SmoothScrollPhysics extends BouncingScrollPhysics {
  const SmoothScrollPhysics({super.parent});

  @override
  SmoothScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SmoothScrollPhysics(parent: buildParent(ancestor));
  }

  /// Reduced friction factor for smoother overscroll behavior.
  @override
  double frictionFactor(double overscrollFraction) {
    return 0.002;
  }

  /// Minimum velocity required to trigger a fling gesture.
  @override
  double get minFlingVelocity => 10.0;

  /// Maximum velocity allowed for fling gestures.
  @override
  double get maxFlingVelocity => 20000.0;
}
