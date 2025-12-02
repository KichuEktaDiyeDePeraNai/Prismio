import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/lesson_data.dart';
import '../models/quiz_models.dart';
import '../services/quiz_generator.dart';
import '../widgets/quiz_taking_widget.dart';

/// Page for taking quizzes on lessons
class QuizPage extends StatefulWidget {
  final Lesson lesson;

  const QuizPage({
    super.key,
    required this.lesson,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<Quiz> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = _loadAndGenerateQuiz();
  }

  Future<Quiz> _loadAndGenerateQuiz() async {
    try {
      // Load lesson content
      final lessonContent =
          await rootBundle.loadString('assets/${widget.lesson.assetFileName}');

      // Generate quiz
      final quiz = QuizGenerator.generateQuiz(
        lessonTitle: widget.lesson.title,
        lessonCategory: widget.lesson.category,
        lessonContent: lessonContent,
      );

      return quiz;
    } catch (e) {
      throw Exception('Failed to load quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.lesson.icon, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${widget.lesson.title} Quiz',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade600,
      ),
      body: FutureBuilder<Quiz>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating Quiz...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _quizFuture = _loadAndGenerateQuiz();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final quiz = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.deepPurple.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz: ${widget.lesson.title}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.quiz, color: Colors.deepPurple.shade600),
                        const SizedBox(width: 8),
                        Text('${quiz.totalQuestions} Questions'),
                        const SizedBox(width: 16),
                        Icon(Icons.category, color: Colors.deepPurple.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${quiz.mcqQuestions.length} MCQ, '
                            '${quiz.trueFalseQuestions.length} T/F, '
                            '${quiz.shortAnswerQuestions.length} SA, '
                            '${quiz.fillBlankQuestions.length} FB',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: QuizTakingWidget(quiz: quiz),
              ),
            ],
          );
        },
      ),
    );
  }
}
