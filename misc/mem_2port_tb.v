`timescale 1ns/1ns

module mem_2port_tb;

reg clk;
reg reset = 0;
reg r_en1;
reg r_en2;
reg w_en;
reg [15:0] addr1;
reg [15:0] addr2;
reg [15:0] w_data;
reg [15:0] r_data1;
reg [15:0] r_data2;

mem_2port mem(.*);

initial begin
    $display("starting...");
    initial $readmemh("add_no_inputs.hex", mem.mem, 0, 8);

    clk = 1;

    #1
    r_en1 = 1;
    r_en2 = 1;
    w_en = 0;
    addr1 = 16'h 0;
    addr2 = 16'h 1;

    #11
    r_en1 = 0;
    w_en = 1;
    addr1 = 16'h C000;
    w_data = 16'h 0102;
end

initial begin
    $dumpfile("bob.vcd");
    $dumpvars(0, mem_2port_tb);
end

always #5 clk = ~clk;

always #30 begin
    $writememh("output.hex", mem.mem, 'hC000, 'hC002);
    $finish();
end

endmodule