import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_project/core/utils/app_scaffold.dart';

class GpsToolScreen extends StatefulWidget {
  const GpsToolScreen({super.key});

  @override
  State<GpsToolScreen> createState() => _GpsToolScreenState();
}

class _GpsToolScreenState extends State<GpsToolScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  String latitude = "--";
  String longitude = "--";
  String accuracy = "--";

  List<Position> surveyPoints = [];
  double totalDistance = 0;
  double polygonArea = 0;

  /// ================= LOCATION =================
  Future<Position?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enable GPS")));
      return null;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> updateLocation() async {
    final pos = await getLocation();
    if (pos == null) return;

    setState(() {
      latitude = pos.latitude.toStringAsFixed(6);
      longitude = pos.longitude.toStringAsFixed(6);
      accuracy = "${pos.accuracy.toStringAsFixed(2)} m";
    });
  }

  Future<void> addSurveyPoint() async {
    final pos = await getLocation();
    if (pos == null) return;

    setState(() {
      if (surveyPoints.isNotEmpty) {
        totalDistance += Geolocator.distanceBetween(
          surveyPoints.last.latitude,
          surveyPoints.last.longitude,
          pos.latitude,
          pos.longitude,
        );
      }

      surveyPoints.add(pos);
      polygonArea = calculatePolygonArea();
    });
  }

  void clearSurvey() {
    setState(() {
      surveyPoints.clear();
      totalDistance = 0;
      polygonArea = 0;
    });
  }

  double calculatePolygonArea() {
    if (surveyPoints.length < 3) return 0;

    double area = 0;

    for (int i = 0; i < surveyPoints.length; i++) {
      int j = (i + 1) % surveyPoints.length;

      area += surveyPoints[i].latitude * surveyPoints[j].longitude;
      area -= surveyPoints[j].latitude * surveyPoints[i].longitude;
    }

    return (area.abs() / 2) * 111139 * 111139;
  }

  /// ================= UI =================

  Widget infoTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget card(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget button(String text, VoidCallback onTap) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "GPS Survey Tool",
      showBack: true,
      child: Container(
        /// 🔥 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// HEADER
                  const Text(
                    "GPS SURVEY TOOL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CONTENT (NO SCROLL ON DESKTOP)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 700;

                        return isMobile ? _mobileLayout() : _desktopLayout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= MOBILE =================
  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _locationCard(),
          const SizedBox(height: 16),
          _surveyCard(),
          const SizedBox(height: 16),
          if (surveyPoints.isNotEmpty) _listCard(),
          const SizedBox(height: 16),
          _mapCard(),
        ],
      ),
    );
  }

  /// ================= DESKTOP =================
  Widget _desktopLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _locationCard()),
            const SizedBox(width: 16),
            Expanded(child: _surveyCard()),
          ],
        ),

        const SizedBox(height: 16),

        Expanded(
          child: Row(
            children: [
              Expanded(child: _mapCard()),
              const SizedBox(width: 16),
              Expanded(child: _listCard()),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= CARDS =================

  Widget _locationCard() {
    return card(
      "CURRENT LOCATION",
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              infoTile("LAT", latitude),
              infoTile("LNG", longitude),
              infoTile("ACC", accuracy),
            ],
          ),
          const SizedBox(height: 16),
          button("GET LOCATION", updateLocation),
        ],
      ),
    );
  }

  Widget _surveyCard() {
    return card(
      "SURVEY",
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button("ADD POINT", addSurveyPoint),
              const SizedBox(width: 10),
              button("CLEAR", clearSurvey),
            ],
          ),
          const SizedBox(height: 16),
          Text("Points: ${surveyPoints.length}"),
          Text("Distance: ${totalDistance.toStringAsFixed(2)} m"),
          Text("Area: ${(polygonArea / 10000).toStringAsFixed(4)} ha"),
        ],
      ),
    );
  }

  Widget _listCard() {
    return card(
      "POINTS",
      surveyPoints.isEmpty
          ? const Text("No points added")
          : ListView.builder(
              itemCount: surveyPoints.length,
              itemBuilder: (_, i) {
                final p = surveyPoints[i];
                return ListTile(
                  title: Text(
                    "${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}",
                  ),
                );
              },
            ),
    );
  }

  Widget _mapCard() {
    return card(
      "MAP",
      Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text("Google Maps Integration"),
      ),
    );
  }
}
