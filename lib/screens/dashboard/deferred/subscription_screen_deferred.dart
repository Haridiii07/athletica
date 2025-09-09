import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/services/deferred_loading_service.dart';

/// Deferred version of SubscriptionScreen
/// This screen is loaded only when needed to reduce initial bundle size
class SubscriptionScreenDeferred extends StatefulWidget {
  const SubscriptionScreenDeferred({super.key});

  @override
  State<SubscriptionScreenDeferred> createState() => _SubscriptionScreenDeferredState();
}

class _SubscriptionScreenDeferredState extends State<SubscriptionScreenDeferred>
    with DeferredLoadingMixin {
  String _selectedTier = 'free';
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    setDeferredLoading('subscription');
    loadDeferredFeature();
  }

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
      body: buildDeferredContent(() => _buildContent()),
    );
  }

  Widget _buildContent() {
    return SafeArea(
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Plan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentTier.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                currentTier.price == 0
                    ? 'Free Forever'
                    : '${currentTier.price} EGP ${currentTier.duration}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Features included:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              ...currentTier.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textGrey,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
        ..._tiers.map((tier) => _buildPlanCard(tier)),
      ],
    );
  }

  Widget _buildPlanCard(SubscriptionTier tier) {
    final isSelected = _selectedTier == tier.id;
    final isPopular = tier.isPopular;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTier = tier.id;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor
                  : isPopular
                      ? AppTheme.successGreen
                      : AppTheme.borderColor,
              width: isSelected || isPopular ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isPopular) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tier.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Radio<String>(
                    value: tier.id,
                    groupValue: _selectedTier,
                    onChanged: (value) {
                      setState(() {
                        _selectedTier = value!;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tier.price == 0
                    ? 'Free Forever'
                    : '${tier.price} EGP ${tier.duration}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Features:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              ...tier.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textGrey,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )),
              if (tier.limitations.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Limitations:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                ...tier.limitations.map((limitation) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cancel,
                            color: AppTheme.errorRed,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              limitation,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textGrey,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
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
              _buildComparisonRow('Analytics', ['Basic', 'Advanced', 'Advanced', 'Advanced']),
              _buildComparisonRow('Support', ['Email', 'Priority', 'Priority', 'Dedicated']),
              _buildComparisonRow('Branding', ['No', 'Yes', 'Yes', 'White-label']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, List<String> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          ...values.map((value) => Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textGrey,
                      ),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _upgradePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Upgrade Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancelSubscription,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.errorRed),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancel Subscription',
              style: TextStyle(
                color: AppTheme.errorRed,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _upgradePlan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan upgraded successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error upgrading plan: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _cancelSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your subscription? You will lose access to premium features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Subscription'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement cancellation logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription cancelled'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.errorRed),
            ),
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
