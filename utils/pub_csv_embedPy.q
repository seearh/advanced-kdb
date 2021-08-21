/ q pub_csv_embedPy.q CSV_FILE_PATH TABLE [HOST]:[PORT]:[USER]:[PW]

\l p.q

/ Check for 2 mandatory positional arguments
if[2 > c:count .z.x;'"At least 2 arguments expected, ", (string c), " provided"];
`fp`tab`tick set' .z.x 0 1 2;

/ Validate CSV file path
if[()~key hsym `$fp;'fp," not found"];
if[not ".csv"~-4#fp;(last "/" vs fp)," is not a .csv file"];

/ Validate tickerplant connection, default at port 5010
tick:(hsym `$":",tick;`::5010) ""~tick;
h: @[hopen;tick;{'"Could not connect to ticker plant at ", (-3!tick), " due to: ", x}];

/ Validate table to publish to
if[not (tab:`$tab) in t:h`.u.t;'string[tab], " table does not exist in tickerplant. Tables include: ", -3!t];

/ Grab schema from tickerplant
m: exec upper t, c from h(`.q.meta;tab);

/ Use embedPy to read CSV into q
pd:.p.import`pandas;
read_csv:pd`:read_csv;
df:read_csv["TRADES.csv"];
data:flip m[`c]!df[;`:tolist;<;(::)] each hsym m`c;

/ Columns typing
non_matches: (),where m[`t]<>exec upper t from meta data;
data:![data;();0b;.[m;(`c;non_matches)]!enlist[$;;]./: @[(flip;enlist);1>count non_matches] .[value m;(::;non_matches)]];

/ Publish to ticker plant
h(`.u.upd;tab;value flip data);
0N!"Published ", string[count data], " rows to ", string[tab], " table in tickerplant at ", -3!tick;
exit 0;