import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/utils/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePlanScreen extends StatefulWidget {
  final Plan? plan; // For editing existing plan

  const CreatePlanScreen({super.key, this.plan});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedStatus = 'draft';
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final List<String> _features = [];
  final TextEditingController _featureController = TextEditingController();

  final List<String> _statusOptions = ['draft', 'active', 'archived'];

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _nameController.text = widget.plan!.name;
      _descriptionController.text = widget.plan!.description;
      _durationController.text = widget.plan!.duration.toString();
      _priceController.text = widget.plan!.price.toString();
      _selectedStatus = widget.plan!.status;
      _imagePath = widget.plan!.imageUrl;
      _features.addAll(widget.plan!.features);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.plan != null;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Plan' : 'Create New Plan',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.errorRed),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Image Section
                _buildImageSection(),
                const SizedBox(height: 24),

                // Basic Information
                _buildSectionTitle('Plan Information'),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _nameController,
                  label: 'Plan Name',
                  hint: 'Enter plan name (e.g., Fat Loss Program)',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Plan name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Describe what this plan includes',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _durationController,
                        label: 'Duration (weeks)',
                        hint: '4',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Duration is required';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Enter valid duration';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: 'Price (EGP)',
                        hint: '500',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price is required';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) < 0) {
                            return 'Enter valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Features Section
                _buildSectionTitle('Plan Features'),
                const SizedBox(height: 16),

                _buildFeaturesSection(),
                const SizedBox(height: 24),

                // Status Selection
                _buildSectionTitle('Plan Status'),
                const SizedBox(height: 16),

                _buildStatusSelector(),
                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryBlue,
                  width: 2,
                ),
                color: AppTheme.cardBackground,
              ),
              child: _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_imagePath!),
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: AppTheme.primaryBlue,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Plan Image',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickImage,
            child: Text(
              _imagePath != null ? 'Change Image' : 'Add Image',
              style: const TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        hintStyle: const TextStyle(color: AppTheme.textGrey),
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
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.errorRed),
        ),
        filled: true,
        fillColor: AppTheme.cardBackground,
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Feature Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _featureController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText:
                        'Add a feature (e.g., Personal training sessions)',
                    hintStyle: const TextStyle(color: AppTheme.textGrey),
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
                      borderSide: const BorderSide(
                          color: AppTheme.primaryBlue, width: 2),
                    ),
                    filled: true,
                    fillColor: AppTheme.darkBackground,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addFeature,
                icon: const Icon(Icons.add, color: AppTheme.primaryBlue),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Features List
          if (_features.isNotEmpty) ...[
            Text(
              'Plan Features:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...(_features.asMap().entries.map((entry) {
              final index = entry.key;
              final feature = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
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
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeFeature(index),
                      icon: const Icon(Icons.close,
                          color: AppTheme.errorRed, size: 16),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            }).toList()),
          ] else ...[
            const Text(
              'No features added yet',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: _statusOptions.map((status) {
          final isSelected = _selectedStatus == status;
          return RadioListTile<String>(
            title: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              _getStatusDescription(status),
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            value: status,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            activeColor: AppTheme.primaryBlue,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'draft':
        return 'Plan is being created and not yet published';
      case 'active':
        return 'Plan is published and available to clients';
      case 'archived':
        return 'Plan is no longer available';
      default:
        return '';
    }
  }

  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              side: const BorderSide(color: AppTheme.borderColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _savePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditing ? 'Update Plan' : 'Create Plan'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty && !_features.contains(feature)) {
      setState(() {
        _features.add(feature);
        _featureController.clear();
      });
    }
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final coachProvider = Provider.of<CoachProvider>(context, listen: false);

      final plan = Plan(
        id: widget.plan?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        coachId: 'coach_id', // Mock coach ID
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imagePath,
        duration: int.parse(_durationController.text),
        price: double.parse(_priceController.text),
        features: _features,
        status: _selectedStatus,
        createdAt: widget.plan?.createdAt ?? DateTime.now(),
        expiresAt: widget.plan?.expiresAt,
        clientCount: widget.plan?.clientCount ?? 0,
        successRate: widget.plan?.successRate ?? 0.0,
        revenue: widget.plan?.revenue ?? 0.0,
      );

      if (widget.plan != null) {
        await coachProvider.updatePlan(plan);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan updated successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } else {
        await coachProvider.addPlan(plan);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan created successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving plan: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Delete Plan',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.plan?.name}"? This action cannot be undone.',
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
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final coachProvider =
                    Provider.of<CoachProvider>(context, listen: false);
                await coachProvider.deletePlan(widget.plan!.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plan deleted successfully'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting plan: $e'),
                    backgroundColor: AppTheme.errorRed,
                  ),
                );
              }
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
