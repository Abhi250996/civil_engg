import 'package:flutter/material.dart';
import '../../../core/utils/calculation_utils.dart';
import '../../../core/utils/validators.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Theme Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);     // Soft White

  final TextEditingController x1Controller = TextEditingController();
  final TextEditingController y1Controller = TextEditingController();
  final TextEditingController x2Controller = TextEditingController();
  final TextEditingController y2Controller = TextEditingController();

  double? distance;

  void calculateDistance() {
    if (!_formKey.currentState!.validate()) return;

    double x1 = double.parse(x1Controller.text);
    double y1 = double.parse(y1Controller.text);
    double x2 = double.parse(x2Controller.text);
    double y2 = double.parse(y2Controller.text);

    setState(() {
      distance = CalculationUtils.distanceBetweenPoints(
        x1: x1, y1: y1, x2: x2, y2: y2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "COORDINATE SURVEY",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),

                  // Point 1 Card
                  _buildPointCard(
                    title: "START POINT (P1)",
                    icon: Icons.location_on_outlined,
                    xCtrl: x1Controller,
                    yCtrl: y1Controller,
                    color: primaryBlue,
                  ),

                  const SizedBox(height: 16),

                  // Point 2 Card
                  _buildPointCard(
                    title: "END POINT (P2)",
                    icon: Icons.flag_outlined,
                    xCtrl: x2Controller,
                    yCtrl: y2Controller,
                    color: accentBlue,
                  ),

                  const SizedBox(height: 32),

                  _buildCalculateButton(),

                  if (distance != null) _buildResultCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentBlue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: accentBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Enter Euclidean coordinates to calculate the linear distance between two points.",
              style: TextStyle(color: primaryBlue.withOpacity(0.7), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard({
    required String title,
    required IconData icon,
    required TextEditingController xCtrl,
    required TextEditingController yCtrl,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCoordinateInput(xCtrl, "X Coordinate")),
              const SizedBox(width: 12),
              Expanded(child: _buildCoordinateInput(yCtrl, "Y Coordinate")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateInput(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      validator: (v) => Validators.validateRequired(v, label),
      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 12),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        onPressed: calculateDistance,
        child: const Text("CALCULATE MEASUREMENT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryBlue, Color(0xFF162D6D)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("CALCULATED DISTANCE", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text(
            distance!.toStringAsFixed(3),
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
          ),
          const Text("UNITS", style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}