import 'package:flutter/material.dart';
import '../models/quiz_models.dart';

/// Widget for taking a quiz
class QuizTakingWidget extends StatefulWidget {
  final Quiz quiz;

  const QuizTakingWidget({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizTakingWidget> createState() => _QuizTakingWidgetState();
}

class _QuizTakingWidgetState extends State<QuizTakingWidget> {
  late List<QuizQuestion> allQuestions;
  int currentQuestionIndex = 0;
  final Map<int, dynamic> userAnswers = {};
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    allQuestions = [
      ...widget.quiz.mcqQuestions,
      ...widget.quiz.trueFalseQuestions,
      ...widget.quiz.shortAnswerQuestions,
      ...widget.quiz.fillBlankQuestions,
    ]..shuffle();
  }

  void _submitAnswer(dynamic answer) {
    setState(() {
      userAnswers[currentQuestionIndex] = answer;
      if (currentQuestionIndex < allQuestions.length - 1) {
        currentQuestionIndex++;
      } else {
        showResults = true;
      }
    });
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  int _calculateScore() {
    int correct = 0;
    
    for (int i = 0; i < allQuestions.length; i++) {
      final question = allQuestions[i];
      final userAnswer = userAnswers[i];

      if (question is MCQQuestion) {
        if (userAnswer == question.answer) correct++;
      } else if (question is TrueFalseQuestion) {
        if (userAnswer == question.answer) correct++;
      } else if (question is ShortAnswerQuestion) {
        if (_compareAnswers(userAnswer, question.answer)) correct++;
      } else if (question is FillBlankQuestion) {
        if (_compareAnswers(userAnswer, question.answer)) correct++;
      }
    }

    return correct;
  }

  bool _compareAnswers(dynamic userAnswer, String correctAnswer) {
    if (userAnswer == null) return false;
    return userAnswer.toString().toLowerCase().trim() ==
        correctAnswer.toLowerCase().trim();
  }

  @override
  Widget build(BuildContext context) {
    if (showResults) {
      return _buildResultsScreen();
    }

    final question = allQuestions[currentQuestionIndex];
    
    return Column(
      children: [
        // Progress bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${allQuestions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Chip(
                    label: Text(question.difficulty),
                    backgroundColor: _getDifficultyColor(question.difficulty),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / allQuestions.length,
                minHeight: 8,
              ),
            ],
          ),
        ),
        // Question content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildQuestionContent(question),
          ),
        ),
        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              ElevatedButton.icon(
                onPressed: currentQuestionIndex < allQuestions.length - 1
                    ? _nextQuestion
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent(QuizQuestion question) {
    if (question is MCQQuestion) {
      return _buildMCQQuestion(question);
    } else if (question is TrueFalseQuestion) {
      return _buildTrueFalseQuestion(question);
    } else if (question is ShortAnswerQuestion) {
      return _buildShortAnswerQuestion(question);
    } else if (question is FillBlankQuestion) {
      return _buildFillBlankQuestion(question);
    }
    return const SizedBox.shrink();
  }

  Widget _buildMCQQuestion(MCQQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          question.options.length,
          (index) {
            final optionLetter = String.fromCharCode(65 + index);
            final isSelected =
                userAnswers[currentQuestionIndex] == optionLetter;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _submitAnswer(optionLetter),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? Colors.blue.shade50
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Text(
                            optionLetter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (userAnswers.containsKey(currentQuestionIndex))
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Explanation: ${question.explanation}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  Widget _buildTrueFalseQuestion(TrueFalseQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.statement,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildTrueFalseButton(true, question),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTrueFalseButton(false, question),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrueFalseButton(
    bool value,
    TrueFalseQuestion question,
  ) {
    final isSelected = userAnswers[currentQuestionIndex] == value;

    return GestureDetector(
      onTap: () => _submitAnswer(value),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            value ? 'True' : 'False',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortAnswerQuestion(ShortAnswerQuestion question) {
    final controller = TextEditingController(
      text: userAnswers[currentQuestionIndex] ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          minLines: 4,
          maxLines: 6,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Type your answer here...',
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: (value) {
            userAnswers[currentQuestionIndex] = value;
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _submitAnswer(controller.text),
          icon: const Icon(Icons.check),
          label: const Text('Submit Answer'),
        ),
      ],
    );
  }

  Widget _buildFillBlankQuestion(FillBlankQuestion question) {
    final controller = TextEditingController(
      text: userAnswers[currentQuestionIndex] ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Fill in the blank...',
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: (value) {
            userAnswers[currentQuestionIndex] = value;
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _submitAnswer(controller.text),
          icon: const Icon(Icons.check),
          label: const Text('Submit Answer'),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final score = _calculateScore();
    final percentage = ((score / allQuestions.length) * 100).toStringAsFixed(1);
    final passed = score >= (allQuestions.length * 0.6); // 60% pass

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Icon(
                  passed ? Icons.check_circle : Icons.info,
                  size: 80,
                  color: passed ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  passed ? 'Excellent!' : 'Good Effort!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score / ${allQuestions.length} Correct ($percentage%)',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Results Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildScoreRow('MCQ', _countCorrectByType(MCQQuestion)),
                _buildScoreRow('True/False', _countCorrectByType(TrueFalseQuestion)),
                _buildScoreRow('Short Answer', _countCorrectByType(ShortAnswerQuestion)),
                _buildScoreRow('Fill in the Blank', _countCorrectByType(FillBlankQuestion)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex = 0;
                        userAnswers.clear();
                        showResults = false;
                        _initializeQuiz();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake Quiz'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String type, Map<String, int> scores) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type),
          Text('${scores['correct']} / ${scores['total']}'),
        ],
      ),
    );
  }

  Map<String, int> _countCorrectByType(Type questionType) {
    int correct = 0;
    int total = 0;

    for (int i = 0; i < allQuestions.length; i++) {
      if (allQuestions[i].runtimeType == questionType) {
        total++;
        if (userAnswers.containsKey(i)) {
          final question = allQuestions[i];
          final userAnswer = userAnswers[i];

          bool isCorrect = false;
          if (question is MCQQuestion) {
            isCorrect = userAnswer == question.answer;
          } else if (question is TrueFalseQuestion) {
            isCorrect = userAnswer == question.answer;
          } else if (question is ShortAnswerQuestion) {
            isCorrect = _compareAnswers(userAnswer, question.answer);
          } else if (question is FillBlankQuestion) {
            isCorrect = _compareAnswers(userAnswer, question.answer);
          }

          if (isCorrect) correct++;
        }
      }
    }

    return {'correct': correct, 'total': total};
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green.shade200;
      case 'Medium':
        return Colors.orange.shade200;
      case 'Hard':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
