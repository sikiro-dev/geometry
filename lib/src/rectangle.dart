import 'package:geometry/src/shape.dart';
import 'package:geometry/src/point.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

///rapresent a rectangle on the plane, where [firstEdge] and [secondEdge] are two opposite edge
class Rectangle extends Shape {
  final Point firstEdge;
  final Point secondEdge;

  const Rectangle({@required this.firstEdge, @required this.secondEdge})
      : assert(firstEdge != null),
        assert(secondEdge != null),
        assert(firstEdge != secondEdge);

  double get width => (firstEdge - secondEdge).x.abs();
  double get heigth => (firstEdge - secondEdge).y.abs();

  /// the nearest to the center of the four edge
  Point get lowEdge => Point(
      math.min(firstEdge.x, secondEdge.x), math.min(firstEdge.y, secondEdge.y));
}
