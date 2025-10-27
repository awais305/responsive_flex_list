import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';
import 'package:responsive_flex_list/src/layouts/builder_layout.dart';
import 'package:responsive_flex_list/src/layouts/children_layout.dart';
import 'package:responsive_flex_list/src/layouts/masonry_instagram_layout.dart';
import 'package:responsive_flex_list/src/layouts/pinterest_layout.dart';
import 'package:responsive_flex_list/src/layouts/with_separator_layout.dart';
import 'package:responsive_flex_list/src/widgets/flex_error_widget.dart';

/// A widget that powers the animated behavior of responsive flex.
///
/// This widget handles building list layouts (builder, children, and separators),
/// while applying staggered animations, custom transitions, and optional separators.
///
/// Generic over type [T], which represents the data model for list items.
///
class ListAnimations<T> extends StatefulWidget {
  /// Creates a [ListAnimations] instance.
  const ListAnimations({
    super.key,
    required this.type,
    required this.items,
    required this.children,
    this.itemBuilder,
    required this.crossAxisCount,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    required this.animationDuration,
    required this.animationCurve,
    required this.animationType,
    required this.animationFlow,
    required this.staggerDelay,
    required this.maxStaggeredItems,
    required this.maxRowHeightMultiplier,
    this.customAnimationBuilder,
    required this.shouldAnimate,
    this.mainAxisSeparator,
    required this.mainAxisSeparatorMode,
    this.crossAxisSeparator,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    required this.isRTL,
    required this.rtlOptions,
    required this.useIntrinsicHeight,
    required this.roundRobinLayout,
    this.maxRowHeight,
    this.onLoadingProgress,
  });

  final ResponsiveListType type;
  final List<T> items;
  final int crossAxisCount;
  final List<Widget> children;
  final ItemBuilder<T>? itemBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final bool? primary;
  final double? cacheExtent;
  final Duration animationDuration;
  final Curve animationCurve;
  final ResponsiveAnimationType animationType;
  final Duration staggerDelay;
  final double maxRowHeightMultiplier;
  final int maxStaggeredItems;
  final CustomAnimationBuilder? customAnimationBuilder;
  final bool shouldAnimate;
  final SeparatorBuilder? mainAxisSeparator;
  final SeparatorBuilder? crossAxisSeparator;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final AnimationFlow animationFlow;
  final MainAxisSeparatorMode mainAxisSeparatorMode;
  final bool useIntrinsicHeight;
  final bool roundRobinLayout;
  final double? maxRowHeight;
  final RTLOptions rtlOptions;
  final bool isRTL;
  final void Function(int loaded, int total)? onLoadingProgress;

  @override
  State<ListAnimations<T>> createState() => ListAnimationsState<T>();
}

