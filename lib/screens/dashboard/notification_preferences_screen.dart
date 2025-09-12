import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';

/// Screen for managing notification preferences
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _newMessages = true;
  bool _clientProgressUpdates = true;
  bool _planReminders = true;
  bool _achievementNotifications = true;
  bool _systemUpdates = false;
  bool _marketingEmails = false;

  String _reminderTime = '09:00';
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _quietHoursEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    // Placeholder - settings will be loaded from server/local storage
    setState(() {
      // Load current settings
    });
  }

  Future<void> _saveNotificationSettings() async {
    // Placeholder - settings will be saved to server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification preferences saved'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          'Notification Preferences',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveNotificationSettings,
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationChannelsSection(),
          const SizedBox(height: 24),
          _buildNotificationTypesSection(),
          const SizedBox(height: 24),
          _buildTimingSection(),
          const SizedBox(height: 24),
          _buildQuietHoursSection(),
          const SizedBox(height: 24),
          _buildNotificationSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildNotificationChannelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Channels',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildToggleItem(
          'Push Notifications',
          'Receive push notifications on your device',
          _pushNotifications,
          (value) => setState(() => _pushNotifications = value),
          Icons.notifications,
        ),
        _buildToggleItem(
          'Email Notifications',
          'Receive notifications via email',
          _emailNotifications,
          (value) => setState(() => _emailNotifications = value),
          Icons.email,
        ),
        _buildToggleItem(
          'SMS Notifications',
          'Receive notifications via SMS',
          _smsNotifications,
          (value) => setState(() => _smsNotifications = value),
          Icons.sms,
        ),
      ],
    );
  }

  Widget _buildNotificationTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Types',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildToggleItem(
          'New Messages',
          'Get notified when you receive new messages',
          _newMessages,
          (value) => setState(() => _newMessages = value),
          Icons.message,
        ),
        _buildToggleItem(
          'Client Progress Updates',
          'Get notified when clients update their progress',
          _clientProgressUpdates,
          (value) => setState(() => _clientProgressUpdates = value),
          Icons.trending_up,
        ),
        _buildToggleItem(
          'Plan Reminders',
          'Get reminded about upcoming workout plans',
          _planReminders,
          (value) => setState(() => _planReminders = value),
          Icons.schedule,
        ),
        _buildToggleItem(
          'Achievement Notifications',
          'Get notified about achievements and milestones',
          _achievementNotifications,
          (value) => setState(() => _achievementNotifications = value),
          Icons.emoji_events,
        ),
        _buildToggleItem(
          'System Updates',
          'Get notified about app updates and maintenance',
          _systemUpdates,
          (value) => setState(() => _systemUpdates = value),
          Icons.system_update,
        ),
        _buildToggleItem(
          'Marketing Emails',
          'Receive promotional offers and new feature announcements',
          _marketingEmails,
          (value) => setState(() => _marketingEmails = value),
          Icons.campaign,
        ),
      ],
    );
  }

  Widget _buildTimingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timing',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.schedule, color: AppTheme.primaryBlue),
                title: const Text(
                  'Daily Reminder Time',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: Text(
                  'Receive daily reminders at $_reminderTime',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: Text(
                  _reminderTime,
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: _selectReminderTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuietHoursSection() {
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text(
                  'Enable Quiet Hours',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: Text(
                  'No notifications between $_quietHoursStart and $_quietHoursEnd',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                value: _quietHoursEnabled,
                onChanged: (value) =>
                    setState(() => _quietHoursEnabled = value),
                activeColor: AppTheme.primaryBlue,
              ),
              if (_quietHoursEnabled) ...[
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.bedtime, color: AppTheme.primaryBlue),
                  title: const Text(
                    'Start Time',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  trailing: Text(
                    _quietHoursStart,
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _selectQuietHoursStart(),
                ),
                ListTile(
                  leading: const Icon(Icons.alarm, color: AppTheme.primaryBlue),
                  title: const Text(
                    'End Time',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  trailing: Text(
                    _quietHoursEnd,
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _selectQuietHoursEnd(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_active,
                    color: AppTheme.primaryBlue),
                title: const Text(
                  'Test Notifications',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'Send a test notification to verify settings',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: AppTheme.textGrey),
                onTap: _testNotification,
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.settings, color: AppTheme.primaryBlue),
                title: const Text(
                  'System Notification Settings',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'Open device notification settings',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: AppTheme.textGrey),
                onTap: _openSystemSettings,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.clear_all, color: AppTheme.errorRed),
                title: const Text(
                  'Clear All Notifications',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
                subtitle: const Text(
                  'Remove all notifications from your device',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: AppTheme.textGrey),
                onTap: _clearAllNotifications,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
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

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse('2024-01-01 $_reminderTime:00'),
      ),
    );
    if (picked != null) {
      setState(() {
        _reminderTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectQuietHoursStart() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse('2024-01-01 $_quietHoursStart:00'),
      ),
    );
    if (picked != null) {
      setState(() {
        _quietHoursStart =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectQuietHoursEnd() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse('2024-01-01 $_quietHoursEnd:00'),
      ),
    );
    if (picked != null) {
      setState(() {
        _quietHoursEnd =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _testNotification() async {
    // Placeholder for test notification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  Future<void> _openSystemSettings() async {
    // Placeholder for opening system settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening system settings...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  Future<void> _clearAllNotifications() async {
    // Placeholder for clearing notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications cleared'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
