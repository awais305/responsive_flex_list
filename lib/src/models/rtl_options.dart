import 'package:flutter/semantics.dart';

/// A responsive list view that automatically adjusts the number of columns
/// based on screen breakpoints with RTL support.
///
/// This widget creates a grid-like layout that adapts to different screen sizes
/// by changing the number of columns displayed. It supports three different
/// construction patterns and includes comprehensive RTL support.
///
/// ## RTL Support
///
/// The widget automatically detects RTL text direction and can adapt its behavior:
/// - Animations can be mirrored (slideLeft becomes slideRight)
/// - Row and item ordering can be reversed
/// - Scroll direction can be adapted
///
/// Configure RTL behavior using the [rtlOptions] parameter:
///
/// ```dart
/// ResponsiveFlexList(
///   rtlOptions: RTLOptions(
///     mirrorAnimations: true,
///     reverseList: true,
///   ),
///   children: myWidgets,
/// )
/// ```
class RTLOptions {
  /// Creates RTL configuration options
  const RTLOptions({
    this.mirrorAnimations = true,
    this.reverseRowOrder = true,
    this.reverseList = false,
    this.reverseScrollDirection = false,
    this.forceTextDirection,
    this.adjustScrollPhysics = false,
  });

  /// Whether to mirror animations in RTL mode
  /// For example, slideLeft becomes slideRight in RTL
  final bool mirrorAnimations;

  /// Whether to reverse the order of rows in RTL mode
  final bool reverseRowOrder;

  /// Whether to reverse the order of items within each row in RTL mode
  final bool reverseList;

  /// Whether to adapt scroll direction behavior for RTL
  final bool reverseScrollDirection;

  /// Force a specific text direction, overriding the inherited direction
  /// If null, uses the inherited text direction from the widget tree
  final TextDirection? forceTextDirection;

  /// Whether to adjust scroll physics for RTL behavior.
  final bool adjustScrollPhysics;

  /// Default RTL options with sensible defaults
  static const RTLOptions defaults = RTLOptions();

  RTLOptions copyWith({
    bool? mirrorAnimations,
    bool? reverseRowOrder,
    bool? reverseList,
    bool? reverseScrollDirection,
    TextDirection? forceTextDirection,
    bool? adjustScrollPhysics,
  }) {
    return RTLOptions(
      mirrorAnimations: mirrorAnimations ?? this.mirrorAnimations,
      reverseRowOrder: reverseRowOrder ?? this.reverseRowOrder,
      reverseList: reverseList ?? this.reverseList,
      reverseScrollDirection:
          reverseScrollDirection ?? this.reverseScrollDirection,
      forceTextDirection: forceTextDirection ?? this.forceTextDirection,
      adjustScrollPhysics: adjustScrollPhysics ?? this.adjustScrollPhysics,
    );
  }

  @override
  String toString() {
    return 'RTLOptions(mirrorAnimations: $mirrorAnimations, reverseRowOrder: $reverseRowOrder, reverseList: $reverseList, reverseScrollDirection: $reverseScrollDirection, forceTextDirection: $forceTextDirection,adjustScrollPhysics: $adjustScrollPhysics)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RTLOptions &&
        other.mirrorAnimations == mirrorAnimations &&
        other.reverseRowOrder == reverseRowOrder &&
        other.reverseList == reverseList &&
        other.reverseScrollDirection == reverseScrollDirection &&
        other.forceTextDirection == forceTextDirection &&
        other.adjustScrollPhysics == adjustScrollPhysics;
  }

  @override
  int get hashCode {
    return mirrorAnimations.hashCode ^
        reverseRowOrder.hashCode ^
        reverseList.hashCode ^
        reverseScrollDirection.hashCode ^
        forceTextDirection.hashCode ^
        adjustScrollPhysics.hashCode;
  }
}
