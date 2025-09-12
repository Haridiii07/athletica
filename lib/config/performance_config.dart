import 'package:flutter/foundation.dart';

/// Performance configuration for the app
class PerformanceConfig {
  // Enable/disable performance monitoring
  static const bool enablePerformanceMonitoring = kDebugMode;

  // Enable/disable RepaintBoundary widgets
  static const bool enableRepaintBoundaries = true;

  // Enable/disable build time measurement
  static const bool enableBuildTimeMeasurement = kDebugMode;

  // Enable/disable memory usage tracking
  static const bool enableMemoryTracking = kDebugMode;

  // List view optimization settings
  static const int listViewCacheExtent = 250;
  static const int listViewItemExtent = 80;

  // Image optimization settings
  static const int imageCacheWidth = 300;
  static const int imageCacheHeight = 300;
  static const int imageMaxCacheSize = 100; // MB

  // Animation optimization settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration throttleDelay = Duration(milliseconds: 100);

  // Memory management settings
  static const int maxCacheSize = 50; // MB
  static const Duration cacheExpiration = Duration(hours: 24);

  // Network optimization settings
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // UI optimization settings
  static const bool enableConstConstructors = true;
  static const bool enableLazyLoading = true;
  static const bool enableKeepAlive = true;

  /// Get performance settings as a map
  static Map<String, dynamic> get settings => {
        'enablePerformanceMonitoring': enablePerformanceMonitoring,
        'enableRepaintBoundaries': enableRepaintBoundaries,
        'enableBuildTimeMeasurement': enableBuildTimeMeasurement,
        'enableMemoryTracking': enableMemoryTracking,
        'listViewCacheExtent': listViewCacheExtent,
        'listViewItemExtent': listViewItemExtent,
        'imageCacheWidth': imageCacheWidth,
        'imageCacheHeight': imageCacheHeight,
        'imageMaxCacheSize': imageMaxCacheSize,
        'animationDuration': animationDuration.inMilliseconds,
        'debounceDelay': debounceDelay.inMilliseconds,
        'throttleDelay': throttleDelay.inMilliseconds,
        'maxCacheSize': maxCacheSize,
        'cacheExpiration': cacheExpiration.inHours,
        'networkTimeout': networkTimeout.inSeconds,
        'maxRetryAttempts': maxRetryAttempts,
        'enableConstConstructors': enableConstConstructors,
        'enableLazyLoading': enableLazyLoading,
        'enableKeepAlive': enableKeepAlive,
      };

  /// Print performance configuration
  static void printConfig() {
    if (kDebugMode) {
      debugPrint('Performance Configuration:');
      settings.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }
  }
}
