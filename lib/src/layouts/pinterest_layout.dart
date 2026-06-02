import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/core/constants.dart';
import 'package:responsive_flex_list/src/layouts/base_responsive_layout.dart';
import 'package:responsive_flex_list/src/layouts/not_lazy_pinterest_list_widget.dart';

/// Pinterest-style masonry layout that packs items into columns with minimal gaps.
///
/// Items are distributed across columns to create a visually balanced masonry grid,
/// similar to Pinterest's layout. Automatically switches to smoother scroll physics
/// for large lists (800+ items) to improve performance.
class PinterestLayout extends BaseResponsiveLayout {
  final void Function(int loaded, int total)? onLoadingProgress;

  /// Whether the pinterest layout will cache widgets once built.
  ///
  /// By default this is true for backwards compatibility; cached mode
  /// prevents unnecessary rebuilds but can also hold memory for long lists.
  final bool cacheChildren;

  const PinterestLayout({
    required this.onLoadingProgress,
    this.cacheChildren = true,
    super.key,
    super.crossAxisSpacing,
    super.padding,
    super.physics,
    super.mainAxisSpacing,
    required super.maxStaggeredItems,
    required super.crossAxisCount,
    required super.itemCount,
    super.itemBuilder,
    required super.isRTL,
    required super.rtlOptions,
    required super.animationFlow,
    required super.animations,
    required super.animationType,
    super.customAnimationBuilder,
    super.items,
    required super.shrinkWrap,
    required super.reverse,
    super.controller,
    super.primary,
    super.scrollCacheExtent,
  }) : super(useIntrinsicHeight: false);

  @override
  Widget buildLayout(BuildContext context) {
    // Use provided physics, or smoother variant for large lists
    final ScrollPhysics? effectivePhysics =
        physics ?? (itemCount < 800 ? null : const SmoothScrollPhysics());

    return CustomScrollView(
      physics: effectivePhysics,
      primary: primary,
      controller: controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      scrollCacheExtent: effectiveScrollCacheExtent,
      slivers: [
        SliverPadding(
          padding: padding ?? const EdgeInsets.all(4),
          sliver: SliverToBoxAdapter(
            child: NotLazyPinterestListWidget(
              itemCount: itemCount,
              itemBuilder: itemBuilder!,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing ?? kDefaultMainAxisSpacing,
              crossAxisSpacing: getEffectiveCrossAxisSpacing(),
              useIntrinsicHeight: useIntrinsicHeight,
              textDirection: getTextDirection(),
              buildAnimatedItem: buildAnimatedItem,
              calculateAnimationIndex: calculateAnimationIndex,
              onLoadingProgress: onLoadingProgress,
              cacheChildren: cacheChildren,
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
