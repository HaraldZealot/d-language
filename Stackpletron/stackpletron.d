module stackpletron;

import std.stdio;

struct Stackpletron
{
	private enum memorySize = 100;


	public void loadCode()
	{
		int checkedInput(short i)
		{
			long inputed;
			writef("%02d?\t", i);
			readf(" %d", &inputed);
			while((inputed < -9999 || 9999 < inputed) && -99999 != inputed)
			{
				writef("%02d?\t", i);
				readf(" %d", &inputed);
			}
			return cast(int)inputed;
		}
		
		short i = 0;
		int inputed = checkedInput(i);
		while(inputed != -99999)
		{
			memory[i] = cast(short)inputed;
			++i;
			inputed = checkedInput(i);
		}
	}

	public void printDump()
	{
		writeln("registers");
		writeln("A\t", accumulatorRegister);
		writeln("B\t", biasRegister);
		writeln("I\t", instructionRegister);
		writeln("\n\nmemory");
		enum base = 10;
		write("\t");
		foreach(i;0..base)
			writef("   %02d  ", i);
		foreach(i, word; memory)
		{
			if(i % base == 0)
				writef("\n%02d\t", base * (i / base));
			
			writef("%+05d  ", word);
		}
		writeln();
	}

	public void run()
	{
		try{
			do{
				extract();
				final switch(cast(OperationCode)operandRegister)
				{
					case OperationCode.READ:
						write("input:  ");
						readf(" %d", &memory[addressRegister + biasRegister]);
						break;
					case OperationCode.WRITE:
						writefln("\noutput: %+05d", memory[addressRegister + biasRegister]);
						break;

					case OperationCode.LOAD:
						accumulatorRegister = memory[addressRegister + biasRegister];
						break;
					case OperationCode.STORE:
						memory[addressRegister + biasRegister] = accumulatorRegister;
						break;
					case OperationCode.LOADTOP:
						accumulatorRegister = stackTopRegister;
						break;
					case OperationCode.STORETOP:
						stackTopRegister = accumulatorRegister;
						break;
					case OperationCode.LOADBIAS:
						accumulatorRegister = biasRegister;
						break;
					case OperationCode.STOREBIAS:
						biasRegister = accumulatorRegister;
						break;
					case OperationCode.PUSH:
						memory[--stackTopRegister] = accumulatorRegister;
						break;
					case OperationCode.POP:
						accumulatorRegister = memory[stackTopRegister++];
						break;

					case OperationCode.ADD:
						accumulatorRegister += memory[addressRegister + biasRegister];
						break;
					case OperationCode.SUBSTRACT:
						accumulatorRegister -= memory[addressRegister + biasRegister];
						break;
					case OperationCode.DIVIDE:
						accumulatorRegister /= memory[addressRegister + biasRegister];
						break;
					case OperationCode.MULTIPLY:
						accumulatorRegister *= memory[addressRegister + biasRegister];
						break;
					case OperationCode.LITERAL:
						accumulatorRegister = addressRegister;
						break;

					case OperationCode.BRANCH:
						instructionRegister = cast(short)(addressRegister - 1);
						break;
					case OperationCode.BRANCHNEG:
						if(accumulatorRegister < 0)
							instructionRegister = cast(short)(addressRegister - 1);
						break;
					case OperationCode.BRANCHZERO:
						if(accumulatorRegister == 0)
							instructionRegister = cast(short)(addressRegister - 1);
						break;
					case OperationCode.HALT:
						--instructionRegister;
						break;
					case OperationCode.CALL:
						memory[--stackTopRegister] = instructionRegister;
						instructionRegister = cast(short)(addressRegister - 1);
						break;
					case OperationCode.RETURN:
						instructionRegister = memory[stackTopRegister++];
						foreach(unused;0..addressRegister)
							stackTopRegister++;
						break;
				}
				++instructionRegister;
			}while(operandRegister != OperationCode.HALT);
			writeln("\nStackpletron has succecfully finished\n");
			printDump();
		}catch(Throwable e)
		{
			writefln("An error \"%s\" has occured", e.msg);
			printDump;
		}
	}


	private void extract()pure nothrow @safe @nogc
	{
		short currentCode = memory[instructionRegister];
		if(currentCode < 0)
			operandRegister = -currentCode / memorySize;
		else
			operandRegister = currentCode / memorySize;
		addressRegister = currentCode % memorySize;
	}

private:

	enum OperationCode: short {
		READ = 10,
		WRITE = 11,

		LOAD = 20,
		STORE = 21,
		LOADTOP = 22,
		STORETOP = 23,
		LOADBIAS = 24,
		STOREBIAS =25,
		PUSH = 26,
		POP = 27,

		ADD = 30,
		SUBSTRACT = 31,
		DIVIDE = 32,
		MULTIPLY = 33,
		LITERAL = 34,

		BRANCH = 40,
		BRANCHNEG = 41,
		BRANCHZERO = 42,
		HALT = 43,
		CALL = 44,
		RETURN = 45}

	short[] memory = new short[memorySize];
	short operandRegister;
	short addressRegister;
	short instructionRegister = 0;
	short accumulatorRegister = 0;
	short stackTopRegister = memorySize;
	short biasRegister = 0;
}

