import 'package:geometry/src/point.dart';

///rapresent a transform matrix
///[scale] is the scalar factor
///[beforeScale] is like a vector and is subtract before the scale
///[afterScale] is applied after the scale
class Transform {
  final double scale;
  final Point afterScale;
  final Point beforeScale;

  const Transform(
      {this.scale = 1,
      this.afterScale = const Point(0.0, 0.0),
      this.beforeScale = const Point(0.0, 0.0)});

  ///apply the transformation to a given point
  Point apply(Point point) {
    return ((point - beforeScale) * scale + afterScale);
  }
}
