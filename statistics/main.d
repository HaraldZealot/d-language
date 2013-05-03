module main;

import std.stdio, std.exception;

interface Statistic {
   void accumulate(double x);
   void postprocess();
   double result();
}

class IncrementalStatistic: Statistic
{
   private double m_result;
   protected ref double mresult() {return m_result;}
   abstract void accumulate(double x);
   void postprocess() {}
   double result() {
      return m_result;
   }
}

class Min: IncrementalStatistic
{
   this() {mresult() = double.max;}
   void accumulate(double x) {
      if(mresult() > x) {
         mresult = x;
      }
   }
}

class Max: IncrementalStatistic
{
   this() {mresult() = double.min;}
   void accumulate(double x) {
      if(mresult() < x) {
         mresult = x;
      }
   }
}

class Average: IncrementalStatistic
{
   private uint m_count = 0;
   this() {mresult() = 0.0;}
   void accumulate(double x) {
      mresult() += x;
      ++m_count;
   }
   override void postprocess() {
      mresult() /= m_count;
   }
}

void main(string[] args)
{
   try {
      Statistic[] statistics;
      foreach(arg; args[1 .. $])
      {
         auto newStat = cast(Statistic) Object.factory("main." ~ arg);
         enforce(newStat,"Invalid statistic function: " ~ arg);
         statistics ~= newStat;
      }

      for(double x; readf(" %s ", &x) == 1;)
         foreach(s; statistics)
         s.accumulate(x);

      foreach(s; statistics) {
         s.postprocess();
         writeln(s.result());
      }
   }
   catch(Exception e)
   {
      writeln(e.msg);
   }
}
