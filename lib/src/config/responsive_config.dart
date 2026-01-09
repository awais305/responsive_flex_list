import 'package:flutter/foundation.dart';

import 'package:responsive_flex_list/src/models/breakpoints.dart';

class ResponsiveConfig {
  static Breakpoints? _activeBreakpoints;

  /// Optional initialization for custom breakpoints at app startup.
  /// If not called, defaults to [Breakpoints.defaultBreakpoints].
  static void init({required Breakpoints breakpoints}) {
    debugPrint('ResponsiveConfig initialized with $breakpoints');
    _activeBreakpoints = breakpoints;
  }

  /// Returns the active [Breakpoints].
  /// Falls back to default breakpoints if [init] was never called.
  static Breakpoints get breakpoints {
    return _activeBreakpoints ?? Breakpoints.defaultBreakpoints;
  }
}
