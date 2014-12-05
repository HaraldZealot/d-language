module maze; 
import cells;
import std.typetuple;
import std.typecons;

abstract class Maze
{
public:
	this(int rows, int collumns)
	{
		logicalRows = rows;
		logicalCollumns = collumns;
		representationRows = 2 * logicalRows + 1;
		representationCollumns = 2 * logicalCollumns + 1;
		field = new AbstractCell[][representationRows];
		foreach(i;0..representationRows)
			field[i] = new AbstractCell[representationCollumns];	
	}

	void draw()const;

protected:
	immutable int logicalRows, logicalCollumns;
	immutable int representationRows, representationCollumns;
	AbstractCell[][] field; 

}

class ConsoleMaze(Cell,HWall,VWall,Vertex): Maze
	if(isConsoleMazeImplementation!(TypeTuple!(Cell,HWall,VWall,Vertex)))
{
public:
	this(int rows, int collumns)
	{
		super(rows, collumns);		
		foreach(i; 0..representationRows)
			foreach(j; 0..representationCollumns)
			{
				auto code  = (~i&1) | ((~j&1)<<1);

				switch(code)
				{
					case 0:
						field[i][j] = new Cell;
						break;
					case 1:
						field[i][j] = new HWall;
						break;
					case 2:
						field[i][j] = new VWall;
						break;
					case 3:
						field[i][j] = new Vertex;
						break;
					default:
						assert(false, "wrong code calculation");
				}					
			}
		
	}
	
	void draw()const
	{
		import std.stdio: writeln;
		foreach(row; field)
		{
			foreach(cell; row)
				cell.draw();
			writeln();
		}
	}
	
}