import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class StructureInputScreen extends StatefulWidget {
  const StructureInputScreen({super.key});

  @override
  State<StructureInputScreen> createState() => _StructureInputScreenState();
}

class _StructureInputScreenState extends State<StructureInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const primaryBlue = Color(0xFF1E3A8A);
  static const accentBlue = Color(0xFF3B82F6);
  static const bgColor = Color(0xFFF8FAFC);

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  /// REGULATIONS
  final frontSetbackController = TextEditingController(text: "1.5");
  final rearSetbackController = TextEditingController(text: "1.0");
  final sideSetbackController = TextEditingController(text: "1.0");

  /// BUILDING
  final floorsController = TextEditingController(text: "1");
  final roomsController = TextEditingController(text: "2");
  final floorHeightController = TextEditingController(text: "3.0");

  /// STRUCTURE
  final soilController = TextEditingController(text: "150");
  final seismicZoneController = TextEditingController(text: "3");
  final loadController = TextEditingController(text: "50");

  /// ROAD / INDUSTRY
  final thicknessController = TextEditingController(text: "200");

  /// DROPDOWNS
  String orientation = "North";
  String unitSystem = "Metric";
  String drawingScale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  late String structureType;

  @override
  void initState() {
    super.initState();
    structureType = (Get.arguments?["type"] ?? "building").toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "${structureType.toUpperCase()} DESIGNER",
          style: const TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryBlue),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 1100 : 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PROJECT
                      _sectionTitle("Project Information"),
                      _buildResponsiveLayout(
                        isDesktop: isDesktop,
                        children: [
                          _buildTextField(
                            projectNameController,
                            "Project Name",
                            Icons.work,
                          ),
                          _buildTextField(
                            locationController,
                            "Location",
                            Icons.location_city,
                          ),
                          _buildDropdown(
                            "Units",
                            unitSystem,
                            ["Metric", "Imperial"],
                            (v) => setState(() => unitSystem = v!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SITE
                      _sectionTitle("Site Geometry"),
                      _buildResponsiveLayout(
                        isDesktop: isDesktop,
                        children: [
                          _buildTextField(
                            lengthController,
                            "Plot Length (m)",
                            Icons.straighten,
                            isNum: true,
                          ),
                          _buildTextField(
                            widthController,
                            "Plot Width (m)",
                            Icons.square_foot,
                            isNum: true,
                          ),
                          _buildDropdown(
                            "Orientation",
                            orientation,
                            ["North", "South", "East", "West"],
                            (v) => setState(() => orientation = v!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SETBACKS
                      if (structureType == "building") ...[
                        _sectionTitle("Regulatory Setbacks"),
                        _buildResponsiveLayout(
                          isDesktop: isDesktop,
                          children: [
                            _buildTextField(
                              frontSetbackController,
                              "Front Setback (m)",
                              Icons.arrow_upward,
                              isNum: true,
                            ),
                            _buildTextField(
                              rearSetbackController,
                              "Rear Setback (m)",
                              Icons.arrow_downward,
                              isNum: true,
                            ),
                            _buildTextField(
                              sideSetbackController,
                              "Side Setback (m)",
                              Icons.arrow_back,
                              isNum: true,
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 25),

                      /// BUILDING PROGRAM
                      if (structureType == "building") ...[
                        _sectionTitle("Building Program"),
                        _buildResponsiveLayout(
                          isDesktop: isDesktop,
                          children: [
                            _buildTextField(
                              floorsController,
                              "Floors",
                              Icons.layers,
                              isNum: true,
                            ),
                            _buildTextField(
                              roomsController,
                              "Rooms / BHK",
                              Icons.bed,
                              isNum: true,
                            ),
                            _buildTextField(
                              floorHeightController,
                              "Floor Height (m)",
                              Icons.height,
                              isNum: true,
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 25),

                      /// STRUCTURE
                      _sectionTitle("Structural Parameters"),
                      _buildResponsiveLayout(
                        isDesktop: isDesktop,
                        children: [
                          _buildTextField(
                            soilController,
                            "Soil Bearing Capacity (kN/m²)",
                            Icons.terrain,
                            isNum: true,
                          ),
                          _buildTextField(
                            seismicZoneController,
                            "Seismic Zone",
                            Icons.warning,
                            isNum: true,
                          ),
                          _buildTextField(
                            loadController,
                            "Design Load",
                            Icons.fitness_center,
                            isNum: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// ROAD
                      if (structureType == "road") ...[
                        _sectionTitle("Road Parameters"),
                        _buildResponsiveLayout(
                          isDesktop: isDesktop,
                          children: [
                            _buildTextField(
                              lengthController,
                              "Road Length (km)",
                              Icons.add_road,
                              isNum: true,
                            ),
                            _buildTextField(
                              widthController,
                              "Carriageway Width (m)",
                              Icons.width_full,
                              isNum: true,
                            ),
                            _buildTextField(
                              thicknessController,
                              "Pavement Thickness (mm)",
                              Icons.layers,
                              isNum: true,
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 25),

                      /// DRAWING SETTINGS
                      _sectionTitle("Drawing Preferences"),
                      _buildResponsiveLayout(
                        isDesktop: isDesktop,
                        children: [
                          _buildDropdown(
                            "Scale",
                            drawingScale,
                            ["1:50", "1:100", "1:200"],
                            (v) => setState(() => drawingScale = v!),
                          ),
                          _buildDropdown(
                            "Sheet Size",
                            sheetSize,
                            ["A0", "A1", "A2", "A3"],
                            (v) => setState(() => sheetSize = v!),
                          ),
                          _buildDropdown(
                            "Detail Level",
                            detailLevel,
                            ["Concept", "Standard", "Construction"],
                            (v) => setState(() => detailLevel = v!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildGenerateButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// BUTTON
  Widget _buildGenerateButton() {
    return SizedBox(
      height: 60,
      child: Obx(
        () => ElevatedButton.icon(
          icon: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.architecture),
          label: Text(
            controller.isLoading.value
                ? "PROCESSING..."
                : "GENERATE PROFESSIONAL DRAWING",
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                        "unit": unitSystem,
                      },

                      "site": {
                        "length": lengthController.text,
                        "width": widthController.text,
                        "orientation": orientation,
                      },

                      "regulations": {
                        "frontSetback": frontSetbackController.text,
                        "rearSetback": rearSetbackController.text,
                        "sideSetback": sideSetbackController.text,
                      },

                      "building": {
                        "floors": floorsController.text,
                        "rooms": roomsController.text,
                        "floorHeight": floorHeightController.text,
                      },

                      "structure": {
                        "soilBearingCapacity": soilController.text,
                        "seismicZone": seismicZoneController.text,
                        "designLoad": loadController.text,
                      },

                      "drawing": {
                        "scale": drawingScale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: structureType,
                      inputData: data,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /// COMPONENTS

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w900, color: primaryBlue),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isNum = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accentBlue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResponsiveLayout({
    required bool isDesktop,
    required List<Widget> children,
  }) {
    if (isDesktop) {
      return Row(
        children: children
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: c,
                ),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: children
          .map(
            (c) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
          )
          .toList(),
    );
  }
}
