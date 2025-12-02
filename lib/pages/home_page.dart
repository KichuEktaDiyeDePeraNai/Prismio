import 'package:flutter/material.dart';
import '../services/file_picker_service.dart';
import '../widgets/control_buttons_widget.dart';
import '../widgets/model_info_widget.dart';
import '../widgets/model_viewer_widget.dart';
import '../widgets/models_category_widget.dart';

/// Home page widget that manages the 3D model viewer state
class HomePage extends StatefulWidget {
  final String title;

  const HomePage({
    super.key,
    required this.title,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedFilePath;
  bool _isLoadingFile = false;
  int _selectedTabIndex = 0;

  /// Handles picking a GLB file from device storage
  Future<void> _pickGlbFile() async {
    setState(() {
      _isLoadingFile = true;
    });

    try {
      final filePath = await FilePickerService.pickGlbFile();

      if (filePath != null) {
        setState(() {
          _selectedFilePath = filePath;
          _isLoadingFile = false;
        });

        _showSuccessMessage(
            'Loaded: ${FilePickerService.getFileName(filePath)}');
      } else {
        setState(() {
          _isLoadingFile = false;
        });
      }
    } on FilePickerException catch (e) {
      setState(() {
        _isLoadingFile = false;
      });
      _showErrorMessage(e.toString());
    } catch (e) {
      setState(() {
        _isLoadingFile = false;
      });
      _showErrorMessage('Unexpected error: $e');
    }
  }

  /// Resets to the default HORNET model
  void _resetToDefault() {
    setState(() {
      _selectedFilePath = null;
    });

    _showInfoMessage('Reset to default HORNET model');
  }

  /// Shows a success message using SnackBar
  void _showSuccessMessage(String message) {
    _showSnackBar(message, Colors.green);
  }

  /// Shows an error message using SnackBar
  void _showErrorMessage(String message) {
    _showSnackBar(message, Colors.red);
  }

  /// Shows an info message using SnackBar
  void _showInfoMessage(String message) {
    _showSnackBar(message, Colors.blue);
  }

  /// Shows a SnackBar with the given message and color
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Navigator.pushNamed(context, '/lesson');
            },
            tooltip: 'Open Hornet Lesson',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetToDefault,
            tooltip: 'Reset to default model',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    context,
                    'Viewer',
                    Icons.view_in_ar,
                    0,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    context,
                    'Models',
                    Icons.grid_on,
                    1,
                  ),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildViewerTab()
                : _buildModelsTab(),
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: _pickGlbFile,
              tooltip: 'Pick GLB file from device',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Builds a tab button for switching between views
  Widget _buildTabButton(
    BuildContext context,
    String label,
    IconData icon,
    int tabIndex,
  ) {
    final isActive = _selectedTabIndex == tabIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = tabIndex;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the viewer tab with 3D model display
  Widget _buildViewerTab() {
    return Column(
      children: [
        ControlButtonsWidget(
          isLoading: _isLoadingFile,
          onPickFile: _pickGlbFile,
          onResetToDefault: _resetToDefault,
        ),
        // Lesson Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/lesson');
            },
            icon: const Icon(Icons.school, color: Colors.white),
            label: const Text(
              'Open Hornet Biology Lesson',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        ModelInfoWidget(
          selectedFilePath: _selectedFilePath,
        ),
        const SizedBox(height: 16),
        ModelViewerWidget(
          selectedFilePath: _selectedFilePath,
        ),
      ],
    );
  }

  /// Builds the models tab with category list
  Widget _buildModelsTab() {
    return ModelsCategoryWidget(
      onModelSelected: (modelPath) {
        setState(() {
          _selectedFilePath = modelPath;
          _selectedTabIndex = 0; // Switch to viewer tab
        });
      },
    );
  }
}
