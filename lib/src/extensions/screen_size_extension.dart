import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/config/responsive_config.dart';
import 'package:responsive_flex_list/src/models/breakpoints.dart';

/// Convenience getters for screen size and breakpoint checks.
///
/// Example:
/// ```dart
/// if (context.isTablet) {
///   // Render tablet-specific layout
/// }
/// ```

extension ScreenSize on BuildContext {
  Breakpoints get _breakpoints => ResponsiveConfig.breakpoints;

  /// Returns `true` if [MediaQuery] is not available (e.g., outside a widget tree).
  bool get hasMediaQuery {
    try {
      MediaQuery.of(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Helper to find the next defined breakpoint value.
  double? _getNextBreakpoint(List<double?> breakpoints) {
    for (final bp in breakpoints) {
      if (bp != null) return bp;
    }
    return null;
  }

  bool _isInBreakpointRange(double? lowerBound, List<double?> nextBreakpoints) {
    if (lowerBound == null) return false;
    final upperBound = _getNextBreakpoint(nextBreakpoints);
    return screenWidth >= lowerBound &&
        (upperBound == null || screenWidth < upperBound);
  }

  bool _isSmallestBreakpointRange(
    double? breakpoint,
    List<double?> nextBreakpoints,
  ) {
    if (breakpoint == null) return false;
    final upperBound = _getNextBreakpoint(nextBreakpoints);
    if (upperBound == null) return screenWidth >= breakpoint;
    return screenWidth < upperBound;
  }

  // Individual size checks - only return true if the breakpoint is defined.
  bool get isSmallMobile {
    return _isSmallestBreakpointRange(
      _breakpoints.smallMobile,
      [
        _breakpoints.mobile,
        _breakpoints.smallTablet,
        _breakpoints.tablet,
        _breakpoints.laptop,
        _breakpoints.desktop,
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isMobile {
    return _isInBreakpointRange(
      _breakpoints.mobile,
      [
        _breakpoints.smallTablet,
        _breakpoints.tablet,
        _breakpoints.laptop,
        _breakpoints.desktop,
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isSmallTablet {
    return _isInBreakpointRange(
      _breakpoints.smallTablet,
      [
        _breakpoints.tablet,
        _breakpoints.laptop,
        _breakpoints.desktop,
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isTablet {
    return _isInBreakpointRange(
      _breakpoints.tablet,
      [
        _breakpoints.laptop,
        _breakpoints.desktop,
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isLaptop {
    return _isInBreakpointRange(
      _breakpoints.laptop,
      [
        _breakpoints.desktop,
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isDesktop {
    return _isInBreakpointRange(
      _breakpoints.desktop,
      [
        _breakpoints.largeDesktop,
        _breakpoints.extraLargeDesktop,
      ],
    );
  }

  bool get isLargeDesktop {
    return _isInBreakpointRange(
      _breakpoints.largeDesktop,
      [_breakpoints.extraLargeDesktop],
    );
  }

  bool get isExtraLargeDesktop {
    if (_breakpoints.extraLargeDesktop == null) return false;
    return screenWidth >= _breakpoints.extraLargeDesktop!;
  }

  /// Returns `true` when the current width is in a phone-sized layout range.
  ///
  /// This combines [isSmallMobile] and [isMobile]. It is a breakpoint-width
  /// helper, not physical device detection.
  bool get isMobileRange {
    return isSmallMobile || isMobile;
  }

  /// Returns `true` when the current width is in a tablet-sized layout range.
  ///
  /// This combines [isSmallTablet] and [isTablet]. It is a breakpoint-width
  /// helper, not physical device detection.
  bool get isTabletRange {
    return isSmallTablet || isTablet;
  }

  /// Returns `true` when the current width is in a desktop-sized layout range.
  ///
  /// This combines [isLaptop], [isDesktop], [isLargeDesktop], and
  /// [isExtraLargeDesktop]. It is a breakpoint-width helper, not physical
  /// device detection.
  bool get isDesktopRange {
    return isLaptop || isDesktop || isLargeDesktop || isExtraLargeDesktop;
  }
}
