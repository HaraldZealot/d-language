module main;

import std.stdio, std.conv;

int main(string[] args)
{
   foreach(i, element;preSieveTable){
      writef("%4d",element);
      if((i%7)==6)writeln();
   }
   return 0;
}

mixin(makePreSieve("preSieveTable",200));
unittest
{
   assert(preSieveTable[0..9]==[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]);
}

string makePreSieve(string name, uint length=100)
{
   string result = "immutable ushort[] " ~ name ~ " = [";
   uint d = 0, c = 63052531;

   for(uint i = 2; i < length; i += d)
   {
      result ~= to!(string)(i) ~ ", ";
      d = c / 47079200;
      c = c % 47079200;
      c *= 7;
   }

   return result ~ "];";
}






