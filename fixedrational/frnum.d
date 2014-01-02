
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
        import std.stdio;
        string result;
        auto innerModel = model;

        if(innerModel < 0)
        {
            result ~= "-";
            innerModel = -innerModel;
        }

        auto head = innerModel >>> 15;
        auto tail = 0x7F_FF & innerModel;
        //writefln("h = %s\nt = %s", head, tail);
        auto carier = 10;

        while(head / carier)
            carier *= 10;

        carier /= 10;

        for(auto i = carier; i != 0; i /=10)
        {
            auto digit = head / i;
            result ~= cast(char)('0' + digit);
            head -= digit * i;
        }

        if(tail)
        {
            uint decimalTail = (tail * 100000U) / (1 << 15);
            //writefln("dt = %s", decimalTail);
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
        }
        return result;
    }
}

unittest
{
    import std.stdio;
    frnum a = -5;
    frnum b = 6;
    writefln("%s + %s = %s",a, b, a + b);
    frnum c = 12;
    frnum d;
    d.model = 10923;
    writefln("%s", c * d);
}
