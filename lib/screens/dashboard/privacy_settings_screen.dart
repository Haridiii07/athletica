import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _dataCollection = true;
  bool _analyticsTracking = true;
  bool _crashReporting = true;
  bool _personalizedAds = false;
  bool _dataSharing = false;
  bool _locationTracking = false;
  bool _cameraAccess = true;
  bool _microphoneAccess = false;
  bool _contactsAccess = false;
  bool _calendarAccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Privacy Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Collection
            _buildSettingsSection(
              'Data Collection',
              [
                _buildSwitchItem(
                  'Data Collection',
                  'Allow collection of usage data to improve the app',
                  Icons.data_usage,
                  AppTheme.primaryBlue,
                  _dataCollection,
                  (value) => setState(() => _dataCollection = value),
                ),
                _buildSwitchItem(
                  'Analytics Tracking',
                  'Help us understand how you use the app',
                  Icons.analytics,
                  AppTheme.successGreen,
                  _analyticsTracking,
                  (value) => setState(() => _analyticsTracking = value),
                ),
                _buildSwitchItem(
                  'Crash Reporting',
                  'Automatically report crashes to help fix bugs',
                  Icons.bug_report,
                  AppTheme.warningOrange,
                  _crashReporting,
                  (value) => setState(() => _crashReporting = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Advertising & Marketing
            _buildSettingsSection(
              'Advertising & Marketing',
              [
                _buildSwitchItem(
                  'Personalized Ads',
                  'Show ads based on your interests',
                  Icons.ad_units,
                  AppTheme.textGrey,
                  _personalizedAds,
                  (value) => setState(() => _personalizedAds = value),
                ),
                _buildSwitchItem(
                  'Data Sharing',
                  'Share anonymized data with partners',
                  Icons.share,
                  AppTheme.textGrey,
                  _dataSharing,
                  (value) => setState(() => _dataSharing = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Location & Tracking
            _buildSettingsSection(
              'Location & Tracking',
              [
                _buildSwitchItem(
                  'Location Tracking',
                  'Allow the app to access your location',
                  Icons.location_on,
                  AppTheme.warningOrange,
                  _locationTracking,
                  (value) => setState(() => _locationTracking = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Device Permissions
            _buildSettingsSection(
              'Device Permissions',
              [
                _buildSwitchItem(
                  'Camera Access',
                  'Allow the app to access your camera',
                  Icons.camera_alt,
                  AppTheme.primaryBlue,
                  _cameraAccess,
                  (value) => setState(() => _cameraAccess = value),
                ),
                _buildSwitchItem(
                  'Microphone Access',
                  'Allow the app to access your microphone',
                  Icons.mic,
                  AppTheme.successGreen,
                  _microphoneAccess,
                  (value) => setState(() => _microphoneAccess = value),
                ),
                _buildSwitchItem(
                  'Contacts Access',
                  'Allow the app to access your contacts',
                  Icons.contacts,
                  AppTheme.warningOrange,
                  _contactsAccess,
                  (value) => setState(() => _contactsAccess = value),
                ),
                _buildSwitchItem(
                  'Calendar Access',
                  'Allow the app to access your calendar',
                  Icons.calendar_today,
                  AppTheme.primaryBlue,
                  _calendarAccess,
                  (value) => setState(() => _calendarAccess = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Data Management
            _buildDataManagement(),
            const SizedBox(height: 24),

            // Privacy Policy
            _buildPrivacyPolicy(),
            const SizedBox(height: 32),

            // Delete Account Button
            _buildDeleteAccountButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Management',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              _buildDataAction(
                'Download My Data',
                'Get a copy of all your data',
                Icons.download,
                AppTheme.primaryBlue,
                _downloadData,
              ),
              _buildDataAction(
                'Clear Cache',
                'Remove temporary files and data',
                Icons.clear_all,
                AppTheme.warningOrange,
                _clearCache,
              ),
              _buildDataAction(
                'Reset Privacy Settings',
                'Reset all privacy settings to defaults',
                Icons.restore,
                AppTheme.textGrey,
                _resetPrivacySettings,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataAction(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.privacy_tip, color: AppTheme.primaryBlue),
              const SizedBox(width: 12),
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'We take your privacy seriously. Read our privacy policy to understand how we collect, use, and protect your data.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _viewPrivacyPolicy,
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Privacy Policy'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: const BorderSide(color: AppTheme.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showDeleteAccountDialog,
        icon: const Icon(Icons.delete_forever),
        label: const Text('Delete Account'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _downloadData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Download Data',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'We will prepare your data and send it to your email within 24 hours.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _resetPrivacySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Reset Privacy Settings',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to reset all privacy settings to their default values?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _dataCollection = true;
                _analyticsTracking = true;
                _crashReporting = true;
                _personalizedAds = false;
                _dataSharing = false;
                _locationTracking = false;
                _cameraAccess = true;
                _microphoneAccess = false;
                _contactsAccess = false;
                _calendarAccess = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings reset to defaults'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _viewPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy content will be displayed here. This is a placeholder for the actual privacy policy.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Delete Account',
          style: TextStyle(color: AppTheme.errorRed),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
