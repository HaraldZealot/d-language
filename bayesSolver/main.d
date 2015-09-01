module main;

import std.stdio;

void main()
{
	alias H = Hypotese;
	auto hypoteses = [H(0.25L, [0.0L, 1.0L]), H(0.25L, [1.0L/3.0L, 2.0L/3.0L]), H(0.25L, [2.0L/3.0L, 1.0L/3.0L]), H(0.25L, [1.0L, 0.0L])];

	foreach(i; 0..10)
	{
		writeln(hypoteses);
		size_t event;
		readf(" %u", &event);
		bayesUpdate(event, hypoteses);
	}
	writeln(hypoteses);
}

void bayesUpdate(size_t event, Hypotese[] hypoteses)
{
	real fullProbability = 0.0L;

	foreach(hypotese; hypoteses)
		fullProbability += hypotese.probability * hypotese.eventProbability[event];

	foreach(ref hypotese; hypoteses)
		hypotese.probability = hypotese.probability * hypotese.eventProbability[event] / fullProbability;
}

struct Hypotese
{
public:
	real probability;
	immutable(real[]) eventProbability;

	this(real probability, const(real)[] events)pure
	{
		this.probability = probability;
		eventProbability = events.idup;
	}
}