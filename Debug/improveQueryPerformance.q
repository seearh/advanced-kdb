StringtoDate:{[x]{$[10h~abs type x;x:"D"$x;-14h~ type x;x:x;`date$x]}'[x]};
input: raze 500000#enlist("2010.01.01";2010.01.02);

/ Performance test
0N! "Base performance test";
0N! system "ts:10 StringtoDate input";

/ Remove use of nested function by using Amend At for vectorization
StringtoDate1: {.[; enlist where not -14h=t; `date$x] .[x; enlist where 10h=abs t: type each x; "D"$]};
0N! "Performance test V1";
0N! system "ts:10 StringtoDate1 input";

/ Optional: Don't touch non-strings (or characters for that matter, as Tok will fail, this saves using abs) as functions should be specialized
StringtoDate2: {.[x; enlist where 10h=type each x; "D"$]};
0N! "Performance test V2";
0N! system "ts:10 StringtoDate2 input";

/ If inputs are expected to contain few distinct values, mapping of string dates can be used instead
StringtoDate3: {(a!@[a; where 10h = type each a: distinct x; "D"$])[x]}
0N! "Performance test V3";
0N! system "ts:10 StringtoDate3 input";