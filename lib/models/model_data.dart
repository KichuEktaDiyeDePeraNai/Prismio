/// Data model for 3D models organized by subject category

class ModelCategory {
  final String name;
  final String description;
  final List<ModelItem> models;

  ModelCategory({
    required this.name,
    required this.description,
    required this.models,
  });
}

class ModelItem {
  final String name;
  final String fileName;
  final String description;

  ModelItem({
    required this.name,
    required this.fileName,
    required this.description,
  });
}

/// All available model categories with their models
final List<ModelCategory> modelCategories = [
  // Biology Category
  ModelCategory(
    name: 'Biology',
    description: 'Living organisms and biological structures',
    models: [
      ModelItem(
        name: 'Hornet',
        fileName: 'HORNET.glb',
        description: 'Detailed anatomy of a hornet insect with body segments and stinger',
      ),
      ModelItem(
        name: 'Animal Cell',
        fileName: 'animal_cell_-_downloadable.glb',
        description: 'Internal structure of an animal cell with organelles',
      ),
      ModelItem(
        name: 'Human Heart',
        fileName: 'human_heart_3d_model__anatomy__medical_project.glb',
        description: 'Anatomical model of the human heart showing chambers and valves',
      ),
      ModelItem(
        name: 'Neuron',
        fileName: 'neuron.glb',
        description: 'Structure of a nerve cell with dendrites, axon, and synapses',
      ),
    ],
  ),

  // Information Technology Category
  ModelCategory(
    name: 'Information Technology',
    description: 'Computer hardware and networking components',
    models: [
      ModelItem(
        name: 'Motherboard (ASUS Z170-P)',
        fileName: 'asus_z170-p_motherboard.glb',
        description: 'Computer motherboard with CPU socket and expansion slots',
      ),
      ModelItem(
        name: 'Network Interface Card',
        fileName: 'network_interface_card.glb',
        description: 'Expansion card for network connectivity in computers',
      ),
      ModelItem(
        name: 'Network Router',
        fileName: 'maga_network_router.glb',
        description: 'Network router device for wireless and wired connections',
      ),
      ModelItem(
        name: 'Server Rack',
        fileName: 'network_server_rack.glb',
        description: 'Stacked server infrastructure for data centers',
      ),
      ModelItem(
        name: 'Server Base',
        fileName: 'tall_server_of_base_with_azure_lane_island.glb',
        description: 'Computer server with base infrastructure',
      ),
      ModelItem(
        name: 'Artificial Neural Network',
        fileName: 'artificial_neural_network_ann.glb',
        description: 'AI neural network visualization with interconnected nodes',
      ),
      ModelItem(
        name: 'Quantum Network',
        fileName: 'cylindrical_quantum_network.glb',
        description: 'Cylindrical quantum computing network architecture',
      ),
      ModelItem(
        name: 'Mainboard (Maximus VI Formula)',
        fileName: 'maximus_vi_formula.glb',
        description: 'High-end gaming motherboard with premium components',
      ),
    ],
  ),

  // Office Equipment Category
  ModelCategory(
    name: 'Office Equipment',
    description: 'Business and office devices',
    models: [
      ModelItem(
        name: 'Multifunction Printer',
        fileName: 'mfp_office_printer.glb',
        description: 'All-in-one printer for scanning, copying, and printing',
      ),
    ],
  ),

  // Physics Category
  ModelCategory(
    name: 'Network Concepts',
    description: 'Network topology and architecture concepts',
    models: [
      ModelItem(
        name: 'Network Topologies',
        fileName: 'types_of_network_topologies.glb',
        description: 'Visualization of different network topology types and configurations',
      ),
    ],
  ),
];
