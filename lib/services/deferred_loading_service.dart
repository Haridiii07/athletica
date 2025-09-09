import 'package:flutter/material.dart';

/// Service for managing deferred loading of heavy features
class DeferredLoadingService {
  static final Map<String, bool> _loadedLibraries = {};
  static final Map<String, Future<void>> _loadingFutures = {};

  /// Load a deferred library
  static Future<void> loadLibrary(String libraryName) async {
    if (_loadedLibraries[libraryName] == true) {
      return; // Already loaded
    }

    if (_loadingFutures[libraryName] != null) {
      return _loadingFutures[libraryName]!; // Already loading
    }

    _loadingFutures[libraryName] = _performLoad(libraryName);
    await _loadingFutures[libraryName];
    _loadedLibraries[libraryName] = true;
  }

  /// Check if a library is loaded
  static bool isLoaded(String libraryName) {
    return _loadedLibraries[libraryName] == true;
  }

  /// Get loading progress for a library
  static double getLoadingProgress(String libraryName) {
    if (isLoaded(libraryName)) return 1.0;
    if (_loadingFutures[libraryName] != null) return 0.5; // Loading
    return 0.0; // Not started
  }

  /// Preload a library in the background
  static void preloadLibrary(String libraryName) {
    if (!isLoaded(libraryName) && _loadingFutures[libraryName] == null) {
      loadLibrary(libraryName);
    }
  }

  /// Preload multiple libraries
  static void preloadLibraries(List<String> libraryNames) {
    for (final libraryName in libraryNames) {
      preloadLibrary(libraryName);
    }
  }

  /// Clear loaded libraries (for testing)
  static void clearCache() {
    _loadedLibraries.clear();
    _loadingFutures.clear();
  }

  static Future<void> _performLoad(String libraryName) async {
    // Simulate loading time for better UX
    await Future.delayed(const Duration(milliseconds: 100));
    
    // In a real implementation, this would load the actual library
    // For now, we'll just simulate the loading
    switch (libraryName) {
      case 'create_plan':
        // Load create plan screen
        break;
      case 'chat':
        // Load chat screen
        break;
      case 'identity_verification':
        // Load identity verification screen
        break;
      case 'edit_profile':
        // Load edit profile screen
        break;
      case 'add_client':
        // Load add client screen
        break;
      case 'subscription':
        // Load subscription screen
        break;
      default:
        throw Exception('Unknown library: $libraryName');
    }
  }
}

/// Widget for showing loading state while deferred features load
class DeferredLoadingWidget extends StatefulWidget {
  final String libraryName;
  final Widget Function() builder;
  final Widget? loadingWidget;
  final Duration? loadingDelay;

  const DeferredLoadingWidget({
    super.key,
    required this.libraryName,
    required this.builder,
    this.loadingWidget,
    this.loadingDelay,
  });

  @override
  State<DeferredLoadingWidget> createState() => _DeferredLoadingWidgetState();
}

class _DeferredLoadingWidgetState extends State<DeferredLoadingWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    try {
      if (widget.loadingDelay != null) {
        await Future.delayed(widget.loadingDelay!);
      }
      
      await DeferredLoadingService.loadLibrary(widget.libraryName);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_isLoading) {
      return widget.loadingWidget ?? _buildDefaultLoadingWidget();
    }

    return widget.builder();
  }

  Widget _buildDefaultLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load feature',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _errorMessage = null;
              });
              _loadLibrary();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Mixin for screens that use deferred loading
mixin DeferredLoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isDeferredLoading = false;
  String? _deferredLibraryName;

  void setDeferredLoading(String libraryName) {
    _deferredLibraryName = libraryName;
    _isDeferredLoading = true;
  }

  bool get isDeferredLoading => _isDeferredLoading;

  Future<void> loadDeferredFeature() async {
    if (_deferredLibraryName != null) {
      await DeferredLoadingService.loadLibrary(_deferredLibraryName!);
      if (mounted) {
        setState(() {
          _isDeferredLoading = false;
        });
      }
    }
  }

  Widget buildDeferredContent(Widget Function() builder) {
    if (_isDeferredLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading feature...'),
          ],
        ),
      );
    }
    return builder();
  }
}
