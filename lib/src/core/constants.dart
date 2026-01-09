import 'package:flutter/material.dart';

import 'package:responsive_flex_list/src/core/core.dart';

/// Default animation duration for ResponsiveFlexList animations
const Duration kDefaultAnimationDuration = Duration(milliseconds: 250);

/// Default stagger delay between item animations
const Duration kDefaultStaggerDelay = Duration(milliseconds: 100);

/// Default maximum number of items to animate
const int kDefaultMaxStaggeredItems = 20;

/// Default animation curve
const Curve kDefaultAnimationCurve = Curves.easeInOut;

/// Default animation type
const ResponsiveAnimationType kDefaultResponsiveAnimationType =
    ResponsiveAnimationType.none;

/// Default animation mode
const AnimationFlow kDefaultAnimationFlow = AnimationFlow.simultaneous;

const MainAxisSeparatorMode kDefaultMainAxisSeparatorMode =
    MainAxisSeparatorMode.fullWidth;

/// Default spacing values
const double kDefaultMainAxisSpacing = 15.0;
const double kDefaultCrossAxisSpacing = 15.0;
