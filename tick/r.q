/ q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd] [-tabs TAB1,TAB2,...] [-db dbDir]

if[not "w"=first string .z.o;system "sleep 1"];

upd:{ if[x in tables`.;x insert y] };

/ Initialize logging
system"l utils/logging.q";
.log.initLog[`:log;`;1];

if[not ()~tabs:first (o:.Q.opt .z.X)@`tabs;
    tabs:`$"," vs tabs];
.log.info["Tables to subscribe to: ", -3!tabs];

.log.info["(TP;HDB) handles: ", -3!.u.x:(2_.Q.x),-[count .Q.x;2]_(":5010";":5012")];

.u.end:{
    .log.info["Running EOD"];
    t:tables`.;
    t@:where `g=attr each t@\:`sym;
    .Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
    @[;`sym;`g#] each t;
    };

.u.rep:{
    .log.info["Initializing schema of ", -3!x 0];
    (.[;();:;].) x;
    if[null first y;:()];
    if[all tabs in tables[];
        .log.info["Replaying ",(-3!y 0)," rows from ",(-3!y 1)," and cd to HDB"];
        -11!y;
        $[`db in key o;
            system "cd ", first o`db;
            system "cd ",1_-10_string first reverse y];
        .log.info["Replay complete, current working directory is ", system "cd"]
        ];
    };

.log.info["Connecting to tickerplant at ", -3!tick:`$":",.u.x 0];
h:hopen tick;
subMsg:{ "(.u.sub[",(.Q.s1 x),";`];`.u `i`L)" };

$[count tabs;
    { .u.rep . @[h;subMsg x] } each tabs;
    .u.rep . @[h;subMsg `]];