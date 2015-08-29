module main;

import std.stdio;

import dualnumber;

void main()
{
	auto a = Dualnumber!real(1, 2), b = Dualnumber!real(3, 4);
	writeln(a, " + ", b, " = ", a + b);
	writeln(a, " - ", b, " = ", a - b);
	writeln(a, " * ", b, " = ", a * b);
	writeln(a, " / ", b, " = ", a / b);
	
	writeln;
	foreach(i; 0..11)
	{
		auto x = cast(real) i;
		auto dx = Dualnumber!real(x, 1.0L);
		writeln(dx * dx * dx);
	}
}