`default_nettype none

module register_file #(
    parameter REG_COUNT = 8,
    parameter ADDR_SIZE = $clog2(REG_COUNT),
    parameter WORD_SIZE = 16
) (
    input clk,
    input reset,
    input r_en1,
    input r_en2,
    input w_en,
    input [ADDR_SIZE-1:0] reg1,
    input [ADDR_SIZE-1:0] reg2,
    input [WORD_SIZE-1:0] w_data,
    output reg [WORD_SIZE-1:0] r_data1,
    output reg [WORD_SIZE-1:0] r_data2
);

    logic [WORD_SIZE-1:0] registers[0:REG_COUNT-1];

    initial begin
        // registers <= '{default:'0};
        integer i;
        for (i = 0; i<REG_COUNT; i=i+1) begin
            registers[i] <= 0;
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            integer i;
            for (i = 0; i<REG_COUNT; i=i+1) begin
                registers[i] <= 0;
            end
        end else begin
            if(r_en1)
                if(reg1 == 0)
                    r_data1 <= 0;
                else
                    r_data1 <= registers[reg1];
            else if(w_en)
                if(reg1 == 0)
                    r_data1 <= 0;
                else begin
                    registers[reg1] <= w_data;
                    r_data1 <= w_data;
                end
            end

            if(r_en2)
                r_data2 <= registers[reg2];
    end

endmodule