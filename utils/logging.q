\d .log

/ Ran from process to initiate a timestamped logfile
initLog: { [logDir;logFn;lvl]
    levels: 0 1 2 3i!`debug`info`warn`err;
    if[not lvl in key levels;'"Log levels must be in: ", -3!key levels];
    logFn: $[logFn~`;
        `$(-2_last "/" vs string .z.f),"_",(15#ssr[string .z.P;"[.:]";""]),".",string levels[lvl];
        logFn
    ];
    logHandle:hopen .Q.dd[logDir;logFn];
    $[`handle in system "v";
        [handle::handle,logHandle;level::level,lvl];
        [handle::1#logHandle;level::1#lvl]
    ]
    };

/ Memory usage details
unit: `s#(5 (1024*)\ 1)!"BKMGTP";
mem: {
    w:(string w%1024 xexp key[unit] bin value w),'unit w:3#.Q.w[];
    ": " sv raze flip (string key w;value w)
    };

/ Message header for every log message
/ Includes username, host and memory usage details
header: {
    hdr: "@" sv string (.z.u;.z.h);
    hdr: hdr, " ", mem[];
    "[", hdr, "]"
    };

logging: { [msg; lvl]
    msg:string[.z.P], header[], " ", msg;
    {y x}[msg] each neg 1 2i,handle where level >= lvl;
    };

debug: logging[;0];
info: logging[;1];
warn: logging[;2];
err: logging[;3];

.z.po: {
    user: string .z.u;
    host: string .z.h;
    add: "." sv string "i"$0x0 vs .z.a;
    info["A connection is opened by ", user, "@", host, " from ", add, " on handle ", -3!x]
    };

.z.pc: {
    user: string .z.u;
    host: string .z.h;
    add: "." sv string "i"$0x0 vs .z.a;
    info["A connection is closed by ", user, "@", host, " from ", add, " on handle ", -3!x]
    };