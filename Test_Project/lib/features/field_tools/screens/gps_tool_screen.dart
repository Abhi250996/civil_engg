import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class GpsToolScreen extends StatefulWidget {
  const GpsToolScreen({super.key});

  @override
  State<GpsToolScreen> createState() => _GpsToolScreenState();
}

class _GpsToolScreenState extends State<GpsToolScreen> {
  String latitude = "--";
  String longitude = "--";
  String accuracy = "--";

  List<Position> surveyPoints = [];

  double totalDistance = 0;
  double polygonArea = 0;

  /// GET CURRENT LOCATION
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

  /// UPDATE CURRENT LOCATION
  Future<void> updateLocation() async {
    Position? pos = await getLocation();

    if (pos == null) return;

    setState(() {
      latitude = pos.latitude.toStringAsFixed(6);
      longitude = pos.longitude.toStringAsFixed(6);
      accuracy = "${pos.accuracy.toStringAsFixed(2)} m";
    });
  }

  /// ADD SURVEY POINT
  Future<void> addSurveyPoint() async {
    Position? pos = await getLocation();
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

  /// CLEAR SURVEY
  void clearSurvey() {
    setState(() {
      surveyPoints.clear();
      totalDistance = 0;
      polygonArea = 0;
    });
  }

  /// POLYGON AREA (Approximate GPS)
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

  Widget infoTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS Survey Tool")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// CURRENT LOCATION
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      "CURRENT LOCATION",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoTile("LAT", latitude),
                        infoTile("LNG", longitude),
                        infoTile("ACC", accuracy),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: updateLocation,
                      child: const Text("GET LOCATION"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SURVEY CONTROLS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      "SURVEY POINTS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: addSurveyPoint,
                          child: const Text("ADD POINT"),
                        ),

                        ElevatedButton(
                          onPressed: clearSurvey,
                          child: const Text("CLEAR"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Points: ${surveyPoints.length}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Distance: ${totalDistance.toStringAsFixed(2)} m",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Area: ${(polygonArea / 10000).toStringAsFixed(4)} hectares",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SURVEY POINT LIST
            if (surveyPoints.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text(
                        "SURVEY POINTS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: surveyPoints.length,
                        itemBuilder: (context, index) {
                          final p = surveyPoints[index];

                          return ListTile(
                            leading: Text("#${index + 1}"),
                            title: Text(
                              "${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}",
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// MAP PLACEHOLDER
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "Map View (Google Maps Integration Ready)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
