/q tick/cep.q [host]:port[:usr:pwd]

upd:insert;

/ Connect to ticker plant
tick:(hsym `$":",tick;`::5010) ""~tick:.z.x 0;
h: @[hopen;tick;{'"Could not connect to ticker plant at ", (-3!tick), " due to: ", x}];

/ Subscribe to trades and quotes table
tabs:`trades`quotes;
.u.rep:{ [x;y]
    (.[;();:;].) each $[all null tabs;x;enlist x];
    if[null first y;:()];
    if[all tabs in tables[];
        -11!y;
        ]
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

/ Start timer
system "t 1000";
