module mem_2port #(
    parameter WORD_SIZE = 16,
    parameter ADDR_SIZE = 16,
    parameter WORD_COUNT = 2 ^ ADDR_SIZE
) (
    input clk,
    input reset,
    input r_en1,
    input r_en2,
    input w_en,
    input [ADDR_SIZE-1:0] addr1,
    input [ADDR_SIZE-1:0] addr2,
    input [WORD_SIZE-1:0] w_data,
    output reg [WORD_SIZE-1:0] r_data1,
    output reg [WORD_SIZE-1:0] r_data2
);

    reg [WORD_SIZE-1:0] mem[0:WORD_COUNT];

    always @(posedge clk) begin
        if(reset) begin
            r_data1 <= 0;
            r_data2 <= 0;
        end else begin
            if(r_en1)
                r_data1 <= mem[addr1];
            else if(w_en) begin
                mem[addr1] = w_data;
                r_data1 = w_data;
            end

            if(r_en2)
                r_data2 <= mem[addr2];
        end
    end

endmodule