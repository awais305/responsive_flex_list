## [1.4.2] - 24 Aug 2026

#### Performance
- Improved grid and list rendering performance.
- Optimized Instagram-style grid row calculations.
- Reduced unnecessary widget processing when building rows.
- Reduced animation overhead by using a single animation controller for staggered animations.

## [1.4.1] - 05 Jun 2026

- Fixed incomplete last-row alignment in `ResponsiveFlexList.builder` by preserving cross-axis spacing for empty column slots.

## [1.4.0] - 02 Jun 2026

#### Migration Notes
___

- Raised the minimum SDK versions to Dart `>=3.6.0` and Flutter `>=3.27.0`.
- Renamed `cacheExtent` to `scrollCacheExtent` to match Flutter's `CustomScrollView` API. Replace `cacheExtent: ...` with `scrollCacheExtent: ...`.
- Updated default breakpoint ranges. Desktop now starts at `1024px`, large desktop at `1440px`, and extra-large desktop at `1920px`.

#### Fixes
___

##### Breakpoints
- Fixed matching so each range now uses consistent lower-bound behavior.
- Fixed extra-large desktop handling across resolution, `copyWith`, `mergeWith`, equality, `hashCode`, and `toString`.

##### Context Helpers
- Updated size helpers to use the latest `ResponsiveConfig.breakpoints`.
- Corrected desktop boundary checks for `context.isDesktop`, `context.isLargeDesktop`, and `context.isExtraLargeDesktop`.

##### Pinterest Masonry
- Fixed child caching when `cacheChildren` changes after the first build.
- Prevented unnecessary cache rebuilds caused by inline `itemBuilder` closures.
- Fixed cache updates when item counts increase or decrease.

##### Scroll Cache
- Fixed `scrollCacheExtent` forwarding across standard, separator, masonry, and round-robin layouts.

#### Performance
- Improved Pinterest masonry caching so cached children are preserved across normal parent rebuilds.

## [1.3.0] - 13 Mar 2026

- **Feature**: Added `ResponsiveFlexGridDelegate` support to `ResponsiveFlexList`. This allows centralized configuration of column counts, spacing, and item dimensions.
- **Deprecation**: Deprecated individual parameters (`childAspectRatio`, `mainAxisExtent`, `crossAxisSpacing`, `mainAxisSpacing`, `minCrossAxisCount`, `maxCrossAxisCount`, `crossAxisCount`) in `ResponsiveFlexList` constructors in favor of `gridDelegate`.
- **Improvement**: Enhanced `ListsRowBuilder` to intelligently apply `AspectRatio` or `mainAxisExtent` from the delegate.

## [1.2.0] - 02 Mar 2026

- **Feature**: Added `minCrossAxisCount` and `maxCrossAxisCount` properties to all responsive widgets. This allows defining explicit column boundaries across different screen sizes.
- **Breaking Change**: Removed generic type `<T>` from `ResponsiveFlexList`, `ResponsiveFlexMasonry`, and all related widgets and layouts. This simplifies the API and improves maintainability.
- **Breaking Change**: Replaced `List<T> items` with `int itemCount` in all builder-style constructors. Note: A deprecated `items` parameter is retained for backward compatibility during migration.
- **Breaking Change**: Updated `ItemBuilder` signature to a simplified `Widget Function(BuildContext context, int index)` without generics. Access your data using the provided index.
- **Internal**: Optimized performance by calculating stagger limits dynamically within the build phase.
- **Improvement**: Refactored animation stagger logic to be dynamic based on the actual column count. This ensures consistent full-screen animation coverage even when using custom column boundaries.
- **Improvement**: Updated all internal layout engines to support the new pattern.

## [1.1.0] - 01 Feb 2026

- **Breaking Change**: Updated `ItemBuilder<T>` signature from `Widget Function(T item, int index)` to `Widget Function(BuildContext context, int index)`. This change provides access to the build context for more advanced widget building. Users can access items from the parent list using the `index` parameter.
- **Enhancement**: Updated all layout implementations (RoundRobinLayout, MasonryInstagramLayout, NotLazyPinterestListWidget, ListsRowBuilder) to support the new ItemBuilder signature.
- **Documentation**: Updated README with examples demonstrating the new ItemBuilder usage pattern.
- **Tests**: Updated all test cases to reflect the new ItemBuilder signature.

## [1.0.1] - 10 Jan 2026

- Updated README with clearer usage instructions
- Improved example app to demonstrate correct package usage

## [1.0.0] - 09 Jan 2026

- **Breaking Change**: Updated `ItemBuilder<T>` signature to use non-nullable `T`. Users may need to remove null checks or explicit `?` from their item builder functions.
- **Feature**: Made `ResponsiveConfig.init` optional. The package now falls back to `Breakpoints.defaultBreakpoints` if not initialized.
- **Cleanup**: Updated example app, tests and documentation to reflect the new, simpler initialization flow.

## [0.1.0] - 27 Oct 2025

- initial release
