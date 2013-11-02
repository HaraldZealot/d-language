module main;

import std.stdio;

int main(string[] args)
{
    int a, b;
    writeln("a? b?");
    readf(" %s  %s", &a, &b);
    writeln("a = ", a, ", b = ", b);
    int[] upFwdRem = [0, 1], dwFwdRem = [1, 0], upFwdDiv = [0, 1], dwFwdDiv = [1, 0];
    int[] upBwdRem = [0, 1], dwBwdRem = [1, 0], upBwdDiv = [0, 1], dwBwdDiv = [1, 0];
    {
        int c, d;

        do
        {
            c = a % b;
            d = a / b;
            a = b;
            b = c;
            upFwdRem ~= c * upFwdRem[$ -1] + upFwdRem[$ -2];
            dwFwdRem ~= c * dwFwdRem[$ -1] + dwFwdRem[$ -2];
            upFwdDiv ~= d * upFwdDiv[$ -1] + upFwdDiv[$ -2];
            dwFwdDiv ~= d * dwFwdDiv[$ -1] + dwFwdDiv[$ -2];
            upBwdRem ~= upBwdRem[$ -1] + c * upBwdRem[$ -2];
            dwBwdRem ~= dwBwdRem[$ -1] + c * dwBwdRem[$ -2];
            upBwdDiv ~= upBwdDiv[$ -1] + d * upBwdDiv[$ -2];
            dwBwdDiv ~= dwBwdDiv[$ -1] + d * dwBwdDiv[$ -2];
        } while(c);
    }
    writeln();
    writeln(upFwdRem);
    writeln(dwFwdRem);
    writeln();
    writeln(upFwdDiv);
    writeln(dwFwdDiv);
    for(int i=0;i<upBwdDiv.length;++i)
    {
        writef("%s ",cast(real)upFwdDiv[i]/cast(real)dwFwdDiv[i]);
    }
    writeln();
    writeln("\nbackward\n");
    writeln(upBwdRem);
    writeln(dwBwdRem);
    writeln();
    writeln(upBwdDiv);
    writeln(dwBwdDiv);
    for(int i=0;i<upBwdDiv.length;++i)
    {
        writef("%s ",cast(real)upBwdDiv[i]/cast(real)dwBwdDiv[i]);
    }
    writeln();
    return 0;
}
