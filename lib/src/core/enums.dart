/// Internal enum to distinguish between different ResponsiveFlexList constructors.
///
/// This is used internally to determine which build logic to use based on
/// the constructor that was called.
enum ResponsiveListType {
  /// Default constructor with predefined children widgets.
  children,

  /// Builder constructor that creates widgets on demand.
  builder,

  /// Separator constructor that adds separators between rows.
  withSeparators,

  /// Masonry constructor which packs items column-wise and doesn't leave gaps.
  instagram,

  /// Masonry constructor optimized for Pinterest-style layouts.
  pinterest,
}

/// Defines how animations are applied to items in the responsive list.
///
/// Controls the animation sequence and timing for item appearance.
enum AnimationFlow {
  /// Each item animates independently in sequence.
  ///
  /// Items animate one after another regardless of their position,
  /// creating a smooth sequential effect across the entire list.
  individual,

  /// Items animate row by row.
  ///
  /// All items in a row animate together, then the next row animates.
  /// Useful for creating a top-to-bottom reveal effect.
  byRow,

  /// Items animate column by column.
  ///
  /// All items in a column animate together, then the next column animates.
  /// Useful for creating a left-to-right reveal effect.
  byColumn,

  /// All items animate at the same time.
  ///
  /// Every item in the list starts and completes its animation simultaneously,
  /// creating an instant reveal effect.
  simultaneous,
}

/// Determines how separators span across the main axis in row layouts.
///
/// Controls the width behavior of separators between rows in the responsive list.
enum MainAxisSeparatorMode {
  /// Separator spans the entire width of the container.
  ///
  /// The separator extends from edge to edge, regardless of item widths.
  fullWidth,

  /// Separator width matches the combined width of items in the row.
  ///
  /// The separator only spans across the actual space occupied by items,
  /// respecting the layout's natural width constraints.
  itemWidth,
}

/// Available animation types for responsive list transitions.
///
/// Each animation type provides a different visual effect when items
/// appear or change position in the responsive list.
enum ResponsiveAnimationType {
  /// No animation - items appear instantly.
  ///
  /// Use this for performance-critical scenarios or when animations
  /// are not desired.
  none,

  /// Fade in/out animation.
  ///
  /// Items fade in with opacity animation from 0 to 1.
  /// This is the most subtle and universally appropriate animation.
  fade,

  /// Scale animation combined with fade.
  ///
  /// Items scale up from 30% to 100% size while fading in.
  /// Creates a "popping" effect that draws attention to new items.
  scale,

  /// Horizontal slide animation with fade.
  ///
  /// Items slide in from the right (50% offset) while fading in.
  /// Good for horizontal layouts or when indicating direction.
  /// **RTL Note**: Automatically mirrors to slide from left in RTL contexts.
  slide,

  /// Vertical slide up animation with fade.
  ///
  /// Items slide up from below (50% offset) while fading in.
  /// Natural for vertical lists and feels like items are "rising up".
  slideUp,

  /// Vertical slide down animation with fade.
  ///
  /// Items slide down from above (-50% offset) while fading in.
  /// Creates a "dropping in" effect.
  slideDown,

  /// Rotation animation with scale and fade.
  ///
  /// Items rotate slightly (0.1 turns) while scaling from 50% and fading in.
  /// More playful animation suitable for creative interfaces.
  /// **RTL Note**: Rotation direction mirrors in RTL contexts.
  rotation,

  /// Bounce animation using elastic curve.
  ///
  /// Items scale from 0% to 100% with an elastic/bouncy curve.
  /// Eye-catching and playful, good for game-like interfaces.
  bounce,

  /// 3D flip-in animation.
  ///
  /// Items flip in with a 3D rotation effect around the Y-axis.
  /// Advanced animation that creates depth perception.
  /// **RTL Note**: Flip direction mirrors in RTL contexts.
  flipIn,
}
