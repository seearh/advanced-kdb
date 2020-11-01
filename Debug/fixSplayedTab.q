system "l db/";
system "c 500 500";

/ t1: Displaying as a dictionary instead of a table
0N! t1;

/ Evidently it is missing a .d file
0N! "Files in `:t1/";
0N! key `:t1;

/ FIX
`:t1/.d set `sym`price`size;

/ t2: Length mismatch between q column entities, null displayed in price column
{0N! x; 0N! count each get each .Q.dd/:[x; key x]} each `:t1`:t2`:t3;

/ FIX
`:t2 set .Q.en[`:db/;] -1_t2;

/ t3: sym column is not enumerated with the enum domain of the sym file
0N! {type each @[x; ] each cols x} each `t1`t2`t3;

/ FIX
sym: get `:sym;
`:t3/ set update `sym?sym from t3;
`:sym set sym;