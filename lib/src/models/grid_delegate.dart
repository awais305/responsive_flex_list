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

  const ResponsiveFlexGridDelegate(
      {this.crossAxisSpacing,
      this.mainAxisSpacing,
      this.crossAxisCount,
      this.minCrossAxisCount,
      this.maxCrossAxisCount,
      this.childAspectRatio,
      this.mainAxisExtent});
}
