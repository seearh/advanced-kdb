/q tick.q [host]:port[:usr:pwd]
/
    globals used
    .u.w - dictionary of tables->(handle;syms)
    .u.i - msg count in log file
    .u.j - total msg count (log file plus those held in buffer)
    .u.J - per table msg count processed by tickerplant (excluding log)
    .u.t - table names
    .u.L - tp log filename, e.g. `:./sym2008.09.11
    .u.l - handle to tp log file
    .u.d - date
\

system"l tick/",(src:first .z.x,enlist"sym"),".q"

/ Initialize logging
system"l utils/logging.q";
.log.initLog[`:log;`;1];
.log.everyMin:{
    if[not `lastRan in key `.log;.log.lastRan:"n"$0];
    if[60<"j"$"v"$.z.p-.log.lastRan;
        .log.info["Messages processed:",-3!.u.J];
        .log.info["Subscription details:",-3!.u.w];
        .log.lastRan:x
        ];
    };

if[not system"p";system"p 5010"]

\l tick/u.q
\d .u
ld:{if[not type key L::`$(-10_string L),string x;.[L;();:;()]];i::j::-11!(-2;L);if[0<=type i;-2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";exit 1];hopen L};
tick:{init[];if[not min(`time`sym~2#key flip value@)each t;'`timesym];@[;`sym;`g#]each t;d::.z.D;if[l::count y;L::`$":",y,"/",x,10#".";l::ld d]};

endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};
ts:{if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};

if[system"t";
 .log.info["Starting tickerplant in zero latency mode"];
 .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D;.log.everyMin x};
 upd:{[t;x]
 if[not -16=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 t insert x;if[l;l enlist (`upd;t;x);j+:1];J[t]+:1;}];

if[not system"t";system"t 1000";
 .log.info["Starting tickerplant in batch mode"];
 .z.ts:{ts .z.D;.log.everyMin x};
 upd:{[t;x]ts"d"$a:.z.P;
 if[not -16=type first first x;a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 f:key flip value t;pub[t;$[0>type first x;enlist f!x;flip f!x]];if[l;l enlist (`upd;t;x);i+:1;J[t]+:1];}];

\d .
.u.tick[src;.z.x 1];
.log.info["Tickerplant initialization complete"];
