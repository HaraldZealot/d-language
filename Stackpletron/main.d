module main.d;


import stackpletron;

void main()
{
	auto machine = Stackpletron();
	machine.loadCode();
	machine.run();
}



