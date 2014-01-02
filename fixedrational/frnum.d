
struct frnum //fixed rational numbers 4 byte
{
    private int model;

    this(int value)
    {
        auto sign = 0x80_00_00_00 & value;
        model = sign | (value & 0xFF_FF) << 15;
    }

    frnum opBinary(string op)(frnum rhs)
        if(op == "+" || op == "-")
    {
        alias this lhs;
        frnum result;
        mixin("result.model=lhs.model" ~ op ~ "rhs.model;");
        return result;
    }

    frnum opBinary(string op)(frnum rhs)
        if(op == "*")
    {
        alias this lhs;
        auto sign = (0x80_00_00_00 & lhs.model) ^ (0x80_00_00_00 & rhs.model);
        auto a = lhs.model < 0 ? -lhs.model : lhs.model;
        auto b = rhs.model < 0 ? -rhs.model : rhs.model;
        frnum result;
        result.model = ((a & 0x7F_FF) * (b & 0x7F_FF)) >>> 15;
        result.model += (a >>> 15) * (b & 0x7F_FF) + (a & 0x7F_FF) * (b >>> 15);
        result.model += (0xFF_FF & ((a >>> 15) * (b >>> 15))) << 15;
        return result;
    }

    string toString()
    {
        import std.conv;
        string result = to!string(model>>15);
        if(0x7F_FF & model)
        {
            auto tail = 0x7F_FF & (model < 0? -model : model);
            auto decimalTail = (tail * 100000) / (1<<15);
            result ~= ".";
            string temporal;
            for(auto i = 10000; i != 0; i /=10)
            {
                auto digit = decimalTail / i;

                if(digit)
                {
                    result ~= temporal ~ cast(char)('0' + digit);
                    temporal = null;
                }
                else
                    temporal ~= '0';

                decimalTail -= digit * i;
            }
             //~ to!string((tail * 100000) / (1<<15));
            //result ~= to!string(() / cast(real) (1 << 15))[1..$];
        }
        return result;
    }
}

unittest
{
    import std.stdio;
    frnum a = -5;
    writefln("%b", a.model);
    writefln("%d", a.model);
    writefln("%X", a.model);
    frnum b = 5;
    writefln("%b", b.model);
    writefln("%d", b.model);
    writefln("%X", b.model);
    writefln("a-b=%s",(a-b));
    frnum c = 1;
    frnum d;
    d.model = 10922;
    writefln("%s",c*d);
}
