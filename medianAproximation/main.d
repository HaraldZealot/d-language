import std.stdio, std.algorithm;

void main()
{
    Point a = {0.25, 4};
    Point b = {0.8125, 2};
    Point c = {1.5625, 3};
    writeln("calcparabola(", a, ", ", b, ", ", c, ") =\n", calcParabola(a, b, c));
    writeln("calcLine(", a, ", ", b, ") =\n",calcLine(a,b));

}

struct Point
{
    real x;
    real y;
}

real[3] calcParabola(Point pm, Point p0, Point pp)
{
    real[3] result;
    real denominator = (pm.x - p0.x) * (pp.x - p0.x) * (pm.x - pp.x);
    result[0] = p0.y;
    result[1] = ((pm.x - p0.x) ^^ 2 * (pp.y - p0.y) - (pp.x - p0.x) ^^ 2 * (pm.y - p0.y)) / denominator;
    result[2] = ((pm.y - p0.y) * (pp.x - p0.x) - (pp.y - p0.y) * (pm.x - p0.x)) / denominator;
    result[0] += result[2] * p0.x ^^ 2 - result[1] * p0.x;
    result[1] += -2.0L * result[2] * p0.x;
    return result;
}

unittest
{
    assert([0.0L, 0.0L, 0.0L] == calcParabola(Point(-1.0L, 0.0L), Point(0.0L, 0.0L), Point(1.0L, 0.0L)), "zero test failed");
    assert([1.0L, 0.0L, 0.0L] == calcParabola(Point(-1.0L, 1.0L), Point(0.0L, 1.0L), Point(1.0L, 1.0L)), "constant test failed");
    assert([0.0L, 1.0L, 0.0L] == calcParabola(Point(-1.0L, -1.0L), Point(0.0L, 0.0L), Point(1.0L, 1.0L)), "line test failed");
    assert([1.0L, -2.0L, 0.0L] == calcParabola(Point(-1.0L, 3.0L), Point(0.0L, 1.0L), Point(1.0L, -1.0L)), "line test failed");
    assert([0.0L, 0.0L, 1.0L] == calcParabola(Point(-1.0L, 1.0L), Point(0.0L, 0.0L), Point(1.0L, 1.0L)), "parabola test failed");
    assert([25.0L, -30.0L, 9.0L] == calcParabola(Point(-1.0L, 64.0L), Point(0.0L, 25.0L), Point(1.0L, 4.0L)), "parabola test failed");
    assert([2.0L, -3.0L, 4.0L] == calcParabola(Point(0.0L, 2.0L), Point(1.0L, 3.0L), Point(2.0L, 12.0L)), "x0!=0 test failed");
}

real[2] calcLine(Point p0,Point p1)
{
    real[2] result;
    real denominator = p0.x - p1.x;
    result[0] = (p0.x * p1.y - p1.x * p0.y) / denominator;
    result[1] = (p0.y - p1.y) / denominator;
    return result;
}

unittest
{
    assert([0.0L, 0.0L] == calcLine(Point(0.0L, 0.0L), Point(1.0L, 0.0L)), "zero test failed");
    assert([2.0L, 0.0L] == calcLine(Point(0.0L, 2.0L), Point(1.0L, 2.0L)), "constant test failed");
    assert([0.0L, 3.0L] == calcLine(Point(0.0L, 0.0L), Point(1.0L, 3.0L)), "line test failed");
    assert([1.0L, 3.0L] == calcLine(Point(0.0L, 1.0L), Point(1.0L, 4.0L)), "line test failed");
    assert([2.0L, -1.0L] == calcLine(Point(0.0L, 2.0L), Point(1.0L, 1.0L)), "line test failed");
    assert([1.0L, 1.0L/3.0L] == calcLine(Point(0.0L, 1.0L), Point(3.0L, 2.0L)), "line test failed");
}

real[2] medianLine(Point[] points)
{
    real[2][] coeficients=new real[2][0];

    for(auto i=0; i<points.length; ++i)
        for(auto j=i + 1; j<points.length; ++j)
            coeficients ~= calcLine(points[i], points[j]);

    typeof(return) result;
    sort!("a[0]<b[0]")(coeficients);
    result[0] = coeficients[$/2][0];
    sort!("a[1]<b[1]")(coeficients);
    result[1] = coeficients[$/2][1];
    return result;
}

unittest
{
    assert(calcLine(Point(1,2), Point(2,3)) == medianLine([Point(1,2), Point(2,3)]),"unique line test failed");
    Point[] points=[Point(1,2), Point(2,3), Point(3,4), Point(4,5), Point(5,6), Point(6,7), Point(7,8)];
    assert([1.0L, 1.0L] == medianLine(points), "single line test failed");
    points[1] = Point(2,2);
    assert([1.0L, 1.0L] == medianLine(points), "one error point test failed");
    points[1] = Point(2,2000);
    assert([1.0L, 1.0L] == medianLine(points), "one error point test failed");
}
