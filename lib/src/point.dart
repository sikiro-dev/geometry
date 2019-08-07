import 'package:geometry/src/shape.dart';
import 'package:geometry/src/line.dart';
import 'package:geometry/src/circle.dart';
import 'dart:math' as math;

///rappresent a point on the plane
class Point extends Shape {
  final double x;
  final double y;

  ///create a point with [x] and [y] as coords
  const Point(this.x, this.y);

  ///returns the distance between [this] and an [other] point
  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  ///[start] e [end] sono i punti rispetto ai quali si vuole sapere quale dei due punti di [pts] permette di disegnare l'arco che gira in senso orario
  factory Point.clockwise(Point start, Point end, List<Point> pts,
      {bool reversed = false}) {
    return pts[0].higher(pts[1])
        ? reversed ? pts[0] : pts[1]
        : reversed ? pts[1] : pts[0];
  }

  ///return the closer shape from [shapes]
  ///
  ///shape must contain only one type of Shape
  Shape closer(List<Shape> shapes) {
    assert(shapes.every((shape) => shape is Point) ||
        shapes.every((shape) => shape is Line));
    switch (shapes[0].runtimeType) {
      case Point:
        return (shapes as List<Point>).reduce((pointA, pointB) =>
            pointA.distanceTo(this) < pointB.distanceTo(this)
                ? pointA
                : pointB);
        break;
      case Line:
        return (shapes as List<Line>).reduce((lineA, lineB) =>
            lineA.distanceTo(this) < lineB.distanceTo(this) ? lineA : lineB);
        break;
      default:
        return null;
    }
  }

  ///true if [this].y is greater than [other].y
  bool higher(Point other) => y > other.y;

  ///true if [this].x is greater than [other].x
  bool wider(Point other) => x > other.x;

  ///returns the angle between [this], the center of the given [circle] and the point p with cos(p) = 0 of the [circle]
  double angleOnCircle(Circle c) {
    final tan = (y - c.center.y) / (x - c.center.x);
    return x - c.center.x < 0.0 ? math.pi + math.atan(tan) : math.atan(tan);
  }

  ///returns the midpoint between this and an [other] point
  Point midpoint(Point other) {
    return Point((x + other.x) / 2.0, (y + other.y) / 2.0);
  }

  int get hashCode => x.hashCode + y.hashCode;

  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  bool operator >(Point other) => x > other.x && y > other.y;

  bool operator <(Point other) => x < other.x && y < other.y;

  bool operator >=(Point other) => x >= other.x && y >= other.y;

  bool operator <=(Point other) => x <= other.x && y <= other.y;

  Point operator -(Point other) => Point(x - other.x, y - other.y);

  Point operator +(Point other) => Point(x + other.x, y + other.y);

  Point operator *(double d) => Point(x * d, y * d);

  ///return [this] traspose to the first quadrant
  Point abs() => Point(x.abs(), y.abs());
}
