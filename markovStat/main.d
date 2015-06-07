module main;

import std.stdio, std.string, std.regex, std.algorithm, std.array;

void main()
{
	uint[dchar][dchar] markovMatrix;
	string text = cast(string)stdin.byChunk(4096).joiner.array;
	dchar p = ' ';

	text = toLower(text);

	auto re1 = ctRegex!(`[–.—,:!?;*()»«0-9-]`);
	text = replaceAll(text, re1, " ");
	auto re2 = ctRegex!(`\s+`);
	text = replaceAll(text, re2, " ");
	auto re3 = ctRegex!(`'`);
	text = replaceAll(text, re3, `’`);

	auto f = File("format.txt", "w");
	f.write(text);

	foreach(dchar c; text)
	{
		++markovMatrix[p][c];
		p=c;
	}

	/+foreach(row; markovMatrix.byKeyValue)
	{
		foreach(elem; row.value.byKeyValue)
			write(row.key, "->", elem.key, ": ", elem.value,"\t\t");
		writeln();
	}+/

	writeln("\n\n");

	auto alphabet = "абвгдеёжзійклмнопрстуўфхцчш’ыьэюя ";

	write(" |");
	foreach(dchar colchar; alphabet)
		writef("  %c|", colchar);
	writeln();

	foreach(dchar rowchar; alphabet)
	{
		write(rowchar,"|");
		if(rowchar in markovMatrix)
		{
			foreach(dchar colchar; alphabet)
			{
				if(colchar in markovMatrix[rowchar])
					writef("%3d|", markovMatrix[rowchar][colchar]);
				else
					write("   |");
			}
		}
		writeln();
	}

	writeln();

	foreach(dchar rowchar; alphabet)
	{
		write(sum(markovMatrix[rowchar].byKey), " ");
	}
}

