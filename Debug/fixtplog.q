tplog: get `:tplog;

/ The correct trade table schema
0N! meta trade: ([] sym: `$(); price: `float$(); size: `long$());
upd: upsert;

/ Distinct counts of entries reveal that there are 1-item lists.
/ Each line of the tplog should be a list of length 3 in the format
/ (funcName; tabName; tabValue)
0N! distinct count each tplog;

/ FIX
tplog: raze @[;1;:;enlist raze @[l;1]] l: cut[; tplog] where differ count each tplog;

/ characters in sym and floats in size columns
0N! distinct ?[;();();`t] each meta each @[; 2] each tplog;

/ FIX
f: {$["c" = first exec t from meta x where c = `sym; update `$'sym from x; x]};
g: {$["f" = first exec t from meta x where c = `size; update `long$size from x; x]};
tplog: .[; (::), 2; g] .[tplog; (::), 2; f];

/ Set down a fixed tplog and replay it
`:tplogfixed set ();
(hopen `:tplogfixed) tplog;
-11!`:tplogfixed;