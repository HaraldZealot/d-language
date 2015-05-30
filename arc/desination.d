module destination;

import arc;
import std.stdio;

struct Destination
{
	this(const(Arc) arc)
	{
		this.arc = arc;
	}

	void process()
	{
		writeln(3+arc.output()*5);
	}

private:
	const Arc arc;
}
