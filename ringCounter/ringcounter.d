

unittest
{
    RingCounter a(1u,7u);
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
    public uint current;
    private uint modulus;

    this(uint val, uint modulus)
    {
        current = val;
        this.modulus = modulus;
    }

    void next()
    {
        ++current;
        while(current > modulus)
            current -= modulus;
    }
}
