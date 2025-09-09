import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/screens/dashboard/create_plan_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'Active', 'Draft', 'Archived'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coachProvider = Provider.of<CoachProvider>(context, listen: false);
      coachProvider.loadPlans();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Plan> _getFilteredPlans(List<Plan> plans) {
    List<Plan> filtered = plans;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((plan) {
        return plan.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            plan.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((plan) {
        switch (_selectedFilter) {
          case 'Active':
            return plan.status == 'active';
          case 'Draft':
            return plan.status == 'draft';
          case 'Archived':
            return plan.status == 'archived';
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Search and Filter
            _buildSearchAndFilter(),

            // Plans List
            Expanded(
              child: Consumer<CoachProvider>(
                builder: (context, coachProvider, child) {
                  if (coachProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBlue,
                      ),
                    );
                  }

                  final filteredPlans = _getFilteredPlans(coachProvider.plans);

                  if (filteredPlans.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPlans.length,
                    itemBuilder: (context, index) {
                      final plan = filteredPlans[index];
                      return _buildPlanCard(plan);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreatePlanScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Workout Plans',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Consumer<CoachProvider>(
            builder: (context, coachProvider, child) {
              return Text(
                '${coachProvider.plans.length} plans',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search plans...',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              prefixIcon:
                  const Icon(Icons.search, color: AppTheme.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: AppTheme.cardBackground,
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: AppTheme.cardBackground,
                    selectedColor: AppTheme.primaryBlue,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.borderColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Plan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Image and Header
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              color: AppTheme.primaryBlue.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                if (plan.imageUrl != null)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      plan.imageUrl!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildStatusChip(plan.status),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Plan Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Plan Stats
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.access_time,
                      value: '${plan.duration} weeks',
                      label: 'Duration',
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      icon: Icons.people,
                      value: '${plan.clientCount}',
                      label: 'Clients',
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      icon: Icons.trending_up,
                      value: plan.successRateText,
                      label: 'Success',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price and Actions
                Row(
                  children: [
                    Text(
                      '${plan.price} EGP',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: AppTheme.textSecondary),
                      onSelected: (value) {
                        _handlePlanAction(value, plan);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility,
                                  color: AppTheme.textSecondary),
                              SizedBox(width: 8),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: AppTheme.textSecondary),
                              SizedBox(width: 8),
                              Text('Edit Plan'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, color: AppTheme.textSecondary),
                              SizedBox(width: 8),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              Icon(Icons.archive,
                                  color: AppTheme.textSecondary),
                              SizedBox(width: 8),
                              Text('Archive'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppTheme.errorRed),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: AppTheme.errorRed)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
        color = AppTheme.successGreen;
        label = 'Active';
        break;
      case 'draft':
        color = AppTheme.warningOrange;
        label = 'Draft';
        break;
      case 'archived':
        color = AppTheme.textGrey;
        label = 'Archived';
        break;
      default:
        color = AppTheme.textGrey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_outlined,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No workout plans found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by creating your first workout plan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreatePlanScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlanAction(String action, Plan plan) {
    switch (action) {
      case 'view':
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreatePlanScreen(plan: plan),
          ),
        );
        break;
      case 'duplicate':
        // TODO: Duplicate plan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plan.name} duplicated successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        break;
      case 'archive':
        // TODO: Archive plan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plan.name} archived successfully'),
            backgroundColor: AppTheme.warningOrange,
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(plan);
        break;
    }
  }

  void _showDeleteConfirmation(Plan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Delete Plan',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${plan.name}"? This action cannot be undone.',
          style: const TextStyle(color: AppTheme.textSecondary),
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
              // TODO: Implement delete plan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${plan.name} deleted successfully'),
                  backgroundColor: AppTheme.successGreen,
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
