import 'package:flutter/material.dart';
import 'package:responsive_flex_list/src/config/responsive_config.dart';
import 'package:responsive_flex_list/src/models/breakpoints.dart';

Breakpoints _breakpoints = ResponsiveConfig.breakpoints;

/// Convenience getters for screen size and breakpoint checks.
///
/// Example:
/// ```dart
/// if (context.isTablet) {
///   // Render tablet-specific layout
/// }
/// ```

extension ScreenSize on BuildContext {
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

  // Helper to find the next defined breakpoint value
  double? _getNextBreakpoint(List<double?> breakpoints) {
    for (final bp in breakpoints) {
      if (bp != null) return bp;
    }
    return null;
  }

  // Individual size checks - only return true if the breakpoint is defined
  bool get isSmallMobile {
    if (_breakpoints.smallMobile == null) return false;
    final upperBound = _breakpoints.mobile ??
        _breakpoints.smallTablet ??
        _breakpoints.tablet ??
        double.infinity;
    return screenWidth < _breakpoints.smallMobile! && screenWidth < upperBound;
  }

  bool get isMobile {
    if (_breakpoints.mobile == null) return false;
    final upperBound = _getNextBreakpoint([
          _breakpoints.smallTablet,
          _breakpoints.tablet,
          _breakpoints.laptop,
        ]) ??
        double.infinity;
    return screenWidth >= _breakpoints.mobile! && screenWidth < upperBound;
  }

  bool get isSmallTablet {
    if (_breakpoints.smallTablet == null) return false;
    final upperBound = _getNextBreakpoint([
          _breakpoints.tablet,
          _breakpoints.laptop,
          _breakpoints.desktop,
        ]) ??
        double.infinity;
    return screenWidth >= _breakpoints.smallTablet! && screenWidth < upperBound;
  }

  bool get isTablet {
    if (_breakpoints.tablet == null) return false;
    final upperBound = _getNextBreakpoint([
          _breakpoints.laptop,
          _breakpoints.desktop,
          _breakpoints.largeDesktop,
        ]) ??
        double.infinity;
    return screenWidth >= _breakpoints.tablet! && screenWidth < upperBound;
  }

  bool get isLaptop {
    if (_breakpoints.laptop == null) return false;
    final upperBound = _getNextBreakpoint([
          _breakpoints.desktop,
          _breakpoints.largeDesktop,
          _breakpoints.extraLargeDesktop,
        ]) ??
        double.infinity;
    return screenWidth >= _breakpoints.laptop! && screenWidth < upperBound;
  }

  bool get isDesktop {
    if (_breakpoints.desktop == null) return false;
    final upperBound = _getNextBreakpoint([
          _breakpoints.largeDesktop,
          _breakpoints.extraLargeDesktop,
        ]) ??
        double.infinity;
    return screenWidth >= _breakpoints.desktop! && screenWidth < upperBound;
  }

  bool get isLargeDesktop {
    if (_breakpoints.largeDesktop == null) return false;
    final upperBound = _breakpoints.extraLargeDesktop ?? double.infinity;
    return screenWidth >= _breakpoints.largeDesktop! &&
        screenWidth < upperBound;
  }

  bool get isExtraLargeDesktop {
    if (_breakpoints.extraLargeDesktop == null) return false;
    return screenWidth >= _breakpoints.extraLargeDesktop!;
  }

  /// General checks, if you want to implement at all screen sizes for same category
  bool get isMobileDevice {
    // Only return true if at least one mobile breakpoint is defined
    if (_breakpoints.smallMobile == null && _breakpoints.mobile == null) {
      return false;
    }

    final upperBound = _getNextBreakpoint([
          _breakpoints.mobile,
          _breakpoints.smallTablet,
          _breakpoints.tablet,
        ]) ??
        double.infinity;
    return screenWidth < upperBound;
  }

  bool get isTabletDevice {
    // Only return true if at least one tablet breakpoint is defined
    if (_breakpoints.smallTablet == null && _breakpoints.tablet == null) {
      return false;
    }

    final lowerBound = _breakpoints.mobile ?? _breakpoints.smallMobile ?? 0;
    final upperBound = _getNextBreakpoint([
          _breakpoints.tablet,
          _breakpoints.laptop,
          _breakpoints.desktop,
        ]) ??
        double.infinity;
    return screenWidth >= lowerBound && screenWidth < upperBound;
  }

  bool get isDesktopDevice {
    // Only return true if at least one desktop breakpoint is defined
    if (_breakpoints.laptop == null &&
        _breakpoints.desktop == null &&
        _breakpoints.largeDesktop == null &&
        _breakpoints.extraLargeDesktop == null) {
      return false;
    }

    final lowerBound = _getNextBreakpoint([
          _breakpoints.laptop,
          _breakpoints.desktop,
          _breakpoints.largeDesktop,
        ]) ??
        0;
    return screenWidth >= lowerBound;
  }
}
