module main;

import source;
import destination;

void main()
{
	Source s;
	auto d = Destination(s.getArc());
	s.transmorgrify(5, 1);
	d.process();
	s.transmorgrify(17, 13);
	d.process();
}
