import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/utils/performance_utils.dart';
import 'package:athletica/widgets/empty_states.dart';
import 'package:athletica/widgets/loading_states.dart';
import 'package:athletica/screens/dashboard/client_details_screen.dart';
import 'package:athletica/screens/dashboard/add_client_screen.dart';

/// Performance-optimized clients screen demonstrating best practices
class OptimizedClientsScreen extends OptimizedStatefulWidget {
  const OptimizedClientsScreen({super.key});

  @override
  State<OptimizedClientsScreen> createState() => _OptimizedClientsScreenState();
}

class _OptimizedClientsScreenState
    extends OptimizedState<OptimizedClientsScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final List<String> _filters = ['All', 'Active', 'Inactive', 'Premium'];

  @override
  bool get wantKeepAlive => true; // Keep state alive for performance

  @override
  void initState() {
    super.initState();
    _loadClients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadClients() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    PerformanceUtils.debounce(
      'search',
      const Duration(milliseconds: 300),
      () {
        if (mounted) {
          setState(() => _searchQuery = _searchController.text);
        }
      },
    );
  }

  List<Client> get _filteredClients {
    final coachProvider = Provider.of<CoachProvider>(context, listen: false);
    var clients = coachProvider.clients;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      clients = clients
          .where((client) =>
              client.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (client.email
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      clients = clients.where((client) {
        switch (_selectedFilter) {
          case 'Active':
            return client.subscriptionStatus == 'active';
          case 'Inactive':
            return client.subscriptionStatus == 'inactive';
          case 'Premium':
            return client.subscriptionStatus == 'premium';
          default:
            return true;
        }
      }).toList();
    }

    return clients;
  }

  @override
  Widget buildOptimized(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: _buildOptimizedAppBar(),
      body: PerformanceMonitor(
        name: 'ClientsScreen',
        child: Column(
          children: [
            _buildOptimizedSearchAndFilters(),
            Expanded(
              child: _buildOptimizedClientsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildOptimizedFAB(),
    );
  }

  PreferredSizeWidget _buildOptimizedAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Clients',
        style: TextStyle(color: AppTheme.textPrimary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppTheme.textPrimary),
          onPressed: _loadClients,
        ),
      ],
    );
  }

  Widget _buildOptimizedSearchAndFilters() {
    return PerformanceUtils.repaintBoundary(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOptimizedSearchBar(),
            const SizedBox(height: 12),
            _buildOptimizedFilters(),
          ],
        ),
      ),
      debugLabel: 'SearchAndFilters',
    );
  }

  Widget _buildOptimizedSearchBar() {
    return PerformanceUtils.repaintBoundary(
      TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search clients...',
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
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryBlue),
          ),
          filled: true,
          fillColor: AppTheme.cardBackground,
        ),
      ),
      debugLabel: 'SearchBar',
    );
  }

  Widget _buildOptimizedFilters() {
    return PerformanceUtils.repaintBoundary(
      SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;

            return PerformanceUtils.optimizedListItem(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    PerformanceUtils.throttle(
                      'filter',
                      const Duration(milliseconds: 100),
                      () {
                        if (mounted) {
                          setState(() => _selectedFilter = filter);
                        }
                      },
                    );
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              index: index,
              debugLabel: 'Filter_$filter',
            );
          },
        ),
      ),
      debugLabel: 'Filters',
    );
  }

  Widget _buildOptimizedClientsList() {
    if (_isLoading) {
      return const ListLoadingWidget(itemCount: 8);
    }

    final clients = _filteredClients;

    if (clients.isEmpty) {
      return EmptyClientsWidget(
        onAddClient: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddClientScreen(),
            ),
          );
        },
      );
    }

    return PerformanceUtils.memoryEfficientListView(
      itemCount: clients.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final client = clients[index];
        return _buildOptimizedClientCard(client, index);
      },
    );
  }

  Widget _buildOptimizedClientCard(Client client, int index) {
    return PerformanceUtils.optimizedCard(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: () => _navigateToClientDetails(client),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                _buildOptimizedAvatar(client),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOptimizedClientInfo(client),
                ),
                _buildOptimizedClientActions(client),
              ],
            ),
          ),
        ),
      ),
      debugLabel: 'ClientCard_${client.id}',
    );
  }

  Widget _buildOptimizedAvatar(Client client) {
    return PerformanceUtils.repaintBoundary(
      CircleAvatar(
        radius: 25,
        backgroundColor: AppTheme.primaryBlue,
        backgroundImage: client.profilePhotoUrl != null
            ? NetworkImage(client.profilePhotoUrl!)
            : null,
        child: client.profilePhotoUrl == null
            ? Text(
                client.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            : null,
      ),
      debugLabel: 'Avatar_${client.id}',
    );
  }

  Widget _buildOptimizedClientInfo(Client client) {
    return PerformanceUtils.repaintBoundary(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            client.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            client.email ?? 'No email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildOptimizedStatusChip(client.subscriptionStatus),
              const SizedBox(width: 8),
              _buildOptimizedProgressIndicator(client),
            ],
          ),
        ],
      ),
      debugLabel: 'ClientInfo_${client.id}',
    );
  }

  Widget _buildOptimizedStatusChip(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = AppTheme.successGreen;
        break;
      case 'premium':
        statusColor = AppTheme.warningOrange;
        break;
      case 'inactive':
        statusColor = AppTheme.errorRed;
        break;
      default:
        statusColor = AppTheme.textGrey;
    }

    return PerformanceUtils.repaintBoundary(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugLabel: 'StatusChip_$status',
    );
  }

  Widget _buildOptimizedProgressIndicator(Client client) {
    final progress =
        client.sessionHistory.length / 10.0; // Mock progress calculation

    return PerformanceUtils.repaintBoundary(
      Expanded(
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: AppTheme.borderColor,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
        ),
      ),
      debugLabel: 'ProgressIndicator_${client.id}',
    );
  }

  Widget _buildOptimizedClientActions(Client client) {
    return PerformanceUtils.repaintBoundary(
      PopupMenuButton<String>(
        onSelected: (value) => _handleClientAction(value, client),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.visibility, color: AppTheme.primaryBlue),
                SizedBox(width: 8),
                Text('View Details'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: AppTheme.warningOrange),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: AppTheme.errorRed),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
        child: const Icon(
          Icons.more_vert,
          color: AppTheme.textSecondary,
        ),
      ),
      debugLabel: 'ClientActions_${client.id}',
    );
  }

  Widget _buildOptimizedFAB() {
    return PerformanceUtils.optimizedButton(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddClientScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      debugLabel: 'FAB',
    );
  }

  void _navigateToClientDetails(Client client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDetailsScreen(client: client),
      ),
    );
  }

  void _handleClientAction(String action, Client client) {
    switch (action) {
      case 'view':
        _navigateToClientDetails(client);
        break;
      case 'edit':
        // Placeholder - edit functionality will be implemented
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edit functionality coming soon'),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
        break;
      case 'delete':
        // Placeholder - delete functionality will be implemented
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete functionality coming soon'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        break;
    }
  }
}
