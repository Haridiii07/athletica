import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athletica/presentation/providers/auth_provider.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/widgets/platform_widgets.dart';
import 'package:athletica/screens/dashboard/notification_settings_screen.dart';
import 'package:athletica/screens/dashboard/privacy_settings_screen.dart';
import 'package:athletica/screens/dashboard/security_settings_screen.dart';
import 'package:athletica/screens/dashboard/language_selection_screen.dart';
import 'package:athletica/screens/dashboard/help_support_screen.dart';
import 'package:athletica/screens/dashboard/about_us_screen.dart';
import 'package:athletica/screens/dashboard/contact_us_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 24),

            // Account Settings
            _buildSettingsSection(
              'Account',
              [
                _buildSettingsItem(
                  'Notifications',
                  'Manage your notification preferences',
                  Icons.notifications,
                  AppTheme.primaryBlue,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationSettingsScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  'Privacy',
                  'Control your privacy settings',
                  Icons.privacy_tip,
                  AppTheme.successGreen,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacySettingsScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  'Security',
                  'Password and security options',
                  Icons.security,
                  AppTheme.warningOrange,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SecuritySettingsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // App Settings
            _buildSettingsSection(
              'App',
              [
                _buildSettingsItem(
                  'Language',
                  'Select your preferred language',
                  Icons.language,
                  AppTheme.primaryBlue,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LanguageSelectionScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  'Theme',
                  'Choose your app theme',
                  Icons.palette,
                  AppTheme.successGreen,
                  _showThemeDialog,
                ),
                _buildSettingsItem(
                  'Storage',
                  'Manage app storage and cache',
                  Icons.storage,
                  AppTheme.warningOrange,
                  _showStorageDialog,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Support & Info
            _buildSettingsSection(
              'Support & Info',
              [
                _buildSettingsItem(
                  'Help & Support',
                  'Get help and contact support',
                  Icons.help,
                  AppTheme.primaryBlue,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  'About Us',
                  'Learn more about Athletica',
                  Icons.info,
                  AppTheme.successGreen,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AboutUsScreen(),
                    ),
                  ),
                ),
                _buildSettingsItem(
                  'Contact Us',
                  'Get in touch with our team',
                  Icons.contact_mail,
                  AppTheme.warningOrange,
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ContactUsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Legal
            _buildSettingsSection(
              'Legal',
              [
                _buildSettingsItem(
                  'Terms of Service',
                  'Read our terms and conditions',
                  Icons.description,
                  AppTheme.textGrey,
                  _showTermsDialog,
                ),
                _buildSettingsItem(
                  'Privacy Policy',
                  'Read our privacy policy',
                  Icons.policy,
                  AppTheme.textGrey,
                  _showPrivacyPolicyDialog,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Logout Button
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final coachState = ref.watch(currentCoachProvider);
    final coach = coachState.valueOrNull;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryBlue,
            backgroundImage: coach?.profilePhotoUrl != null
                ? NetworkImage(coach!.profilePhotoUrl!)
                : null,
            child: coach?.profilePhotoUrl == null
                ? Text(
                    coach?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach?.name ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  coach?.email ?? 'user@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    coach?.subscriptionTier.toUpperCase() ?? 'FREE',
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, color: AppTheme.textSecondary),
          ),
        ],
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

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
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
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
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

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: const Text('Profile editing coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Choose Theme',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode, color: AppTheme.textPrimary),
              title: const Text('Dark Mode'),
              subtitle: const Text('Current theme'),
              trailing: const Icon(Icons.check, color: AppTheme.successGreen),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading:
                  const Icon(Icons.light_mode, color: AppTheme.textSecondary),
              title: const Text('Light Mode'),
              subtitle: const Text('Coming soon'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: const Text('Light mode coming soon!'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
            ),
          ],
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

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Storage Management',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'App Storage: 45.2 MB',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cache: 12.8 MB',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: const Text('Cache cleared successfully'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Cache'),
            ),
          ],
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service content will be displayed here. This is a placeholder for the actual terms and conditions.',
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

  void _showPrivacyPolicyDialog() {
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

  void _showLogoutDialog() {
    PlatformAlertDialog.show(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      actions: [
        PlatformAlertAction(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        PlatformAlertAction(
          text: 'Logout',
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(authRepositoryProvider).signOut();
            context.go('/auth/signin');
          },
          isDestructive: true,
        ),
      ],
    );
  }
}
