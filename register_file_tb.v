`timescale 1ns/1ns

module register_file_tb;

reg clk;
reg reset = 0;
reg r_en1;
reg r_en2;
reg w_en;
reg [15:0] reg1;
reg [15:0] reg2;
reg [15:0] w_data;
reg [15:0] r_data1;
reg [15:0] r_data2;

register_file r(.*);
integer t = 1;
integer i;

initial begin
    $display("starting...");
    clk = 1;

    #(t)
    // verify register file is all zeros
    for(i=0; i<8; i++) begin
        `assert(r.registers[i], 0)
    end

    `time_bump(t,10)
    // read from r0 and r1
    r_en1 = 1;
    r_en2 = 1;
    w_en = 0;
    reg1 = 16'h 0;
    reg2 = 16'h 1;
    `time_plus(t,5)
    `assert(r_data1, 0)
    `assert(r_data2, 0)

    // write 0x0102 to r0
    `time_bump(t,10)
    r_en1 = 0;
    w_en = 1;
    reg1 = 16'h 0000;
    w_data = 16'h 0102;
    `time_plus(t,5)
    `assert(r_data1, 'h0)

    // write 0x0102 to r1
    `time_bump(t,10)
    r_en1 = 0;
    w_en = 1;
    reg1 = 16'h 0001;
    w_data = 16'h 0102;
    `time_plus(t,5)
    `assert(r_data1, 'h0102)

    // read from r0 and r1
    `time_bump(t,10)
    r_en1 = 1;
    r_en2 = 1;
    w_en = 0;
    reg1 = 16'h 0;
    reg2 = 16'h 1;
    `time_plus(t,5)
    `assert(r_data1, 0)
    `assert(r_data2, 'h0102)

    // write 0x0304 to r1
    `time_bump(t,10)
    r_en1 = 0;
    w_en = 1;
    reg1 = 16'h 0001;
    w_data = 16'h 0304;
    `time_plus(t,5)
    `assert(r_data1, 'h0304)

    // write 0x0506 to r2
    `time_bump(t,10)
    r_en1 = 0;
    w_en = 1;
    reg1 = 16'h 0002;
    w_data = 16'h 0506;
    `time_plus(t,5)
    `assert(r_data1, 'h0506)    

    // read from r1 and r2
    `time_bump(t,10)
    r_en1 = 1;
    r_en2 = 1;
    w_en = 0;
    reg1 = 16'h 1;
    reg2 = 16'h 2;
    `time_plus(t,5)
    `assert(r_data1, 'h0304);
    `assert(r_data2, 'h0506);

    `time_bump(t,20)
    $writememh("output.hex", r.registers, 'h0, 'h7);
    $finish();
end

initial begin
    $dumpfile("bob.vcd");
    $dumpvars(5, register_file_tb);
end

always #5 clk = ~clk;

endmodule