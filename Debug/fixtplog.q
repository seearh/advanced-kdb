0N!"Getting tplog file from Debug directory...";
tplog: get `:tplog;
show tplog;

0N!"Defining `trade table and upd function...";
show meta trade: flip `sym`price`size!(trade_meta:"sfj")$\:();
upd: upsert;

/ Distinct counts of entries reveal that there are 1-item lists
/ Each line of the tplog should be a list of length 3 in the format
/ (funcName; tabName; tabValue)
0N!"Inspecting distinct length of records...";
show distinct tplog_count: count each tplog;
0N!"Found ", string[count bad_rows: where 3 <> tplog_count], " bad records...";
show flip (bad_rows;tplog bad_rows);

0N!"Fixing bad length records...";
tplog: raze @[;1;:;enlist raze @[l;1]] l: cut[; tplog] where differ count each tplog;

/ All records should conform to the trade table meta above
/ There are records with characters in sym and/or floats in size columns
0N!"Inspecting distinct meta of upserted records...";
show distinct all_meta: {?[;();();`t] meta @[x; 2]} each tplog;
0N!"Found ", string[count bad_meta: where not trade_meta ~/: all_meta], " bad meta...";
show flip (bad_meta;all_meta bad_meta);

0N!"Fixing bad meta in upserted records...";
f: {$["c" = first exec t from meta x where c = `sym; update `$'sym from x; x]};
g: {$["f" = first exec t from meta x where c = `size; update `long$size from x; x]};
tplog: .[; (::), 2; {g f x}] tplog;

0N!"Setting down tplogfixed...";
show `:tplogfixed set ();
hclose (h: hopen `:tplogfixed) tplog;

0N!"Replaying tplogfixed...";
0N!(string count trade), " records corresponding to ", (string -11!`:tplogfixed), " log entries were replayed";
show trade;