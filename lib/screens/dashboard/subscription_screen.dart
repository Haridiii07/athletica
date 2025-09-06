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
