import 'package:geometry_kp/src/shape.dart';
import 'package:geometry_kp/src/point.dart';
import 'package:geometry_kp/src/line.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;

enum Radiant { First, Second, Third, Fourth }

///rappresent a circle on the plane
class Circle extends Shape {
  final Point center;
  final double radius;

  double get circumference => 2 * math.pi * radius;

  ///the [a] coefficient of the canonical equation of the circle
  double get a => -center.x * 2.0;

  ///the [b] coefficient of the canonical equation of the circle
  double get b => -center.y * 2.0;

  ///the [c] coefficient of the canonical equation of the circle
  double get c =>
      math.pow(center.x, 2) + math.pow(center.y, 2) - math.pow(radius, 2);

  ///true if the [point] is on [this], false otherwise
  bool onCircle(Point point) =>
      point.distanceTo(center).toStringAsFixed(5) == radius.toStringAsFixed(5);

  ///create a circle with [center] and [radius]
  const Circle({@required this.center, @required this.radius})
      : assert(center != null && radius != null);

  ///create a cirlce from the coord [x] and [y] of the center with the given [radius]
  factory Circle.fromCoordsRadius(
      {@required double x, @required double y, @required double radius}) {
    assert(x != null && y != null && radius != null);
    return Circle(center: Point(x, y), radius: radius);
  }

  ///create a circle from the three coefficients [a], [b] and [c]
  factory Circle.fromCoefficients({double a, double b, double c}) {
    assert(a != null && b != null && c != null);
    return Circle.fromCoordsRadius(
        x: -a / 2.0,
        y: -b / 2.0,
        radius: math.sqrt(math.pow(a, 2) / 4.0 + math.pow(b, 2) / 4.0 - c));
  }

  ///create a circle that pass through three given points [pointA], [pointB] and [pointC]
  factory Circle.fromTreePoints(
      {@required Point pointA,
      @required Point pointB,
      @required Point pointC}) {
    assert(pointA != null && pointB != null && pointC != null);
    final u = math.pow(pointA.x, 2) + math.pow(pointA.y, 2);
    final v = math.pow(pointB.x, 2) + math.pow(pointB.y, 2);
    final z = math.pow(pointC.x, 2) + math.pow(pointC.y, 2);
    final a = -(-pointB.y * u +
            pointC.y * u +
            pointA.y * v -
            pointC.y * v -
            pointA.y * z +
            pointB.y * z) /
        (pointA.y * pointB.x -
            pointA.x * pointB.y -
            pointA.y * pointC.x +
            pointB.y * pointC.x +
            pointA.x * pointC.y -
            pointB.x * pointC.y);
    final b = -(pointB.x * u -
            pointC.x * u -
            pointA.x * v +
            pointC.x * v +
            pointA.x * z -
            pointB.x * z) /
        (pointA.y * pointB.x -
            pointA.x * pointB.y -
            pointA.y * pointC.x +
            pointB.y * pointC.x +
            pointA.x * pointC.y -
            pointB.x * pointC.y);
    final c = -(pointB.y * pointC.x * u -
            pointB.x * pointC.y * u -
            pointA.y * pointC.x * v +
            pointA.x * pointC.y * v +
            pointA.y * pointB.x * z -
            pointA.x * pointB.y * z) /
        (pointA.y * pointB.x -
            pointA.x * pointB.y -
            pointA.y * pointC.x +
            pointB.y * pointC.x +
            pointA.x * pointC.y -
            pointB.x * pointC.y);
    return Circle.fromCoefficients(a: a, b: b, c: c);
  }

  Radiant radiantOf(Point point) {
    if (point.x >= center.x) {
      if (point.y >= center.y) {
        return Radiant.First;
      } else {
        return Radiant.Fourth;
      }
    } else {
      if (point.y >= center.y) {
        return Radiant.Second;
      } else {
        return Radiant.Third;
      }
    }
  }

