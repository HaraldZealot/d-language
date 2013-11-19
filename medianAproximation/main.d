import std.stdio;

void main()
{
    Point a={0.25, 4};
    Point b={0.8125, 2};
    Point c={1.5625, 3};
    writeln("calcparabola(",a,", ",b,", ",c,") =\n",calcParabola(a,b,c));
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
    result[1] = ((pm.x - p0.x) ^^ 2 * (pp.y-p0.y) - (pp.x-p0.x) ^^ 2 * (pm.y - p0.y)) / denominator;
    result[2] = ((pm.y - p0.y) * (pp.x - p0.x) - (pp.y - p0.y) * (pm.x - p0.x)) / denominator;
    return result;
}

unittest
{
    assert([0.0L, 0.0L, 0.0L] == calcParabola(Point(-1.0L, 0.0L), Point(0.0L, 0.0L), Point(1.0L, 0.0L)),"zero test failed");
    assert([1.0L, 0.0L, 0.0L] == calcParabola(Point(-1.0L, 1.0L), Point(0.0L, 1.0L), Point(1.0L, 1.0L)),"constant test failed");
    assert([0.0L, 1.0L, 0.0L] == calcParabola(Point(-1.0L, -1.0L), Point(0.0L, 0.0L), Point(1.0L, 1.0L)),"line test failed");
    assert([1.0L, -2.0L, 0.0L] == calcParabola(Point(-1.0L, 3.0L), Point(0.0L, 1.0L), Point(1.0L, -1.0L)),"line test failed");
    assert([0.0L, 0.0L, 1.0L] == calcParabola(Point(-1.0L, 1.0L), Point(0.0L, 0.0L), Point(1.0L, 1.0L)),"parabola test failed");
    assert([25.0L, -30.0L, 9.0L] == calcParabola(Point(-1.0L, 64.0L), Point(0.0L, 25.0L), Point(1.0L, 4.0L)),"parabola test failed");
}
