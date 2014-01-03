
struct fixed //fixed rational numbers 4 byte
{
    private int model = 0x80_00_00_00;

    static @property fixed nan() pure nothrow @safe
    {
        return fixed.init;
    }

    static @property fixed infinity() pure nothrow @safe
    {
        fixed result;
        result.model = 0x7F_FF_FF_FF;
        return result;
    }

    static @property fixed epsilon() pure nothrow @safe
    {
        fixed result;
        result.model = 0x1;
        return result;
    }

    static @property fixed min() pure nothrow @safe
    {
        fixed result;
        result.model = 0x80_00_00_02;
        return result;
    }

    static @property fixed max() pure nothrow @safe
    {
        fixed result;
        result.model = 0x7F_FF_FF_FE;
        return result;
    }

    this(int value) pure nothrow @safe
    {
        auto sign = 0x80_00_00_00 & value;
        model = sign | (value & 0x7F_FF) << 16;
    }

    fixed opUnary(string op)() const pure nothrow @safe
        if(op == "+" || op == "-")
    {
        fixed result;
        mixin("result.model=" ~ op ~ "model;");
        return result;
    }

    fixed opBinary(string op)(fixed rhs) const pure nothrow @safe
    {
        alias this lhs;
        if(isNaN(lhs) || isNaN(rhs))
            return fixed.nan;

        return opBinaryImpl!op(rhs);
    }

    private fixed opBinaryImpl(string op)(fixed rhs) const pure nothrow @safe
        if(op == "+" || op == "-")
    {
        alias this lhs;
        fixed result;
        mixin("result.model=lhs.model" ~ op ~ "rhs.model;");
        return result;
    }

    private fixed opBinaryImpl(string op)(fixed rhs) const pure nothrow @safe
        if(op == "*")
    {
        alias this lhs;
        auto sign = (0x80_00_00_00 & lhs.model) ^ (0x80_00_00_00 & rhs.model);
        auto a = lhs.model < 0 ? -lhs.model : lhs.model;
        auto b = rhs.model < 0 ? -rhs.model : rhs.model;
        uint al = a & 0xFF_FF;
        uint ah = a >>> 16;
        uint bl = b & 0xFF_FF;
        uint bh = b >>> 16;
        fixed result;
        result.model = (al * bl) >>> 16;
        result.model += ah * bl + al * bh;
        result.model += (0x7F_FF & (ah *bh)) << 16;

        if(sign)
            result.model = -result.model;

        return result;
    }

    string toString() const pure nothrow @safe
    {
        if(isNaN(this))
            return "nan";
        string result;
        int innerModel = model;

        if(innerModel < 0)
        {
            result ~= "-";
            innerModel = -innerModel;
        }

        if(innerModel == fixed.infinity.model)
            return result ~ "inf";

        auto head = innerModel >>> 16;
        auto tail = 0xFF_FF & innerModel;
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
            auto decimalTail = cast(uint)((tail * 100000UL) / (1UL << 16));
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

bool isNaN(fixed value) pure nothrow @safe
{
    return value.model == 0x80_00_00_00;
}

bool isInfinity(fixed value) pure nothrow @safe
{
    return 0x7F_FF_FF_FF == value.model || 0x80_00_00_01 == value.model;
}


//nan test
unittest
{
    assert(isNaN(fixed.nan));
    assert(isNaN(fixed.init));
    assert(!isNaN(fixed(0)));
    assert(!isNaN(fixed(23)));
    assert(!isNaN(fixed(-44)));
    assert(!isNaN(fixed.epsilon));
    assert(!isNaN(fixed.infinity));
    assert(!isNaN(fixed.min));
    assert(!isNaN(fixed.max));

    assert(isNaN(+fixed.nan));
    assert(!isNaN(+fixed(0)));
    assert(!isNaN(+fixed(23)));
    assert(!isNaN(+fixed(-44)));
    assert(!isNaN(+fixed.epsilon));
    assert(!isNaN(+fixed.infinity));
    assert(!isNaN(+fixed.min));
    assert(!isNaN(+fixed.max));

    assert(isNaN(-fixed.nan));
    assert(!isNaN(-fixed(0)));
    assert(!isNaN(-fixed(23)));
    assert(!isNaN(-fixed(-44)));
    assert(!isNaN(-fixed.epsilon));
    assert(!isNaN(-fixed.infinity));
    assert(!isNaN(-fixed.min));
    assert(!isNaN(-fixed.max));

    assert(isNaN(fixed.nan + fixed(13)));
    assert(isNaN(fixed(17) + fixed.nan));
    assert(isNaN(fixed.nan + fixed.nan));
    assert(!isNaN(fixed(17) + fixed(13)));
    assert(isNaN(fixed.nan - fixed(13)));
    assert(isNaN(fixed(17) - fixed.nan));
    assert(isNaN(fixed.nan - fixed.nan));
    assert(!isNaN(fixed(17) - fixed(13)));
    assert(isNaN(fixed.nan * fixed(13)));
    assert(isNaN(fixed(17) * fixed.nan));
    assert(isNaN(fixed.nan * fixed.nan));
    assert(!isNaN(fixed(17) * fixed(13)));
}

//infinity test
unittest
{
    assert(isInfinity(fixed.infinity));
    assert(isInfinity(-fixed.infinity));
    assert(!isInfinity(fixed(0)));
    assert(!isInfinity(fixed(23)));
    assert(!isInfinity(fixed(-44)));
    assert(!isInfinity(fixed.epsilon));
    assert(!isInfinity(fixed.nan));
    assert(!isInfinity(fixed.init));
    assert(!isInfinity(fixed.min));
    assert(!isInfinity(fixed.max));

}

//pseudo main
unittest
{
    import std.stdio;
    fixed a = -5;
    fixed b = 6;
    writefln("%s + %s = %s",a, b, a + b);
    fixed c = -12;
    fixed d;
    d.model = 65536/3;
    writefln("%s", c * d);
    writeln(" nan: ", fixed.nan);
    writeln(" inf: ", fixed.infinity);
    writeln("-inf: ", -fixed.infinity);
    writeln(" min: ", fixed.min);
    writeln(" max: ", fixed.max);
    writeln(" epsilon: ", fixed.epsilon());

    writeln("\nfloat");
    writefln("%s + %s = %s", float.infinity, float.infinity, float.infinity + float.infinity);
    writefln("%s - %s = %s", float.infinity, float.infinity, float.infinity - float.infinity);
    writefln("%s * %s = %s", float.infinity, float.infinity, float.infinity * float.infinity);
    writefln("%s / %s = %s", float.infinity, float.infinity, float.infinity / float.infinity);

    writefln("%s + %s = %s", float.max, float.max, float.max + float.max);
    writefln("%s - %s = %s", float.max, float.max, float.max - float.max);
    writefln("%s * %s = %s", float.max, float.max, float.max * float.max);
    writefln("%s / %s = %s", float.max, float.max, float.max / float.max);

}
