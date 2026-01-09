import 'package:flutter/material.dart';

/// Model for header state
class HeaderModel {
  final String title;
  final bool visible;

  HeaderModel({required this.title, required this.visible});
}

/// Reusable widget for displaying any list with grouped sticky headers
class GroupedListView<T> extends StatefulWidget {
  /// The list of items to display
  final List<T> items;

  /// Function to extract the group key from an item (e.g., date, category)
  /// This determines how items are grouped together
  final String Function(T item) groupBy;

  /// Function to extract the subgroup key from an item (optional)
  /// For example, if groupBy is month, subGroupBy could be day
  final String Function(T item)? subGroupBy;

  /// Function to build the header for each group
  /// Receives the group key and list of items in that group
  final Widget Function(String groupKey, List<T> items) groupHeaderBuilder;

  /// Function to build the subgroup header (optional)
  /// For example, day headers within a month group
  final Widget Function(String subGroupKey, List<T> items)?
  subGroupHeaderBuilder;

  /// Function to build each item widget
  final Widget Function(T item, int itemsInSubGroup) itemBuilder;

  /// Label for the first/latest group header
  final String? firstGroupLabel;

  /// Function to format the group key for display in sticky header
  /// If null, uses the group key as-is
  final String Function(String groupKey)? groupKeyFormatter;

  /// Function to sort groups (default: reversed, showing latest first)
  final int Function(String a, String b)? groupComparator;

  /// Function to sort subgroups within a group
  final int Function(String a, String b)? subGroupComparator;

  /// Function to sort items within a subgroup
  final int Function(T a, T b)? itemComparator;

  /// Background color for the sticky header
  final Color stickyHeaderBackgroundColor;

  /// Text style for the sticky header
  final TextStyle? stickyHeaderTextStyle;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Animation duration for sticky header transitions
  final Duration animationDuration;

  /// Padding for sticky header
  final EdgeInsets stickyHeaderPadding;

  /// Whether to show the sticky header at all
  final bool showStickyHeader;

  /// Cache extent for better scroll performance
  final double cacheExtent;

  const GroupedListView({
    super.key,
    required this.items,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.subGroupBy,
    this.subGroupHeaderBuilder,
    this.firstGroupLabel,
    this.groupKeyFormatter,
    this.groupComparator,
    this.subGroupComparator,
    this.itemComparator,
    this.stickyHeaderBackgroundColor = Colors.white,
    this.stickyHeaderTextStyle,
    this.physics = const BouncingScrollPhysics(),
    this.animationDuration = const Duration(milliseconds: 300),
    this.stickyHeaderPadding = const EdgeInsets.only(left: 20),
    this.showStickyHeader = true,
    this.cacheExtent = 500.0,
  });

  @override
  State<GroupedListView<T>> createState() => _GroupedListViewState<T>();
}

class _GroupedListViewState<T> extends State<GroupedListView<T>> {
  final scrollController = ScrollController();
  final scrollNotifier = ValueNotifier(0.0);
  final headerNotifier = ValueNotifier<HeaderModel?>(null);
  String? lastGroupTitle;

  // Track currently visible header to reduce unnecessary updates
  String? _currentVisibleHeader;
  bool _isHeaderVisible = false;

  void _refreshHeader(String title, bool visible, {String? lastOne}) {
    // Dismiss header when at top
    if (scrollController.offset <= 0) {
      if (_isHeaderVisible) {
        _isHeaderVisible = false;
        _currentVisibleHeader = null;
        headerNotifier.value = HeaderModel(title: title, visible: false);
      }
      return;
    }

    // Determine which title to show
    String actualTitle = title;
    bool shouldBeVisible = visible;

    if (!visible && lastOne != null && lastOne.isNotEmpty) {
      actualTitle = lastOne;
      shouldBeVisible = true;
    }

    // Only update if something actually changed
    if (_currentVisibleHeader != actualTitle ||
        _isHeaderVisible != shouldBeVisible) {
      _currentVisibleHeader = actualTitle;
      _isHeaderVisible = shouldBeVisible;
      headerNotifier.value = HeaderModel(
        title: actualTitle,
        visible: shouldBeVisible,
      );
    }
  }

