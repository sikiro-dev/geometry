import 'package:geometry/geometry.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('A group of tests', () {
    Line lineA;
    Line lineB;

    setUp(() {
      lineA = Line(m: 0, q: 0);
      lineB = Line(m: 1, q: 0);
    });

    test('First Test', () {
      expect(lineA.angleBetween(lineB), math.pi / 4.0);
    });
  });
}
