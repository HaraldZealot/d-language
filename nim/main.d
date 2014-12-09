module main;

import std.stdio, std.conv, std.random;

immutable int maxStones = 8;

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
	auto nimSum = 0;
	for(auto i = 0; i < heaps.length - 1; ++i)
	{
		heaps[i] = uniform(1,maxStones);
		nimSum ^= heaps[i];
	}
	for(auto i = 0; i<3; ++i)
	{
		nimSum ^= 1 << uniform(0, countOfBits(maxStones));
	}
	while(!nimSum)
	{
		nimSum ^= 1 << uniform(0, countOfBits(maxStones));
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

	writefln("What count of stones will you take from '%c' heap?\n(Enter number between 1 and %d):", cast(char)(index+'A'), heaps[index]);
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
	auto nimSum = 0;
	foreach(heap; heaps)
		nimSum ^= heap;
	if(nimSum)
	{
		auto index = 0;
		while(heaps[index] <= (heaps[index] ^ nimSum))
			++index;
		heaps[index] ^= nimSum;
	}
	else
	{
		ulong index;
		do{
			index = uniform(0, heaps.length);
		}while(!heaps[index]);
		heaps[index] -= uniform!"[]"(1, heaps[index]);
	}
}

bool canTurn(int[] heaps)
{
	foreach(heap;heaps)
		if(heap)
			return true;
	return false;
}

unittest
{
	assert(5==countOfBits(31));
	assert(5==countOfBits(32));
	assert(6==countOfBits(33));
}

int countOfBits(int number)
{
	int count = 0, representation=1;
	while(representation < number)
	{
		representation <<= 1;
		++count;
	}
	return count;
}

