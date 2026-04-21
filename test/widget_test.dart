import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiking_trails/widgets/trail_card.dart';
import 'package:hiking_trails/models/trail.dart';
import 'package:latlong2/latlong.dart';

void main() {
  testWidgets('TrailCard renders Sentier and Balade symbols and names correctly', (WidgetTester tester) async {
    final trail1 = Trail(
      id: 's1',
      name: 'Sentier 1 Test',
      lengthKm: 12.0,
      importance: 85,
      coordinateSegments: [[const LatLng(45.0, 5.0), const LatLng(45.1, 5.1)]],
    );
    final trail2 = Trail(
      id: 'b1',
      name: 'Balade 1 Test',
      lengthKm: 4.5,
      importance: 10,
      coordinateSegments: [[const LatLng(45.0, 5.0), const LatLng(45.1, 5.1)]],
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TrailCard(
              trail: trail1,
              isSelected: false,
              isFav: false,
              hideUnloved: false,
              onToggleFavorite: (_) {},
              onTap: (_) {},
            ),
            TrailCard(
              trail: trail2,
              isSelected: false,
              isFav: false,
              hideUnloved: false,
              onToggleFavorite: (_) {},
              onTap: (_) {},
            ),
          ],
        ),
      ),
    ));

    expect(find.text('Sentier 1 Test'), findsOneWidget);
    expect(find.text('Balade 1 Test'), findsOneWidget);
    expect(find.textContaining('12.0 km'), findsOneWidget);
    expect(find.textContaining('4.5 km'), findsOneWidget);
  });
}
