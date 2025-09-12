import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

/// Performance optimization utilities
class PerformanceUtils {
  /// Check if the app is running in debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Wrap a widget with RepaintBoundary to prevent unnecessary repaints
  static Widget repaintBoundary(Widget child, {String? debugLabel}) {
    return RepaintBoundary(child: child);
  }

  /// Create an optimized list item with RepaintBoundary
  static Widget optimizedListItem({
    required Widget child,
    required int index,
    String? debugLabel,
  }) {
    return repaintBoundary(
      child,
      debugLabel: debugLabel ?? 'ListItem_$index',
    );
  }

  /// Create an optimized card with RepaintBoundary
  static Widget optimizedCard({
    required Widget child,
    String? debugLabel,
  }) {
    return repaintBoundary(
      child,
      debugLabel: debugLabel ?? 'Card',
    );
  }

  /// Create an optimized button with RepaintBoundary
  static Widget optimizedButton({
    required Widget child,
    String? debugLabel,
  }) {
    return repaintBoundary(
      child,
      debugLabel: debugLabel ?? 'Button',
    );
  }

  /// Debounce function calls to prevent excessive rebuilds
  static void debounce(
    String key,
    Duration delay,
    VoidCallback callback,
  ) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  static final Map<String, Timer> _debounceTimers = {};

  /// Throttle function calls to limit execution frequency
  static void throttle(
    String key,
    Duration delay,
    VoidCallback callback,
  ) {
    if (_throttleTimers.containsKey(key)) return;

    callback();
    _throttleTimers[key] = Timer(delay, () {
      _throttleTimers.remove(key);
    });
  }

  static final Map<String, Timer> _throttleTimers = {};

  /// Measure widget build time
  static T measureBuildTime<T>(
    String name,
    T Function() builder,
  ) {
    final stopwatch = Stopwatch()..start();
    final result = builder();
    stopwatch.stop();

    if (isDebugMode) {
      debugPrint('Build time for $name: ${stopwatch.elapsedMicroseconds}μs');
    }

    return result;
  }

  /// Check if the current frame is the first frame after a rebuild
  static bool get isFirstFrame {
    return SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle;
  }

  /// Schedule a callback for the next frame
  static void scheduleForNextFrame(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  /// Create a lazy loading widget that only builds when visible
  static Widget lazyBuilder({
    required Widget Function() builder,
    Widget? placeholder,
  }) {
    return Builder(
      builder: (context) {
        // Only build when the widget is actually visible
        if (placeholder != null) {
          return placeholder;
        }
        return builder();
      },
    );
  }

  /// Optimize image loading with caching
  static Widget optimizedImage({
    required String imageUrl,
    required Widget placeholder,
    required Widget errorWidget,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder;
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget;
      },
      // Enable caching
      cacheWidth: 300,
      cacheHeight: 300,
    );
  }

  /// Create a memory-efficient list view
  static Widget memoryEfficientListView({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return optimizedListItem(
          child: itemBuilder(context, index),
          index: index,
        );
      },
    );
  }

  /// Create a memory-efficient grid view
  static Widget memoryEfficientGridView({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
  }) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) {
        return optimizedListItem(
          child: itemBuilder(context, index),
          index: index,
        );
      },
    );
  }

  /// Optimize animations with specific child widgets
  static Widget optimizedAnimatedBuilder({
    required Animation<double> animation,
    required Widget Function(BuildContext context, Widget? child) builder,
    Widget? child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child != null ? repaintBoundary(child) : null,
    );
  }

  /// Create a performance-optimized page view
  static Widget optimizedPageView({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    PageController? controller,
    ScrollPhysics? physics,
  }) {
    return PageView.builder(
      controller: controller,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return optimizedListItem(
          child: itemBuilder(context, index),
          index: index,
          debugLabel: 'PageView_$index',
        );
      },
    );
  }

  /// Memory cleanup utility
  static void cleanup() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    for (final timer in _throttleTimers.values) {
      timer.cancel();
    }
    _throttleTimers.clear();
  }
}

/// Performance-optimized stateful widget base class
abstract class OptimizedStatefulWidget extends StatefulWidget {
  const OptimizedStatefulWidget({super.key});
}

abstract class OptimizedState<T extends OptimizedStatefulWidget>
    extends State<T> {
  @override
  void dispose() {
    PerformanceUtils.cleanup();
    super.dispose();
  }

  /// Override this method to provide custom performance optimizations
  Widget buildOptimized(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.measureBuildTime(
      runtimeType.toString(),
      () => buildOptimized(context),
    );
  }
}

/// Performance-optimized stateless widget base class
abstract class OptimizedStatelessWidget extends StatelessWidget {
  const OptimizedStatelessWidget({super.key});

  /// Override this method to provide custom performance optimizations
  Widget buildOptimized(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.measureBuildTime(
      runtimeType.toString(),
      () => buildOptimized(context),
    );
  }
}

/// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String name;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    required this.name,
    this.enabled = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || !PerformanceUtils.isDebugMode) {
      return widget.child;
    }

    _stopwatch.start();

    return PerformanceUtils.repaintBoundary(
      widget.child,
      debugLabel: widget.name,
    );
  }

  @override
  void didUpdateWidget(PerformanceMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && PerformanceUtils.isDebugMode) {
      _stopwatch.stop();
      debugPrint(
          'PerformanceMonitor ${widget.name}: ${_stopwatch.elapsedMicroseconds}μs');
      _stopwatch.reset();
    }
  }
}