  void _onListen() => scrollNotifier.value = scrollController.offset;

  Map<String, List<T>> _groupItems() {
    final grouped = <String, List<T>>{};
    for (final item in widget.items) {
      final key = widget.groupBy(item);
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }

  Map<String, List<T>> _subGroupItems(List<T> items) {
    if (widget.subGroupBy == null) return {'': items};

    final subGrouped = <String, List<T>>{};
    for (final item in items) {
      final key = widget.subGroupBy!(item);
      subGrouped.putIfAbsent(key, () => []).add(item);
    }
    return subGrouped;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onListen);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onListen);
    scrollController.dispose();
    scrollNotifier.dispose();
    headerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupItems();
    var groupKeys = groupedData.keys.toList();

    // Sort groups
    if (widget.groupComparator != null) {
      groupKeys.sort(widget.groupComparator);
    } else {
      // Default: reverse order (latest first)
      groupKeys = groupKeys.reversed.toList();
    }

    return Stack(
      children: [
        CustomScrollView(
          physics: widget.physics,
          controller: scrollController,
          cacheExtent: widget.cacheExtent,
          slivers: [
            ...groupKeys
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final groupKey = entry.value;
                  final groupItems = groupedData[groupKey]!;

                  // Sort items in group if comparator provided
                  if (widget.itemComparator != null) {
                    groupItems.sort(widget.itemComparator!);
                  }

                  final isFirstGroup = index == 0;
                  final displayGroupKey = widget.groupKeyFormatter != null
                      ? widget.groupKeyFormatter!(groupKey)
                      : groupKey;

                  final headerTitle =
                      isFirstGroup && widget.firstGroupLabel != null
                      ? widget.firstGroupLabel!
                      : displayGroupKey;

                  final lastOne = lastGroupTitle ?? '';
                  lastGroupTitle = displayGroupKey;

                  // Get subgroups
                  final subGroupedData = _subGroupItems(groupItems);
                  var subGroupKeys = subGroupedData.keys.toList();

                  // Sort subgroups
                  if (widget.subGroupComparator != null &&
                      widget.subGroupBy != null) {
                    subGroupKeys.sort(widget.subGroupComparator!);
                  }

                  return [
                    // Main group header
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: _SliverHeaderDelegate(
                        child: widget.groupHeaderBuilder(
                          isFirstGroup && widget.firstGroupLabel != null
                              ? widget.firstGroupLabel!
                              : groupKey,
                          groupItems,
                        ),
                        onHeaderChanged: (visible) {
                          if (widget.showStickyHeader) {
                            _refreshHeader(
                              headerTitle,
                              visible,
                              lastOne: lastOne,
                            );
                          }
                        },
                      ),
                    ),
                    // Subgroups and items
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final subGroupKey = subGroupKeys[index];
                        final subGroupItems = subGroupedData[subGroupKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subgroup header (if provided)
                            if (widget.subGroupHeaderBuilder != null &&
                                widget.subGroupBy != null)
                              widget.subGroupHeaderBuilder!(
                                subGroupKey,
                                subGroupItems,
                              ),
                            // Items in subgroup
                            ...subGroupItems.map((item) {
                              return widget.itemBuilder(
                                item,
                                subGroupItems.length,
                              );
                            }),
                          ],
                        );
                      }, childCount: subGroupKeys.length),
                    ),
                  ];
                })
                .expand((slivers) => slivers),
          ],
        ),
        // Sticky header
        if (widget.showStickyHeader)
          ValueListenableBuilder(
            valueListenable: headerNotifier,
            builder: (context, snapshot, child) {
              final visible = snapshot?.visible ?? false;
              final title = snapshot?.title ?? '';
              return Positioned(
                left: widget.stickyHeaderPadding.left,
                top: widget.stickyHeaderPadding.top,
                right: widget.stickyHeaderPadding.right,
                child: AnimatedSwitcher(
                  switchInCurve: Curves.bounceIn,
                  duration: widget.animationDuration,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  child: visible
                      ? DecoratedBox(
                          key: Key(title),
                          decoration: BoxDecoration(
                            color: widget.stickyHeaderBackgroundColor,
                          ),
                          child: Text(
                            title,
                            style:
                                widget.stickyHeaderTextStyle ??
                                const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Internal delegate for sliver persistent header
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Function(bool visible) onHeaderChanged;

  final double _height = 40;

  // Track last state to avoid unnecessary callbacks
  bool _lastVisibleState = false;

  _SliverHeaderDelegate({required this.child, required this.onHeaderChanged});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final visible = shrinkOffset > maxExtent - minExtent;

    // Only call callback if state changed
    if (visible != _lastVisibleState) {
      _lastVisibleState = visible;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onHeaderChanged(visible);
      });
    }

    return child;
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

/// Example usage with TransactionModel:
///
/// ```dart
/// class TransactionModel {
///   final String title;
///   final String description;
///   final String amount;
///   final DateTime date;
///   final String category;
///   final String image;
///
///   TransactionModel({
///     required this.title,
///     required this.description,
///     required this.amount,
///     required this.date,
///     required this.category,
///     required this.image,
///   });
/// }
///
/// // Example 1: Group by DATE (month)
/// GroupedListView<TransactionModel>(
///   items: transactions,
///   groupBy: (transaction) {
///     return '${transaction.date.month} ${transaction.date.year}';
///   },
///   subGroupBy: (transaction) {
///     return '${transaction.date.month}/${transaction.date.day}';
///   },
///   firstGroupLabel: 'Latest Transactions',
///   groupHeaderBuilder: (groupKey, items) {
///     final total = items.fold(0.0, (sum, t) => sum + double.parse(t.amount));
///     return Padding(
///       padding: const EdgeInsets.all(20),
///       child: Row(
///         mainAxisAlignment: MainAxisAlignment.spaceBetween,
///         children: [
///           Text(groupKey, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
///           Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 23)),
///         ],
///       ),
///     );
///   },
///   subGroupHeaderBuilder: (subGroupKey, items) {
///     final dailyTotal = items.fold(0.0, (sum, t) => sum + double.parse(t.amount));
///     return Padding(
///       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
///       child: Row(
///         mainAxisAlignment: MainAxisAlignment.spaceBetween,
///         children: [
///           Text(subGroupKey, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
///           if (items.length > 1) Text('\$${dailyTotal.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey)),
///         ],
///       ),
///     );
///   },
///   itemBuilder: (transaction, itemsInSubGroup) {
///     return ListTile(
///       title: Text(transaction.title),
///       subtitle: Text(transaction.description),
///       trailing: itemsInSubGroup > 1 ? Text('\$${transaction.amount}') : null,
///     );
///   },
/// )
///
/// // Example 2: Group by CATEGORY
/// GroupedListView<TransactionModel>(
///   items: transactions,
///   groupBy: (transaction) => transaction.category,
///   firstGroupLabel: 'All Categories',
///   groupHeaderBuilder: (groupKey, items) {
///     final total = items.fold(0.0, (sum, t) => sum + double.parse(t.amount));
///     return Padding(
///       padding: const EdgeInsets.all(20),
///       child: Row(
///         mainAxisAlignment: MainAxisAlignment.spaceBetween,
///         children: [
///           Text(groupKey, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
///           Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 23)),
///         ],
///       ),
///     );
///   },
///   itemBuilder: (transaction, itemsInGroup) {
///     return ListTile(
///       title: Text(transaction.title),
///       subtitle: Text(transaction.description),
///       trailing: Text('\$${transaction.amount}'),
///     );
///   },
/// )
///
/// // Example 3: Brands and Products
/// class Product {
///   final String name;
///   final String brand;
///   final double price;
///   Product({required this.name, required this.brand, required this.price});
/// }
///
/// GroupedListView<Product>(
///   items: products,
///   groupBy: (product) => product.brand,
///   firstGroupLabel: 'All Brands',
///   groupHeaderBuilder: (brand, items) {
///     return Padding(
///       padding: const EdgeInsets.all(20),
///       child: Text(brand, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
///     );
///   },
///   itemBuilder: (product, itemsInGroup) {
///     return ListTile(
///       title: Text(product.name),
///       trailing: Text('\$${product.price.toStringAsFixed(2)}'),
///     );
///   },
/// )
/// ```
///
///
List<TransactionModel> transactions = [
  ..._octoberTransactions,
  ..._novemberTransactions,
  ..._decemberTransactions,
  ..._januaryTransactions,
];

class TransactionModel {
  String title;
  String description;
  String amount;
  DateTime date;
  String category;
  String image;

  TransactionModel({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.image,
  });
}

List<TransactionModel> _januaryTransactions = [
  TransactionModel(
    title: "Transport Payment",
    description: "Monthly rent for transport",
    amount: "1200.00",
    date: DateTime(2024, 1, 1),
    category: "Housing",
    image: "rent.jpg",
  ),
];

List<TransactionModel> _decemberTransactions = [
  TransactionModel(
    title: "Rent Payment",
    description: "Monthly rent for apartment",
    amount: "1500.00",
    date: DateTime(2023, 12, 1),
    category: "Housing",
    image: "rent.jpg",
  ),
  TransactionModel(
    title: "Electricity Bill",
    description: "Monthly electricity bill payment",
    amount: "120.50",
    date: DateTime(2023, 12, 1),
    category: "Utilities",
    image: "electricity.jpg",
  ),
  TransactionModel(
    title: "Car Insurance",
    description: "Payment for car insurance premium",
    amount: "300.00",
    date: DateTime(2023, 12, 3),
    category: "Insurance",
    image: "car_insurance.jpg",
  ),
  TransactionModel(
    title: "Internet Subscription",
    description: "Monthly internet service subscription",
    amount: "60.00",
    date: DateTime(2023, 12, 4),
    category: "Utilities",
    image: "internet.jpg",
  ),
  TransactionModel(
    title: "Holiday Shopping",
    description: "Shopping for holiday gifts",
    amount: "250.00",
    date: DateTime(2023, 12, 5),
    category: "Shopping",
    image: "holiday_shopping.jpg",
  ),
  TransactionModel(
    title: "Dinner with Friends",
    description: "Dining out with friends",
    amount: "75.00",
    date: DateTime(2023, 12, 6),
    category: "Dining",
    image: "dinner.jpg",
  ),
  TransactionModel(
    title: "Health Insurance",
    description: "Health insurance premium payment",
    amount: "200.00",
    date: DateTime(2023, 12, 7),
    category: "Insurance",
    image: "health_insurance.jpg",
  ),
  TransactionModel(
    title: "Grocery Shopping",
    description: "Weekly grocery shopping",
    amount: "85.99",
    date: DateTime(2023, 12, 8),
    category: "Food",
    image: "groceries.jpg",
  ),
  TransactionModel(
    title: "Movie Night",
    description: "Movie night with family",
    amount: "40.00",
    date: DateTime(2023, 12, 9),
    category: "Entertainment",
    image: "movies.jpg",
  ),
  TransactionModel(
    title: "New Year's Eve Party",
    description: "Expenses for New Year's Eve",
    amount: "150.00",
    date: DateTime(2023, 12, 10),
    category: "Entertainment",
    image: "new_years_eve.jpg",
  ),
];

List<TransactionModel> _novemberTransactions = [
  TransactionModel(
    title: "Groceries",
    description: "Weekly grocery shopping",
    amount: "45.99",
    date: DateTime(2023, 11, 1),
    category: "Food",
    image: "groceries.jpg",
  ),
  TransactionModel(
    title: "Gasoline",
    description: "Filled up the car",
    amount: "35.25",
    date: DateTime(2023, 11, 2),
    category: "Transportation",
    image: "gasoline.jpg",
  ),
  TransactionModel(
    title: "Restaurant",
    description: "Dinner with friends",
    amount: "75.50",
    date: DateTime(2023, 11, 3),
    category: "Dining",
    image: "restaurant.jpg",
  ),
  TransactionModel(
    title: "Electronics",
    description: "Bought a new phone",
    amount: "599.99",
    date: DateTime(2023, 11, 4),
    category: "Shopping",
    image: "phone.jpg",
  ),
  TransactionModel(
    title: "Clothing",
    description: "Shopping for new clothes",
    amount: "129.95",
    date: DateTime(2023, 11, 5),
    category: "Shopping",
    image: "clothing.jpg",
  ),
  TransactionModel(
    title: "Utilities",
    description: "Monthly utility bill",
    amount: "150.00",
    date: DateTime(2023, 11, 6),
    category: "Bills",
    image: "utilities.jpg",
  ),
  TransactionModel(
    title: "Health",
    description: "Gym membership renewal",
    amount: "50.00",
    date: DateTime(2023, 11, 7),
    category: "Health",
    image: "gym.jpg",
  ),
  TransactionModel(
    title: "Travel",
    description: "Plane ticket booking",
    amount: "350.00",
    date: DateTime(2023, 11, 8),
    category: "Travel",
    image: "travel.jpg",
  ),
  TransactionModel(
    title: "Entertainment",
    description: "Movie night with friends",
    amount: "25.00",
    date: DateTime(2023, 11, 9),
    category: "Entertainment",
    image: "entertainment.jpg",
  ),
  TransactionModel(
    title: "Education",
    description: "Online course subscription",
    amount: "89.99",
    date: DateTime(2023, 11, 10),
    category: "Education",
    image: "education.jpg",
  ),
];

List<TransactionModel> _octoberTransactions = [
  TransactionModel(
    title: "Groceries",
    description: "Weekly grocery shopping",
    amount: "45.99",
    date: DateTime(2022, 10, 1),
    category: "Food",
    image: "groceries.jpg",
  ),
  TransactionModel(
    title: "Gasoline",
    description: "Filled up the car",
    amount: "35.25",
    date: DateTime(2022, 10, 2),
    category: "Transportation",
    image: "gasoline.jpg",
  ),
  TransactionModel(
    title: "Restaurant",
    description: "Dinner with friends",
    amount: "75.50",
    date: DateTime(2022, 10, 3),
    category: "Dining",
    image: "restaurant.jpg",
  ),
  TransactionModel(
    title: "Electronics",
    description: "Bought a new phone",
    amount: "599.99",
    date: DateTime(2022, 10, 4),
    category: "Shopping",
    image: "phone.jpg",
  ),
  TransactionModel(
    title: "Clothing",
    description: "Shopping for new clothes",
    amount: "129.95",
    date: DateTime(2022, 10, 5),
    category: "Shopping",
    image: "clothing.jpg",
  ),
  TransactionModel(
    title: "Utilities",
    description: "Monthly utility bill",
    amount: "150.00",
    date: DateTime(2022, 10, 6),
    category: "Bills",
    image: "utilities.jpg",
  ),
  TransactionModel(
    title: "Health",
    description: "Gym membership renewal",
    amount: "50.00",
    date: DateTime(2022, 10, 7),
    category: "Health",
    image: "gym.jpg",
  ),
  TransactionModel(
    title: "Travel",
    description: "Plane ticket booking",
    amount: "350.00",
    date: DateTime(2022, 10, 8),
    category: "Travel",
    image: "travel.jpg",
  ),
  TransactionModel(
    title: "Entertainment",
    description: "Movie night with friends",
    amount: "25.00",
    date: DateTime(2022, 10, 9),
    category: "Entertainment",
    image: "entertainment.jpg",
  ),
  TransactionModel(
    title: "Education",
    description: "Online course subscription",
    amount: "89.99",
    date: DateTime(2022, 10, 10),
    category: "Education",
    image: "education.jpg",
  ),
  TransactionModel(
    title: "Groceries",
    description: "Weekly grocery shopping",
    amount: "45.99",
    date: DateTime(2022, 10, 11),
    category: "Food",
    image: "groceries.jpg",
  ),
  TransactionModel(
    title: "Gasoline",
    description: "Filled up the car",
    amount: "35.25",
    date: DateTime(2022, 10, 12),
    category: "Transportation",
    image: "gasoline.jpg",
  ),
  TransactionModel(
    title: "Restaurant",
    description: "Dinner with friends",
    amount: "75.50",
    date: DateTime(2022, 10, 13),
    category: "Dining",
    image: "restaurant.jpg",
  ),
];
