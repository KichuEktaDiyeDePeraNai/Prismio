import 'package:flutter/material.dart';
import 'dart:convert';
import 'prismio_content_generator.dart';

/// Service to generate and manage Prismio content
class PrismioContentService {
  /// Generate complete learning content from lesson
  static Future<Map<String, dynamic>> generateLearningContent({
    required String lessonTitle,
    required String lessonCategory,
    required String lessonContent,
  }) async {
    try {
      // Generate content using the comprehensive generator
      final content = PrismioContentGenerator.generateCompleteLearningContent(
        lessonTitle: lessonTitle,
        lessonCategory: lessonCategory,
        lessonContent: lessonContent,
      );

      return {
        'success': true,
        'data': content,
        'timestamp': DateTime.now(),
      };
    } catch (e) {
      debugPrint('Error generating content: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Export content as JSON
  static String exportAsJson(Map<String, dynamic> content) {
    return jsonEncode(content);
  }

  /// Get quiz set from generated content
  static Map<String, dynamic>? getQuizSet(Map<String, dynamic> content) {
    return content['quiz'] as Map<String, dynamic>?;
  }

  /// Get flashcards from generated content
  static List<dynamic>? getFlashcards(Map<String, dynamic> content) {
    return content['flashcards'] as List<dynamic>?;
  }

  /// Get memory palace structure
  static Map<String, dynamic>? getMemoryPalace(Map<String, dynamic> content) {
    return content['memory_palace'] as Map<String, dynamic>?;
  }

  /// Get story mode
  static Map<String, dynamic>? getStoryMode(Map<String, dynamic> content) {
    return content['story_mode'] as Map<String, dynamic>?;
  }

  /// Get 3D object suggestions
  static List<dynamic>? get3DObjects(Map<String, dynamic> content) {
    return content['3d_objects'] as List<dynamic>?;
  }

  /// Get analytics dashboard design
  static Map<String, dynamic>? getAnalyticsDashboard(
    Map<String, dynamic> content,
  ) {
    return content['analytics'] as Map<String, dynamic>?;
  }

  /// Get homepage UI design
  static Map<String, dynamic>? getHomepageUI(Map<String, dynamic> content) {
    return content['homepage_ui'] as Map<String, dynamic>?;
  }
}
