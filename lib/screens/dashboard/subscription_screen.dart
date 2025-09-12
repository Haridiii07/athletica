import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/utils/theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedTier = 'free';

  final List<SubscriptionTier> _tiers = [
    SubscriptionTier(
      id: 'free',
      name: 'Free',
      price: 0,
      duration: 'Forever',
      features: [
        'Up to 3 clients',
        'Basic workout plans',
        'Client progress tracking',
        'Email support',
      ],
      limitations: [
        'Limited to 3 clients',
        'No advanced analytics',
        'No custom branding',
      ],
      isPopular: false,
    ),
    SubscriptionTier(
      id: 'basic',
      name: 'Basic',
      price: 500,
      duration: 'per month',
      features: [
        'Up to 25 clients',
        'Advanced analytics',
        'Custom branding',
        'Priority support',
        'Workout templates',
        'Client messaging',
      ],
      limitations: [],
      isPopular: true,
    ),
    SubscriptionTier(
      id: 'pro',
      name: 'Pro',
      price: 750,
      duration: 'per month',
      features: [
        'Up to 100 clients',
        'Advanced scheduling',
        'Group training sessions',
        'Payment tracking',
        'Custom reports',
        'API access',
      ],
      limitations: [],
      isPopular: false,
    ),
    SubscriptionTier(
      id: 'elite',
      name: 'Elite',
      price: 1000,
      duration: 'per month',
      features: [
        'Unlimited clients',
        'White-label solution',
        'Advanced integrations',
        'Dedicated support',
        'Custom features',
        'Multi-location support',
      ],
      limitations: [],
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Subscription Plans',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Plan Info
              _buildCurrentPlanInfo(),
              const SizedBox(height: 24),

              // Plan Selection
              _buildPlanSelection(),
              const SizedBox(height: 24),

              // Features Comparison
              _buildFeaturesComparison(),
              const SizedBox(height: 32),

              // Subscription History
              _buildSubscriptionHistory(),
              const SizedBox(height: 24),

              // Payment Methods
              _buildPaymentMethods(),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanInfo() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentTier = _tiers.firstWhere(
          (tier) => tier.id == authProvider.coach?.subscriptionTier,
          orElse: () => _tiers.first,
        );

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
                  const Icon(
                    Icons.star,
                    color: AppTheme.warningOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Plan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currentTier.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                currentTier.price == 0
                    ? 'Free Forever'
                    : '${currentTier.price} EGP ${currentTier.duration}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '0 / ${authProvider.coach?.clientLimit ?? 3} clients used',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...(_tiers.map((tier) => _buildTierCard(tier)).toList()),
      ],
    );
  }

  Widget _buildTierCard(SubscriptionTier tier) {
    final isSelected = _selectedTier == tier.id;
    final isCurrentTier = tier.id == 'free'; // Mock current tier

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryBlue
              : tier.isPopular
                  ? AppTheme.warningOrange
                  : AppTheme.borderColor,
          width: isSelected || tier.isPopular ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (tier.isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppTheme.warningOrange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: tier.id,
                      groupValue: _selectedTier,
                      onChanged: isCurrentTier
                          ? null
                          : (value) {
                              setState(() {
                                _selectedTier = value!;
                              });
                            },
                      activeColor: AppTheme.primaryBlue,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            tier.price == 0
                                ? 'Free Forever'
                                : '${tier.price} EGP ${tier.duration}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrentTier)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ...(tier.features
                    .map((feature) => _buildFeatureItem(feature, true))
                    .toList()),
                if (tier.limitations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...(tier.limitations
                      .map((limitation) => _buildFeatureItem(limitation, false))
                      .toList()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature, bool isIncluded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isIncluded ? Icons.check_circle : Icons.cancel,
            color: isIncluded ? AppTheme.successGreen : AppTheme.errorRed,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        isIncluded ? AppTheme.textPrimary : AppTheme.textGrey,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features Comparison',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              _buildComparisonRow('Clients', ['3', '25', '100', 'Unlimited']),
              _buildComparisonRow(
                  'Analytics', ['Basic', 'Advanced', 'Advanced', 'Advanced']),
              _buildComparisonRow(
                  'Support', ['Email', 'Priority', 'Priority', 'Dedicated']),
              _buildComparisonRow(
                  'Branding', ['No', 'Yes', 'Yes', 'White-label']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          ...(values
              .map((value) => Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ))
              .toList()),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final selectedTier = _tiers.firstWhere((tier) => tier.id == _selectedTier);
    final isCurrentTier = selectedTier.id == 'free';

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isCurrentTier ? null : _upgradeSubscription,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isCurrentTier
                  ? 'Current Plan'
                  : selectedTier.price == 0
                      ? 'Downgrade to Free'
                      : 'Upgrade to ${selectedTier.name}',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'All plans include a 7-day free trial. Cancel anytime.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textGrey,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubscriptionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Subscription History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _viewAllHistory,
              child: const Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ],
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
              _buildHistoryItem(
                'Basic Plan',
                '500 EGP',
                'Active',
                '2024-01-15',
                AppTheme.successGreen,
              ),
              _buildHistoryItem(
                'Free Plan',
                '0 EGP',
                'Expired',
                '2023-12-01',
                AppTheme.textGrey,
              ),
              _buildHistoryItem(
                'Trial Period',
                '0 EGP',
                'Completed',
                '2023-11-15',
                AppTheme.warningOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String plan, String amount, String status,
      String date, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                date,
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

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addPaymentMethod,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
              ),
            ),
          ],
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
              _buildPaymentMethodItem(
                '**** **** **** 1234',
                'Visa',
                'Primary',
                true,
                Icons.credit_card,
                AppTheme.primaryBlue,
              ),
              _buildPaymentMethodItem(
                '**** **** **** 5678',
                'Mastercard',
                'Secondary',
                false,
                Icons.credit_card,
                AppTheme.textGrey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(String cardNumber, String cardType,
      String status, bool isPrimary, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardNumber,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$cardType • $status',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (isPrimary)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Primary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _managePaymentMethod(cardNumber),
                icon:
                    const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewAllHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Complete Subscription History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

              // Extended history list
              ...List.generate(10, (index) {
                final plans = [
                  'Basic Plan',
                  'Pro Plan',
                  'Elite Plan',
                  'Free Plan'
                ];
                final amounts = ['500 EGP', '750 EGP', '1000 EGP', '0 EGP'];
                final statuses = [
                  'Active',
                  'Expired',
                  'Completed',
                  'Cancelled'
                ];
                final dates = [
                  '2024-01-15',
                  '2023-12-01',
                  '2023-11-15',
                  '2023-10-01'
                ];
                final colors = [
                  AppTheme.successGreen,
                  AppTheme.textGrey,
                  AppTheme.warningOrange,
                  AppTheme.errorRed
                ];

                return _buildHistoryItem(
                  plans[index % plans.length],
                  amounts[index % amounts.length],
                  statuses[index % statuses.length],
                  dates[index % dates.length],
                  colors[index % colors.length],
                );
              }),

              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Add Payment Method',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Payment method integration coming soon! This is a demo.',
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
                  content: Text('Payment method integration coming soon!'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _managePaymentMethod(String cardNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Manage Payment Method',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              cardNumber,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.star, color: AppTheme.warningOrange),
              title: const Text('Set as Primary'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment method set as primary'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.primaryBlue),
              title: const Text('Edit Details'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit functionality coming soon'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.errorRed),
              title: const Text('Remove'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Remove functionality coming soon'),
                    backgroundColor: AppTheme.errorRed,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _upgradeSubscription() {
    final selectedTier = _tiers.firstWhere((tier) => tier.id == _selectedTier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          'Upgrade to ${selectedTier.name}',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are about to upgrade to:',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '${selectedTier.name} - ${selectedTier.price} EGP ${selectedTier.duration}',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment integration coming soon! This is a demo.',
              style: TextStyle(
                color: AppTheme.warningOrange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
                SnackBar(
                  content:
                      Text('Upgraded to ${selectedTier.name} successfully!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class SubscriptionTier {
  final String id;
  final String name;
  final int price;
  final String duration;
  final List<String> features;
  final List<String> limitations;
  final bool isPopular;

  SubscriptionTier({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.limitations,
    required this.isPopular,
  });
}
