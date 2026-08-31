/// Abstract base class for delegates that control grid child placement and spacing.
///
/// Shared configuration properties such as column counts ([crossAxisCount],
/// [minCrossAxisCount], [maxCrossAxisCount]) and axis spacing ([crossAxisSpacing],
/// [mainAxisSpacing]) are defined here.
abstract class ResponsiveGridDelegate {
  /// Spacing between items in a row (cross-axis).
  final double? crossAxisSpacing;

  /// Spacing between rows or items in a column (main-axis).
  final double? mainAxisSpacing;

  /// Fixed number of columns. If null, determined automatically based on breakpoints.
  final int? crossAxisCount;

  /// Minimum number of columns to display.
  final int? minCrossAxisCount;

  /// Maximum number of columns to display.
  final int? maxCrossAxisCount;

  const ResponsiveGridDelegate({
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.crossAxisCount,
    this.minCrossAxisCount,
    this.maxCrossAxisCount,
  })  : assert(
          crossAxisSpacing == null || crossAxisSpacing >= 0,
          'crossAxisSpacing must be greater than or equal to zero',
        ),
        assert(
          mainAxisSpacing == null || mainAxisSpacing >= 0,
          'mainAxisSpacing must be greater than or equal to zero',
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
        );
}

/// A delegate that controls the layout of children within a [ResponsiveFlexList].
///
/// This delegate extends [ResponsiveGridDelegate] to add item dimension constraints
/// ([childAspectRatio] and [mainAxisExtent]).
class ResponsiveFlexGridDelegate extends ResponsiveGridDelegate {
  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double? childAspectRatio;

  /// The extent of each child in the main axis.
  ///
  /// If this is non-null, [childAspectRatio] is ignored.
  final double? mainAxisExtent;

  const ResponsiveFlexGridDelegate({
    super.crossAxisSpacing,
    super.mainAxisSpacing,
    super.crossAxisCount,
    super.minCrossAxisCount,
    super.maxCrossAxisCount,
    this.childAspectRatio,
    this.mainAxisExtent,
  })  : assert(
          childAspectRatio == null || childAspectRatio > 0,
          'childAspectRatio must be greater than zero',
        ),
        assert(
          mainAxisExtent == null || mainAxisExtent > 0,
          'mainAxisExtent must be greater than zero',
        ),
        assert(
          mainAxisExtent == null || childAspectRatio == null,
          'Cannot provide both mainAxisExtent and childAspectRatio',
        );

  @override
  String toString() {
    return 'ResponsiveFlexGridDelegate('
        'crossAxisSpacing: $crossAxisSpacing, '
        'mainAxisSpacing: $mainAxisSpacing, '
        'crossAxisCount: $crossAxisCount, '
        'minCrossAxisCount: $minCrossAxisCount, '
        'maxCrossAxisCount: $maxCrossAxisCount, '
        'childAspectRatio: $childAspectRatio, '
        'mainAxisExtent: $mainAxisExtent'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResponsiveFlexGridDelegate) return false;

    return crossAxisSpacing == other.crossAxisSpacing &&
        mainAxisSpacing == other.mainAxisSpacing &&
        crossAxisCount == other.crossAxisCount &&
        minCrossAxisCount == other.minCrossAxisCount &&
        maxCrossAxisCount == other.maxCrossAxisCount &&
        childAspectRatio == other.childAspectRatio &&
        mainAxisExtent == other.mainAxisExtent;
  }

  @override
  int get hashCode {
    return Object.hash(
      crossAxisSpacing,
      mainAxisSpacing,
      crossAxisCount,
      minCrossAxisCount,
      maxCrossAxisCount,
      childAspectRatio,
      mainAxisExtent,
    );
  }
}

/// A delegate that controls the layout of children within a masonry layout.
///
/// This delegate allows you to customize the masonry layout's behavior, including
/// column counts and spacing.
///
/// Note: Masonry layouts determine item main-axis dimensions automatically based on
/// content or pattern rules, so `childAspectRatio` and `mainAxisExtent` are not
/// supported or exposed on this delegate.
class ResponsiveMasonryGridDelegate extends ResponsiveGridDelegate {
  const ResponsiveMasonryGridDelegate({
    super.crossAxisSpacing,
    super.mainAxisSpacing,
    super.crossAxisCount,
    super.minCrossAxisCount,
    super.maxCrossAxisCount,
  });

  @override
  String toString() {
    return 'ResponsiveMasonryGridDelegate('
        'crossAxisSpacing: $crossAxisSpacing, '
        'mainAxisSpacing: $mainAxisSpacing, '
        'crossAxisCount: $crossAxisCount, '
        'minCrossAxisCount: $minCrossAxisCount, '
        'maxCrossAxisCount: $maxCrossAxisCount'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResponsiveMasonryGridDelegate) return false;

    return crossAxisSpacing == other.crossAxisSpacing &&
        mainAxisSpacing == other.mainAxisSpacing &&
        crossAxisCount == other.crossAxisCount &&
        minCrossAxisCount == other.minCrossAxisCount &&
        maxCrossAxisCount == other.maxCrossAxisCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      crossAxisSpacing,
      mainAxisSpacing,
      crossAxisCount,
      minCrossAxisCount,
      maxCrossAxisCount,
    );
  }
}
