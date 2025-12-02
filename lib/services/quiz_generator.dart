import 'dart:math';
import '../models/quiz_models.dart';

/// Generates quizzes from lesson content
class QuizGenerator {
  static const int _mcqPerQuiz = 5;
  static const int _trueFalsePerQuiz = 3;
  static const int _shortAnswerPerQuiz = 3;
  static const int _fillBlankPerQuiz = 2;

  /// Generate a complete quiz from lesson content
  static Quiz generateQuiz({
    required String lessonTitle,
    required String lessonCategory,
    required String lessonContent,
  }) {
    final random = Random();
    
    // Extract key concepts from lesson
    var concepts = _extractConcepts(lessonContent);
    var facts = _extractFacts(lessonContent);
    var definitions = _extractDefinitions(lessonContent);

    // Fallback: If extraction is too sparse, create default questions
    if (concepts.isEmpty || facts.isEmpty) {
      return _generateDefaultQuiz(lessonTitle, lessonCategory, lessonContent, random);
    }

    // Generate questions with balanced difficulty
    final mcqQuestions = _generateMCQs(
      concepts: concepts,
      facts: facts,
      random: random,
      count: _mcqPerQuiz,
    );

    final trueFalseQuestions = _generateTrueFalse(
      facts: facts,
      concepts: concepts,
      random: random,
      count: _trueFalsePerQuiz,
    );

    final shortAnswerQuestions = _generateShortAnswer(
      definitions: definitions,
      concepts: concepts,
      random: random,
      count: _shortAnswerPerQuiz,
    );

    final fillBlankQuestions = _generateFillBlank(
      facts: facts,
      concepts: concepts,
      random: random,
      count: _fillBlankPerQuiz,
    );

    return Quiz(
      lessonTitle: 'Quiz: $lessonTitle',
      lessonCategory: lessonCategory,
      mcqQuestions: mcqQuestions,
      trueFalseQuestions: trueFalseQuestions,
      shortAnswerQuestions: shortAnswerQuestions,
      fillBlankQuestions: fillBlankQuestions,
    );
  }

  /// Generate a default quiz if extraction fails
  static Quiz _generateDefaultQuiz(
    String lessonTitle,
    String lessonCategory,
    String lessonContent,
    Random random,
  ) {
    return Quiz(
      lessonTitle: 'Quiz: $lessonTitle',
      lessonCategory: lessonCategory,
      mcqQuestions: [
        MCQQuestion(
          difficulty: 'Easy',
          question: 'What topic does this lesson cover?',
          options: [lessonTitle, 'Biology', 'Chemistry', 'Physics'],
          answer: 'A',
          explanation: 'This lesson is about $lessonTitle.',
        ),
        MCQQuestion(
          difficulty: 'Medium',
          question: 'Which category does this lesson belong to?',
          options: [lessonCategory, 'Science', 'Technology', 'History'],
          answer: 'A',
          explanation: 'This lesson is in the $lessonCategory category.',
        ),
      ],
      trueFalseQuestions: [
        TrueFalseQuestion(
          difficulty: 'Easy',
          statement: 'This lesson is educational.',
          answer: true,
        ),
      ],
      shortAnswerQuestions: [
        ShortAnswerQuestion(
          difficulty: 'Medium',
          question: 'What is the main topic of this lesson?',
          answer: lessonTitle,
        ),
      ],
      fillBlankQuestions: [
        FillBlankQuestion(
          difficulty: 'Easy',
          question: 'This lesson is about _____.',
          answer: lessonTitle,
        ),
      ],
    );
  }

  /// Extract key concepts from lesson text
  static List<String> _extractConcepts(String content) {
    final concepts = <String>[];
    
    // Extract headings as concepts
    final headingPattern = RegExp(r'^##\s+(.+)$', multiLine: true);
    for (final match in headingPattern.allMatches(content)) {
      final concept = match.group(1)?.trim() ?? '';
      if (concept.isNotEmpty && !concept.contains('Table of Contents')) {
        concepts.add(concept);
      }
    }

    // Extract bold terms
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    for (final match in boldPattern.allMatches(content)) {
      final term = match.group(1)?.trim() ?? '';
      if (term.isNotEmpty && term.length < 100) {
        concepts.add(term);
      }
    }

    return concepts.toSet().toList(); // Remove duplicates
  }

