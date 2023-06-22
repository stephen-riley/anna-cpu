`default_nettype none

module rolling_counter #(
    parameter STATE_COUNT = 4,
    parameter STATE_BITS = $clog2(STATE_COUNT)
)
(
    input clk,
    input reset,
    output reg[STATE_BITS-1:0] state
);

    always @(posedge clk) begin
        if(reset)
            state <= 0;
        else
            state <= (state + 1) % STATE_COUNT;
    end

`ifdef FORMAL
    // register for knowing if we have just started
    reg f_past_valid = 0;

    initial assume(reset);
    initial assume(state == 0);

    always @(posedge clk) begin
        // cover reset
        if(f_past_valid && $past(reset) && !reset)
                _reset_: assert(state == 0);

        // cover a full rotation
        if(f_past_valid && !reset)
            _rolled_over_: cover($past(state) == STATE_COUNT-1 && state == 0);

        // assert we're always advancing the state
        if(f_past_valid)
            if(!$past(reset))
                _incrementing_: assert(state == ($past(state) + 1) % STATE_COUNT);

        f_past_valid = 1;
    end
`endif

endmodule