  ///return the clockwise angle of the arc between [pointA] and [pointB] that are on [this]
  double arc(Point pointA, Point pointB) {
    assert(onCircle(pointA));
    assert(onCircle(pointB));
    double arc = Line.fromPoints(pointA: pointA, pointB: center)
        .angleBetween(Line.fromPoints(pointA: pointB, pointB: center));
    switch (radiantOf(pointA)) {
      case Radiant.First:
        if (radiantOf(pointB) == Radiant.First) {
          return arc;
        } else if (radiantOf(pointB) == Radiant.Second) {
          if (Line.fromPoints(pointA: pointA, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x, center.y + radius),
                          pointB: center)) +
                  Line.fromPoints(pointA: pointB, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x, center.y + radius),
                          pointB: center)) <=
              math.pi / 2.0) {
            return arc;
          } else {
            return 2 * math.pi - arc;
          }
        } else {
          return 2 * math.pi - arc;
        }
        break;
      case Radiant.Second:
        if (radiantOf(pointB) == Radiant.Second) {
          return arc;
        } else if (radiantOf(pointB) == Radiant.Third) {
          if (Line.fromPoints(pointA: pointA, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x - radius, center.y),
                          pointB: center)) +
                  Line.fromPoints(pointA: pointB, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x - radius, center.y),
                          pointB: center)) <=
              math.pi / 2.0) {
            return arc;
          } else {
            return 2 * math.pi - arc;
          }
        } else {
          return 2 * math.pi - arc;
        }
        break;
      case Radiant.Third:
        if (radiantOf(pointB) == Radiant.Third) {
          return arc;
        } else if (radiantOf(pointB) == Radiant.Fourth) {
          if (Line.fromPoints(pointA: pointA, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x, center.y - radius),
                          pointB: center)) +
                  Line.fromPoints(pointA: pointB, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x, center.y - radius),
                          pointB: center)) <=
              math.pi / 2.0) {
            return arc;
          } else {
            return 2 * math.pi - arc;
          }
        } else {
          return 2 * math.pi - arc;
        }
        break;
      case Radiant.Fourth:
        if (radiantOf(pointB) == Radiant.Fourth) {
          return arc;
        } else if (radiantOf(pointB) == Radiant.First) {
          if (Line.fromPoints(pointA: pointA, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x + radius, center.y),
                          pointB: center)) +
                  Line.fromPoints(pointA: pointB, pointB: center).angleBetween(
                      Line.fromPoints(
                          pointA: Point(center.x + radius, center.y),
                          pointB: center)) <=
              math.pi / 2.0) {
            return arc;
          } else {
            return 2 * math.pi - arc;
          }
        } else {
          return 2 * math.pi - arc;
        }
        break;
    }
    return 0.0;
  }

  ///returns a list of point where [this] circle intersect with the [other] shape
  List<Point> intersect(Shape other) {
    switch (other.runtimeType) {
      case Circle:
        {
          final circle = other as Circle;
          return intersect(Line(
              m: -(a - circle.a) / (b - circle.b),
              q: (circle.c - c) / (b - circle.b)));
        }
        break;
      case Line:
        {
          final line = other as Line;
          final x1 = line.m.isInfinite
              ? center.x
              : (-a -
                      b * line.m -
                      2 * line.m * line.q -
                      math.sqrt(
                          math.pow(a + b * line.m + 2 * line.m * line.q, 2) -
                              4 *
                                  (1 + math.pow(line.m, 2)) *
                                  (c + b * line.q + math.pow(line.q, 2)))) /
                  (2 * (1 + math.pow(line.m, 2)));
          final x2 = line.m.isInfinite
              ? center.x
              : (-a -
                      b * line.m -
                      2 * line.m * line.q +
                      math.sqrt(
                          math.pow(a + b * line.m + 2 * line.m * line.q, 2) -
                              4 *
                                  (1 + math.pow(line.m, 2)) *
                                  (c + b * line.q + math.pow(line.q, 2)))) /
                  (2 * (1 + math.pow(line.m, 2)));
          return [
            Point(x1,
                line.m.isInfinite ? center.y + radius : line.m * x1 + line.q),
            Point(x2,
                line.m.isInfinite ? center.y - radius : line.m * x2 + line.q)
          ];
        }
      default:
        return null;
    }
  }
}
