import 'package:geometry/src/shape.dart';
import 'package:geometry/src/point.dart';

///rappresent an arrow, like an edge of a graph
///[start] is the start of the arc
///[end] its end
///[curve] is the circle on which the points [start] and [end] are placed
///[left] is the arrow's left tail
///[rigth] is the arrow's rigth tail
///[tip] is the arrows's tip
class Arrow extends Shape {
  final Point start;
  final Point end;
  final Point mid;
  final Shape body;
  final Point left;
  final Point rigth;
  final Point tip;

  const Arrow(
      {this.start,
      this.end,
      this.mid,
      this.body,
      this.left,
      this.rigth,
      this.tip});
}
