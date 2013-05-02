module main;

import std.stdio, std.array;



void main(string[] args)
{
   writefln("Hello World\n");

   writefln("min%s = %s", [-1, 2, 3], min([-1, 2, 3]));
   writefln("min%s = %s", [3.5, 2, 1e-6], min([3.5, 2, 1e-6]));
   writefln("min%s = %s", ["ac", "ab", "b"], min(["ac", "ab", "b"]));
   //return 0;
}


T min(T)(T[] input)
{
   if(!input.empty) {
      auto result = input[0];
      foreach(element; input)

      if(element < result) {
         result = element;
      }

      return result;
   }
   else { assert(false); }
}
