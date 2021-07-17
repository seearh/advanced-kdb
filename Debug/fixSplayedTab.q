system "l db/";
system "c 500 500";

0N!"t1:";
show t1;

0N! "Files in `:t1/ - ", ", " sv string key `:t1;
0N! "t1 is missing a .d file that dictates column order of splayed tables";
0N! "Setting .d file...";
show get `:t1/.d set `sym`price`size;
0N! "Reloading database...";
system "l .";
0N!"t1 fixed:";
show t1;

0N!"t2:";
show t2;
0N! "Last entry contains null price";
show count each flip t2;
0N! "Length of price column differs from that of sym and size";
0N! "Drop last entry and resplay the table...";
`:t2 set .Q.en[`:db/;] -1_t2;
0N! "Reloading database...";
system "l .";
0N!"t2 fixed:";
show t2;
show count each flip t2;

0N!"t3:";
show t3;
0N! "Nothing is visibly wrong";
0N! "But observe the type of each of its column versus other splayed tables...";
show {?[x;();();(`tab,cols x)!(enlist enlist x),flip (type;cols x)]} each `t1`t2`t3;
0N! "Its sym column is not enumerated in the domain of the sym file";
0N! "Getting sym file...";
show sym: get `:sym;
0N! "Setting down the enumerated sym column...";
`:t3/ set update `sym?sym from t3;
0N! "Setting down updated sym file...";
`:sym set sym;
0N! "Reloading database...";
system "l .";
0N! "t3 fixed:";
show t3;
show {?[x;();();(`tab,cols x)!(enlist enlist x),flip (type;cols x)]} each `t1`t2`t3;