import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/lesson_data.dart';
import 'quiz_page.dart';

/// Generic lesson page that can display any lesson with 3D model
class ModelLessonPage extends StatefulWidget {
  final Lesson lesson;

  const ModelLessonPage({
    super.key,
    required this.lesson,
  });

  @override
  State<ModelLessonPage> createState() => _ModelLessonPageState();
}

class _ModelLessonPageState extends State<ModelLessonPage> {
  String _markdownContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkdownContent();
  }

  Future<void> _loadMarkdownContent() async {
    try {
      final content = await rootBundle.loadString('assets/${widget.lesson.assetFileName}');
      setState(() {
        _markdownContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _markdownContent = '# Error\nCould not load the lesson content: $e';
        _isLoading = false;
      });
    }
  }

  void _show3DModelDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header with close button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(widget.lesson.icon, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              '🎨 Interactive 3D ${widget.lesson.title} Model',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // 3D Model Viewer
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ModelViewer(
                        backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                        src: 'assets/models/${widget.lesson.modelFileName}',
                        alt: '${widget.lesson.title} 3D Model',
                        ar: true,
                        autoRotate: true,
                        cameraControls: true,
                        disableZoom: false,
                      ),
                    ),
                  ),
                ),
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    '🎮 Drag to rotate • 🔍 Scroll to zoom • 📱 AR available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                '${widget.lesson.title} Lesson',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _show3DModelDialog,
                            icon: const Icon(Icons.view_in_ar),
                            label: const Text('3D Model'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(lesson: widget.lesson),
                                ),
                              );
                            },
                            icon: const Icon(Icons.quiz),
                            label: const Text('Quiz'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Markdown(
                    data: _markdownContent,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: Theme.of(context).textTheme.headlineLarge,
                      h2: Theme.of(context).textTheme.headlineMedium,
                      h3: Theme.of(context).textTheme.headlineSmall,
                      p: Theme.of(context).textTheme.bodyMedium,
                      code: const TextStyle(
                        backgroundColor: Color(0xFFF5F5F5),
                        fontFamily: 'monospace',
                      ),
                      blockquote: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
