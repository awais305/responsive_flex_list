import 'package:flutter/widgets.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

import 'package:responsive_flex_list/src/widgets/list_animations.dart';

/// Base class for all responsive widgets (List and Masonry).
///
class BaseResponsiveWidget extends StatefulWidget {
  const BaseResponsiveWidget({
    super.key,
    required this.children,
    required this.itemBuilder,
    required this.type,
    int? itemCount,
    this.crossAxisCount,
    this.padding,
    this.physics,
    this.controller,
    this.mainAxisSeparator,
    this.crossAxisSeparator,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.scrollCacheExtent,
    this.breakpoints,
    this.animationDuration,
    this.animationCurve,
    this.animationType = kDefaultAnimationType,
    this.animationFlow = kDefaultAnimationFlow,
    this.staggerDelay = kDefaultStaggerDelay,
    this.maxStaggeredItems,
    this.customAnimationBuilder,
    this.rtlOptions = RTLOptions.defaults,
    this.mainAxisSeparatorMode = kDefaultMainAxisSeparatorMode,
    this.useIntrinsicHeight = false,
    this.roundRobinLayout = false,
    this.maxRowHeightMultiplier = 1,
    this.maxRowHeight,
    this.onLoadingProgress,
    this.cacheChildren = true,
    this.minCrossAxisCount,
    this.maxCrossAxisCount,
    this.gridDelegate,
    this.childAspectRatio,
    this.mainAxisExtent,
    @Deprecated(
        'Use itemCount instead. If provided, itemCount will be items.length.')
    this.items,
  })  : assert(
          itemCount == null || itemCount >= 0,
          'itemCount must be greater than or equal to zero',
        ),
        assert(
          crossAxisCount == null || crossAxisCount > 0,
          'crossAxisCount must be greater than zero',
        ),
        assert(
          minCrossAxisCount == null || minCrossAxisCount > 0,
          'minCrossAxisCount must be greater than zero',
        ),
        assert(
          maxCrossAxisCount == null || maxCrossAxisCount > 0,
          'maxCrossAxisCount must be greater than zero',
        ),
        assert(
          minCrossAxisCount == null ||
              maxCrossAxisCount == null ||
              minCrossAxisCount <= maxCrossAxisCount,
          'minCrossAxisCount cannot be greater than maxCrossAxisCount',
        ),
        assert(
          mainAxisSpacing == null || mainAxisSpacing >= 0,
          'mainAxisSpacing must be greater than or equal to zero',
        ),
        assert(
          crossAxisSpacing == null || crossAxisSpacing >= 0,
          'crossAxisSpacing must be greater than or equal to zero',
        ),
        assert(
          childAspectRatio == null || childAspectRatio > 0,
          'childAspectRatio must be greater than zero',
        ),
        assert(
          mainAxisExtent == null || mainAxisExtent > 0,
          'mainAxisExtent must be greater than zero',
        ),
        assert(
          maxRowHeight == null || maxRowHeight > 0,
          'maxRowHeight must be greater than zero',
        ),
        assert(
          maxRowHeightMultiplier > 0,
          'maxRowHeightMultiplier must be greater than zero',
        ),
        assert(
          scrollCacheExtent == null || scrollCacheExtent >= 0,
          'scrollCacheExtent must be greater than or equal to zero',
        ),
        itemCount = itemCount ?? items?.length ?? 0;

  /// Fixed number of columns. If null, determined automatically based on breakpoints.
  final int? crossAxisCount;

  /// Minimum number of columns to display.
  ///
  /// e.g.
  /// minCrossAxisCount: 2
  ///
  /// -> At least 2 columns even on small phones
  final int? minCrossAxisCount;

  /// Maximum number of columns to display.
  ///
  /// e.g.
  /// maxCrossAxisCount: 4
  ///
  /// -> At most 4 columns even on ultra-wide screens
  final int? maxCrossAxisCount;

  /// A delegate that controls the layout of children within the list/grid.
  final ResponsiveFlexGridDelegate? gridDelegate;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double? childAspectRatio;

  /// The extent of each child in the main axis.
  final double? mainAxisExtent;

