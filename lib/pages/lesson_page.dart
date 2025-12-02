import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  String _markdownContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkdownContent();
  }

  Future<void> _loadMarkdownContent() async {
    try {
      final content = await rootBundle.loadString('assets/HORNET_LESSON.md');
      setState(() {
        _markdownContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _markdownContent = '# Error\nCould not load the lesson content.';
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
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🐝 Interactive 3D Hornet Model',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.black),
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
                      child: const ModelViewer(
                        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                        src: 'assets/models/HORNET.glb',
                        alt: 'Interactive 3D Hornet Model',
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
        title: const Row(
          children: [
            Icon(Icons.menu_book, color: Colors.white),
            SizedBox(width: 8),
            Text('Hornet Biology Lesson', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                  SizedBox(height: 16),
                  Text('Loading lesson content...'),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.amber.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Markdown(
                data: _markdownContent,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  h2: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                  h3: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade700,
                  ),
                  p: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  listBullet: TextStyle(color: Colors.amber.shade600),
                  blockquote: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  code: TextStyle(
                    backgroundColor: Colors.grey.shade100,
                    fontFamily: 'monospace',
                  ),
                ),
                imageBuilder: (uri, title, alt) {
                  // Check if this is our hornet image
                  if (uri.path.contains('hornet') || uri.path.contains('Hornet')) {
                    return GestureDetector(
                      onTap: _show3DModelDialog,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Hornet.jpg',
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text('Hornet Image\n(Click to view 3D model)'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Overlay with click indicator
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.view_in_ar,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap to view 3D model',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  
                  // For other images, return default handling
                  return Image.asset(
                    uri.path.startsWith('assets/') ? uri.path : 'assets/${uri.path}',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Image not found'),
                      );
                    },
                  );
                },
                onTapLink: (text, href, title) {
                  // Handle other links if needed
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _show3DModelDialog,
        backgroundColor: Colors.amber.shade600,
        icon: const Icon(Icons.view_in_ar, color: Colors.white),
        label: const Text(
          'View 3D Model',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}