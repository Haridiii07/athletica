import 'package:flutter/material.dart';
import 'package:athletica/data/models/exercise.dart';
import 'package:athletica/utils/theme.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  final Function(Exercise) onExerciseSelected;
  final List<Exercise> selectedExercises;

  const ExerciseLibraryScreen({
    super.key,
    required this.onExerciseSelected,
    required this.selectedExercises,
  });

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  String _selectedEquipment = 'All';

  final List<String> _categories = [
    'All',
    'Strength',
    'Cardio',
    'Flexibility',
    'Balance'
  ];
  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> _equipment = [
    'All',
    'Bodyweight',
    'Dumbbells',
    'Barbell',
    'Machine',
    'None'
  ];

  // Mock exercise data - in a real app, this would come from an API
  final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'Push-ups',
      description:
          'Classic bodyweight exercise for chest, shoulders, and triceps',
      category: 'strength',
      difficulty: 'beginner',
      equipment: 'bodyweight',
      muscleGroups: 'chest, shoulders, triceps',
      reps: 10,
      sets: 3,
      instructions:
          'Start in plank position, lower body to ground, push back up',
      tips: ['Keep core tight', 'Full range of motion', 'Control the movement'],
    ),
    Exercise(
      id: '2',
      name: 'Squats',
      description: 'Fundamental lower body exercise',
      category: 'strength',
      difficulty: 'beginner',
      equipment: 'bodyweight',
      muscleGroups: 'legs, glutes',
      reps: 15,
      sets: 3,
      instructions:
          'Stand with feet shoulder-width apart, lower as if sitting in chair',
      tips: ['Keep knees behind toes', 'Chest up', 'Full depth'],
    ),
    Exercise(
      id: '3',
      name: 'Burpees',
      description: 'Full-body cardio exercise',
      category: 'cardio',
      difficulty: 'intermediate',
      equipment: 'bodyweight',
      muscleGroups: 'full body',
      reps: 8,
      sets: 3,
      instructions:
          'Squat down, jump back to plank, do push-up, jump forward, jump up',
      tips: ['Maintain pace', 'Full extension', 'Land softly'],
    ),
    Exercise(
      id: '4',
      name: 'Deadlifts',
      description: 'Compound movement for posterior chain',
      category: 'strength',
      difficulty: 'advanced',
      equipment: 'barbell',
      muscleGroups: 'back, glutes, hamstrings',
      reps: 5,
      sets: 4,
      instructions:
          'Lift barbell from ground to hip level, keeping back straight',
      tips: ['Keep bar close to body', 'Hinge at hips', 'Drive through heels'],
    ),
    Exercise(
      id: '5',
      name: 'Plank',
      description: 'Isometric core strengthening exercise',
      category: 'strength',
      difficulty: 'beginner',
      equipment: 'bodyweight',
      muscleGroups: 'core',
      duration: 60,
      instructions: 'Hold body in straight line from head to heels',
      tips: ['Engage core', 'Breathe normally', 'Don\'t sag hips'],
    ),
    Exercise(
      id: '6',
      name: 'Mountain Climbers',
      description: 'Dynamic cardio exercise',
      category: 'cardio',
      difficulty: 'intermediate',
      equipment: 'bodyweight',
      muscleGroups: 'core, shoulders, legs',
      duration: 30,
      instructions: 'Start in plank, alternate bringing knees to chest',
      tips: ['Keep core tight', 'Maintain plank position', 'Quick pace'],
    ),
    Exercise(
      id: '7',
      name: 'Lunges',
      description: 'Single-leg strengthening exercise',
      category: 'strength',
      difficulty: 'beginner',
      equipment: 'bodyweight',
      muscleGroups: 'legs, glutes',
      reps: 12,
      sets: 3,
      instructions: 'Step forward, lower back knee to ground, return to start',
      tips: [
        'Keep front knee behind toe',
        'Equal weight on both legs',
        'Control descent'
      ],
    ),
    Exercise(
      id: '8',
      name: 'Jumping Jacks',
      description: 'Basic cardio warm-up exercise',
      category: 'cardio',
      difficulty: 'beginner',
      equipment: 'bodyweight',
      muscleGroups: 'full body',
      duration: 45,
      instructions:
          'Jump feet apart while raising arms overhead, return to start',
      tips: ['Land softly', 'Maintain rhythm', 'Full arm movement'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Exercise Library',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Done (${widget.selectedExercises.length})',
              style: const TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(),

          // Exercise List
          Expanded(
            child: _buildExerciseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              hintText: 'Search exercises...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Category', _selectedCategory, _categories),
                const SizedBox(width: 8),
                _buildFilterChip(
                    'Difficulty', _selectedDifficulty, _difficulties),
                const SizedBox(width: 8),
                _buildFilterChip('Equipment', _selectedEquipment, _equipment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selected, List<String> options) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          style: const TextStyle(color: AppTheme.textPrimary),
          dropdownColor: AppTheme.cardBackground,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              switch (label) {
                case 'Category':
                  _selectedCategory = newValue!;
                  break;
                case 'Difficulty':
                  _selectedDifficulty = newValue!;
                  break;
                case 'Equipment':
                  _selectedEquipment = newValue!;
                  break;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    final filteredExercises = _getFilteredExercises();

    if (filteredExercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        final isSelected =
            widget.selectedExercises.any((e) => e.id == exercise.id);

        return _buildExerciseCard(exercise, isSelected);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                : AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              exercise.categoryIcon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              exercise.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildExerciseTag(exercise.category, exercise.categoryIcon),
                const SizedBox(width: 8),
                _buildExerciseTag(exercise.difficulty, '⭐'),
                const SizedBox(width: 8),
                _buildExerciseTag(exercise.equipment, exercise.equipmentIcon),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exercise.muscleGroups,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textGrey,
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            if (isSelected) {
              // Remove from selection
              widget.onExerciseSelected(exercise);
            } else {
              // Add to selection
              widget.onExerciseSelected(exercise);
            }
          },
          icon: Icon(
            isSelected ? Icons.check_circle : Icons.add_circle_outline,
            color: isSelected ? AppTheme.successGreen : AppTheme.textSecondary,
          ),
        ),
        onTap: () {
          _showExerciseDetails(exercise);
        },
      ),
    );
  }

  Widget _buildExerciseTag(String label, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Exercise> _getFilteredExercises() {
    List<Exercise> filtered = _exercises;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return exercise.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            exercise.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            exercise.muscleGroups
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((exercise) {
        return exercise.category.toLowerCase() ==
            _selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulty != 'All') {
      filtered = filtered.where((exercise) {
        return exercise.difficulty.toLowerCase() ==
            _selectedDifficulty.toLowerCase();
      }).toList();
    }

    // Apply equipment filter
    if (_selectedEquipment != 'All') {
      filtered = filtered.where((exercise) {
        return exercise.equipment.toLowerCase() ==
            _selectedEquipment.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  void _showExerciseDetails(Exercise exercise) {
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

              // Exercise header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        exercise.categoryIcon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Exercise details
              _buildDetailRow('Category', exercise.category),
              _buildDetailRow('Difficulty', exercise.difficulty),
              _buildDetailRow('Equipment', exercise.equipment),
              _buildDetailRow('Muscle Groups', exercise.muscleGroups),
              if (exercise.reps != null)
                _buildDetailRow('Reps', '${exercise.reps}'),
              if (exercise.sets != null)
                _buildDetailRow('Sets', '${exercise.sets}'),
              if (exercise.duration != null)
                _buildDetailRow('Duration', exercise.formattedDuration),

              if (exercise.instructions != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.instructions!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],

              if (exercise.tips.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...exercise.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(color: AppTheme.textSecondary)),
                          Expanded(
                            child: Text(
                              tip,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],

              const SizedBox(height: 24),

              // Action buttons
              Row(
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
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onExerciseSelected(exercise);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.selectedExercises.any((e) => e.id == exercise.id)
                            ? 'Remove from Plan'
                            : 'Add to Plan',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
