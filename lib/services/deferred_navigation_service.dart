import 'package:flutter/material.dart';
import 'package:athletica/services/deferred_loading_service.dart';

/// Service for handling navigation to deferred screens
class DeferredNavigationService {
  /// Navigate to a deferred screen with loading indicator
  static Future<T?> navigateToDeferred<T extends Object?>(
    BuildContext context,
    String screenName, {
    Object? arguments,
    bool preload = false,
  }) async {
    // Preload the library if requested
    if (preload) {
      DeferredLoadingService.preloadLibrary(screenName);
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeferredLoadingDialog(screenName: screenName),
    );

    try {
      // Load the library
      await DeferredLoadingService.loadLibrary(screenName);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to the actual screen
      return await _navigateToScreen<T>(context, screenName, arguments);
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        _showErrorDialog(context, screenName, e.toString());
      }
      return null;
    }
  }

  /// Navigate to create plan screen
  static Future<T?> navigateToCreatePlan<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'create_plan',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Navigate to chat screen
  static Future<T?> navigateToChat<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'chat',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Navigate to subscription screen
  static Future<T?> navigateToSubscription<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'subscription',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Navigate to identity verification screen
  static Future<T?> navigateToIdentityVerification<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'identity_verification',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Navigate to edit profile screen
  static Future<T?> navigateToEditProfile<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'edit_profile',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Navigate to add client screen
  static Future<T?> navigateToAddClient<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool preload = false,
  }) async {
    return navigateToDeferred<T>(
      context,
      'add_client',
      arguments: arguments,
      preload: preload,
    );
  }

  /// Preload commonly used deferred screens
  static void preloadCommonScreens() {
    DeferredLoadingService.preloadLibraries([
      'create_plan',
      'chat',
      'subscription',
    ]);
  }

  /// Preload all deferred screens
  static void preloadAllScreens() {
    DeferredLoadingService.preloadLibraries([
      'create_plan',
      'chat',
      'subscription',
      'identity_verification',
      'edit_profile',
      'add_client',
    ]);
  }

  static Future<T?> _navigateToScreen<T extends Object?>(
    BuildContext context,
    String screenName,
    Object? arguments,
  ) async {
    switch (screenName) {
      case 'create_plan':
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => const create_plan.CreatePlanScreenDeferred(),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      case 'chat':
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => chat.ChatScreenDeferred(
              client: arguments as dynamic,
            ),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      case 'subscription':
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => const subscription.SubscriptionScreenDeferred(),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      case 'identity_verification':
        // Import and navigate to identity verification screen
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => const identity_verification.IdentityVerificationScreen(),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      case 'edit_profile':
        // Import and navigate to edit profile screen
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => const edit_profile.EditProfileScreen(),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      case 'add_client':
        // Import and navigate to add client screen
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (context) => const add_client.AddClientScreen(),
            settings: RouteSettings(arguments: arguments),
          ),
        );
      default:
        throw Exception('Unknown screen: $screenName');
    }
  }

  static void _showErrorDialog(
    BuildContext context,
    String screenName,
    String error,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Loading Error'),
        content: Text('Failed to load $screenName: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Loading dialog for deferred screens
class _DeferredLoadingDialog extends StatefulWidget {
  final String screenName;

  const _DeferredLoadingDialog({required this.screenName});

  @override
  State<_DeferredLoadingDialog> createState() => _DeferredLoadingDialogState();
}

class _DeferredLoadingDialogState extends State<_DeferredLoadingDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 3,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Loading ${_getScreenDisplayName(widget.screenName)}...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a moment',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScreenDisplayName(String screenName) {
    switch (screenName) {
      case 'create_plan':
        return 'Create Plan';
      case 'chat':
        return 'Chat';
      case 'subscription':
        return 'Subscription';
      case 'identity_verification':
        return 'Identity Verification';
      case 'edit_profile':
        return 'Edit Profile';
      case 'add_client':
        return 'Add Client';
      default:
        return 'Feature';
    }
  }
}
