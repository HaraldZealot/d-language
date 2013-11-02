

unittest
{
    RingCounter a(7,1);
    assert(a.current == 1);
    a.next();
    assert(a.current == 2);
    assert(a.current == 2);
    a.next();
    a.next();
    a.next();
    a.next();
    assert(a.current == 6);
    a.next();
    assert(a.current == 0);
}

struct RingCounter
{

}
