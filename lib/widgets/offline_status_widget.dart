import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';

/// Widget for displaying offline status and sync information
class OfflineStatusWidget extends StatelessWidget {
  const OfflineStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Simplified version - always show online status for now
    return const SizedBox.shrink();
  }
}

/// Offline banner for specific screens
class OfflineBanner extends StatelessWidget {
  final Widget child;
  final bool showBanner;

  const OfflineBanner({
    super.key,
    required this.child,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    // Simplified version - always show child for now
    return child;
  }
}

/// Sync status indicator for app bar
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Simplified version - always show online status for now
    return const Icon(
      Icons.wifi,
      color: AppTheme.successGreen,
      size: 20,
    );
  }
}

/// Offline data info dialog
class OfflineDataInfoDialog extends StatelessWidget {
  const OfflineDataInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardBackground,
      title: const Text(
        'Offline Data',
        style: TextStyle(color: AppTheme.textPrimary),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offline functionality is currently disabled.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }
}