/// State for [ListAnimations].
///
/// Handles creation of animation controllers, running staggered
/// animations, building list layouts, and disposing controllers.
class ListAnimationsState<T> extends State<ListAnimations<T>>
    with TickerProviderStateMixin {
  final GlobalKey _listKey = GlobalKey();
  late List<Animation<double>> _animations;
  late List<AnimationController> _controllers;
  bool _hasAnimated = false;

  /// Expose animations for subclasses to use in custom layouts
  List<Animation<double>> get animations => _animations;

  @override
  void initState() {
    super.initState();
    _initializeEmptyAnimations();
    _tryInitializeAndAnimate();
  }

  @override
  void didUpdateWidget(ListAnimations<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool wasEmpty = _getOldItemCount(oldWidget) == 0;
    final bool isNowNonEmpty = _getCurrentItemCount() > 0;

    if (wasEmpty && isNowNonEmpty) {
      _tryInitializeAndAnimate();
    }

    if (oldWidget.shouldAnimate != widget.shouldAnimate) {
      if (widget.shouldAnimate && !_hasAnimated && _getCurrentItemCount() > 0) {
        _tryInitializeAndAnimate();
      } else if (!widget.shouldAnimate) {
        _skipAnimation();
      }
    }
  }

  int _getOldItemCount(ListAnimations<T> oldWidget) {
    return oldWidget.type == ResponsiveListType.children
        ? oldWidget.children.length
        : oldWidget.items.length;
  }

  int _getCurrentItemCount() {
    return widget.type == ResponsiveListType.children
        ? widget.children.length
        : widget.items.length;
  }

  void _initializeEmptyAnimations() {
    _controllers = [];
    _animations = [];
  }

  void _tryInitializeAndAnimate() {
    if (widget.animationType == ResponsiveAnimationType.none) return;

    final int currentItemCount = _getCurrentItemCount();

    if (currentItemCount > 0 && !_hasAnimated) {
      _initializeAnimations();

      if (widget.shouldAnimate) {
        _startAnimation();
        _hasAnimated = true;
      } else {
        _skipAnimation();
        _hasAnimated = true;
      }
    }
  }

  void _initializeAnimations() {
    _disposeControllers();

    final int currentItemCount = _getCurrentItemCount();
    final int maxItems = currentItemCount.clamp(0, widget.maxStaggeredItems);

    _controllers = List.generate(
      maxItems,
      (index) =>
          AnimationController(duration: widget.animationDuration, vsync: this),
    );

    _animations = _controllers
        .map(
          (controller) =>
              CurvedAnimation(parent: controller, curve: widget.animationCurve),
        )
        .toList();
  }

  void _startAnimation() {
    if (_controllers.isEmpty) return;

    for (final controller in _controllers) {
      controller.reset();
    }

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: widget.staggerDelay.inMilliseconds * i),
        () {
          if (mounted && i < _controllers.length) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  void _skipAnimation() {
    if (_controllers.isEmpty) return;

    for (final controller in _controllers) {
      controller.value = 1.0;
    }
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ResponsiveListType.builder) {
      return BuilderLayout(
        listKey: _listKey,
        items: widget.items,
        crossAxisCount: widget.crossAxisCount,
        shrinkWrap: widget.shrinkWrap,
        reverse: widget.reverse,
        useIntrinsicHeight: widget.useIntrinsicHeight,
        isRTL: widget.isRTL,
        rtlOptions: widget.rtlOptions,
        animationFlow: widget.animationFlow,
        mainAxisSeparatorMode: widget.mainAxisSeparatorMode,
        animations: _animations,
        animationType: widget.animationType,
        maxStaggeredItems: widget.maxStaggeredItems,
        cacheExtent: widget.cacheExtent,
        controller: widget.controller,
        customAnimationBuilder: widget.customAnimationBuilder,
        itemBuilder: widget.itemBuilder,
        padding: widget.padding,
        physics: widget.physics,
        primary: widget.primary,
        mainAxisSpacing:
            (widget.mainAxisSpacing == null || widget.mainAxisSpacing! <= 5)
                ? kDefaultMainAxisSpacing
                : widget.mainAxisSpacing!,
        crossAxisSpacing:
            (widget.crossAxisSpacing == null || widget.crossAxisSpacing! <= 5)
                ? kDefaultCrossAxisSpacing
                : widget.crossAxisSpacing,
      );
    }

    if (widget.type == ResponsiveListType.children) {
      return ChildrenLayout(
        listKey: _listKey,
        shrinkWrap: widget.shrinkWrap,
        controller: widget.controller,
        physics: widget.physics,
        padding: widget.padding,
        cacheExtent: widget.cacheExtent,
        customAnimationBuilder: widget.customAnimationBuilder,
        primary: widget.primary,
        reverse: widget.reverse,
        crossAxisCount: widget.crossAxisCount,
        maxStaggeredItems: widget.maxStaggeredItems,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        isRTL: widget.isRTL,
        useIntrinsicHeight: widget.useIntrinsicHeight,
        rtlOptions: widget.rtlOptions,
        animationFlow: widget.animationFlow,
        animations: _animations,
        animationType: widget.animationType,
        children: widget.children,
      );
    }

    if (widget.type == ResponsiveListType.withSeparators) {
      return WithSeparatorLayout(
        listKey: _listKey,
        items: widget.items,
        crossAxisCount: widget.crossAxisCount,
        shrinkWrap: widget.shrinkWrap,
        reverse: widget.reverse,
        mainAxisSeparatorMode: widget.mainAxisSeparatorMode,
        useIntrinsicHeight: widget.useIntrinsicHeight,
        isRTL: widget.isRTL,
        rtlOptions: widget.rtlOptions,
        animationFlow: widget.animationFlow,
        animations: _animations,
        animationType: widget.animationType,
        maxStaggeredItems: widget.maxStaggeredItems,
        padding: widget.padding ?? EdgeInsets.zero,
        controller: widget.controller,
        physics: widget.physics,
        primary: widget.primary,
        cacheExtent: widget.cacheExtent,
        crossAxisSeparator: widget.crossAxisSeparator,
        mainAxisSeparator: widget.mainAxisSeparator,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing ?? kDefaultMainAxisSpacing,
        customAnimationBuilder: widget.customAnimationBuilder,
        itemBuilder: widget.itemBuilder,
        roundRobinLayout: widget.roundRobinLayout,
        maxRowHeight: widget.maxRowHeight,
      );
    }

    if (widget.type == ResponsiveListType.instagram) {
      return InstagramLayout<T>(
        padding: widget.padding,
        maxRowHeightMultiplier: widget.maxRowHeightMultiplier,
        crossAxisCount: widget.crossAxisCount < 4 ? 3 : widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing ?? kDefaultMainAxisSpacing,
        maxStaggeredItems: widget.maxStaggeredItems,
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        isRTL: widget.isRTL,
        rtlOptions: widget.rtlOptions,
        animationFlow: widget.animationFlow,
        animations: animations,
        animationType: widget.animationType,
        crossAxisSpacing: widget.crossAxisSpacing,
        customAnimationBuilder: widget.customAnimationBuilder,
      );
    }
    if (widget.type == ResponsiveListType.pinterest) {
      return PinterestLayout<T>(
        padding: widget.padding,
        mainAxisSpacing: widget.mainAxisSpacing ?? kDefaultMainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        maxStaggeredItems: widget.maxStaggeredItems,
        crossAxisCount: widget.crossAxisCount <= 2 ? 2 : widget.crossAxisCount,
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        isRTL: widget.isRTL,
        rtlOptions: widget.rtlOptions,
        animationFlow: widget.animationFlow,
        animations: animations,
        animationType: widget.animationType,
        onLoadingProgress: widget.onLoadingProgress,
        customAnimationBuilder: widget.customAnimationBuilder,
      );
    }

    return FlexErrorWidget(error: 'Invalid List Type: ${widget.type}');
  }
}
