module mem #(
    parameter WORD_SIZE=16,
    parameter ADDR_SIZE=16,
    parameter WORD_COUNT=65536
) (
    input clk,
    input reset,
    input r_en,
    input w_en,
    input [ADDR_SIZE-1:0] addr,
    input [WORD_SIZE-1:0] w_data,
    output reg [WORD_SIZE-1:0] r_data
);

    reg [WORD_SIZE-1:0] memory[WORD_COUNT];

    always @(negedge clk) begin
        if(reset)
            r_data <= 0;
        else if(r_en)
            r_data <= memory[addr];
        else if(w_en) begin
            memory[addr] = w_data;
            r_data = w_data;
        end
        $strobe("mem: r_en=%b, addr=%h, r_data=%h", r_en, addr, r_data);
    end

endmodule