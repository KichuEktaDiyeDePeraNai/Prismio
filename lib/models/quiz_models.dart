/// Quiz data models for the Good Doctor AR learning app

abstract class QuizQuestion {
  final String difficulty; // Easy, Medium, Hard
  final String questionType; // MCQ, TrueFalse, ShortAnswer, FillBlank

  QuizQuestion({
    required this.difficulty,
    required this.questionType,
  });

  Map<String, dynamic> toJson();
}

class MCQQuestion extends QuizQuestion {
  final String question;
  final List<String> options; // [A, B, C, D]
  final String answer; // Correct option letter
  final String explanation;

  MCQQuestion({
    required String difficulty,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  }) : super(difficulty: difficulty, questionType: 'MCQ');

  @override
  Map<String, dynamic> toJson() => {
    'difficulty': difficulty,
    'question': question,
    'options': options,
    'answer': answer,
    'explanation': explanation,
  };
}

class TrueFalseQuestion extends QuizQuestion {
  final String statement;
  final bool answer; // true or false

  TrueFalseQuestion({
    required String difficulty,
    required this.statement,
    required this.answer,
  }) : super(difficulty: difficulty, questionType: 'TrueFalse');

  @override
  Map<String, dynamic> toJson() => {
    'difficulty': difficulty,
    'statement': statement,
    'answer': answer,
  };
}

class ShortAnswerQuestion extends QuizQuestion {
  final String question;
  final String answer;

  ShortAnswerQuestion({
    required String difficulty,
    required this.question,
    required this.answer,
  }) : super(difficulty: difficulty, questionType: 'ShortAnswer');

  @override
  Map<String, dynamic> toJson() => {
    'difficulty': difficulty,
    'question': question,
    'answer': answer,
  };
}

class FillBlankQuestion extends QuizQuestion {
  final String question; // Contains _____ for blank
  final String answer;

  FillBlankQuestion({
    required String difficulty,
    required this.question,
    required this.answer,
  }) : super(difficulty: difficulty, questionType: 'FillBlank');

  @override
  Map<String, dynamic> toJson() => {
    'difficulty': difficulty,
    'question': question,
    'answer': answer,
  };
}

class Quiz {
  final String lessonTitle;
  final String lessonCategory;
  final List<MCQQuestion> mcqQuestions;
  final List<TrueFalseQuestion> trueFalseQuestions;
  final List<ShortAnswerQuestion> shortAnswerQuestions;
  final List<FillBlankQuestion> fillBlankQuestions;

  Quiz({
    required this.lessonTitle,
    required this.lessonCategory,
    required this.mcqQuestions,
    required this.trueFalseQuestions,
    required this.shortAnswerQuestions,
    required this.fillBlankQuestions,
  });

  int get totalQuestions =>
      mcqQuestions.length +
      trueFalseQuestions.length +
      shortAnswerQuestions.length +
      fillBlankQuestions.length;

  Map<String, dynamic> toJson() => {
    'lessonTitle': lessonTitle,
    'lessonCategory': lessonCategory,
    'totalQuestions': totalQuestions,
    'mcq': mcqQuestions.map((q) => q.toJson()).toList(),
    'true_false': trueFalseQuestions.map((q) => q.toJson()).toList(),
    'short_answer': shortAnswerQuestions.map((q) => q.toJson()).toList(),
    'fill_blank': fillBlankQuestions.map((q) => q.toJson()).toList(),
  };
}

class QuizDifficultyDistribution {
  final int easyCount;
  final int mediumCount;
  final int hardCount;

  QuizDifficultyDistribution({
    this.easyCount = 3,
    this.mediumCount = 4,
    this.hardCount = 3,
  });

  int get total => easyCount + mediumCount + hardCount;
}
