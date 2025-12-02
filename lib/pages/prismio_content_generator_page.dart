import 'package:flutter/material.dart';
import 'package:test/services/prismio_content_service.dart';

/// Example page demonstrating Prismio content generation
class PrismioContentGeneratorPage extends StatefulWidget {
  final String lessonTitle;
  final String lessonCategory;
  final String lessonContent;

  const PrismioContentGeneratorPage({
    super.key,
    required this.lessonTitle,
    required this.lessonCategory,
    required this.lessonContent,
  });

  @override
  State<PrismioContentGeneratorPage> createState() =>
      _PrismioContentGeneratorPageState();
}

class _PrismioContentGeneratorPageState
    extends State<PrismioContentGeneratorPage> {
  Map<String, dynamic>? _generatedContent;
  bool _isLoading = false;
  String? _selectedTab = 'Overview';

  @override
  void initState() {
    super.initState();
    _generateContent();
  }

  Future<void> _generateContent() async {
    setState(() => _isLoading = true);

    final result = await PrismioContentService.generateLearningContent(
      lessonTitle: widget.lessonTitle,
      lessonCategory: widget.lessonCategory,
      lessonContent: widget.lessonContent,
    );

    setState(() {
      _generatedContent = result['data'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.lessonTitle} - Content Generator'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[400]!, Colors.blue[400]!],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _generatedContent == null
              ? const Center(
                  child: Text('Failed to generate content'),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTabBar(),
                      _buildContentSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      'Overview',
      'Quiz',
      'Flashcards',
      'Summaries',
      'Mnemonics',
      'Memory Palace',
      'Story',
      'Analytics',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs
            .map(
              (tab) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(tab),
                  selected: _selectedTab == tab,
                  onSelected: (selected) {
                    setState(() => _selectedTab = tab);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildContentSection() {
    switch (_selectedTab) {
      case 'Quiz':
        return _buildQuizSection();
      case 'Flashcards':
        return _buildFlashcardsSection();
      case 'Summaries':
        return _buildSummariesSection();
      case 'Mnemonics':
        return _buildMnemonicsSection();
      case 'Memory Palace':
        return _buildMemoryPalaceSection();
      case 'Story':
        return _buildStorySection();
      case 'Analytics':
        return _buildAnalyticsSection();
      default:
        return _buildOverviewSection();
    }
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content Generation Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Lesson Title', widget.lessonTitle),
                  _buildInfoRow('Category', widget.lessonCategory),
                  _buildInfoRow('Content Length',
                      '${widget.lessonContent.length} characters'),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Generated Components:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildComponentList([
                    '✓ Quiz Set (13 questions)',
                    '✓ Flashcards (3 cards)',
                    '✓ Summaries (3 versions)',
                    '✓ Mnemonics & Visual Cues',
                    '✓ Memory Palace (5 rooms)',
                    '✓ Puzzle Rooms (3 puzzles)',
                    '✓ Story Mode (5 chapters)',
                    '✓ Battle Quiz Challenges',
                    '✓ Sleep Audio Script',
                    '✓ Study Habits & Goals',
                    '✓ Teacher Mode Content',
                    '✓ Analytics Dashboard',
                    '✓ 3D AR Objects (5 models)',
                    '✓ Homepage UI Design',
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All content is automatically generated and ready to integrate!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection() {
    final quiz = PrismioContentService.getQuizSet(_generatedContent!);
    if (quiz == null) return const Center(child: Text('No quiz data'));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Set',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Total Questions',
                      quiz['total_questions'].toString()),
                  const SizedBox(height: 8),
                  Text(
                    'Difficulty Distribution:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _buildInfoRow('Easy',
                      quiz['difficulty_distribution']['easy'].toString()),
                  _buildInfoRow('Medium',
                      quiz['difficulty_distribution']['medium'].toString()),
                  _buildInfoRow('Hard',
                      quiz['difficulty_distribution']['hard'].toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sample Questions:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...(quiz['questions'] as List)
              .take(2)
              .map((q) => _buildQuestionCard(q))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(question['type'] as String)),
            const SizedBox(height: 8),
            Text(
              question['question'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Answer: ${question['answer']}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardsSection() {
    final flashcards = PrismioContentService.getFlashcards(_generatedContent!);
    if (flashcards == null || flashcards.isEmpty) {
      return const Center(child: Text('No flashcards'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flashcards (${flashcards.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...flashcards.map((card) {
            final c = card as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['term'] as String,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(c['definition'] as String),
                    const SizedBox(height: 8),
                    Text(
                      'Example: ${c['example']}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSummariesSection() {
    final summaries =
        PrismioContentService.getAnalyticsDashboard(_generatedContent!);
    if (summaries == null) return const Center(child: Text('No summaries'));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Summaries',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Quick Summary (30 seconds)',
            _generatedContent!['summaries']['thirty_second_summary'],
          ),
          _buildSummaryCard(
            'Standard Summary (1 minute)',
            _generatedContent!['summaries']['one_minute_summary'],
          ),
          _buildSummaryCard(
            'Extended Summary (3 minutes)',
            _generatedContent!['summaries']['three_minute_extended_summary'],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildMnemonicsSection() {
    final mnemonics =
        _generatedContent!['mnemonics'] as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Memory Aids & Mnemonics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (mnemonics['acronyms'] != null)
            ...(mnemonics['acronyms'] as List).map((a) {
              final acronym = a as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acronym['acronym'] as String,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      ...(acronym['stands_for'] as List)
                          .map((s) => Text('• $s'))
                          .toList(),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMemoryPalaceSection() {
    final palace =
        PrismioContentService.getMemoryPalace(_generatedContent!);
    if (palace == null) {
      return const Center(child: Text('No palace data'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            palace['palace_name'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Total Rooms', palace['total_rooms'].toString()),
          _buildInfoRow('Theme', palace['palace_theme'] as String),
          const SizedBox(height: 16),
          Text(
            'Rooms:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...(palace['rooms'] as List)
              .map((r) {
                final room = r as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['room_name'] as String,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(room['description'] as String),
                        const SizedBox(height: 4),
                        _buildInfoRow('Time Estimate',
                            room['estimated_time'].toString()),
                      ],
                    ),
                  ),
                );
              })
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStorySection() {
    final story = PrismioContentService.getStoryMode(_generatedContent!);
    if (story == null) return const Center(child: Text('No story data'));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story['story_name'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Structure', story['narrative_structure'].toString()),
          _buildInfoRow('Chapters', story['total_chapters'].toString()),
          const SizedBox(height: 16),
          ...(story['chapters'] as List)
              .map((c) {
                final chapter = c as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chapter ${chapter['chapter_num']}: ${chapter['title']}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(chapter['learning_content'] as String),
                      ],
                    ),
                  ),
                );
              })
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    final analytics =
        PrismioContentService.getAnalyticsDashboard(_generatedContent!);
    if (analytics == null) {
      return const Center(child: Text('No analytics data'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Dashboard Design',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Tracked Metrics:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildComponentList([
            'Total XP & Level Progression',
            'Daily Streak & Consistency',
            'Accuracy Rate & Performance',
            'Study Time & Engagement Hours',
            'Room Completion Status (0-100%)',
            'Weak Topics Analysis',
            'Attention & Engagement Score',
            'Progress Over Time (graphs)',
            'Learning Style Insights',
            'Achievement Badges',
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildComponentList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(item),
              ))
          .toList(),
    );
  }
}