  /// Extract factual statements from lesson
  static List<String> _extractFacts(String content) {
    final facts = <String>[];
    
    // Split content by sentences and filter substantial ones
    final sentences = content.split(RegExp(r'[.!?]\s+'));
    
    for (final sentence in sentences) {
      final cleaned = sentence.trim();
      if (cleaned.length > 20 &&
          cleaned.length < 300 &&
          !cleaned.contains('Table of Contents') &&
          !cleaned.contains('Click on') &&
          !cleaned.contains('Explore')) {
        facts.add(cleaned);
      }
    }

    return facts.toSet().toList();
  }

  /// Extract definitions from lesson
  static List<Map<String, String>> _extractDefinitions(String content) {
    final definitions = <Map<String, String>>[];
    
    // Extract definitions marked with colons
    final definitionPattern = RegExp(r'\*\*(.+?)\*\*:\s*(.+?)(?=\n|$)');
    for (final match in definitionPattern.allMatches(content)) {
      final term = match.group(1)?.trim() ?? '';
      final def = match.group(2)?.trim() ?? '';
      
      if (term.isNotEmpty && def.isNotEmpty && def.length < 300) {
        definitions.add({
          'term': term,
          'definition': def,
        });
      }
    }

    return definitions;
  }

  /// Generate MCQ questions
  static List<MCQQuestion> _generateMCQs({
    required List<String> concepts,
    required List<String> facts,
    required Random random,
    required int count,
  }) {
    final questions = <MCQQuestion>[];
    final used = <String>{};

    while (questions.length < count && (concepts.isNotEmpty || facts.isNotEmpty)) {
      // Randomly select a fact as correct answer
      if (facts.isEmpty) break;
      
      final correctFact = facts[random.nextInt(facts.length)];
      if (used.contains(correctFact)) continue;
      used.add(correctFact);

      // Create question and distractors
      final question = _createMCQQuestion(
        fact: correctFact,
        concepts: concepts,
        facts: facts,
        random: random,
      );

      if (question != null) {
        questions.add(question);
      }
    }

    return questions;
  }

  /// Create a single MCQ question
  static MCQQuestion? _createMCQQuestion({
    required String fact,
    required List<String> concepts,
    required List<String> facts,
    required Random random,
  }) {
    // Normalize fact for question format
    final questionText = _normalizeText(fact);
    if (questionText.isEmpty || questionText.length > 200) return null;

    // Create correct answer
    final correctAnswer = _createAnswer(fact);

    // Create distractors
    final distractors = <String>{};
    while (distractors.length < 3) {
      final pool = random.nextBool() ? concepts : facts;
      if (pool.isEmpty) break;
      
      final distractor = pool[random.nextInt(pool.length)];
      if (distractor != fact && distractor != correctAnswer) {
        distractors.add(_createAnswer(distractor));
      }
    }

    if (distractors.length < 3) return null;

    // Shuffle options and find correct answer position
    final options = [correctAnswer, ...distractors.toList()]..shuffle(random);
    final correctIndex = options.indexOf(correctAnswer);
    final answerLetter = String.fromCharCode(65 + correctIndex); // A, B, C, D

    return MCQQuestion(
      difficulty: _getDifficulty(random),
      question: "Which of the following is true? $questionText",
      options: options,
      answer: answerLetter,
      explanation: _generateExplanation(fact),
    );
  }

