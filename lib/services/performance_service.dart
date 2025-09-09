import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athletica/services/deferred_loading_service.dart';

/// Service for managing performance optimizations and perceived performance
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  static const int _maxCacheSize = 100; // Maximum number of images to cache
  static const Duration _preloadDelay = Duration(milliseconds: 500);
  
  final Set<String> _precachedAssets = <String>{};
  final Set<String> _preloadedLibraries = <String>{};

  /// Pre-cache critical assets for better perceived performance
  static Future<void> precacheCriticalAssets() async {
    try {
      final criticalAssets = [
        // App branding
        'assets/images/logo.png',
        'assets/images/icon.png',
        'assets/images/favicon.png',
        
        // UI placeholders
        'assets/images/placeholder-avatar.png',
        'assets/images/placeholder-workout.png',
        'assets/images/placeholder-plan.png',
        
        // Background images
        'assets/images/background-gradient.png',
        'assets/images/background-pattern.png',
        
        // Social media icons
        'assets/images/google-icon.png',
        'assets/images/facebook-icon.png',
        'assets/images/apple-icon.png',
        
        // Common UI elements
        'assets/images/checkmark.png',
        'assets/images/error-icon.png',
        'assets/images/success-icon.png',
      ];

      for (final asset in criticalAssets) {
        await _precacheAsset(asset);
      }

      print('✅ Critical assets pre-cached successfully');
    } catch (e) {
      print('⚠️ Asset pre-caching failed: $e');
    }
  }

  /// Pre-cache a single asset
  static Future<void> _precacheAsset(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      PerformanceService()._precachedAssets.add(assetPath);
      print('✅ Pre-cached: $assetPath');
    } catch (e) {
      print('⚠️ Could not pre-cache $assetPath: $e');
    }
  }

  /// Preload common deferred screens
  static void preloadCommonScreens() {
    final commonScreens = [
      'create_plan',
      'chat',
      'subscription',
    ];

    for (final screen in commonScreens) {
      DeferredLoadingService.preloadLibrary(screen);
      PerformanceService()._preloadedLibraries.add(screen);
    }

    print('✅ Common screens preloaded in background');
  }

  /// Preload all deferred screens
  static void preloadAllScreens() {
    final allScreens = [
      'create_plan',
      'chat',
      'subscription',
      'identity_verification',
      'edit_profile',
      'add_client',
    ];

    for (final screen in allScreens) {
      DeferredLoadingService.preloadLibrary(screen);
      PerformanceService()._preloadedLibraries.add(screen);
    }

    print('✅ All screens preloaded in background');
  }

  /// Optimize image cache
  static void optimizeImageCache() {
    final imageCache = PaintingBinding.instance.imageCache;
    
    // Set cache limits
    imageCache.maximumSize = _maxCacheSize;
    imageCache.maximumSizeBytes = 50 << 20; // 50MB
    
    print('✅ Image cache optimized');
  }

  /// Clear unused assets from cache
  static void clearUnusedAssets() {
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    
    print('✅ Unused assets cleared from cache');
  }

  /// Get performance statistics
  static Map<String, dynamic> getPerformanceStats() {
    final imageCache = PaintingBinding.instance.imageCache;
    
    return {
      'precached_assets': PerformanceService()._precachedAssets.length,
      'preloaded_libraries': PerformanceService()._preloadedLibraries.length,
      'image_cache_size': imageCache.currentSize,
      'image_cache_bytes': imageCache.currentSizeBytes,
      'max_cache_size': imageCache.maximumSize,
      'max_cache_bytes': imageCache.maximumSizeBytes,
    };
  }

  /// Monitor performance and log statistics
  static void logPerformanceStats() {
    final stats = getPerformanceStats();
    print('📊 Performance Statistics:');
    print('  Pre-cached assets: ${stats['precached_assets']}');
    print('  Pre-loaded libraries: ${stats['preloaded_libraries']}');
    print('  Image cache size: ${stats['image_cache_size']}/${stats['max_cache_size']}');
    print('  Image cache bytes: ${(stats['image_cache_bytes'] as int) ~/ 1024}KB/${(stats['max_cache_bytes'] as int) ~/ 1024}KB');
  }

  /// Initialize performance optimizations
  static Future<void> initialize() async {
    print('🚀 Initializing performance optimizations...');
    
    // Optimize image cache
    optimizeImageCache();
    
    // Pre-cache critical assets
    await precacheCriticalAssets();
    
    // Preload common screens
    preloadCommonScreens();
    
    // Log performance stats
    logPerformanceStats();
    
    print('✅ Performance optimizations initialized');
  }

  /// Check if asset is pre-cached
  static bool isAssetPrecached(String assetPath) {
    return PerformanceService()._precachedAssets.contains(assetPath);
  }

  /// Check if library is pre-loaded
  static bool isLibraryPreloaded(String libraryName) {
    return PerformanceService()._preloadedLibraries.contains(libraryName);
  }

  /// Get pre-cached assets list
  static Set<String> getPrecachedAssets() {
    return Set.from(PerformanceService()._precachedAssets);
  }

  /// Get pre-loaded libraries list
  static Set<String> getPreloadedLibraries() {
    return Set.from(PerformanceService()._preloadedLibraries);
  }
}

/// Mixin for widgets that need performance optimizations
mixin PerformanceOptimizedMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _optimizePerformance();
  }

  void _optimizePerformance() {
    // Pre-cache images used in this widget
    _precacheWidgetAssets();
    
    // Preload related deferred screens
    _preloadRelatedScreens();
  }

  void _precacheWidgetAssets() {
    // Override in subclasses to pre-cache specific assets
  }

  void _preloadRelatedScreens() {
    // Override in subclasses to preload related screens
  }
}

/// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    // Monitor performance every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && widget.enabled) {
        PerformanceService.logPerformanceStats();
        _startMonitoring();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
