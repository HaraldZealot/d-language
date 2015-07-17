module thrmch.machine;

import terms.common;

struct Machine
{
public:
	void moveForward()
	{
		if(current)
			current = current.next;
	}

	void moveBackward()
	{
		if(current)
			current = current.previous;
	}

	OutputTerm remove()
	{
		if(current)
		{
			Node* previousNeigbour = current.previous, nextNeigbour = current.next;

			if(previousNeigbour)
				previousNeigbour.next = nextNeigbour;

			if(nextNeigbour)
				nextNeigbour.previous = previousNeigbour;

			current.previous = stack;
			current.next = null;

			stack = current;
			current = previousNeigbour;

			return stack.term;
		}
		else
			return null;
	}

	void change(OutputTerm newValue)
	{
		if(stack)
			stack.term = newValue;
	}

	void add(OutputTerm value)
	{
		Node* p;
		p = new Node(value);

		p.previous = stack;
		stack = p;
	}

	void insert()
	{
		if(stack)
		{
			if(current)
			{
				Node* previousNeigbour = current, nextNeigbour = current.next;

				if(previousNeigbour)
					previousNeigbour.next = stack;

				if(nextNeigbour)
					nextNeigbour.previous = stack;
			}

			current = stack;

			stack = stack.previous;
		}
	}

private:

	struct Node
	{
		OutputTerm term;

		Node* previous, next;
	}

	Node* current;

	Node* stack;

}