input: raze 500000#enlist("2010.01.01";2010.01.02);
perfTab: flip `func`time`memMB!"STJ"$\:();

system "c 500 500";

show StringtoDate:{[x]
    {
        $[10h~abs type x;
            x:"D"$x;
        -14h~type x;
            x:x;
            `date$x]
        }'[x]
    };
0N! "Testing StringtoDate...";
show t: system "ts:50 StringtoDate input";
`perfTab upsert (`StringtoDate;"t"$t 0;t 1);

0N! "Replace nested function and if-else with Amend At...";
show StringtoDateAmendAt: { 
    @[; where not -14h=t; `date$x] @[x; enlist where 10h=abs t:type each x; "D"$] 
    };
0N! "Testing StringtoDateAmendAt...";
show t: system "ts:50 StringtoDateAmendAt input";
`perfTab upsert (`StringtoDateAmendAt;"t"$t 0;t 1);

0N! "Replace nested function and if-else with Dot Amend...";
show StringtoDateDotAmend: { 
    .[; enlist where not -14h=t; `date$x] .[x; enlist where 10h=abs t:type each x; "D"$] 
    };
0N! "Testing StringtoDateDotAmend...";
show t: system "ts:50 StringtoDateDotAmend input";
`perfTab upsert (`StringtoDateDotAmend;"t"$t 0;t 1);

0N! "Amend At string types only...";
show StringtoDateAmendStrings: { @[x; where 10h=type each x; "D"$] };
0N! "Testing StringtoDateAmendStrings...";
show t: system "ts:50 StringtoDateAmendStrings input";
`perfTab upsert (`StringtoDateAmendStrings;"t"$t 0;t 1);

0N! "Dot Amend string types only...";
show StringtoDateDotAmendStrings: { .[x; enlist where 10h=type each x; "D"$] };
0N! "Testing StringtoDateDotAmendStrings...";
show t: system "ts:50 StringtoDateDotAmendStrings input";
`perfTab upsert (`StringtoDateDotAmendStrings;"t"$t 0;t 1);

0N! "Direct mapping of string dates to dates...";
show StringtoDateMapping: { (a!@[a; where 10h=type each a: distinct x; "D"$])[x] };
0N! "Testing StringtoDateMapping...";
show t: system "ts:50 StringtoDateMapping input";
`perfTab upsert (`StringtoDateMapping;"t"$t 0;t 1);

update memMB: memMB%1024 xexp 2, timeFact: (first perfTab`time)%time, memFact:memMB%(first perfTab`memMB) from `perfTab;
show perfTab;