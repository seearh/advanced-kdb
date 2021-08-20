/ q tick/sym.q [-p PORT]

trades: flip `time`sym`price`size!"nsfj"$\:();
quotes: flip `time`sym`bid`ask!"nsff"$\:();
agg: flip `time`sym`pmax`pmin`hibid`loask`volume!"nsffffj"$\:();