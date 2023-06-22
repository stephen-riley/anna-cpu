`timescale 1ns/1ns

module rolling_counter_tb;

reg clk;
reg reset;
reg[3:0] state;

rolling_counter #(.STATE_BITS(4), .STATE_COUNT(12)) sm(.*);

initial begin
    $display("starting...");
    clk = 1;
    reset = 1;
    #10 reset = 0;
end

initial begin
    $dumpfile("bob.vcd");
    $dumpvars(0, tb);
end

always #5 clk = ~clk;

always #200 $finish();

endmodule