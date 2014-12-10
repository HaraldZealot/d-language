module main;

import std.stdio, std.conv, std.random;

immutable int maxStones = 8;

void main()
{
	try{
		writeln("This is nim game.\n\nRULES:\nThere are some heaps. Each heap contain some stones.");
		writeln("The two player take any possible amount (at least one)\n"
				"of stone per turn from any heaps.");
		writeln("Player who takes last stones on the tables win.");

		writeln("\n\n\nLet start!");
		auto heaps = generateHeaps(3);

		auto turn = 0;// human
		do
		{
			outputHeaps(heaps);
			if(turn==0)
			{
				writeln("It's your turn:");
				humanTurn(heaps);
			}
			else if(turn == 1)
			{
				computerTurn(heaps);
				writeln("Computer have made its turn.");
			}
			turn = 1 - turn;
		}while(canTurn(heaps));

		auto resultTitles = ["Human", "Computer"];
		writefln("\n\n\n%s is win!!!\n%s is lost.", resultTitles[1-turn], resultTitles[turn]);
	}
	catch(Exception e)
	{
		stderr.writeln(e.msg);
	}
}

int[] generateHeaps(int count)
{
	auto heaps = new int[count];
	for(auto i = 0; i < heaps.length; ++i)
	{
		heaps[i] = uniform(1,maxStones);
	}
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

void humanTurn(int[] heaps)
{
	writefln("Enter letter from 'A' to '%c':", cast(char)(heaps.length - 1 + 'A'));
	int index;
	do
	{
		char symbol;
		readf(" %c", &symbol);
		index = symbol - 'A';
		if(index < 0 || index >= heaps.length)
		{
			stderr.writeln("imposible letter");
			continue;
		}
		if(!heaps[index])
			stderr.writeln("this heap is allready empty");
	}while(index<0 || index>=heaps.length || !heaps[index]);

	writefln("What count of stones will you take from '%c' heap?\n(Enter number between 1 and %d):", 
	         cast(char)(index+'A'), heaps[index]);
	int amount;
	do
	{
		readf(" %d", &amount);
		if(amount < 1)
			stderr.writeln("You have to take some stones");
		if(amount > heaps[index])
			stderr.writeln("There are not enough in the heap");
	}while(amount < 1 || amount > heaps[index]);
	heaps[index] -= amount;
}

void computerTurn(int[] heaps)
{
	ulong index;
	do{
		index = uniform(0, heaps.length);
	}while(!heaps[index]);
	heaps[index] -= uniform!"[]"(1, heaps[index]);
}

bool canTurn(int[] heaps)
{
	foreach(heap;heaps)
		if(heap)
			return true;
	return false;
}