  /// Generate True/False questions
  static List<TrueFalseQuestion> _generateTrueFalse({
    required List<String> facts,
    required List<String> concepts,
    required Random random,
    required int count,
  }) {
    final questions = <TrueFalseQuestion>[];
    final used = <String>{};

    while (questions.length < count) {
      if (facts.isEmpty) break;
      
      final fact = facts[random.nextInt(facts.length)];
      if (used.contains(fact)) continue;
      used.add(fact);

      final isTrue = random.nextBool();
      final statement = isTrue
          ? _normalizeText(fact)
          : _createFalsification(fact);

      if (statement.isNotEmpty) {
        questions.add(TrueFalseQuestion(
          difficulty: _getDifficulty(random),
          statement: statement,
          answer: isTrue,
        ));
      }
    }

    return questions;
  }

  /// Generate Short Answer questions
  static List<ShortAnswerQuestion> _generateShortAnswer({
    required List<Map<String, String>> definitions,
    required List<String> concepts,
    required Random random,
    required int count,
  }) {
    final questions = <ShortAnswerQuestion>[];
    final used = <String>{};

    while (questions.length < count) {
      if (definitions.isEmpty) break;
      
      final def = definitions[random.nextInt(definitions.length)];
      final key = def['term'] ?? '';
      
      if (used.contains(key)) continue;
      used.add(key);

      questions.add(ShortAnswerQuestion(
        difficulty: _getDifficulty(random),
        question: "Define or explain: ${def['term']}",
        answer: def['definition'] ?? '',
      ));
    }

    return questions;
  }

  /// Generate Fill in the Blank questions
  static List<FillBlankQuestion> _generateFillBlank({
    required List<String> facts,
    required List<String> concepts,
    required Random random,
    required int count,
  }) {
    final questions = <FillBlankQuestion>[];
    final used = <String>{};

    while (questions.length < count) {
      final pool = random.nextBool() ? facts : concepts;
      if (pool.isEmpty) break;
      
      final text = pool[random.nextInt(pool.length)];
      if (used.contains(text)) continue;
      used.add(text);

      // Extract a word to be the answer
      final words = text.split(RegExp(r'\s+'));
      if (words.length < 3) continue;

      final answerIndex = random.nextInt(words.length);
      final answer = words[answerIndex];

      if (answer.length < 3 || answer.contains(RegExp(r'[.,:;!?]'))) continue;

      words[answerIndex] = '_____';
      final question = words.join(' ');

      questions.add(FillBlankQuestion(
        difficulty: _getDifficulty(random),
        question: question,
        answer: answer,
      ));
    }

    return questions;
  }

  /// Get random difficulty (30% Easy, 40% Medium, 30% Hard)
  static String _getDifficulty(Random random) {
    final value = random.nextDouble();
    if (value < 0.3) return 'Easy';
    if (value < 0.7) return 'Medium';
    return 'Hard';
  }

  /// Normalize text for questions
  static String _normalizeText(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\[.+?\]\(.+?\)'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Create answer from fact
  static String _createAnswer(String text) {
    final cleaned = _normalizeText(text);
    if (cleaned.length > 100) {
      return cleaned.substring(0, 100) + '...';
    }
    return cleaned;
  }

  /// Create false statement (falsification)
  static String _falsification(String text) {
    final words = text.split(' ');
    if (words.isEmpty) return text;
    
    // Replace key terms
    final falsified = text
        .replaceAll(RegExp(r'increases?'), 'decreases')
        .replaceAll(RegExp(r'decreases?'), 'increases')
        .replaceAll(RegExp(r'yes|true'), 'no')
        .replaceAll(RegExp(r'no|false'), 'yes')
        .replaceAll('are', 'are not')
        .replaceAll('is', 'is not');

    if (falsified == text) {
      return 'The opposite of: $text';
    }
    return falsified;
  }

  /// Create falsification
  static String _createFalsification(String text) {
    return _falsification(text);
  }

  /// Generate explanation for MCQ answer
  static String _generateExplanation(String fact) {
    final cleaned = _normalizeText(fact);
    if (cleaned.length > 150) {
      return cleaned.substring(0, 150) + '...';
    }
    return cleaned;
  }
}
