`schema`tick set' .z.x 0 1;

/ Load in schema file
system"l tick/",(first enlist[schema],enlist"sym"),".q";

/ Initialize logging
system"l utils/logging.q";
.log.initLog[`:log;`;1];

.log.info["Connecting to tickerplant at ", -3!tick:(hsym `$":",tick;`::5010) ""~tick];
h: @[hopen;tick;{'"Could not connect to ticker plant at ", (-3!tick), " due to: ", x}];

\d .feed

/ Generators of random feeds
gensym: { x?`AAPL`AMZN`FB`GOOG`IBM };
genlong: { x?10000 };
genfloat: { x?100.0 };
genmap: "sfj"!(gensym;genfloat;genlong);
gen: { [t;x] genmap[exec t from meta t where c<>`time] @\: x };

\d .

.z.ts: {
    { h(`.u.upd;x;.feed.gen[x;10]) } each `trades`quotes;
    };
.log.info["Starting timer..."];
system "t 1000";