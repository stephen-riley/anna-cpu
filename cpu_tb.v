module cpu_tb;

parameter
    WORD_SIZE = 16,
    ADDR_SIZE = 16;

reg clk;
reg reset = 0;
reg mem_r_en;
reg [ADDR_SIZE-1:0] mem_addr;
reg [WORD_SIZE-1:0] mem_r_data;
reg mem_w_en;
reg [WORD_SIZE-1:0] mem_w_data;

mem #(.WORD_SIZE(16), .ADDR_SIZE(16)) mem(
    .clk(clk),
    .reset(reset),
    .r_en(mem_r_en), 
    .w_en(mem_w_en), 
    .addr(mem_addr), 
    .w_data(mem_w_data), 
    .r_data(mem_r_data)
);

cpu cpu(.mem(mem.memory), .*);

initial begin
    $dumpfile("bob.vcd");
    $dumpvars(0, cpu_tb);
end

initial begin
    $readmemh("add_no_inputs.hex", mem.memory, 0, 9);
    $strobe("initial: mem[0]=%h", mem.memory[0]);
    
    #0
    // cpu.halt <= 0;
    // reset <= 1;
    clk <= 1;

    // #10 reset <= 0;
end

always #5 clk = ~clk;

always #100 $finish();

endmodule