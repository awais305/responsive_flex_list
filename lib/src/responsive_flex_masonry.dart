import 'package:responsive_flex_list/responsive_flex_list.dart';

import 'package:responsive_flex_list/src/widgets/base_responsive_widget.dart';

/// Creates a responsive masonry-style list.
///
/// This layout arranges children in a **Pinterest**/**Instagram** style
/// which automatically adapts to screen size (mobile, tablet, desktop)
/// without requiring manual calculations.
///
/// Example:
/// ```dart
/// ResponsiveFlexMasonry.pinterest(
///   itemCount: products.length,
///   itemBuilder: (context, index) {
///     return ProductCard(products[index]);
///   },
/// )
/// ```
///
/// [ResponsiveFlexMasonry] with respective constructor creates popular
///  social media layouts, providing a ready-made explore/feed style grid
///  without manually defining custom patterns.
///
/// - Automatically handles responsiveness for different screen widths.
/// - Includes animations out of the box (no controllers needed).

class ResponsiveFlexMasonry extends BaseResponsiveWidget {
  /// A masonry layout inspired by Instagram's Explore page.
  ///
  /// Useful for:
  /// - Photo galleries
  /// - Content discovery sections
  /// - Social media feeds
  ///
  /// This layout adapts rows dynamically based on incoming data and screen size.
  ///
  const ResponsiveFlexMasonry.instagram({
    super.key,
    super.itemCount,
    super.itemBuilder,
    @Deprecated('Use itemCount instead') super.items,
    super.maxRowHeightMultiplier = 1,
    super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    super.shrinkWrap = false,
    super.reverse = false,
    super.primary,
    super.scrollCacheExtent,
    super.breakpoints,
    super.animationDuration,
    super.animationCurve,
    super.animationType = kDefaultAnimationType,
    super.animationFlow,
    super.staggerDelay = kDefaultStaggerDelay,
    super.maxStaggeredItems,
    super.customAnimationBuilder,
    super.rtlOptions = RTLOptions.defaults,
    super.mainAxisSpacing = 1,
    super.crossAxisSpacing = 1,
    super.minCrossAxisCount,
    super.maxCrossAxisCount,
    super.gridDelegate,
  })  : assert(
          animationDuration == null ||
              (animationType != AnimationType.none ||
                  customAnimationBuilder != null),
          'animationDuration requires animation to be enabled',
        ),
        super(
          children: const [],
          roundRobinLayout: false,
          mainAxisSeparatorMode: kDefaultMainAxisSeparatorMode,
          mainAxisSeparator: null,
          crossAxisSeparator: null,
          useIntrinsicHeight: false,
          type: ResponsiveListType.instagram,
        );

  /// Non-lazy Pinterest-style masonry grid widget for bounded collections.
  ///
  /// Unlike lazy loading approaches, this widget builds and can cache all
  /// children upfront. That keeps item positions stable, but it is best suited
  /// to small and medium collections rather than infinite feeds.
  ///
  const ResponsiveFlexMasonry.pinterest({
    super.key,
    super.itemCount,
    super.itemBuilder,
    @Deprecated('Use itemCount instead') super.items,
    super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    super.shrinkWrap = false,
    super.reverse = false,
    super.primary,
    super.scrollCacheExtent,
    super.breakpoints,
    super.animationDuration,
    super.animationCurve,
    super.animationType = kDefaultAnimationType,
    super.animationFlow,
    super.staggerDelay = kDefaultStaggerDelay,
    super.maxStaggeredItems,
    super.customAnimationBuilder,
    super.rtlOptions = RTLOptions.defaults,
    super.mainAxisSpacing = 15,
    super.crossAxisSpacing = 10,
    super.onLoadingProgress,
    super.cacheChildren,
    super.minCrossAxisCount,
    super.maxCrossAxisCount,
    super.gridDelegate,
  })  : assert(
          animationDuration == null ||
              (animationType != AnimationType.none ||
                  customAnimationBuilder != null),
          'animationDuration requires animation to be enabled',
        ),
        super(
          children: const [],
          roundRobinLayout: false,
          mainAxisSeparatorMode: kDefaultMainAxisSeparatorMode,
          mainAxisSeparator: null,
          crossAxisSeparator: null,
          useIntrinsicHeight: false,
          type: ResponsiveListType.pinterest,
          maxRowHeightMultiplier: 1,
        );
}
