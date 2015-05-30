module arc;

final class Arc
{
	int output() const
	{
		return a * b;
	}
	
	void inputA(int val)
	{
		a = val;
	}
	
	void inputB(int val)
	{
		b = val;
	}
	
private:
	int a = 1, b = 1;
}
