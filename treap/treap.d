module treap;

import std.traits, std.random;

struct Treap(Data)
{
    private struct Node(Data)
    {
        Data content;
        int priority;
        Node *parent, left, right;
        this(Data value, int priority)
        {
            content = value;
            this.priority = priority;
        }
    }
    alias Node!Data *Link;
    private Link root;
    this(Data[] arr)
    {

        static if(!is(typeof(Data.init < Data.init) == bool))
            static assert(0, "Treap alows only comparable data");

        foreach(e ; arr)
        insert(e);
    }
    void insert(Data val)
    {
        Link newNode = new Node!Data(val, uniform(0, 100));
        insert(newNode, root);
    }
    static private void insert(Link newNode, ref Link p)
    {
        if(!p)
            p = newNode;
        else if(newNode.priority > p.priority)
        {
            split(p, newNode.content, newNode.left, newNode.right);
            p = newNode;
        }
        else
            insert(newNode, newNode.content < p.content ? p.left : p.right);
    }
    static private void split(Link t, Data val, ref Link l, ref Link r)
    {
        if(!t)
            l = r = null;
        else if(val < t.content)
            split(t.left, val, l, t.left), r = t;
        else
            split(t.right, val, t.right, r), l = t;
    }
    void erase(Data value)
    {
        erase(root, value);
    }
    static private void erase(ref Link t, Data value)
    {
        if(t)
        {
            if(t.content == value)
                merge(t, t.left, t.right);
            else
                erase(value < t.content ? t.left : t.right, value);
        }
    }

    static private void merge(ref Link t, Link l, Link r)
    {
        if(!l || !r)
            t = l ? l : r;
        else if(l.priority > r.priority)
            merge(l.right, l.right, r), t = l;
        else
            merge(r.left, l, r.left), t = r;
    }

    auto reduce(alias fun, T )(fun, T init = T.init)
    {

    }
}

unittest
{
    auto treap = new Treap!int([18, 19, 35, 65, 34, 76, 89, ]);//90, 4, 2, 8, 0, 1, 6, 16]);

    import std.stdio;
    real procentMetric(Data)(const ref Treap!Data treap)
    {
        int count(Data)(const Treap!Data.Link t, int init)
        {
            if(t)
                return count!int(t.left,init)+count!int(t.right,init)+1;
            else
                return init;
        }
        int height(Data)(const Treap!Data.Link t, int init)
        {
            if(t)
                return (height!int(t.left,init)>height!int(t.right,init)?height!int(t.left,init):height!int(t.right,init))+1;
            else
                return init;
        }
        int cnt = count!int(treap.root,0);
        int hgh = height!int(treap.root,0);
        writeln("cnt = ", cnt, " hgh = ", hgh);
        if(!hgh)
            return 1.0;
        return cast(real)cnt/cast(real)((1UL<<hgh) - 1);
    }
    void printLinear(Treap!int.Link p)
    {
        if(p)
        {
            //writeln(p.content);
            printLinear(p.left);
            write(p.content," ");
            printLinear(p.right);
            //writeln(p.content);
        }
    }
    printLinear(treap.root);
    writeln("\nproM = ", procentMetric!int(*treap));
    enum Hiral {C, R, L}
    string hiralise(Hiral prev, Hiral cur)
    {
        if(prev == Hiral.C && cur == Hiral.L)
            return "";
        else if(prev == Hiral.C && cur == Hiral.R)
            return "";
        else if(prev == cur)
            return "   ";
        else
            return "\u2502  ";
    }
    string prefix(Hiral cur)
    {
        if(cur == Hiral.C)
            return "";
        else if(cur == Hiral.R)
            return "\u250c\u2500\u2500";
        else
            return "\u2514\u2500\u2500";
    }
    void printTreelike(Treap!int.Link p, int level, string oldPrefix, Hiral cur)
    {
        if(p)
        {
            printTreelike(p.right, level + 1, oldPrefix ~ hiralise(cur, Hiral.R), Hiral.R);
            writeln(oldPrefix, prefix(cur), p.content, " "); //,p.priority);//, " level = ", level);
            printTreelike(p.left, level + 1, oldPrefix ~ hiralise(cur, Hiral.L), Hiral.L);
        }

        //else
        //   writeln(oldPrefix,prefix(cur),"null");//, " level = ", level);
    }
    printTreelike(treap.root, 0, "", Hiral.C);
    /*treap.erase(35);
    printTreelike(treap.root, 0, "", Hiral.C);
    int kkey = 17;
    Treap!int.Link left, right;
    treap.split(treap.root, kkey, left, right);

    writeln("\n\n");
    printTreelike(right, 0, "", Hiral.C);
    writeln("\nsplit by ", kkey, "\n");
    printTreelike(left, 0, "", Hiral.C);
    Treap!int.Link ntr;
    Treap!int.merge(ntr, left, right);
    printTreelike(ntr, 0, "", Hiral.C); */
    //readln();
}

