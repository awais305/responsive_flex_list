import 'package:responsive_flex_list/src/core/core.dart';
import 'package:responsive_flex_list/src/models/rtl_options.dart';
import 'package:responsive_flex_list/src/widgets/base_responsive_widget.dart';

/// A responsive list view that automatically adjusts the number of columns
/// based on screen breakpoints.
///
/// This widget creates a grid-like layout that adapts to different screen sizes
/// by changing the number of columns displayed. It supports four different
/// construction patterns:
///
/// 1. **Default constructor**: Renders a fixed list of child widgets.
/// 2. **Builder constructor**: Dynamically builds items from a data source.
/// 3. **Separator constructor**: Similar to builder, but inserts
///    separators between rows or columns.

///
/// ## Basic Usage
///
/// ```dart
/// // With predefined children
/// ResponsiveFlexList(
///   children: [
///     Card(child: Text('Item 1')),
///     Card(child: Text('Item 2')),
///     Card(child: Text('Item 3')),
///   ],
/// )
///
/// // With builder masonry
/// ResponsiveFlexList.builder(
///   items: myDataList,
///   itemBuilder: (item, index) => Card(
///     child: Text('Item ${item.name}'),
///   ),
/// )
///
/// // With custom breakpoints
/// ResponsiveFlexList(
///   breakpoints: Breakpoints(
///     tablet: 800,
///     tabletColumns: 4,
///   ),
///   children: myWidgets,
/// )
/// ```
///
/// ## Responsive Behavior
///
/// The widget automatically determines how many columns to display based on
/// the screen width and the configured breakpoints. By default:
/// ```
/// | Small Mobile        | < 320px   | List (1 column)  |
/// | Mobile              | < 480px   | Grid (2 columns) |
/// | Small Tablet        | < 640px   | Grid (3 columns) |
/// | Tablet              | < 820px   | Grid (4 columns) |
/// | Laptop              | < 1024px  | Grid (5 columns) |
/// | Desktop             | < 1280px  | Grid (6 columns) |
/// | Large Desktop       | < 1440px  | Grid (7 columns) |
/// | Extra Large Desktop | < 1920px  | Grid (8 columns) |
///
/// ```

///
/// These can be customized using the [breakpoints] parameter.
class ResponsiveFlexList<T> extends BaseResponsiveWidget<T> {
  /// Creates a responsive list view with predefined children.
  ///
  /// This constructor is best used when you have a fixed list of widgets
  /// that won't change during the widget's lifetime.
  ///
  /// The [children] parameter is required and cannot be empty.
  ///
  /// Example:
  /// ```dart
  /// ResponsiveFlexList(
  ///   children: [
  ///     Container(height: 100, color: Colors.red),
  ///     Container(height: 100, color: Colors.blue),
  ///     Container(height: 100, color: Colors.green),
  ///   ],
  ///   crossAxisSpacing: 8.0,
  ///   mainAxisSpacing: 8.0,
  /// )
  /// ```

  const ResponsiveFlexList({
    super.key,
    required super.children,
    super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    super.shrinkWrap = false,
    super.reverse = false,
    super.breakpoints,
    super.primary,
    super.cacheExtent,
    super.animationFlow,
    super.animationCurve,
    super.animationDuration,
    super.staggerDelay = kDefaultStaggerDelay,
    super.animationType = kDefaultResponsiveAnimationType,
    super.maxStaggeredItems,
    super.crossAxisSpacing,
    super.mainAxisSpacing,
    super.customAnimationBuilder,
    super.rtlOptions = RTLOptions.defaults,
  })  : assert(
          animationDuration == null ||
              (animationType != ResponsiveAnimationType.none ||
                  customAnimationBuilder != null),
          'animationDuration cannot be used with $animationType',
        ),
        super(
          items: const [],
          itemBuilder: null,
          mainAxisSeparator: null,
          crossAxisSeparator: null,
          type: ResponsiveListType.children,
          mainAxisSeparatorMode: kDefaultMainAxisSeparatorMode,
          useIntrinsicHeight: false,
          maxRowHeightMultiplier: 1,
          maxRowHeight: null,
          roundRobinLayout: false,
        );

