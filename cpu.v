`default_nettype none

module cpu #(
    parameter WORD_SIZE = 16,
    parameter ADDR_SIZE = 16,
    parameter MEM_SIZE = 2 ** ADDR_SIZE
) (
    input reg clk,
    input reg reset,
    output reg mem_r_en,
    output reg [ADDR_SIZE-1:0] mem_addr,
    input reg [WORD_SIZE-1:0] mem_r_data,
    output reg mem_w_en,
    output reg [WORD_SIZE-1:0] mem_w_data,
    input reg [WORD_SIZE-1:0] mem[MEM_SIZE]
);

// global signals
reg halt;
reg [2:0] cpu_state;

// register signals
reg [2:0] reg_r1;
reg [2:0] reg_r2;
reg reg_r_en1;
reg reg_r_en2;
reg reg_w_en;
reg [15:0] reg_w_data;
reg [15:0] reg_r_data1;
reg [15:0] reg_r_data2;

register_file #(.REG_COUNT(8), .WORD_SIZE(WORD_SIZE)) r(
    .r_en1(reg_r_en1), 
    .r_en2(reg_r_en2), 
    .w_en(reg_w_en), 
    .reg1(reg_r1), 
    .reg2(reg_r2), 
    .w_data(reg_w_data), 
    .r_data1(reg_r_data1), 
    .r_data2(reg_r_data2)
);

reg [WORD_SIZE-1:0] instr;
reg [ADDR_SIZE-1:0] pc;
logic [3:0] opcode;
logic [2:0] func;
logic [2:0] rs1;
logic [2:0] rs2;
logic [2:0] rd;
logic [5:0] imm6;
logic [7:0] imm8;
logic [ADDR_SIZE-1:0] rs1_contents;
logic [ADDR_SIZE-1:0] rs2_contents;
logic [ADDR_SIZE-1:0] rd_contents;
reg alu_enable = 1;
reg [15:0] rd_prime;
reg [15:0] pc_prime;
reg [15:0] rs1_prime;

alu alu(.en(alu_enable), .*);

initial begin
    pc <= 0;
    cpu_state <= FETCH;
    pc_prime <= 0;
end

always @(posedge clk) begin
    if(!reset) begin
        alu_enable = cpu_state == COMPUTE;

        case(cpu_state)

            FETCH: begin
                mem_addr <= pc;
                mem_r_en <= 1;
                pc_prime <= pc;
                cpu_state <= DECODE;
                $strobe("FETCH: mem_r_en=%b, mem_addr=%h", mem_r_en, mem_addr);
            end

            // READ: begin
            //     cpu_state <= DECODE;
            //     $strobe("READ: mem_r_en=%b, mem_addr=%h, mem_r_data=%h", mem_r_en, mem_addr, mem_r_data);
            // end

            DECODE: begin
                mem_r_en <= 0;
                mem_w_en <= 0;

                // instr <= mem_r_data;
                opcode <= mem_r_data[15:12];
                imm6 <= mem_r_data[5:0];
                imm8 <= mem_r_data[7:0];
                rd <= mem_r_data[11:9];
                rs1 <= mem_r_data[8:6];
                rs2 <= mem_r_data[5:3];
                $display("DECODE: instr=%h opcode=%b", mem_r_data, opcode);

                if(opcode == OP_LW) begin
                    mem_r_en <= 1;
                    mem_addr = r.registers[rs1] + imm6;
                end

                $strobe("DECODE: instr=%h opcode=%b", instr, opcode);
                cpu_state <= LOAD;
            end

            LOAD: begin
                // mem_r_data contains whatever OP_LW was trying to do
                rd_contents <= r.registers[rd];
                rs1_contents <= r.registers[rs1];
                rs2_contents <= r.registers[rs2];
                cpu_state <= COMPUTE;
            end

            COMPUTE: begin
                $display("COMPUTE!");
                // if(opcode == OP_OUT && rd == 0)
                //     // halt <= 1;
                //     $display("should halt here");
                // else
                cpu_state <= STORE;
            end

            STORE: begin
                if(opcode == OP_SW) begin
                    mem_w_en <= 1;
                    mem_w_data <= rd_prime;
                    mem_addr <= rs1_contents + imm6;
                end
                r.registers[rs1] = rs1_prime;
                r.registers[rd] = rd_prime;
                pc <= pc_prime;
                cpu_state <= FETCH;
            end
        endcase
    end
end

endmodule