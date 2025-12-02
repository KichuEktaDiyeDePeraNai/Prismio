# Prismio Content Generation - Integration Examples

Complete examples showing how to integrate the Prismio content generation system into your app.

## Quick Start - 10 Steps

### Step 1: Import the Service

```dart
import 'package:test/services/prismio_content_service.dart';
import 'package:test/pages/prismio_content_generator_page.dart';
```

### Step 2: Generate Content from Any Lesson

```dart
Future<void> generateAndDisplayContent(BuildContext context) async {
  const String lessonTitle = 'Animal Cell Structure';
  const String lessonCategory = 'Biology';
  const String lessonContent = '''
    Animal cells are eukaryotic cells that contain various organelles...
    [Your complete lesson text here]
  ''';

  // Generate all components
  final result = await PrismioContentService.generateLearningContent(
    lessonTitle: lessonTitle,
    lessonCategory: lessonCategory,
    lessonContent: lessonContent,
  );

  if (result['success']) {
    // Success! You now have all learning components
    final content = result['data'];
    
    // Navigate to content viewer
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrismioContentGeneratorPage(
            lessonTitle: lessonTitle,
            lessonCategory: lessonCategory,
            lessonContent: lessonContent,
          ),
        ),
      );
    }
  } else {
    debugPrint('Error: ${result['error']}');
  }
}
```

### Step 3: Access Individual Components

```dart
void accessComponents(Map<String, dynamic> content) {
  // Get quiz
  final quiz = PrismioContentService.getQuizSet(content);
  print('Total questions: ${quiz?['total_questions']}');

  // Get flashcards
  final flashcards = PrismioContentService.getFlashcards(content);
  print('Flashcard count: ${flashcards?.length}');

  // Get memory palace
  final palace = PrismioContentService.getMemoryPalace(content);
  print('Palace name: ${palace?['palace_name']}');

  // Get story mode
  final story = PrismioContentService.getStoryMode(content);
  print('Story chapters: ${story?['total_chapters']}');

  // Get 3D objects
  final objects = PrismioContentService.get3DObjects(content);
  print('AR objects count: ${objects?.length}');

  // Get analytics design
  final analytics = PrismioContentService.getAnalyticsDashboard(content);
  print('Dashboard sections: ${analytics?['dashboard_sections']?.length}');

  // Get homepage UI
  final homepage = PrismioContentService.getHomepageUI(content);
  print('Subject cards: ${homepage?['homepage_layout']?['section_2']?['subject_cards']?.length}');
}
```

### Step 4: Export as JSON

```dart
void exportContent(Map<String, dynamic> content) {
  final json = PrismioContentService.exportAsJson(content);
  
  // Save to file
  final file = File('content_${DateTime.now().millisecondsSinceEpoch}.json');
  file.writeAsStringSync(json);
  
  // Or send to backend
  http.post(
    Uri.parse('https://your-api.com/save-content'),
    body: json,
    headers: {'Content-Type': 'application/json'},
  );
  
  debugPrint('Exported JSON (${json.length} bytes)');
}
```

### Step 5: Integrate with Existing Quiz System

```dart
void integrateWithQuizSystem(Map<String, dynamic> content) {
  final quiz = PrismioContentService.getQuizSet(content);
  if (quiz != null) {
    final questions = quiz['questions'] as List? ?? [];
    
    // Convert to your existing Quiz model format
    for (var q in questions) {
      final quizModel = Quiz(
        question: q['question'],
        options: q['options'],
        answer: q['answer'],
        type: q['type'],
        difficulty: q['difficulty'],
      );
      // Add to quiz system
    }
  }
}
```

### Step 6: Display in Existing Pages

```dart
void addContentToLessonPage(Map<String, dynamic> content) {
  final summaries = content['summaries'] as Map<String, dynamic>?;
  final flashcards = content['flashcards'] as List?;
  final mnemonics = content['mnemonics'] as Map<String, dynamic>?;
  
  // Display summary in lesson page
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Quick Summary'),
      content: Text(summaries?['thirty_second_summary'] ?? ''),
    ),
  );
}
```

### Step 7: Teacher Dashboard Integration

```dart
void displayTeacherContent(Map<String, dynamic> content) {
  final teacherContent = content['teacher_mode'] as Map<String, dynamic>?;
  
  if (teacherContent != null) {
    final lessonPlan = teacherContent['lesson_plan'];
    final arMapping = teacherContent['ar_model_mapping'];
    final assessments = teacherContent['assessment_strategies'];
    
    // Display to teacher
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherDashboard(
          lessonPlan: lessonPlan,
          arMapping: arMapping,
          assessments: assessments,
        ),
      ),
    );
  }
}
```

### Step 8: Analytics Integration

```dart
void setupAnalytics(Map<String, dynamic> content) {
  final analytics = content['analytics'] as Map<String, dynamic>?;
  
  if (analytics != null) {
    final sections = analytics['dashboard_sections'] as List? ?? [];
    
    // Initialize tracking for each metric
    for (var section in sections) {
      initializeTrackingSection(section);
    }
  }
}
```