  /// Creates a responsive list view with a builder function.
  ///
  /// This constructor is ideal when you have a list of data that needs to be
  /// converted into widgets. The [itemBuilder] function will be called for
  /// each item in the [items] list.
  ///
  /// The [items] and [itemBuilder] parameters are required.
  ///
  /// Example:
  /// ```dart
  /// ResponsiveFlexList.builder(
  ///   items: ['Apple', 'Banana', 'Cherry'],
  ///   itemBuilder: (fruit, index) => Card(
  ///     child: ListTile(
  ///       title: Text(fruit ?? 'Empty'),
  ///       subtitle: Text('Index: $index'),
  ///     ),
  ///   ),
  /// )
  /// ```
  const ResponsiveFlexList.builder({
    super.key,
    required super.items,
    required super.itemBuilder,
    super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    super.shrinkWrap = false,
    super.reverse = false,
    super.primary,
    super.cacheExtent,
    super.breakpoints,
    super.animationDuration,
    super.animationCurve,
    super.animationFlow,
    super.animationType = kDefaultResponsiveAnimationType,
    super.staggerDelay = kDefaultStaggerDelay,
    super.maxStaggeredItems,
    super.customAnimationBuilder,
    super.rtlOptions = RTLOptions.defaults,
    super.mainAxisSpacing = 10,
    super.crossAxisSpacing = 10,
  })  : assert(
          animationDuration == null ||
              (animationType != ResponsiveAnimationType.none ||
                  customAnimationBuilder != null),
          'animationDuration cannot be used with $animationType',
        ),
        super(
          maxRowHeight: null,
          children: const [],
          mainAxisSeparator: null,
          crossAxisSeparator: null,
          mainAxisSeparatorMode: kDefaultMainAxisSeparatorMode,
          type: ResponsiveListType.builder,
          useIntrinsicHeight: false,
          maxRowHeightMultiplier: 1,
          roundRobinLayout: false,
        );

  /// Creates a responsive list view where rows are axisSeparator by a separator.
  ///
  /// This constructor is similar to the builder constructor, but adds
  /// separators between each row of items. This is useful when you want
  /// visual separation between rows.
  ///
  /// The [items] and [itemBuilder] parameters are required.
  ///
  /// Example:
  /// ```dart
  /// ResponsiveFlexList.withSeparators(
  ///   items: myProducts,
  ///   itemBuilder: (product, index) => ProductCard(product: product),
  ///   mainAxisSeparator: Divider(thickness: 2),
  ///   crossAxisSeparator: VerticalDivider(thickness: 1),
  /// )
  /// ```
  const ResponsiveFlexList.withSeparators({
    super.key,
    required super.items,
    required super.itemBuilder,
    required super.mainAxisSeparator,
    required super.crossAxisSeparator,
    super.crossAxisCount,
    super.padding,
    super.physics,
    super.controller,
    super.mainAxisSeparatorMode = kDefaultMainAxisSeparatorMode,
    super.shrinkWrap = false,
    super.reverse = false,
    super.primary,
    super.cacheExtent,
    super.breakpoints,
    super.animationDuration,
    super.animationCurve,
    super.animationType = kDefaultResponsiveAnimationType,
    super.animationFlow,
    super.staggerDelay = kDefaultStaggerDelay,
    super.maxStaggeredItems,
    super.customAnimationBuilder,
    super.rtlOptions = RTLOptions.defaults,
    super.useIntrinsicHeight = false,
    super.maxRowHeight,
    super.roundRobinLayout = false,
  }) : super(
          children: const [],
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxRowHeightMultiplier: 1,
          type: ResponsiveListType.withSeparators,
        );
}
