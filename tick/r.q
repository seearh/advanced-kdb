/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd] [-tabs TAB1,TAB2,...]

if[not "w"=first string .z.o;system "sleep 1"];

upd:insert;

/ Get tables to subscribe to from CL options
if[not ()~tabs:first (.Q.opt .z.X)@`tabs;
    tabs:`$"," vs tabs];

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:(2_.Q.x),-[count .Q.x;2]_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{
    (.[;();:;].) each $[all null tabs;x;enlist x];
    if[null first y;:()];
    if[all tabs in tables[];
        -11!y;
        system "cd ",1_-10_string first reverse y
        ]
    };
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
h:hopen `$":",.u.x 0;
subMsg:{ "(.u.sub[",(.Q.s1 x),";`];`.u `i`L)" };

$[count tabs;
    { .u.rep . @[h;subMsg x] } each tabs;
    .u.rep . @[h;subMsg `]];