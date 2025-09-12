import 'package:flutter/material.dart';
import 'package:athletica/models/exercise.dart';
import 'package:athletica/utils/theme.dart';

class WorkoutTemplateScreen extends StatefulWidget {
  final Function(WorkoutTemplate) onTemplateSelected;

  const WorkoutTemplateScreen({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<WorkoutTemplateScreen> createState() => _WorkoutTemplateScreenState();
}

class _WorkoutTemplateScreenState extends State<WorkoutTemplateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  final List<String> _categories = [
    'All',
    'Strength',
    'Cardio',
    'HIIT',
    'Yoga',
    'Pilates'
  ];
  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  // Mock workout templates - in a real app, this would come from an API
  final List<WorkoutTemplate> _templates = [
    WorkoutTemplate(
      id: '1',
      name: 'Full Body Strength',
      description:
          'Complete strength workout targeting all major muscle groups',
      category: 'strength',
      difficulty: 'intermediate',
      duration: 45,
      exercises: [
        ExerciseSet(
            id: '1',
            exerciseId: '1',
            exerciseName: 'Push-ups',
            reps: 12,
            order: 1),
        ExerciseSet(
            id: '2',
            exerciseId: '2',
            exerciseName: 'Squats',
            reps: 15,
            order: 2),
        ExerciseSet(
            id: '3',
            exerciseId: '7',
            exerciseName: 'Lunges',
            reps: 10,
            order: 3),
        ExerciseSet(
            id: '4',
            exerciseId: '5',
            exerciseName: 'Plank',
            duration: 60,
            order: 4),
      ],
    ),
    WorkoutTemplate(
      id: '2',
      name: 'HIIT Cardio Blast',
      description: 'High-intensity interval training for maximum fat burn',
      category: 'hiit',
      difficulty: 'advanced',
      duration: 30,
      exercises: [
        ExerciseSet(
            id: '1',
            exerciseId: '3',
            exerciseName: 'Burpees',
            reps: 8,
            order: 1),
        ExerciseSet(
            id: '2',
            exerciseId: '6',
            exerciseName: 'Mountain Climbers',
            duration: 30,
            order: 2),
        ExerciseSet(
            id: '3',
            exerciseId: '8',
            exerciseName: 'Jumping Jacks',
            duration: 45,
            order: 3),
        ExerciseSet(
            id: '4',
            exerciseId: '5',
            exerciseName: 'Plank',
            duration: 30,
            order: 4),
      ],
    ),
    WorkoutTemplate(
      id: '3',
      name: 'Beginner Cardio',
      description: 'Gentle cardio workout perfect for beginners',
      category: 'cardio',
      difficulty: 'beginner',
      duration: 25,
      exercises: [
        ExerciseSet(
            id: '1',
            exerciseId: '8',
            exerciseName: 'Jumping Jacks',
            duration: 60,
            order: 1),
        ExerciseSet(
            id: '2',
            exerciseId: '2',
            exerciseName: 'Squats',
            reps: 10,
            order: 2),
        ExerciseSet(
            id: '3',
            exerciseId: '1',
            exerciseName: 'Push-ups',
            reps: 5,
            order: 3),
      ],
    ),
    WorkoutTemplate(
      id: '4',
      name: 'Core Strengthening',
      description: 'Focused workout for building core strength and stability',
      category: 'strength',
      difficulty: 'intermediate',
      duration: 35,
      exercises: [
        ExerciseSet(
            id: '1',
            exerciseId: '5',
            exerciseName: 'Plank',
            duration: 60,
            order: 1),
        ExerciseSet(
            id: '2',
            exerciseId: '6',
            exerciseName: 'Mountain Climbers',
            duration: 45,
            order: 2),
        ExerciseSet(
            id: '3',
            exerciseId: '2',
            exerciseName: 'Squats',
            reps: 12,
            order: 3),
      ],
    ),
    WorkoutTemplate(
      id: '5',
      name: 'Upper Body Power',
      description: 'Intensive upper body workout for building strength',
      category: 'strength',
      difficulty: 'advanced',
      duration: 50,
      exercises: [
        ExerciseSet(
            id: '1',
            exerciseId: '1',
            exerciseName: 'Push-ups',
            reps: 15,
            order: 1),
        ExerciseSet(
            id: '2',
            exerciseId: '4',
            exerciseName: 'Deadlifts',
            reps: 5,
            order: 2),
        ExerciseSet(
            id: '3',
            exerciseId: '5',
            exerciseName: 'Plank',
            duration: 90,
            order: 3),
      ],
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
          'Workout Templates',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(),

          // Template List
          Expanded(
            child: _buildTemplateList(),
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
              hintText: 'Search templates...',
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
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildTemplateList() {
    final filteredTemplates = _getFilteredTemplates();

    if (filteredTemplates.isEmpty) {
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
              'No templates found',
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
      itemCount: filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = filteredTemplates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(WorkoutTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: InkWell(
        onTap: () => _showTemplateDetails(template),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template header
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
                        template.categoryIcon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          template.description,
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
              const SizedBox(height: 16),

              // Template stats
              Row(
                children: [
                  _buildTemplateStat(
                      'Duration', '${template.duration} min', Icons.timer),
                  const SizedBox(width: 16),
                  _buildTemplateStat('Exercises',
                      '${template.exercises.length}', Icons.fitness_center),
                  const SizedBox(width: 16),
                  _buildTemplateStat(
                      'Difficulty', template.difficulty, Icons.star),
                ],
              ),
              const SizedBox(height: 16),

              // Exercise preview
              Text(
                'Exercises:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: template.exercises.take(3).map((exercise) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      exercise.exerciseName,
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (template.exercises.length > 3) ...[
                const SizedBox(height: 8),
                Text(
                  '+${template.exercises.length - 3} more exercises',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textGrey,
                      ),
                ),
              ],

              const SizedBox(height: 16),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onTemplateSelected(template);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Use This Template'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateStat(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  List<WorkoutTemplate> _getFilteredTemplates() {
    List<WorkoutTemplate> filtered = _templates;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((template) {
        return template.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            template.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((template) {
        return template.category.toLowerCase() ==
            _selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulty != 'All') {
      filtered = filtered.where((template) {
        return template.difficulty.toLowerCase() ==
            _selectedDifficulty.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  void _showTemplateDetails(WorkoutTemplate template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
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

              // Template header
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        template.categoryIcon,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          template.description,
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

              // Template details
              _buildDetailRow('Category', template.category),
              _buildDetailRow('Difficulty', template.difficulty),
              _buildDetailRow('Duration', '${template.duration} minutes'),
              _buildDetailRow(
                  'Exercises', '${template.exercises.length} exercises'),

              const SizedBox(height: 24),

              // Exercise list
              Text(
                'Exercise List',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              ...template.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final exercise = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBackground,
                    borderRadius: BorderRadius.circular(12),
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
                                  .titleMedium
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
                    ],
                  ),
                );
              }),

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
                        widget.onTemplateSelected(template);
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
                      child: const Text('Use This Template'),
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
