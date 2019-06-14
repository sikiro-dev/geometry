import 'package:geometry/src/shape.dart';
import 'package:geometry/src/point.dart';
import 'package:geometry/src/circle.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

///rappresent a line on the plane
class Line extends Shape {
  final double m;
  final double q;

  ///create a line with the given [m] and [q]
  const Line({@required this.m, @required this.q})
      : assert(m != null && q != null);

  ///create a line that pass through two points [pointA] and [pointB]
  factory Line.fromPoints({@required Point pointA, @required Point pointB}) {
    assert(pointA != null && pointB != null);
    double m = (pointB.y - pointA.y) / (pointB.x - pointA.x);
    double q = m.isInfinite
        ? pointA.x
        : -(pointA.x * (pointB.y - pointA.y)) / (pointB.x - pointA.x) +
            pointA.y;
    return Line(m: m, q: q);
  }

  ///returns the distance between [this] and a [point]
  double distanceTo(Point point) =>
      point.distanceTo(perpendicular(point).intersec(this)[0]);

  ///returns two line that are parallels with [this] and their distance from [this] is [distance]
  List<Line> parallels(double distance) {
    var sin = math.sin(math.atan(-1.0 / m));
    sin = sin == 0.0 ? 1.0 : sin;
    return [
      Line(m: m, q: q - (distance / sin)),
      Line(m: m, q: (distance / sin) + q)
    ];
  }

  ///returns a line that is perpendicular to [this] and pass through [point]
  Line perpendicular(Point point) {
    return Line(m: -1 / m, q: m == 0.0 ? point.x : (point.x / m) + point.y);
  }

  ///return the acute angle in radiants between [this] and [other]
  double angleBetween(Line other) {
    if ((m * other.m).isNaN) return math.pi / 2.0;
    if (m.isInfinite) {
      return math.pi / 2.0 - other.angleBetween(Line(m: 0.0, q: 0.0));
    }
    if (other.m.isInfinite) {
      return math.pi / 2.0 - angleBetween(Line(m: 0.0, q: 0.0));
    }
    return math.atan((m - other.m) / (1 + m * other.m)).abs();
  }

  ///return two point that are on [this] line with the given [distance] from [point]
  List<Point> atDistanceFromPoint(Point point, double distance) {
    final c = Circle(center: point, radius: distance);
    return c.intersect(this);
  }

  ///returns the intersections between [this] and a [shape]
  ///
  ///if [shape] is a Line the list will contain only one element
  List<Point> intersec(Shape other) {
    switch (other.runtimeType) {
      case Circle:
        return (other as Circle).intersect(this);
        break;
      case Line:
        {
          final line = other as Line;
          double x = m.isInfinite
              ? q
              : line.m.isInfinite ? line.q : (line.q - q) / (m - line.m);
          double y = m == 0.0 ? q : line.m == 0.0 ? line.q : m * x + q;
          return [Point(x, y)];
        }
        break;
      default:
        return null;
    }
  }
}
