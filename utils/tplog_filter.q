/ q tplog_filter.q ORIG_TPLOG NEW_TPLOG

if[2<>c:count .z.x;'"2 arguments expected, ", (string c), " provided"];
`orig`new set' hsym `$.z.x 0 1;

0N!"Grabbing ", string[orig], "...";
logmsg: get orig;
0N!"It now has ", string[count logmsg], " log messages";

0N!"Filtering trades table updates...";
logmsg: logmsg where `trades=@[flip logmsg;1];
0N!"It now has ", string[count logmsg], " log messages";

0N!"Filtering updates to sym IBM...";
logmsg: @[;2;{flip flip[x] where `IBM=x@1}] each logmsg;
0N!"It now has ", string[count logmsg], " log messages";

0N!"Removing redundant messages...";
logmsg: logmsg where 0<count each flip[logmsg]@2;
0N!"It now has ", string[count logmsg], " log messages";

0N!"Writing down to ", string[new];
new set ();
h: hopen new;
{ h enlist x } each logmsg;
hclose h;
0N!"Write down complete";