/// Animation types and builders for ResponsiveFlexList with RTL support.
///
/// This file contains all animation-related enums, type definitions,
/// and the animation builder that creates transitions for list items.
library;

import 'package:flutter/material.dart';

import 'package:responsive_flex_list/src/core/core.dart';

/// Builder class that creates animation transitions based on animation type with RTL support.
///
/// This class centralizes all animation logic and provides automatic RTL mirroring
/// for directional animations when enabled.
class AnimationTransitionBuilder {
  AnimationTransitionBuilder._();

  /// Builds an animated transition for a widget based on the specified animation type.
  ///
  /// Parameters:
  /// - [context]: Build context for the animation (used to detect RTL)
  /// - [child]: Widget to animate
  /// - [animation]: Animation controller value (0.0 to 1.0)
  /// - [animationType]: Type of animation to apply
  /// - [customBuilder]: Optional custom animation builder
  /// - [enableRTLMirroring]: Whether to automatically mirror animations in RTL (default: true)
  ///
  /// Returns the animated widget with the specified transition applied.
  static Widget build({
    required BuildContext context,
    required Widget child,
    required Animation<double> animation,
    required ResponsiveAnimationType animationType,
    CustomAnimationBuilder? customBuilder,
    required bool enableRTLMirroring,
  }) {
    // Use custom builder if provided
    if (customBuilder != null) {
      return customBuilder(context, child, animation);
    }

    // Detect RTL context
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Apply RTL mirroring if enabled and in RTL context
    final effectiveAnimationType = enableRTLMirroring && isRTL
        ? _getMirroredAnimationType(animationType)
        : animationType;

    // Apply built-in animation based on type
    return _buildTransition(
      child,
      animation,
      effectiveAnimationType,
      isRTL && enableRTLMirroring,
    );
  }

  /// Gets the mirrored animation type for RTL contexts.
  static ResponsiveAnimationType _getMirroredAnimationType(
    ResponsiveAnimationType type,
  ) {
    switch (type) {
      case ResponsiveAnimationType.slide:
        // In RTL, slide should come from left instead of right
        return ResponsiveAnimationType
            .slide; // We'll handle the direction in the builder
      case ResponsiveAnimationType.rotation:
      case ResponsiveAnimationType.flipIn:
        // These will be handled in their respective builders
        return type;
      default:
        return type;
    }
  }

  /// Internal method that builds the actual transition widget.
  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    ResponsiveAnimationType type,
    bool isRTLMirrored,
  ) {
    switch (type) {
      case ResponsiveAnimationType.none:
        return child;

      case ResponsiveAnimationType.fade:
        return _buildFadeTransition(child, animation);

      case ResponsiveAnimationType.scale:
        return _buildScaleTransition(child, animation, isRTLMirrored);

      case ResponsiveAnimationType.slide:
        return _buildSlideTransition(child, animation, isRTLMirrored);

      case ResponsiveAnimationType.slideUp:
        return _buildSlideUpTransition(child, animation);

      case ResponsiveAnimationType.slideDown:
        return _buildSlideDownTransition(child, animation);

      case ResponsiveAnimationType.rotation:
        return _buildRotationTransition(child, animation, isRTLMirrored);

      case ResponsiveAnimationType.bounce:
        return _buildBounceTransition(child, animation);

      case ResponsiveAnimationType.flipIn:
        return _buildFlipInTransition(child, animation, isRTLMirrored);
    }
  }

  /// Creates a simple fade transition.
  static Widget _buildFadeTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Creates a scale transition with fade effect.
  static Widget _buildScaleTransition(
    Widget child,
    Animation<double> animation,
    bool isRTLMirrored,
  ) {
    return ScaleTransition(
      alignment: isRTLMirrored ? Alignment.topRight : Alignment.topLeft,
      scale: Tween<double>(begin: 0.3, end: 1.0).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Creates a horizontal slide transition with fade and RTL support.
  static Widget _buildSlideTransition(
    Widget child,
    Animation<double> animation,
    bool isRTLMirrored,
  ) {
    // In RTL, slide from left (-0.5) instead of right (0.5)
    final slideOffset = isRTLMirrored ? -0.5 : 0.5;

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(slideOffset, 0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Creates a slide up transition with fade.
  static Widget _buildSlideUpTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Creates a slide down transition with fade.
  static Widget _buildSlideDownTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Creates a rotation transition with scale, fade, and RTL support.
  static Widget _buildRotationTransition(
    Widget child,
    Animation<double> animation,
    bool isRTLMirrored,
  ) {
    // In RTL, reverse the rotation direction
    final rotationDirection = isRTLMirrored ? -0.1 : 0.1;

    return RotationTransition(
      turns: Tween<double>(
        begin: rotationDirection,
        end: 0.0,
      ).animate(animation),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  /// Creates a bounce transition using elastic curve.
  static Widget _buildBounceTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.4,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
      child: child,
    );
  }

  /// Creates a 3D flip-in transition with RTL support.
  static Widget _buildFlipInTransition(
    Widget child,
    Animation<double> animation,
    bool isRTLMirrored,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, animChild) {
        // Early exit optimization - avoid matrix operations when fully visible
        if (animation.value >= 1.0) return animChild!;

        final double rotationValue = animation.value * 3.14159;
        final bool isShowingFront = animation.value > 0.5;

        // This prevents memory leaks from shared matrix mutations
        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001); // Perspective

        if (isRTLMirrored) {
          transform.rotateY(-rotationValue);
        } else {
          transform.rotateY(rotationValue);
        }

        if (isShowingFront) {
          if (isRTLMirrored) {
            transform.rotateY(-3.14159);
          } else {
            transform.rotateY(3.14159);
          }
        }

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: isShowingFront
              ? animChild
              : Opacity(opacity: 0, child: animChild),
        );
      },
      child: child,
    );
  }
}
