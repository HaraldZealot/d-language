module dualnumber;

import std.traits;

struct Dualnumber(Field)
	if(isAlgebraicField!Field)
{
public:

	Dualnumber opBinary(string op)(Dualnumber rhs)
		if(op == "+" || op == "-")
	{
		alias lhs = this;
		mixin("return Dualnumber(lhs.re " ~ op ~ " rhs.re, lhs.nel " ~ op ~ " rhs.nel);");
	}
	
	Dualnumber opBinary(string op)(Dualnumber rhs)
		if(op == "*")
	{
		alias lhs = this;
		return Dualnumber(lhs.re * rhs.re, lhs.re * rhs.nel + lhs.nel * rhs.re);
	}
	
	Dualnumber opBinary(string op)(Dualnumber rhs)
		if(op == "/")
	{
		alias lhs = this;
		return Dualnumber(lhs.re / rhs.re, (lhs.nel * rhs.re - lhs.re * rhs.nel) / (rhs.re ^^ 2));
	}
	
private:

	Field re, nel;
}

alias isAlgebraicField = isNumeric; // temporal;