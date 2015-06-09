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

	dstring alphabet = "абвгдеёжзійклмнопрстуўфхцчш’ыьэюя ";

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

	dchar maxIndex = alphabet[0];
	uint maxValue = sum(markovMatrix[maxIndex].byValue);
	foreach(dchar rowchar; alphabet)
	{
		auto curValue = sum(markovMatrix[rowchar].byValue);
		if(curValue > maxValue)
		{
			maxValue = curValue;
			maxIndex = rowchar;
		}
	}

	writeln("'", maxIndex, "'");

	bool[dchar] marks;
	marks[maxIndex] = true;

	dchar[] chain;
	chain ~= maxIndex;

	auto currentIndex = maxIndex;
	while(markovMatrix[currentIndex].hasWayOut(marks))
	{
		maxIndex = '\0';
		maxValue = 0;
		foreach(i; markovMatrix[currentIndex].byKey)
		{
			//writeln(i, " ", maxValue, " ", markovMatrix[currentIndex][i]);
			if(i !in marks && maxValue < markovMatrix[currentIndex][i])
			{
				maxIndex = i;
				maxValue = markovMatrix[currentIndex][i];
			}
		}
		assert(maxIndex != '\0');
		chain ~= maxIndex;
		marks[maxIndex] = true;
		currentIndex = maxIndex;
	}

	writeln(chain);

	foreach(dchar rowchar; chain)
	{
		write(rowchar,"|");
		if(rowchar in markovMatrix)
		{
			foreach(dchar colchar; chain)
			{
				if(colchar in markovMatrix[rowchar])
					writef("%3d|", markovMatrix[rowchar][colchar]);
				else
					write("   |");
			}
		}
		writeln();
	}

}

bool hasWayOut(uint[dchar] markovRow, bool[dchar] marks)
{
	foreach(e; markovRow.byKey)
		if(e !in marks)
			return true;
	return false;
}

