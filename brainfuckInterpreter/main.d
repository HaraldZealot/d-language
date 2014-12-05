module main;

import std.stdio;

enum Operation{inc, dec, left, right, input, output, open, close};



void main()
{
	auto code = loadCode(readln());

}


auto loadCode(string rawCode)
{
	auto result = new uint[rawCode.length];
	foreach(i, symbol; rawCode)
	{
		switch(symbol)
		{
		case '+':
			result[i] = inc;
			break;
		case '-':
			result[i] = dec;
			break;
		case '<':
			result[i] = left;
			break;
		case '>':
			result[i] = right;
			break;
		case '.':
			result[i] = input;
			break;
		case ',':
			result[i] = output;
			break;

		}
	}
}