### Step 9: UI Homepage Update

```dart
void updateHomepage(Map<String, dynamic> content) {
  final homepage = content['homepage_ui'] as Map<String, dynamic>?;
  
  if (homepage != null) {
    final layout = homepage['homepage_layout'] as Map<String, dynamic>?;
    final bottomNav = homepage['bottom_navigation'] as Map<String, dynamic>?;
    
    // Update UI with new subject cards, navigation, etc.
  }
}
```

### Step 10: Complete Workflow

```dart
Future<void> completeWorkflow(BuildContext context, String lessonText) async {
  // 1. Generate content
  final result = await PrismioContentService.generateLearningContent(
    lessonTitle: 'Example Lesson',
    lessonCategory: 'Biology',
    lessonContent: lessonText,
  );

  if (!result['success']) {
    debugPrint('Generation failed: ${result['error']}');
    return;
  }

  final content = result['data'] as Map<String, dynamic>;

  // 2. Access components
  accessComponents(content);

  // 3. Export for storage
  exportContent(content);

  // 4. Integrate with existing systems
  integrateWithQuizSystem(content);
  setupAnalytics(content);
  updateHomepage(content);

  // 5. Display UI
  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrismioContentGeneratorPage(
          lessonTitle: 'Example Lesson',
          lessonCategory: 'Biology',
          lessonContent: lessonText,
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Custom Quiz Generation

```dart
void customQuizDisplay(Map<String, dynamic> content) {
  final quiz = PrismioContentService.getQuizSet(content);
  if (quiz == null) return;

  final questions = quiz['questions'] as List? ?? [];
  
  // Display only hard questions
  final hardQuestions = questions
    .where((q) => q['difficulty'] == 'hard')
    .toList();
}
```

### Memory Palace Navigation

```dart
void displayPalaceRooms(Map<String, dynamic> content) {
  final palace = PrismioContentService.getMemoryPalace(content);
  if (palace == null) return;

  final rooms = palace['rooms'] as List? ?? [];
  
  // Create AR environment for each room
  for (var room in rooms) {
    final roomName = room['room_name'];
    final roomTheme = room['ar_environment'];
    final roomObjects = room['objects'] as List?;
    
    // Initialize AR room with objects
    initializeARRoom(
      name: roomName,
      theme: roomTheme,
      objects: roomObjects ?? [],
    );
  }
}
```

### Story Mode Progression

```dart
void displayStoryChapter(Map<String, dynamic> content, int chapterNum) {
  final story = PrismioContentService.getStoryMode(content);
  if (story == null) return;

  final chapters = story['chapters'] as List? ?? [];
  if (chapterNum >= chapters.length) return;

  final chapter = chapters[chapterNum] as Map<String, dynamic>;
  
  displayChapterUI(
    title: chapter['title'],
    setting: chapter['setting'],
    content: chapter['learning_content'],
    arElements: chapter['ar_elements'],
  );
}
```

### Flashcard Flip Animation

```dart
void displayFlashcard(Map<String, dynamic> content, int cardIndex) {
  final flashcards = PrismioContentService.getFlashcards(content);
  if (flashcards == null || cardIndex >= flashcards.length) return;

  final card = flashcards[cardIndex] as Map<String, dynamic>;
  
  // Create animated flip card
  showFlipCard(
    front: card['term'],
    back: card['definition'],
    example: card['example'],
    difficulty: card['difficulty'],
  );
}
```

### 3D Object Rendering

```dart
void render3DObjects(Map<String, dynamic> content) {
  final objects = PrismioContentService.get3DObjects(content);
  if (objects == null) return;

  for (var obj in objects) {
    final object = obj as Map<String, dynamic>;
    
    renderAR3DObject(
      modelFile: object['ar_properties']['model_file'],
      scale: object['ar_properties']['scale'],
      animation: object['ar_properties']['animation'],
      color: object['ar_properties']['color'],
      interactivity: object['ar_properties']['interactivity'],
      position: calculateRoomPosition(object['room_placement']),
    );
  }
}
```

## File Locations

- **Generator**: `lib/services/prismio_content_generator.dart`
- **Service**: `lib/services/prismio_content_service.dart`
- **UI Page**: `lib/pages/prismio_content_generator_page.dart`
- **Documentation**: `PRISMIO_SYSTEM_DOCUMENTATION.md`
- **Integration Guide**: `PRISMIO_INTEGRATION_EXAMPLES.md`

## Next Steps

1. **Test content generation** with sample lesson text
2. **Integrate with quiz page** to use generated quizzes
3. **Create AR rooms** based on memory palace structure
4. **Add teacher dashboard** for lesson management
5. **Implement analytics tracking** for learning insights
6. **Deploy to production** after testing

---

**Version**: 1.0.0  
**Last Updated**: December 2, 2025
