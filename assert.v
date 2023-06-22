`define assert(signal, value) \
        if (signal !== value) begin \
            $display("[%0t] ASSERTION FAILED at %m:%-0D %h != %h", $time, `__LINE__, signal, value); \
            $finish; \
        end else \
            $display("[%0t] assertion passed at %m:%-D", $time, `__LINE__);

`define time_bump(t, incr) \
        t = t + incr;  \
        #(t)

`define time_plus(t, incr) \
        #(t + incr)