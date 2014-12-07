module main;

import std.stdio, std.conv, std.random;

void main()
{
	try{

		writeln("This is nim game.\n\nRULES:\nThere are some heaps. Each heap contain some stones.");
		writeln("The two player take any possible amount (at least one)\nof stone per turn from any heaps.");
		writeln("Player who takes last stones on the tables win.");

		writeln("\n\n\nLet start! Select level of computer opponent:\n1. wise\n2. fool");
		auto intelegentChoise = 0;
		do{
			readf(" %s", &intelegentChoise);
			if(intelegentChoise != 1 && intelegentChoise != 2)
				stderr.writeln("only 1 or 2 is possible");
		}while(intelegentChoise != 1 && intelegentChoise != 2);

		writeln("\nSelect level of game:\n1. Easy\n2. Normal\n3. Hard\n4. Very Hard");
		auto levelChoise=0;
		do{
			readf(" %s", &levelChoise);
			if(levelChoise<1 || levelChoise>4)
				stderr.writeln("only number between 1 and 4 is possible");
		}while(levelChoise<1 || levelChoise>4);
		auto levelToHeap =[1:3, 2:5, 3:6, 4:10];

		auto heaps = generateHeaps(levelToHeap[levelChoise]);
		outputHeaps(heaps);

	}
	catch(Exception e)
	{
		stderr.writeln(e.msg);
	}
}

int[] generateHeaps(int count)
{
	auto heaps = new int[count];
	auto nimSum = 0;
	for(auto i = 0; i < heaps.length - 1; ++i)
	{
		heaps[i] = uniform(1,32);
		nimSum ^= heaps[i];
	}
	for(auto i = 0; i<3; ++i)
	{
		nimSum ^= 1 << uniform(0,5);
	}
	while(!nimSum)
	{
		nimSum ^= 1 << uniform(0,5);
	}
	heaps[$-1] = nimSum;
	return heaps;
}

void outputHeaps(int[] heaps)
{
	writeln("\nStones in heaps");
	for(auto i=0;i<heaps.length;++i)
	{
		writef("%3d ", heaps[i]);
	}
	writeln();
	for(auto i=0;i<heaps.length;++i)
	{
		writef("  %c ", cast(char)('A' + i));
	}
	writeln();
}

