module source;

import arc;

struct Source
{
	const(Arc) getArc() const
	{
		return arc;
	}

	void transmorgrify(int x, int y)
	{
		arc.inputA(x - y);
		arc.inputB(x ^ y);
	}

private:
	Arc arc = new Arc;
}
