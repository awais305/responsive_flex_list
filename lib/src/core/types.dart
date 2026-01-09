import 'package:flutter/widgets.dart';

/// Typedef for item builders
///
/// Item builders receive:
/// - [item]: The data item
/// - [index]: The position of the item in the list
///
/// Should return the widget to display
typedef ItemBuilder<T> = Widget Function(T item, int index);

typedef SeparatorBuilder = Widget Function(int index, int total);

/// Callback to provide the height of an item at a given index
typedef ItemHeightProvider = double Function(int index);

/// Type definition for custom animation builders.
///
/// Custom animation builders receive:
/// - [context]: The build context
/// - [child]: The widget to animate
/// - [animation]: Animation value from 0.0 to 1.0
///
/// Should return the animated widget
typedef CustomAnimationBuilder = Widget Function(
    BuildContext context, Widget child, Animation<double> animation);
