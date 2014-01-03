
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
        model = sign | (value & 0xFF_FF) << 15;
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
        if(isnan(lhs) || isnan(rhs))
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
        fixed result;
        result.model = ((a & 0x7F_FF) * (b & 0x7F_FF)) >>> 15;
        result.model += (a >>> 15) * (b & 0x7F_FF) + (a & 0x7F_FF) * (b >>> 15);
        result.model += (0xFF_FF & ((a >>> 15) * (b >>> 15))) << 15;

        if(sign)
            result.model = -result.model;

        return result;
    }

    string toString() const pure nothrow @safe
    {
        if(isnan(this))
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

        auto head = innerModel >>> 15;
        auto tail = 0x7F_FF & innerModel;
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

bool isnan(fixed value) pure nothrow @safe
{
    return value.model == 0x80_00_00_00;
}

//nan test
unittest
{
    assert(isnan(fixed.nan));
    assert(isnan(fixed.init));
    assert(!isnan(fixed(0)));
    assert(!isnan(fixed(23)));
    assert(!isnan(fixed(-44)));
    assert(!isnan(fixed.epsilon));
    assert(!isnan(fixed.infinity));
    assert(!isnan(fixed.min));
    assert(!isnan(fixed.max));

    assert(isnan(+fixed.nan));
    assert(!isnan(+fixed(0)));
    assert(!isnan(+fixed(23)));
    assert(!isnan(+fixed(-44)));
    assert(!isnan(+fixed.epsilon));
    assert(!isnan(+fixed.infinity));
    assert(!isnan(+fixed.min));
    assert(!isnan(+fixed.max));

    assert(isnan(-fixed.nan));
    assert(!isnan(-fixed(0)));
    assert(!isnan(-fixed(23)));
    assert(!isnan(-fixed(-44)));
    assert(!isnan(-fixed.epsilon));
    assert(!isnan(-fixed.infinity));
    assert(!isnan(-fixed.min));
    assert(!isnan(-fixed.max));

    assert(isnan(fixed.nan + fixed(13)));
    assert(isnan(fixed(17) + fixed.nan));
    assert(isnan(fixed.nan + fixed.nan));
    assert(!isnan(fixed(17) + fixed(13)));
    assert(isnan(fixed.nan - fixed(13)));
    assert(isnan(fixed(17) - fixed.nan));
    assert(isnan(fixed.nan - fixed.nan));
    assert(!isnan(fixed(17) - fixed(13)));
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
    d.model = 10923;
    writefln("%s", c * d);
    writeln(" nan: ", fixed.nan);
    writeln(" inf: ", fixed.infinity);
    writeln("-inf: ", -fixed.infinity);
    writeln(" min: ", fixed.min);
    writeln(" max: ", fixed.max);
    writeln(" epsilon: ", fixed.epsilon());
}