  /// List of pre-built child widgets for the children constructor.
  final List<Widget> children;

  /// Number of items to be displayed.
  final int itemCount;

  /// Builder function that creates widgets from data items.
  final ItemBuilder? itemBuilder;

  /// [Deprecated] Use [itemCount] instead.
  @Deprecated('Use itemCount instead')
  final List? items;

  /// Padding around the list content. Automatically flipped for RTL layouts.
  final EdgeInsets? padding;

  /// Scroll physics determining how the list responds to user input.
  final ScrollPhysics? physics;

  /// Controller for programmatic scroll control.
  final ScrollController? controller;

  /// Builder for separators between rows (main axis).
  ///
  /// Called with `(rowIndex, totalRows) =>` to create horizontal dividers.
  final SeparatorBuilder? mainAxisSeparator;

  /// Builder for separators between columns (cross axis).
  ///
  /// Called with `(columnIndex, totalColumns) =>` to create vertical dividers.
  final SeparatorBuilder? crossAxisSeparator;

  /// Spacing between rows. Cannot be used with [mainAxisSeparator].
  final double? mainAxisSpacing;

  /// Spacing between items in a row. Cannot be used with [crossAxisSeparator].
  final double? crossAxisSpacing;

  /// Whether the list wraps its content tightly instead of expanding.
  final bool shrinkWrap;

  /// Whether the list scrolls in reverse direction.
  final bool reverse;

  /// Whether this is the primary scroll view associated with the parent.
  final bool? primary;

  /// Viewport cache extent for performance optimization.
  final double? scrollCacheExtent;

  /// Responsive breakpoints configuration for different screen sizes.
  final Breakpoints? breakpoints;

  /// Internal type determining which build logic to use.
  final ResponsiveListType type;

  /// Duration of item entrance animations.
  final Duration? animationDuration;

  /// Curve applied to item entrance animations.
  final Curve? animationCurve;

  /// Type of animation effect (fade, scale, slide, etc.).
  final AnimationType animationType;

  /// Delay between consecutive item animations in staggered mode.
  final Duration staggerDelay;

  /// Maximum items to animate in staggered sequences. Auto-calculated if null.
  final int? maxStaggeredItems;

  /// Custom animation builder for advanced control. Overrides [animationType].
  final CustomAnimationBuilder? customAnimationBuilder;

  /// Controls how animations progress (individual, by row, by column, simultaneous).
  ///
  /// `Animation.simultaneous` Default
  final AnimationFlow animationFlow;

  /// Controls separator width behavior (fullWidth or itemWidth).
  final MainAxisSeparatorMode mainAxisSeparatorMode;

  /// RTL layout configuration options.
  final RTLOptions rtlOptions;

  /// Whether all items in a row match the height of the tallest item.
  ///
  /// Enabling it is relatively expensive. Avoid using it if possible.
  final bool useIntrinsicHeight;

  /// Distributes items sequentially across columns (1→2→3→1→2→3...), similar to newspaper columns
  final bool roundRobinLayout;

  /// Maximum allowed height for a row.
  /// Perfect if you don't want to enable [useIntrinsicHeight].
  final double? maxRowHeight;

  /// Multiplier applied to calculated row heights **(For Instagram Layout)**.
  final double maxRowHeightMultiplier;

  /// Callback fired with progress updates as images load.
  /// Receives (loadedCount, totalCount).
  ///
  /// When `loaded == total`, all images are fully loaded and rendered.
  ///
  /// Since all items are rendered at once (non-lazy), the UI may appear
  /// unresponsive during initial load. This callback provides essential
  /// user feedback to indicate loading progress and prevent the perception
  /// of a frozen app, especially important for lists with 50+ items that
  /// include images.
  final void Function(int loaded, int total)? onLoadingProgress;

  /// When set to `false`, Pinterest layout will not cache its built children.
  ///
  /// Defaults to true for backward compatibility. Turning caching off forces
  /// the masonry widget to rebuild every item on each build pass, which is
  /// useful when the items are expected to change frequently or when you
  /// want to avoid holding a large list in memory.
  final bool cacheChildren;

