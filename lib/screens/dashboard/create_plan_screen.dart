import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:athletica/utils/theme.dart';
import 'package:athletica/data/models/plan.dart';
import 'package:athletica/data/models/exercise.dart' as data_models;
import 'package:athletica/data/models/exercise.dart' as old_models;
import 'package:athletica/presentation/providers/coach_provider.dart';
import 'package:athletica/presentation/providers/auth_provider.dart';
import 'package:athletica/screens/dashboard/workout_template_screen.dart';
import 'package:athletica/screens/dashboard/exercise_library_screen.dart';

class CreatePlanScreen extends ConsumerStatefulWidget {
  final String? planId; // For editing existing plan

  const CreatePlanScreen({super.key, this.planId});

  @override
  ConsumerState<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends ConsumerState<CreatePlanScreen> {
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
  final List<data_models.ExerciseSet> _exercises = [];

  final List<String> _statusOptions = ['draft', 'active', 'archived'];

  @override
  void initState() {
    super.initState();
    // Load plan data if planId is provided
    if (widget.planId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPlanData(widget.planId!);
      });
    }
  }

  Future<void> _loadPlanData(String planId) async {
    try {
      final planAsync = await ref.read(planDetailsProvider(planId).future);
      _nameController.text = planAsync.name;
      _descriptionController.text = planAsync.description;
      _durationController.text = planAsync.duration.toString();
      _priceController.text = planAsync.price.toString();
      _selectedStatus = planAsync.status;
      _imagePath = planAsync.imageUrl;
      _features.addAll(planAsync.features);
      if (mounted) setState(() {});
    } catch (e) {
      // Handle error
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
    final isEditing = widget.planId != null;

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
          onPressed: () => context.pop(),
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

                // Exercise Management Section
                _buildSectionTitle('Workout Exercises'),
                const SizedBox(height: 16),

                _buildExerciseManagementSection(),
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

  Widget _buildExerciseManagementSection() {
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
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openExerciseLibrary,
                  icon: const Icon(Icons.library_books),
                  label: const Text('Add Exercises'),
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
                  onPressed: _openWorkoutTemplates,
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Use Template'),
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
          const SizedBox(height: 16),

          // Exercise list
          if (_exercises.isNotEmpty) ...[
            Text(
              'Selected Exercises (${_exercises.length}):',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...(_exercises.asMap().entries.map((entry) {
              final index = entry.key;
              final exercise = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.exerciseName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (exercise.reps != null) ...[
                                Text(
                                  '${exercise.reps} reps',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (exercise.restTime != null) ...[
                                Text(
                                  '${exercise.restTime}s rest',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (exercise.duration != null) ...[
                                Text(
                                  '${exercise.duration}s',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeExercise(index),
                      icon: const Icon(Icons.close,
                          color: AppTheme.errorRed, size: 20),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            }).toList()),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.borderColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.fitness_center_outlined,
                    size: 48,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No exercises added yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add exercises from the library or use a workout template',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
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
                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
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
            onPressed: () => context.pop(),
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

  void _openExerciseLibrary() async {
    // TODO: Implement exercise library navigation with go_router
    // For now, using Navigator as a temporary solution
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => ExerciseLibraryScreen(
          onExerciseSelected: (exercise) {
            _toggleExercise(exercise);
          },
          selectedExercises: _exercises
              .map((e) => old_models.Exercise(
                    id: e.exerciseId,
                    name: e.exerciseName,
                    description: '',
                    category: '',
                    difficulty: '',
                    equipment: '',
                    muscleGroups: '',
                  ))
              .toList(),
        ),
      ),
    );

    if (result != null && result is old_models.Exercise) {
      _addExerciseFromLibrary(result);
    }
  }

  void _openWorkoutTemplates() async {
    // TODO: Implement workout template navigation with go_router
    await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => WorkoutTemplateScreen(
          onTemplateSelected: (template) {
            _useWorkoutTemplate(template);
          },
        ),
      ),
    );
  }

  void _toggleExercise(old_models.Exercise exercise) {
    setState(() {
      final existingIndex =
          _exercises.indexWhere((e) => e.exerciseId == exercise.id);
      if (existingIndex != -1) {
        _exercises.removeAt(existingIndex);
      } else {
        _addExerciseFromLibrary(exercise);
      }
    });
  }

  void _addExerciseFromLibrary(old_models.Exercise exercise) {
    final exerciseSet = data_models.ExerciseSet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      reps: exercise.reps,
      duration: exercise.duration,
      restTime: 60, // Default rest time
      order: _exercises.length + 1,
    );

    setState(() {
      _exercises.add(exerciseSet);
    });
  }

  void _useWorkoutTemplate(old_models.WorkoutTemplate template) {
    setState(() {
      _exercises.clear();
      // Convert old ExerciseSet to new ExerciseSet
      for (final oldExerciseSet in template.exercises) {
        _exercises.add(data_models.ExerciseSet(
          id: oldExerciseSet.id,
          exerciseId: oldExerciseSet.exerciseId,
          exerciseName: oldExerciseSet.exerciseName,
          reps: oldExerciseSet.reps,
          duration: oldExerciseSet.duration,
          restTime: oldExerciseSet.restTime,
          order: oldExerciseSet.order,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Added ${template.exercises.length} exercises from "${template.name}" template'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      // Update order numbers
      for (int i = index; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i + 1);
      }
    });
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Get coach ID from coach provider
      final coach = await ref.read(currentCoachProvider.future);
      final coachId = coach?.id;
      if (coachId == null) {
        throw Exception('Coach not found');
      }

      final plan = Plan(
        id: widget.planId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        coachId: coachId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imagePath,
        duration: int.parse(_durationController.text),
        price: double.parse(_priceController.text),
        features: _features,
        status: _selectedStatus,
        createdAt: DateTime.now(),
        expiresAt: null,
        clientCount: 0,
        successRate: 0.0,
        revenue: 0.0,
      );

      if (widget.planId != null) {
        // Update existing plan
        final updateUseCase = ref.read(updatePlanUseCaseProvider);
        await updateUseCase.call(plan);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Plan updated successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        }
      } else {
        // Create new plan
        final addUseCase = ref.read(addPlanUseCaseProvider);
        await addUseCase.call(plan);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Plan created successfully'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
        }
      }

      // Invalidate plans provider to refresh list
      ref.invalidate(plansProvider);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving plan: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    if (widget.planId == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Delete Plan',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this plan? This action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              try {
                final deleteUseCase = ref.read(deletePlanUseCaseProvider);
                await deleteUseCase.call(widget.planId!);
                ref.invalidate(plansProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Plan deleted successfully'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                  context.pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting plan: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
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
