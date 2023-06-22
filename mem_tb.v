`timescale 1ns/1ns

module mem_tb;

reg clk;
reg reset = 0;
reg r_en;
reg w_en;
reg [15:0] addr;
reg [15:0] w_data;
reg [15:0] r_data;

mem mem(.*);

initial begin
    $display("starting...");
    clk = 1;

    #1
    r_en = 1;
    w_en = 0;
    addr = 16'h 0;

    #11
    r_en = 0;
    w_en = 1;
    addr = 16'h C000;
    w_data = 16'h 0102;
end

initial begin
    $dumpfile("bob.vcd");
    $dumpvars(0, mem_tb);
end

always #5 clk = ~clk;

always #30 begin
    $writememh("output.hex", mem.mem, 'hC000, 'hC002);
    $finish();
end

endmodule