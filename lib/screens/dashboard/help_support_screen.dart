import 'package:flutter/material.dart';
import 'package:athletica/utils/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I add a new client?',
      answer:
          'To add a new client, go to the Clients tab and tap the "+" button. Fill in the client\'s information and tap "Add Client".',
      category: 'Clients',
    ),
    FAQItem(
      question: 'How do I create a workout plan?',
      answer:
          'Go to the Plans tab and tap "Create Plan". You can choose from templates or create a custom plan with exercises from our library.',
      category: 'Plans',
    ),
    FAQItem(
      question: 'How do I track client progress?',
      answer:
          'Each client has a progress section where you can view their analytics, charts, and performance metrics over time.',
      category: 'Progress',
    ),
    FAQItem(
      question: 'How do I upgrade my subscription?',
      answer:
          'Go to Settings > Subscription to view available plans and upgrade options. You can also manage your payment methods there.',
      category: 'Subscription',
    ),
    FAQItem(
      question: 'How do I change my password?',
      answer:
          'Go to Settings > Security > Change Password. You\'ll need to enter your current password and create a new one.',
      category: 'Security',
    ),
    FAQItem(
      question: 'How do I export client data?',
      answer:
          'You can export client data and reports from the Analytics section. Look for the export options in each analytics screen.',
      category: 'Data',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept credit cards, bank transfers, and mobile payments. You can manage your payment methods in Settings > Subscription.',
      category: 'Payment',
    ),
    FAQItem(
      question: 'How do I contact support?',
      answer:
          'You can contact us through the Contact Us section in Settings, or email us directly at support@athletica.com.',
      category: 'Support',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFAQs = _searchQuery.isEmpty
        ? _faqs
        : _faqs
            .where((faq) =>
                faq.question
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                faq.category.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

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
          'Help & Support',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),

            // Quick Help
            _buildQuickHelp(),
            const SizedBox(height: 24),

            // FAQ Section
            _buildFAQSection(filteredFAQs),
            const SizedBox(height: 24),

            // Contact Support
            _buildContactSupport(),
            const SizedBox(height: 24),

            // Resources
            _buildResources(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search help articles...',
          hintStyle: const TextStyle(color: AppTheme.textGrey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.primaryBlue),
          ),
          filled: true,
          fillColor: AppTheme.darkBackground,
        ),
      ),
    );
  }

  Widget _buildQuickHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Help',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickHelpCard(
                'Getting Started',
                'Learn the basics',
                Icons.play_circle,
                AppTheme.primaryBlue,
                _showGettingStarted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickHelpCard(
                'Video Tutorials',
                'Watch guides',
                Icons.video_library,
                AppTheme.successGreen,
                _showVideoTutorials,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickHelpCard(
                'User Guide',
                'Complete guide',
                Icons.book,
                AppTheme.warningOrange,
                _showUserGuide,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickHelpCard(
                'Troubleshooting',
                'Fix common issues',
                Icons.build,
                AppTheme.errorRed,
                _showTroubleshooting,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickHelpCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(List<FAQItem> faqs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (faqs.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.search_off,
                  size: 48,
                  color: AppTheme.textGrey,
                ),
                const SizedBox(height: 12),
                Text(
                  'No results found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: faqs.map((faq) => _buildFAQItem(faq)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return ExpansionTile(
      title: Text(
        faq.question,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        faq.category,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
      ),
      iconColor: AppTheme.primaryBlue,
      collapsedIconColor: AppTheme.textGrey,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq.answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent, color: AppTheme.primaryBlue),
              const SizedBox(width: 12),
              Text(
                'Contact Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Need more help? Our support team is here to assist you.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _contactEmail,
                  icon: const Icon(Icons.email),
                  label: const Text('Email Us'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _contactChat,
                  icon: const Icon(Icons.chat),
                  label: const Text('Live Chat'),
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
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppTheme.textGrey, size: 16),
              const SizedBox(width: 8),
              Text(
                'Support hours: 9 AM - 6 PM (GMT+2)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Resources',
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
            children: [
              _buildResourceItem(
                'Community Forum',
                'Connect with other coaches',
                Icons.forum,
                AppTheme.primaryBlue,
                _openCommunityForum,
              ),
              _buildResourceItem(
                'Feature Requests',
                'Suggest new features',
                Icons.lightbulb,
                AppTheme.warningOrange,
                _openFeatureRequests,
              ),
              _buildResourceItem(
                'Release Notes',
                'Latest updates and changes',
                Icons.update,
                AppTheme.successGreen,
                _openReleaseNotes,
              ),
              _buildResourceItem(
                'System Status',
                'Check app status and outages',
                Icons.monitor_heart,
                AppTheme.errorRed,
                _openSystemStatus,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem(
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

  void _showGettingStarted() {
    _showHelpDialog('Getting Started',
        'Welcome to Athletica! Here\'s how to get started...');
  }

  void _showVideoTutorials() {
    _showHelpDialog('Video Tutorials',
        'Watch our video tutorials to learn how to use Athletica effectively.');
  }

  void _showUserGuide() {
    _showHelpDialog('User Guide',
        'Complete user guide with detailed instructions for all features.');
  }

  void _showTroubleshooting() {
    _showHelpDialog('Troubleshooting', 'Common issues and their solutions.');
  }

  void _showHelpDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          title,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          content,
          style: const TextStyle(color: AppTheme.textSecondary),
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

  void _contactEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _contactChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat functionality coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _openCommunityForum() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Community forum coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _openFeatureRequests() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature requests coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _openReleaseNotes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Release notes coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _openSystemStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System status page coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
