module main;

import std.stdio;

interface Statistics {
   void accumulate(double x);
   void postprocess();
   double result();
}

class IncrementalStatistics: Statistics
{
   private double m_result;
   protected ref double mresult() {return m_result;}
   abstract void accumulate(double x);
   void postprocess() {}
   double result() {
      return m_result;
   }
}

class Min: IncrementalStatistics
{
   this() {mresult() = double.max;}
   void accumulate(double x) {
      if(mresult() > x) {
         mresult = x;
      }
   }
}

class Max: IncrementalStatistics
{
   private double max = double.min;
   void accumulate(double x) {
      if(max < x) {
         max = x;
      }
   }
   void postprocess() {}
   double result() {
      return max;
   }
}

class Average: IncrementalStatistics
{

}

void main(string[] args)
{
   foreach(argument; args)
   writeln(argument);
}
