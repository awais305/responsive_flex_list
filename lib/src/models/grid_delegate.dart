/// A delegate that controls the layout of children within a [ResponsiveFlexList].
///
/// This delegate allows you to customize the grid's behavior, including
/// column counts, spacing, and item dimensions.
class ResponsiveFlexGridDelegate {
  /// Spacing between items in a row.
  final double? crossAxisSpacing;

  /// Spacing between rows.
  final double? mainAxisSpacing;

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

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double? childAspectRatio;

  /// The extent of each child in the main axis.
  ///
  /// If this is non-null, [childAspectRatio] is ignored.
  final double? mainAxisExtent;

  const ResponsiveFlexGridDelegate({
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.crossAxisCount,
    this.minCrossAxisCount,
    this.maxCrossAxisCount,
    this.childAspectRatio,
    this.mainAxisExtent,
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
        ),
        assert(
          childAspectRatio == null || childAspectRatio > 0,
          'childAspectRatio must be greater than zero',
        ),
        assert(
          mainAxisExtent == null || mainAxisExtent > 0,
          'mainAxisExtent must be greater than zero',
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
