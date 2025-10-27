import 'package:flutter/material.dart';

import 'package:responsive_flex_list/src/core/core.dart';
import 'package:responsive_flex_list/src/models/rtl_options.dart';

class AnimateItemWrapper extends StatelessWidget {
  final int index;
  final int maxStaggeredItems;
  final ResponsiveAnimationType animationType;
  final CustomAnimationBuilder? customAnimationBuilder;
  final RTLOptions rtlOptions;
  final List<Animation<double>> animations;
  final Widget child;

  const AnimateItemWrapper({
    super.key,
    required this.index,
    required this.maxStaggeredItems,
    required this.animationType,
    this.customAnimationBuilder,
    required this.rtlOptions,
    required this.animations,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (index >= maxStaggeredItems) {
      return child;
    }

    if (index >= animations.length) {
      return child;
    }

    return AnimatedBuilder(
      animation: animations[index],
      builder: (context, _) {
        return RepaintBoundary(
          child: AnimationTransitionBuilder.build(
            context: context,
            animation: animations[index],
            animationType: animationType,
            customBuilder: customAnimationBuilder,
            enableRTLMirroring: rtlOptions.mirrorAnimations,
            child: child,
          ),
        );
      },
    );
  }
}
