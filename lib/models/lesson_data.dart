/// Data model for lessons associated with 3D models
import 'package:flutter/material.dart';

class Lesson {
  final String title;
  final String category;
  final String modelFileName;
  final String assetFileName;
  final String description;
  final IconData icon;

  Lesson({
    required this.title,
    required this.category,
    required this.modelFileName,
    required this.assetFileName,
    required this.description,
    required this.icon,
  });
}

/// All available lessons for models
final List<Lesson> modelLessons = [
  // Biology Lessons
  Lesson(
    title: 'The Mighty Hornet',
    category: 'Biology',
    modelFileName: 'HORNET.glb',
    assetFileName: 'HORNET_LESSON.md',
    description: 'Learn about hornet anatomy, behavior, and ecological importance',
    icon: Icons.science,
  ),
  Lesson(
    title: 'Animal Cell Structure',
    category: 'Biology',
    modelFileName: 'animal_cell_-_downloadable.glb',
    assetFileName: 'ANIMAL_CELL_LESSON.md',
    description: 'Explore the components and functions of a typical animal cell',
    icon: Icons.science,
  ),
  Lesson(
    title: 'Human Heart Anatomy',
    category: 'Biology',
    modelFileName: 'human_heart_3d_model__anatomy__medical_project.glb',
    assetFileName: 'HUMAN_HEART_LESSON.md',
    description: 'Understand the structure and function of the human heart',
    icon: Icons.favorite,
  ),
  Lesson(
    title: 'Neuron Structure',
    category: 'Biology',
    modelFileName: 'neuron.glb',
    assetFileName: 'NEURON_LESSON.md',
    description: 'Discover the anatomy of nerve cells and neural communication',
    icon: Icons.science,
  ),

  // IT Lessons
  Lesson(
    title: 'Computer Motherboard',
    category: 'Information Technology',
    modelFileName: 'asus_z170-p_motherboard.glb',
    assetFileName: 'MOTHERBOARD_LESSON.md',
    description: 'Learn about the main circuit board that connects all computer components',
    icon: Icons.computer,
  ),
  Lesson(
    title: 'Network Interface Card',
    category: 'Information Technology',
    modelFileName: 'network_interface_card.glb',
    assetFileName: 'NIC_LESSON.md',
    description: 'Understand how network interface cards connect computers to networks',
    icon: Icons.computer,
  ),
  Lesson(
    title: 'Network Router',
    category: 'Information Technology',
    modelFileName: 'maga_network_router.glb',
    assetFileName: 'ROUTER_LESSON.md',
    description: 'Explore how routers manage data transmission in networks',
    icon: Icons.hub,
  ),
  Lesson(
    title: 'Server Infrastructure',
    category: 'Information Technology',
    modelFileName: 'network_server_rack.glb',
    assetFileName: 'SERVER_RACK_LESSON.md',
    description: 'Learn about data center infrastructure and server rack organization',
    icon: Icons.computer,
  ),
  Lesson(
    title: 'Artificial Neural Network',
    category: 'Information Technology',
    modelFileName: 'artificial_neural_network_ann.glb',
    assetFileName: 'ANN_LESSON.md',
    description: 'Understand how artificial neural networks simulate human learning',
    icon: Icons.psychology,
  ),
  Lesson(
    title: 'Quantum Network',
    category: 'Information Technology',
    modelFileName: 'cylindrical_quantum_network.glb',
    assetFileName: 'QUANTUM_LESSON.md',
    description: 'Explore quantum computing and quantum network architecture',
    icon: Icons.science,
  ),
  Lesson(
    title: 'Gaming Motherboard',
    category: 'Information Technology',
    modelFileName: 'maximus_vi_formula.glb',
    assetFileName: 'GAMING_MB_LESSON.md',
    description: 'Discover high-performance components for gaming systems',
    icon: Icons.computer,
  ),
  Lesson(
    title: 'Computer Server',
    category: 'Information Technology',
    modelFileName: 'tall_server_of_base_with_azure_lane_island.glb',
    assetFileName: 'SERVER_LESSON.md',
    description: 'Learn about server architecture and data processing',
    icon: Icons.computer,
  ),

  // Office Equipment
  Lesson(
    title: 'Multifunction Office Printer',
    category: 'Office Equipment',
    modelFileName: 'mfp_office_printer.glb',
    assetFileName: 'PRINTER_LESSON.md',
    description: 'Understand how modern multifunction printers work',
    icon: Icons.print,
  ),

  // Network Concepts
  Lesson(
    title: 'Network Topologies',
    category: 'Network Concepts',
    modelFileName: 'types_of_network_topologies.glb',
    assetFileName: 'TOPOLOGIES_LESSON.md',
    description: 'Explore different network topology types and their applications',
    icon: Icons.hub,
  ),
];
