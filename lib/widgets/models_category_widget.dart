import 'package:flutter/material.dart';
import '../models/model_data.dart';
import '../models/lesson_data.dart';
import '../pages/model_lesson_page.dart';

/// Widget that displays all 3D models organized by category
class ModelsCategoryWidget extends StatelessWidget {
  final Function(String) onModelSelected;

  const ModelsCategoryWidget({
    super.key,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available 3D Models',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...modelCategories.map((category) {
              return _buildCategorySection(context, category);
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Builds a category section with its models
  Widget _buildCategorySection(
    BuildContext context,
    ModelCategory category,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(category.name),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Models Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: category.models.length,
          itemBuilder: (context, index) {
            final model = category.models[index];
            return _buildModelCard(context, model);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Builds individual model card
  Widget _buildModelCard(
    BuildContext context,
    ModelItem model,
  ) {
    // Find the corresponding lesson for this model
    final lesson = modelLessons.firstWhere(
      (l) => l.modelFileName == model.fileName,
      orElse: () => null as dynamic,
    ) as Lesson?;

    return GestureDetector(
      onTap: () {
        onModelSelected('assets/models/${model.fileName}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded: ${model.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Model Icon/Placeholder
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.view_in_ar,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 8),

                // Model Name
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                // Model Description
                Text(
                  model.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),

                // Lesson Button (if available)
                if (lesson != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModelLessonPage(lesson: lesson),
                            ),
                          );
                        },
                        icon: const Icon(Icons.school, size: 16),
                        label: const Text(
                          'Lesson',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate icon for each category
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Biology':
        return Icons.science;
      case 'Information Technology':
        return Icons.computer;
      case 'Office Equipment':
        return Icons.print;
      case 'Network Concepts':
        return Icons.hub;
      default:
        return Icons.category;
    }
  }
}
