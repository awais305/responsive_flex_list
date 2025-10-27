import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:responsive_flex_list/src/core/core.dart';

/// Non-lazy Pinterest-style masonry grid widget that pre-builds all items for optimal performance.
///
/// Unlike lazy loading approaches, this widget builds and caches all children upfront,
/// making it ideal for lists where all items need to be rendered immediately or when
/// smooth scrolling with complex animations is required. Intelligently handles updates
/// by appending only new items when possible, avoiding full rebuilds.
class NotLazyPinterestListWidget<T> extends StatefulWidget {
  /// List of data items to display in the masonry grid.
  final List<T> items;

  /// Builder function that creates a widget for each item.
  final ItemBuilder<T> itemBuilder;

  /// Number of columns in the masonry grid.
  final int crossAxisCount;

  /// Vertical spacing between items in the same column.
  final double mainAxisSpacing;

  /// Horizontal spacing between columns.
  final double crossAxisSpacing;

  /// Whether to calculate intrinsic heights for items (unused in current implementation).
  final bool useIntrinsicHeight;

  /// Text direction for layout (LTR or RTL).
  final TextDirection textDirection;

  /// Function to wrap items with animation widgets.
  final Widget Function({required int animationIndex, required Widget child})
      buildAnimatedItem;

  /// Function to calculate animation index for staggered animations.
  final int Function({
    required int itemIndex,
    required int rowIndex,
    required int columnIndex,
  }) calculateAnimationIndex;

  /// Callback fired with progress updates as images load.
  /// Receives (loadedCount, totalCount).
  /// When loaded == total, all images are fully loaded and rendered.
  final void Function(int loaded, int total)? onLoadingProgress;

  const NotLazyPinterestListWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.useIntrinsicHeight,
    required this.textDirection,
    required this.buildAnimatedItem,
    required this.calculateAnimationIndex,
    this.onLoadingProgress,
  });

  @override
  State<NotLazyPinterestListWidget<T>> createState() =>
      _NotLazyPinterestListWidgetState<T>();
}

