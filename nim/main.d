module main;

import std.stdio, std.conv;

void main()
{
	try{

		writeln("This is nim game.\n\nRULES:\nThere are some heaps. Each heap contain some stones.");
		writeln("The two player take any possible amount (at least one)\nof stone per turn from any heaps.");
		writeln("Player who takes last stones on the tables win.");
		writeln("\n\n\nLet start! Select level of computer opponent:\n1. wise\n2. fool");
		auto select = 0;
		do{
			readf(" %s", &select);
			if(select!=1 && select !=2)
				stderr.writeln("only 1 or 2 is possible");
		}while(select!=1 && select !=2);
	}
	catch(Exception e)
	{
		stderr.writeln(e.msg);
	}
}

