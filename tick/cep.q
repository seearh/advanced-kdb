/ q tick/cep.q [host]:port[:usr:pwd]

/ Initialize logging
system"l utils/logging.q";
.log.initLog[`:log;`;1];

upd:insert;

tick:(hsym `$":",tick;`::5010) ""~tick:.z.x 0;
.log.info["Connecting to tickerplant at ", -3!tick];
h: @[hopen;tick;{.log.err["Could not connect to ticker plant at ", (-3!tick), " due to: ", x]}];

.log.info["Tables to subscribe to: ", -3!tabs:`trades`quotes];
.u.rep:{ [x;y]
    .log.info["Initializing schema of ", -3!x];
    (.[;();:;].) each $[all null tabs;x;enlist x];
    if[null first y;:()];
    if[all tabs in tables[];
        .log.info["Replaying ",(-3!y 0)," rows from ",(-3!y 1)];
        -11!y;
        .log.info["Replay complete"]
        ];
    };
subMsg:{ "(.u.sub[",(.Q.s1 x),";`];`.u `i`L)" };
{ .u.rep . @[h;subMsg x] } each tabs;

/ Timer function to calculate and publish to tickerplant agg table
agg_cols: `sym`pmax`pmin`hibid`loask`volume;
calc_agg: {
    agg_cols xcols 0!lj[select pmax: max price, pmin: min price, volume: sum size by sym from trades;
        select hibid:last bid, loask:last ask by sym from quotes]
    };
.z.ts: { h(`.u.upd;`agg;value flip calc_agg[]); };

.log.info["Starting timer..."];
system "t 1000";
