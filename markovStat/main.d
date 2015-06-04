module main;

import std.stdio, std.string;

void main()
{
	uint[dchar][dchar] markovMatrix;
	string text = "Просты прыклад тэкста. Занадта малы для апрацоўкі.";
	dchar p = '\0';

	text = toLower(text);

	foreach(dchar c; text)
	{
		++markovMatrix[p][c];
		p=c;
	}

	foreach(row; markovMatrix.byKeyValue)
	{
		foreach(elem; row.value.byKeyValue)
			write(row.key, "->", elem.key, ": ", elem.value,"\t");
		writeln();
	}

}

