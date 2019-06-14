# geometry

library that implement some geometry elements like points, lines, circles, etc.
used as utility library.

for example:

Point pointA = Point(3.0, 5.0);
Point pointB = Point(4.0, 8.0);

Line line = Line.fromPoints(pointA: pointA, pointB: pointB);

Circle circle = Circle(center: pointA, radius: 10.0);

List intersections = line.intersect(circle);
