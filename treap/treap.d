module treap;

import std.traits;

struct Treap(Data)
{
    private struct Node(Data)
    {
        Data content;
        int priority;
        Node* parent, left, right;
        this(Data value, int priority)
        {
            content = value;
            this.priority = priority;
        }
    }

    alias Node!Data* Link;

    private Link root;

    this(Data[] arr)
    {
        static if (!is(typeof(Data.init < Data.init) == bool))
            static assert(0,"Treap alows only comparable data");
        foreach(e ; arr)
            insert(e);
    }

    void insert(Data val)
    {
        Link newNode = new Node!Data(val, 14);
        insert(newNode,root);
    }

    private void insert(Link newNode, ref Link p)
    {
        if(!p)
            p=newNode;
        else if(newNode.priority > p.content)
                split(p, newNode.content, newNode.left, newNode.right), p = newNode;
        else
                insert(newNode, newNode.content < p.content ? p.left : p.right);
    }

    private void split(Link t, Data val, out Link l, out Link r)
    {
        if(!t)
            l=r=null;
        else if(val , t.content)
            split(t.left, val, l, t.left), r = t;
        else
            split(t.right, val, t.right, r), l = t;
    }

}

unittest
{
    auto treap = new Treap!int([4,2,8,0,1,6,16]);

    import std.stdio;
    void printLinear(Treap!int.Link p)
    {
        if(p)
        {
            //writeln(p.content);
            printLinear(p.left);
            writeln(p.content);
            printLinear(p.right);
            //writeln(p.content);
        }
    }
    printLinear(treap.root);
    readln();
}

