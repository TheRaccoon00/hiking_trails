import 'package:flutter_test/flutter_test.dart';
import 'package:hiking_trails/models/trail.dart';

void main() {
  group('Trail Model Tests', () {
    test('Trail name sanitation - GR 5', () {
      final json = {
        'id': 'gr5',
        'name': 'GR 5 (Thonon ➔ Nice)',
        'length_km': 650.0,
        'coordinates': [
          [
            [46.37, 6.48],
            [43.70, 7.26]
          ]
        ]
      };

      final trail = Trail.fromCacheJson(json);

      expect(trail.id, 'gr5');
      // "GR" should be replaced by "Sentier"
      expect(trail.name, contains('Sentier 5'));
      expect(trail.name, isNot(contains('GR')));
    });

    test('Trail name sanitation - GRP', () {
      final json = {
        'id': 'grp1',
        'name': 'GRP Tour du Queyras',
        'length_km': 130.0,
        'coordinates': [
          [
            [44.7, 6.8],
            [44.8, 6.9]
          ]
        ]
      };

      final trail = Trail.fromCacheJson(json);

      expect(trail.name, contains('Itinéraire régional Tour du Queyras'));
      expect(trail.name, isNot(contains('GRP')));
    });

    test('Trail name sanitation - Grande Randonnée', () {
      final json = {
        'id': 'gr1',
        'name': 'Grande Randonnée de Paris',
        'length_km': 50.0,
        'coordinates': [
          [
            [48.8, 2.3],
            [48.9, 2.4]
          ]
        ]
      };

      final trail = Trail.fromCacheJson(json);

      expect(trail.name, contains('Sentier de randonnée de Paris'));
      expect(trail.name, isNot(contains('Grande Randonnée')));
    });

    test('Trail name sanitation - GR17 and symbols', () {
      final json = {
        'id': 'gr17',
        'name': 'GR17® (Lille ➔ Arras)',
        'length_km': 70.0,
        'coordinates': [
          [
            [50.6, 3.0],
            [50.2, 2.7]
          ]
        ]
      };

      final trail = Trail.fromCacheJson(json);

      expect(trail.name, contains('Sentier 17'));
      expect(trail.name, isNot(contains('GR')));
      expect(trail.name, isNot(contains('®')));
    });

    test('Trail name sanitation - GRP20', () {
      final json = {
        'id': 'grp20',
        'name': 'GRP20 de l\'Oisans',
        'length_km': 100.0,
        'coordinates': [
          [
            [45.0, 6.0],
            [45.1, 6.1]
          ]
        ]
      };

      final trail = Trail.fromCacheJson(json);

      expect(trail.name, contains('Itinéraire régional 20 de l\'Oisans'));
      expect(trail.name, isNot(contains('GRP')));
    });

    test('haversineDist calculation check', () {
      // Distance between Paris (48.8566, 2.3522) and Lyon (45.7640, 4.8357) is ~391 km
      double dist = Trail.haversineDist(48.8566, 2.3522, 45.7640, 4.8357);
      expect(dist, closeTo(391.2, 1.0));
    });
  });
}
