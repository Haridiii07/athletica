import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _newClientNotifications = true;
  bool _clientProgressNotifications = true;
  bool _paymentNotifications = true;
  bool _planUpdatesNotifications = true;
  bool _marketingNotifications = false;
  bool _weeklyReports = true;
  bool _monthlyReports = true;

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
          'Notification Settings',
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
            // Notification Channels
            _buildSettingsSection(
              'Notification Channels',
              [
                _buildSwitchItem(
                  'Push Notifications',
                  'Receive notifications on your device',
                  Icons.notifications_active,
                  AppTheme.primaryBlue,
                  _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
                ),
                _buildSwitchItem(
                  'Email Notifications',
                  'Receive notifications via email',
                  Icons.email,
                  AppTheme.successGreen,
                  _emailNotifications,
                  (value) => setState(() => _emailNotifications = value),
                ),
                _buildSwitchItem(
                  'SMS Notifications',
                  'Receive notifications via SMS',
                  Icons.sms,
                  AppTheme.warningOrange,
                  _smsNotifications,
                  (value) => setState(() => _smsNotifications = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Client Notifications
            _buildSettingsSection(
              'Client Notifications',
              [
                _buildSwitchItem(
                  'New Client Registration',
                  'Get notified when new clients join',
                  Icons.person_add,
                  AppTheme.successGreen,
                  _newClientNotifications,
                  (value) => setState(() => _newClientNotifications = value),
                ),
                _buildSwitchItem(
                  'Client Progress Updates',
                  'Get notified about client progress milestones',
                  Icons.trending_up,
                  AppTheme.primaryBlue,
                  _clientProgressNotifications,
                  (value) =>
                      setState(() => _clientProgressNotifications = value),
                ),
                _buildSwitchItem(
                  'Payment Notifications',
                  'Get notified about payments and billing',
                  Icons.payment,
                  AppTheme.successGreen,
                  _paymentNotifications,
                  (value) => setState(() => _paymentNotifications = value),
                ),
                _buildSwitchItem(
                  'Plan Updates',
                  'Get notified about plan changes and updates',
                  Icons.fitness_center,
                  AppTheme.warningOrange,
                  _planUpdatesNotifications,
                  (value) => setState(() => _planUpdatesNotifications = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Marketing & Reports
            _buildSettingsSection(
              'Marketing & Reports',
              [
                _buildSwitchItem(
                  'Marketing Notifications',
                  'Receive promotional offers and updates',
                  Icons.campaign,
                  AppTheme.textGrey,
                  _marketingNotifications,
                  (value) => setState(() => _marketingNotifications = value),
                ),
                _buildSwitchItem(
                  'Weekly Reports',
                  'Receive weekly performance reports',
                  Icons.assessment,
                  AppTheme.primaryBlue,
                  _weeklyReports,
                  (value) => setState(() => _weeklyReports = value),
                ),
                _buildSwitchItem(
                  'Monthly Reports',
                  'Receive monthly analytics reports',
                  Icons.bar_chart,
                  AppTheme.successGreen,
                  _monthlyReports,
                  (value) => setState(() => _monthlyReports = value),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notification Frequency
            _buildNotificationFrequency(),
            const SizedBox(height: 24),

            // Quiet Hours
            _buildQuietHours(),
            const SizedBox(height: 32),

            // Reset Button
            _buildResetButton(),
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
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationFrequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Frequency',
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
              _buildFrequencyOption(
                  'Immediate', 'Get notifications instantly', true),
              _buildFrequencyOption(
                  'Hourly Digest', 'Get notifications once per hour', false),
              _buildFrequencyOption(
                  'Daily Digest', 'Get notifications once per day', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyOption(String title, String subtitle, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Handle frequency selection
        },
        child: Row(
          children: [
            Radio<bool>(
              value: isSelected,
              groupValue: true,
              onChanged: (value) {
                // Handle selection
              },
              activeColor: AppTheme.primaryBlue,
            ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuietHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiet Hours',
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
              Row(
                children: [
                  const Icon(Icons.bedtime, color: AppTheme.warningOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Quiet Hours',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          'No notifications between 10 PM - 8 AM',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle quiet hours toggle
                    },
                    activeColor: AppTheme.primaryBlue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Time',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '10:00 PM',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Time',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '8:00 AM',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _resetToDefaults,
        icon: const Icon(Icons.restore),
        label: const Text('Reset to Defaults'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textSecondary,
          side: const BorderSide(color: AppTheme.borderColor),
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
        content: Text('Notification settings saved successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Reset to Defaults',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to reset all notification settings to their default values?',
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
                _pushNotifications = true;
                _emailNotifications = true;
                _smsNotifications = false;
                _newClientNotifications = true;
                _clientProgressNotifications = true;
                _paymentNotifications = true;
                _planUpdatesNotifications = true;
                _marketingNotifications = false;
                _weeklyReports = true;
                _monthlyReports = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
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
}
