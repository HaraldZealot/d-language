module cells;
import std.typecons;
import std.stdio;
import std.typetuple;
import std.traits;

enum DrawType{none, console, graphical}

alias ThinConsoleImplementation = TypeTuple!(ConsoleCell, ThinConsoleWall!"horizontal", ThinConsoleWall!"vertical", ThinConsoleVertex);

template isMazeImplementation(T...)
{
	/*static if(!isTypeTuple!T)
		enum bool isMazeImplementation = false;
	else */
	static if(T.length != 4)
		enum bool isMazeImplementation = false;
	else 
		enum bool isMazeImplementation = is(T[0]:AbstractCell) && is(T[1]:AbstractWall) 
			&& is(T[2]:AbstractWall) && is(T[3]:AbstractVertex);
}

unittest
{
	static assert(isMazeImplementation!ThinConsoleImplementation);
	static assert(!isMazeImplementation!int);
	static assert(!isMazeImplementation!(TypeTuple!(int,int,int,int)));
	static assert(!isMazeImplementation!(TypeTuple!(AbstractCell, AbstractWall, AbstractVertex)));
}

template isConsoleMazeImplementation(T...)
{
	static if(!isMazeImplementation!T)
		enum bool isConsoleMazeImplementation = false;
	else 
		enum bool isConsoleMazeImplementation =  
			T[0].drawType == DrawType.console 
			&& T[1].drawType == DrawType.console
			&& T[2].drawType == DrawType.console
			&& T[3].drawType == DrawType.console;
}

unittest
{
	static assert(isConsoleMazeImplementation!ThinConsoleImplementation);
	static assert(!isConsoleMazeImplementation!int);
	static assert(!isConsoleMazeImplementation!(TypeTuple!(int,int,int,int)));
	static assert(!isConsoleMazeImplementation!(TypeTuple!(AbstractCell, AbstractWall, AbstractVertex)));
	static assert(!isConsoleMazeImplementation!(TypeTuple!(AbstractCell, AbstractWall, AbstractWall, AbstractVertex)));
}

interface AbstractCell
{
	enum drawType = DrawType.none;
	void draw()const;
	void show()pure nothrow @safe;
	void hide()pure nothrow @safe;
}

abstract class AbstractVertex: AbstractCell
{
	void create(Tuple!(int,int) direction)pure nothrow @safe;
	void destroy(Tuple!(int,int) direction)pure nothrow @safe;

	void show()pure nothrow @safe
	{
		isVisible = true;
	}

	void hide()pure nothrow @safe
	{
		isVisible = false;
	}

protected:
	bool isVisible = true;
}

abstract class AbstractWall: AbstractCell
{
	void create()pure nothrow @safe;
	void destroy()pure nothrow @safe;
	
	void show()pure nothrow @safe
	{
		isVisible = true;
	}
	
	void hide()pure nothrow @safe
	{
		isVisible = false;
	}
	
protected:
	bool isVisible = true;
}

class ConsoleCell: AbstractCell
{
	enum drawType = DrawType.console;
	void draw()const
	{
		write(" ");
	}

	void show()pure nothrow @safe{}
	void hide()pure nothrow @safe{}

}

class ThinConsoleVertex: AbstractVertex
{
	public static enum drawType = DrawType.console;

	this(bool visibility = true)
	{
		isVisible = visibility;
	}

	void draw()const
	{
		static string[variants] symbols=[           " ", "\342\225\264", "\342\225\265", "\342\224\230", 
			                             "\342\225\266", "\342\224\200", "\342\224\224", "\342\224\264",
			                             "\342\225\267", "\342\224\220", "\342\224\202", "\342\224\244",
			                             "\342\224\214", "\342\224\254", "\342\224\234", "\342\224\274"];
		write(symbols[wallBitMask]);
	}

	override void create(Tuple!(int,int) direction)pure nothrow @safe
	{
		mixin mtDirectionToBitmask!"|";
		directionToBitmask(direction);
	}

	override void destroy(Tuple!(int,int) direction)pure nothrow @safe
	{
		mixin mtDirectionToBitmask!"^";
		directionToBitmask(direction);
	}

private:
	enum int direction = 4;
	enum int variants = 2 ^^ direction;
	enum :ubyte {WEST = 1, NORTH=2, EAST=4, SOUTH = 8}
	ubyte wallBitMask = 0;


}

class ThinConsoleWall(string direction): AbstractWall
	if(direction == "horizontal" || direction == "vertical")
{
	public enum drawType = DrawType.console;
	
	this(bool visibility = true)
	{
		isVisible = visibility;
	}

	void draw()const
	{
		if(isVisible && isExist)
		{
			static if(direction == "horizontal")
			{

				write("\342\224\200");
			}
			else 
			{
				write("\342\224\202");
			}
		}
		else
			write(" ");
	}

	override void create()pure nothrow @safe
	{
		isExist = true;
	}

	override void destroy()pure nothrow @safe
	{
		isExist = false;
	}

private:

	bool isExist;
}

private mixin template mtDirectionToBitmask(string op)
	if(op == "|" || op == "^")
{
	void directionToBitmask(Tuple!(int,int) direction)pure nothrow @safe
	{
		assert(direction[0] * direction[1] == 0);
		assert(direction[0] + direction[1] != 0);
		if(direction[0] < 0)
			mixin("wallBitMask " ~ op ~ "= WEST;");
		if(direction[1] > 0)
			mixin("wallBitMask " ~ op ~ "= NORTH;");
		if(direction[0] > 0)
			mixin("wallBitMask " ~ op ~ "= EAST;");
		if(direction[1] < 0)
			mixin("wallBitMask " ~ op ~ "= SOUTH;");
	}
}
