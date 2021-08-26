/ q eod.q LOG_FILEPATH DB_ROOT
`fp`db set' .z.x 0 1;

\l tick/sym.q

if[()~key fp: hsym `$fp;
    msg:(-3!fp)," not found";
    'msg];
date: "D"$-10#string fp;

0N!"Replaying log for ", -3!date;
upd: insert;
-11!fp;

db:hsym `$db;
comp_save: {
    dir: (.Q.dd/)(db;date;x;`);
    comp_dic: ![;enlist[17 2 9],count[c]#enlist 17 2 6] `,c:cols[x] except `time`sym;
    (dir;comp_dic) set .Q.en[db] select from x where sym=`IBM
    };
comp_save each tables`.;
