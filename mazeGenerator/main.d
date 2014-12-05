module main;

import std.stdio;
import std.typecons;
import cells;
import maze;

void main(string[] args)
{
	ThinConsoleVertex[][] v = new ThinConsoleVertex[][4];
	foreach(i;0..4){

		v[i] = new ThinConsoleVertex[4];
		foreach(j;0..4)
			v[i][j] = new ThinConsoleVertex;
	}
	v[0][1].create(Tuple!(int, int)(0,-1));
	v[1][0].create(Tuple!(int, int)(1,0));
	v[1][1].create(Tuple!(int, int)(-1,0));
	v[1][1].create(Tuple!(int, int)(0,1));

	v[0][2].create(Tuple!(int, int)(0,-1));
	v[1][3].create(Tuple!(int, int)(-1,0));
	v[1][2].create(Tuple!(int, int)(1,0));

	foreach(i;0..4)
	{
		foreach(j;0..4)
			v[i][j].draw();
		writeln();
	}

	writeln();
	v[1][1].destroy(Tuple!(int, int)(0,1));
	foreach(i;0..4)
	{
		foreach(j;0..4)
			v[i][j].draw();
		writeln();
	}

	auto maze = new ConsoleMaze!ThinConsoleImplementation(5,6);
	maze.draw();
}

