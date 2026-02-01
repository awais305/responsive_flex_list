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