class _NotLazyPinterestListWidgetState<T>
    extends State<NotLazyPinterestListWidget<T>> {
  /// Cached list of built widget children to avoid unnecessary rebuilds.
  List<Widget> _cachedChildren = [];

  /// Previous item count to detect changes efficiently
  int _previousItemCount = 0;

  /// Previous crossAxisCount to detect column changes
  int _previousCrossAxisCount = 0;

  /// Track if we've already fired the callback for current items
  bool _hasCalledLoadedCallback = false;

  /// Track loaded images count
  int _loadedImagesCount = 0;
  int _totalImagesCount = 0;
  bool _isTrackingImages = false;

  @override
  void initState() {
    super.initState();
    _previousItemCount = widget.items.length;
    _previousCrossAxisCount = widget.crossAxisCount;
    // Build after first frame to allow initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _buildChildrenList(0, _previousItemCount);
        _startImageTracking();
      }
    });
  }

  /// Starts tracking image loading after layout
  void _startImageTracking() {
    if (widget.onLoadingProgress == null || _hasCalledLoadedCallback) return;

    _isTrackingImages = true;
    _loadedImagesCount = 0;
    _totalImagesCount = 0;

    // Wait for layout to complete first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _countAndTrackImages();
    });
  }

  /// Counts total images and sets up listeners
  void _countAndTrackImages() {
    if (!mounted) return;

    // FIRST: Collect all ImageProviders without tracking yet
    final context = this.context;
    final List<ImageProvider> imagesToTrack = [];

    void visitor(Element element) {
      final widget = element.widget;
      if (widget is Image) {
        imagesToTrack.add(widget.image);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);

    // SECOND: Set total count BEFORE starting to track
    _totalImagesCount = imagesToTrack.length;

    // Call initial progress callback
    widget.onLoadingProgress?.call(0, _totalImagesCount);

    // If no images found, call callback with 0,0 immediately
    if (_totalImagesCount == 0 && !_hasCalledLoadedCallback) {
      _hasCalledLoadedCallback = true;
      // Wait one frame for rendering
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLoadingProgress?.call(0, 0);
        }
      });
      return;
    }

    // THIRD: Now track all images (after total is set)
    // This ensures cached images that fire synchronously increment against correct total
    for (final imageProvider in imagesToTrack) {
      _trackImage(imageProvider);
    }
  }

  /// Tracks individual image loading
  void _trackImage(ImageProvider imageProvider) {
    final ImageStream stream =
        imageProvider.resolve(const ImageConfiguration());

    bool listenerCalled = false;
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        if (!listenerCalled) {
          listenerCalled = true;
          _loadedImagesCount++;
          _notifyProgress();

          // For cached images (synchronousCall=true), remove listener immediately
          // For async images, it's removed automatically in the next frame
          if (!synchronousCall) {
            stream.removeListener(listener);
          }
        }
      },
      onError: (exception, stackTrace) {
        if (!listenerCalled) {
          listenerCalled = true;
          _loadedImagesCount++;
          _notifyProgress();
        }
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);

    // If image was cached, listener fired synchronously above
    // Remove it now to prevent memory leaks
    if (listenerCalled) {
      stream.removeListener(listener);
    }
  }

  /// Notifies progress callback
  void _notifyProgress() {
    if (!mounted || !_isTrackingImages) return;

    // Call progress callback with current state
    widget.onLoadingProgress?.call(_loadedImagesCount, _totalImagesCount);

    // Check if we're done
    if (_loadedImagesCount >= _totalImagesCount && !_hasCalledLoadedCallback) {
      _hasCalledLoadedCallback = true;
      _isTrackingImages = false;
    }
  }

  /// Efficiently appends only newly added items to the cached children list.
  void _appendNewItems(int startIndex, int endIndex) {
    final int count = endIndex - startIndex;
    final List<Widget> newWidgets = List.generate(
      count,
      (i) => _buildWidgetForItem(startIndex + i),
    );

    setState(() {
      _cachedChildren.addAll(newWidgets);
      _hasCalledLoadedCallback = false;
    });

    _startImageTracking();
  }

  /// Builds children list from startIndex to endIndex
  void _buildChildrenList(int startIndex, int endIndex) {
    final int count = endIndex - startIndex;
    final List<Widget> newChildren = List.generate(
      count,
      (i) => _buildWidgetForItem(startIndex + i),
    );

    setState(() {
      _cachedChildren = newChildren;
      _hasCalledLoadedCallback = false;
    });
  }

  @override
  void didUpdateWidget(NotLazyPinterestListWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final int newLength = widget.items.length;
    final bool columnCountChanged =
        _previousCrossAxisCount != widget.crossAxisCount;
    final bool itemsChanged = _previousItemCount != newLength;

    // Early return if nothing changed
    if (!columnCountChanged && !itemsChanged) {
      return;
    }

    // Handle column count change - requires full rebuild
    if (columnCountChanged) {
      _cachedChildren = []; // Replace instead of clear
      _buildChildrenList(0, newLength);
      _previousCrossAxisCount = widget.crossAxisCount;
      _previousItemCount = newLength;
      _startImageTracking();
      return;
    }

    // Handle items change
    if (itemsChanged) {
      if (newLength > _previousItemCount) {
        // Items added - append only new ones
        _appendNewItems(_previousItemCount, newLength);
      } else if (newLength < _previousItemCount) {
        // Items removed - rebuild
        _cachedChildren = []; // Replace instead of clear
        _buildChildrenList(0, newLength);
        _startImageTracking();
      }

      _previousItemCount = newLength;
    }
  }

  /// Builds a keyed widget for an item with animation wrapper.
  Widget _buildWidgetForItem(int index) {
    final item = widget.items[index];

    return KeyedSubtree(
      // Unique key combining item and index for proper widget identity
      key: ValueKey('${item}_$index'),
      child: widget.buildAnimatedItem(
        animationIndex: widget.calculateAnimationIndex(
          itemIndex: index,
          rowIndex: 0,
          columnIndex: 0,
        ),
        child: widget.itemBuilder(item, index),
      ),
    );
  }

  @override
  void dispose() {
    // Stop tracking and help garbage collection
    _isTrackingImages = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _PinterestRenderWidget(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        textDirection: widget.textDirection,
        children: _cachedChildren,
      ),
    );
  }
}

