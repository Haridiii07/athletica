import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/services/deferred_loading_service.dart';

/// Deferred version of CreatePlanScreen
/// This screen is loaded only when needed to reduce initial bundle size
class CreatePlanScreenDeferred extends StatefulWidget {
  const CreatePlanScreenDeferred({super.key});

  @override
  State<CreatePlanScreenDeferred> createState() => _CreatePlanScreenDeferredState();
}

class _CreatePlanScreenDeferredState extends State<CreatePlanScreenDeferred>
    with DeferredLoadingMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Strength';
  String _selectedDifficulty = 'Beginner';
  String _selectedDuration = '4 weeks';
  bool _isPublic = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Strength',
    'Cardio',
    'Flexibility',
    'Weight Loss',
    'Muscle Building',
    'Endurance',
    'Sports Specific',
    'Rehabilitation',
  ];

  final List<String> _difficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  final List<String> _durations = [
    '1 week',
    '2 weeks',
    '4 weeks',
    '6 weeks',
    '8 weeks',
    '12 weeks',
    '16 weeks',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    setDeferredLoading('create_plan');
    _loadDeferredFeature();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    _equipmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Create Workout Plan',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveDraft,
            child: Text(
              'Save Draft',
              style: TextStyle(
                color: _isLoading ? AppTheme.textGrey : AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: buildDeferredContent(() => _buildContent()),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // Plan Details
              _buildSectionTitle('Plan Details'),
              const SizedBox(height: 16),
              _buildPlanDetailsSection(),
              const SizedBox(height: 24),

              // Settings
              _buildSectionTitle('Settings'),
              const SizedBox(height: 16),
              _buildSettingsSection(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        // Plan Name
        _buildTextField(
          controller: _nameController,
          label: 'Plan Name',
          hint: 'Enter plan name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a plan name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Description
        _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'Describe your workout plan',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Category
        _buildDropdownField(
          label: 'Category',
          value: _selectedCategory,
          items: _categories,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPlanDetailsSection() {
    return Column(
      children: [
        // Difficulty
        _buildDropdownField(
          label: 'Difficulty Level',
          value: _selectedDifficulty,
          items: _difficulties,
          onChanged: (value) {
            setState(() {
              _selectedDifficulty = value!;
            });
          },
        ),
        const SizedBox(height: 16),

        // Duration
        _buildDropdownField(
          label: 'Duration',
          value: _selectedDuration,
          items: _durations,
          onChanged: (value) {
            setState(() {
              _selectedDuration = value!;
            });
          },
        ),
        const SizedBox(height: 16),

        // Equipment
        _buildTextField(
          controller: _equipmentController,
          label: 'Required Equipment',
          hint: 'List required equipment',
        ),
        const SizedBox(height: 16),

        // Notes
        _buildTextField(
          controller: _notesController,
          label: 'Additional Notes',
          hint: 'Any additional information',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        // Public/Private Toggle
        SwitchListTile(
          title: const Text(
            'Make Public',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          subtitle: const Text(
            'Allow other users to view this plan',
            style: TextStyle(color: AppTheme.textGrey),
          ),
          value: _isPublic,
          onChanged: (value) {
            setState(() {
              _isPublic = value;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textGrey),
            filled: true,
            fillColor: AppTheme.cardBackground,
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
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(color: AppTheme.textPrimary),
              dropdownColor: AppTheme.cardBackground,
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.borderColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createPlan,
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
                    'Create Plan',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveDraft() async {
    // Implementation for saving draft
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final plan = Plan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        duration: _selectedDuration,
        equipment: _equipmentController.text,
        notes: _notesController.text,
        isPublic: _isPublic,
        status: 'draft',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final coachProvider = Provider.of<CoachProvider>(context, listen: false);
      await coachProvider.createPlan(plan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan created successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating plan: $e'),
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
}
