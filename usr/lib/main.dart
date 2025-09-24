import 'package:flutter/material.dart';

// 1. Mock Data Models to represent the data structure
class Identifier {
  final String id;
  final String name;
  Identifier({required this.id, required this.name});
}

class Station {
  final String id;
  final String? area;
  final String? name;
  Station({required this.id, this.area, this.name});
}

class Supporter {
  final String identifierId;
  final String stationId;
  Supporter({required this.identifierId, required this.stationId});
}

// Mock data to simulate what the JavaScript code expects
final List<Identifier> mockIdentifiers = [
  Identifier(id: "id1", name: "المعرف الأول"),
  Identifier(id: "id2", name: "المعرف الثاني"),
];

final List<Station> mockStations = [
  Station(id: "st1", area: "المنطقة أ"),
  Station(id: "st2", area: "المنطقة ب"),
  Station(id: "st3", name: "محطة ج"),
  Station(id: "st4", area: "المنطقة أ"),
];

final List<Supporter> mockSupporters = [
  // Supporters for Identifier 1
  Supporter(identifierId: "id1", stationId: "st1"),
  Supporter(identifierId: "id1", stationId: "st1"),
  Supporter(identifierId: "id1", stationId: "st2"),
  Supporter(identifierId: "id1", stationId: "st3"),
  Supporter(identifierId: "id1", stationId: "st4"),
  Supporter(identifierId: "id1", stationId: "st1"),
  // Supporters for Identifier 2
  Supporter(identifierId: "id2", stationId: "st2"),
  Supporter(identifierId: "id2", stationId: "st2"),
  Supporter(identifierId: "id2", stationId: "st3"),
];


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SupportersDashboard(),
    );
  }
}

class SupportersDashboard extends StatelessWidget {
  const SupportersDashboard({super.key});

  // This function replicates the data processing logic from the JS snippet
  Map<String, dynamic> processIdentifierData(Identifier identifier) {
    // Filter supporters for the current identifier
    final supportersForIdentifier = mockSupporters.where((sup) => sup.identifierId == identifier.id).toList();

    // Calculate area counts
    final areaCounts = <String, int>{};
    for (var sup in supportersForIdentifier) {
      final station = mockStations.firstWhere((st) => st.id == sup.stationId, orElse: () => Station(id: "unknown"));
      // Simplified logic to get area name, similar to the JS example
      final area = station.area ?? station.name ?? "غير محدد";
      areaCounts[area] = (areaCounts[area] ?? 0) + 1;
    }

    // Sort areas by count and take the top 10
    final sortedAreas = areaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topAreas = sortedAreas.take(10).toList();

    // Build the widget to display the top areas
    final topAreasWidget = topAreas.isEmpty
        ? const Text("لا توجد بيانات مناطق", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
        : Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: topAreas.map((entry) {
              return Container(
                constraints: const BoxConstraints(minWidth: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("${entry.value}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }).toList(),
          );

    return {
      "identifierName": identifier.name,
      "supportersCount": supportersForIdentifier.length,
      "topAreasWidget": topAreasWidget,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Process the data for all identifiers
    final processedData = mockIdentifiers.map(processIdentifierData).toList();

    return Directionality(
      // Set text direction to Right-to-Left for Arabic UI
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("لوحة بيانات المؤيدين"),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: processedData.length,
          itemBuilder: (context, index) {
            final item = processedData[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المعرف: ${item["identifierName"]}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "عدد المؤيدين: ${item["supportersCount"]}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "أعلى المناطق:",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Center(child: item["topAreasWidget"]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