/// Internal widget that delegates to custom render object for masonry layout.
///
/// Separates widget layer concerns from rendering logic, allowing efficient
/// updates when layout properties change without rebuilding children.
class _PinterestRenderWidget extends MultiChildRenderObjectWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final TextDirection textDirection;

  const _PinterestRenderWidget({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.textDirection,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return NonLazyMasonryGridRenderBox(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    NonLazyMasonryGridRenderBox renderObject,
  ) {
    renderObject
      ..crossAxisCount = crossAxisCount
      ..mainAxisSpacing = mainAxisSpacing
      ..crossAxisSpacing = crossAxisSpacing
      ..textDirection = textDirection;
  }
}

///////////////////// RENDERER ///////////////////////

/// Custom render box that implements masonry grid layout using shortest-column algorithm.
///
/// Distributes children across columns by always placing the next item in the shortest
/// column, creating a balanced masonry effect. Handles its own layout, painting, and
/// hit testing for optimal performance.
class NonLazyMasonryGridRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _MasonryParentData> {
  NonLazyMasonryGridRenderBox({
    required int crossAxisCount,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
    required TextDirection textDirection,
  })  : _crossAxisCount = crossAxisCount,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _textDirection = textDirection;

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    // Prevent child semantics from bubbling up for better accessibility performance
    config.isSemanticBoundary = true;
  }

  int _crossAxisCount;
  int get crossAxisCount => _crossAxisCount;
  set crossAxisCount(int value) {
    if (_crossAxisCount != value) {
      _crossAxisCount = value;
      _cachedChildWidth = null;
      markNeedsLayout();
    }
  }

  double _mainAxisSpacing;
  double get mainAxisSpacing => _mainAxisSpacing;
  set mainAxisSpacing(double value) {
    if (_mainAxisSpacing != value) {
      _mainAxisSpacing = value;
      markNeedsLayout();
    }
  }

  double _crossAxisSpacing;
  double get crossAxisSpacing => _crossAxisSpacing;
  set crossAxisSpacing(double value) {
    if (_crossAxisSpacing != value) {
      _crossAxisSpacing = value;
      _cachedChildWidth = null;
      markNeedsLayout();
    }
  }

  TextDirection _textDirection;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  // Cache child width to avoid recalculation
  double? _cachedChildWidth;
  double? _cachedMaxWidth;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _MasonryParentData) {
      child.parentData = _MasonryParentData();
    }
  }

  @override
  void performLayout() {
    // Handle empty list case
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    // Cache child width calculation
    final double maxWidth = constraints.maxWidth;
    if (_cachedChildWidth == null || _cachedMaxWidth != maxWidth) {
      _cachedMaxWidth = maxWidth;
      _cachedChildWidth =
          (maxWidth - (_crossAxisCount - 1) * _crossAxisSpacing) /
              _crossAxisCount;
    }
    final double childWidth = _cachedChildWidth!;

    // Track current height of each column to find shortest
    final List<double> columnHeights = List.filled(_crossAxisCount, 0.0);

    // Pre-calculate for RTL
    final bool isLTR = textDirection == TextDirection.ltr;
    final double columnStep = childWidth + _crossAxisSpacing;

    RenderBox? child = firstChild;
    while (child != null) {
      final _MasonryParentData childParentData =
          child.parentData! as _MasonryParentData;

      // Layout child with fixed width, let height be determined by content
      child.layout(
        BoxConstraints.tightFor(width: childWidth),
        parentUsesSize: true,
      );

      // Find shortest column using linear search (fast for small column counts)
      int shortest = 0;
      for (int i = 1; i < _crossAxisCount; i++) {
        if (columnHeights[i] < columnHeights[shortest]) shortest = i;
      }

      // Add vertical spacing only if column already has content
      if (columnHeights[shortest] > 0) {
        columnHeights[shortest] += _mainAxisSpacing;
      }

      // Calculate horizontal position based on text direction
      final double dx = isLTR
          ? shortest * columnStep
          : (_crossAxisCount - 1 - shortest) * columnStep;

      // Position child at top of shortest column
      final newOffset = Offset(dx, columnHeights[shortest]);
      if (childParentData.offset != newOffset) {
        childParentData.offset = newOffset;
      }

      // Update column height with this child's height
      columnHeights[shortest] += child.size.height;
      child = childParentData.nextSibling;
    }

    // Final size is full width and height of tallest column
    size = Size(maxWidth, columnHeights.reduce((a, b) => a > b ? a : b));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Check if we can use the fast path (no offset needed)
    final bool needsCompositing = offset != Offset.zero;

    if (!needsCompositing) {
      // Fast path: paint directly without offset calculations
      RenderBox? child = firstChild;
      while (child != null) {
        final _MasonryParentData childParentData =
            child.parentData! as _MasonryParentData;
        context.paintChild(child, childParentData.offset);
        child = childParentData.nextSibling;
      }
    } else {
      // Standard path: add parent offset
      RenderBox? child = firstChild;
      while (child != null) {
        final _MasonryParentData childParentData =
            child.parentData! as _MasonryParentData;
        context.paintChild(child, childParentData.offset + offset);
        child = childParentData.nextSibling;
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Traverse children in reverse (top-to-bottom in visual stack) for accurate hit testing
    RenderBox? child = lastChild;
    while (child != null) {
      final _MasonryParentData childParentData =
          child.parentData! as _MasonryParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
      child = childParentData.previousSibling;
    }
    return false;
  }
}

/// Parent data for storing child position offsets in the masonry grid.
class _MasonryParentData extends ContainerBoxParentData<RenderBox> {}