  @override
  State<BaseResponsiveWidget> createState() => BaseResponsiveWidgetState();
}

/// Shared state logic managing responsive behavior, animations, and layout calculations.
class BaseResponsiveWidgetState extends State<BaseResponsiveWidget> {
  /// Current number of columns being displayed based on screen width.
  late int crossAxisCount;

  /// Tracks current animation type to detect changes and trigger re-animation.
  AnimationType? _currentAnimationType;

  /// Flag indicating whether animations should play on this build.
  bool shouldAnimate = true;

  /// Maximum number of items to include in staggered animations.
  late int maxStaggeredItems;

  /// Effective text direction considering RTL options and widget tree context.
  TextDirection get _effectiveTextDirection {
    return widget.rtlOptions.forceTextDirection ?? Directionality.of(context);
  }

  /// Whether the current layout is in right-to-left mode.
  bool get _isRTL => _effectiveTextDirection == TextDirection.rtl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initial calculation will happen in build/LayoutBuilder
  }

  @override
  void didUpdateWidget(BaseResponsiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animations when layout configuration changes
    if (oldWidget.breakpoints != widget.breakpoints ||
        oldWidget.rtlOptions != widget.rtlOptions) {
      setState(() => shouldAnimate = true);
    }

    // Reset animation when animation type or RTL mirroring changes
    if (oldWidget.animationType != widget.animationType ||
        oldWidget.rtlOptions.mirrorAnimations !=
            widget.rtlOptions.mirrorAnimations) {
      _currentAnimationType = widget.animationType;
      setState(() => shouldAnimate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (context, constraints) {
        crossAxisCount = _getCrossAxisCount(constraints);
        maxStaggeredItems = _getMaxStaggeredItems(crossAxisCount);

        return buildAnimatedLayout(
          key: ValueKey('$_currentAnimationType'),
          crossAxisCount: crossAxisCount,
          maxStaggeredItems: maxStaggeredItems,
          isRTL: _isRTL,
        );
      },
    );

    // Force text direction if specified in RTL options
    if (widget.rtlOptions.forceTextDirection != null) {
      child = Directionality(
        textDirection: widget.rtlOptions.forceTextDirection!,
        child: child,
      );
    }

    return child;
  }

  /// Builds the animated layout with current configuration and RTL adjustments.
  Widget buildAnimatedLayout({
    required Key key,
    required int crossAxisCount,
    required int maxStaggeredItems,
    required bool isRTL,
  }) {
    return ListAnimations(
      key: key,
      type: widget.type,
      itemCount: widget.itemCount,
      crossAxisCount: crossAxisCount,
      itemBuilder: widget.itemBuilder,
      padding: isRTL ? widget.padding?.flipped : widget.padding,
      physics: _getEffectivePhysics(),
      controller: widget.controller,
      shrinkWrap: widget.shrinkWrap,
      reverse: _getEffectiveReverse(),
      primary: widget.primary,
      scrollCacheExtent: widget.scrollCacheExtent,
      animationDuration: widget.animationDuration ?? kDefaultAnimationDuration,
      animationCurve: widget.animationCurve ?? kDefaultAnimationCurve,
      animationType: widget.animationType,
      animationFlow: widget.animationFlow,
      staggerDelay: widget.staggerDelay,
      maxStaggeredItems: maxStaggeredItems,
      customAnimationBuilder: widget.customAnimationBuilder,
      shouldAnimate: shouldAnimate,
      crossAxisSeparator: widget.crossAxisSeparator,
      mainAxisSeparator: widget.mainAxisSeparator,
      mainAxisSeparatorMode: widget.mainAxisSeparatorMode,
      isRTL: isRTL,
      maxRowHeightMultiplier: widget.maxRowHeightMultiplier,
      rtlOptions: widget.rtlOptions,
      useIntrinsicHeight: widget.useIntrinsicHeight,
      roundRobinLayout: widget.roundRobinLayout,
      maxRowHeight: widget.maxRowHeight,
      onLoadingProgress: widget.onLoadingProgress,
      cacheChildren: widget.cacheChildren,
      childAspectRatio: _getChildAspectRatio(),
      mainAxisExtent: _getMainAxisExtent(),
      mainAxisSpacing: _getMainAxisSpacing(),
      crossAxisSpacing: _getCrossAxisSpacing(),
      items: widget.items,
      children: widget.children,
    );
  }

  double? _getChildAspectRatio() {
    return widget.gridDelegate?.childAspectRatio ?? widget.childAspectRatio;
  }

  double? _getMainAxisExtent() {
    return widget.gridDelegate?.mainAxisExtent ?? widget.mainAxisExtent;
  }

  double? _getMainAxisSpacing() {
    return widget.gridDelegate?.mainAxisSpacing ?? widget.mainAxisSpacing;
  }

  double? _getCrossAxisSpacing() {
    return widget.gridDelegate?.crossAxisSpacing ?? widget.crossAxisSpacing;
  }

  /// Returns scroll physics with RTL adjustments. Defaults to BouncingScrollPhysics for RTL.
  ScrollPhysics? _getEffectivePhysics() {
    if (!_isRTL || !widget.rtlOptions.adjustScrollPhysics) {
      return widget.physics;
    }
    return widget.physics ?? const BouncingScrollPhysics();
  }

  /// Returns scroll direction with RTL adjustments. Inverts reverse when RTL is enabled.
  bool _getEffectiveReverse() {
    bool effectiveReverse = widget.reverse;
    if (_isRTL && widget.rtlOptions.reverseScrollDirection) {
      effectiveReverse = !effectiveReverse;
    }
    return effectiveReverse;
  }

  /// Calculates column count based on screen width and breakpoints.
  int _getCrossAxisCount(BoxConstraints constraints) {
    final effectiveCrossAxisCount =
        widget.gridDelegate?.crossAxisCount ?? widget.crossAxisCount;
    if (effectiveCrossAxisCount != null) {
      return effectiveCrossAxisCount;
    }

    final screenWidth = constraints.maxWidth;
    final points = ResponsiveConfig.breakpoints.mergeWith(widget.breakpoints);

    int count;
    if (points.extraLargeDesktop != null &&
        screenWidth >= points.extraLargeDesktop!) {
      count = points.extraLargeDesktopColumns;
    } else if (points.largeDesktop != null &&
        screenWidth >= points.largeDesktop!) {
      count = points.largeDesktopColumns;
    } else if (points.desktop != null && screenWidth >= points.desktop!) {
      count = points.desktopColumns;
    } else if (points.laptop != null && screenWidth >= points.laptop!) {
      count = points.laptopColumns;
    } else if (points.tablet != null && screenWidth >= points.tablet!) {
      count = points.tabletColumns;
    } else if (points.smallTablet != null &&
        screenWidth >= points.smallTablet!) {
      count = points.smallTabletColumns;
    } else if (points.mobile != null && screenWidth >= points.mobile!) {
      count = points.mobileColumns;
    } else {
      count = points.smallMobileColumns;
    }

    // Apply min/max boundaries
    final effectiveMinCrossAxisCount =
        widget.gridDelegate?.minCrossAxisCount ?? widget.minCrossAxisCount;
    final effectiveMaxCrossAxisCount =
        widget.gridDelegate?.maxCrossAxisCount ?? widget.maxCrossAxisCount;

    if (effectiveMinCrossAxisCount != null) {
      count = count.clamp(effectiveMinCrossAxisCount, double.infinity).toInt();
    }
    if (effectiveMaxCrossAxisCount != null) {
      count = count.clamp(0, effectiveMaxCrossAxisCount).toInt();
    }

    return count;
  }

  /// Calculates max staggered items based on current layout for optimal performance.
  /// Ensures all initial items in the viewport are animated.
  int _getMaxStaggeredItems(int currentColumns) {
    if (widget.maxStaggeredItems != null) {
      return widget.maxStaggeredItems!;
    }

    // Aim for roughly 6-10 rows of items to animate
    // This ensures full-screen coverage on most devices
    return (currentColumns * 8).clamp(kDefaultMaxStaggeredItems, 100);
  }
}
