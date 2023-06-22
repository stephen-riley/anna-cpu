`default_nettype none

module alu #(
    parameter WORD_SIZE = 16,
    parameter ADDR_WIDTH = 16,
    parameter REG_COUNT = 8,
    parameter REG_WIDTH = $clog2(REG_COUNT)
) (
    input logic clk,
    input logic en,
    input logic [3:0] opcode,
    input logic [2:0] func,
    input logic [2:0] rs1,
    input logic [2:0] rs2,
    input logic [2:0] rd,
    input logic [WORD_SIZE-1:0] rs1_contents,
    input logic [WORD_SIZE-1:0] rs2_contents,
    input logic [WORD_SIZE-1:0] rd_contents,
    input logic [5:0] imm6,
    input logic [7:0] imm8,
    output reg [WORD_SIZE-1:0] rd_prime,
    output reg [WORD_SIZE-1:0] rs1_prime,
    output reg [WORD_SIZE-1:0] pc_prime,
    output reg halt
);

always @(posedge clk) begin
    case(opcode)
        // add, sub, and, or, not
        OP_MATH: begin
            case(func)
                FUNC_ADD: rd_prime <= rs1_contents + rs2_contents;
                FUNC_SUB: rd_prime <= rs1_contents - rs2_contents;
                FUNC_AND: rd_prime <= rs1_contents & rs2_contents;
                FUNC_OR:  rd_prime <= rs1_contents | rs2_contents;
                FUNC_NOT: rd_prime <= ~rs1_contents;
                default:  rd_prime <= 0;
            endcase
            pc_prime = pc_prime + 1;
        end

        // jalr
        OP_JALR: begin
            rs1_prime <= pc_prime + 1;
            pc_prime <= rd_contents;
        end

        // // in
        // OP_IN: begin
        //     $error("does not support IN instruction");
        // end

        // // out / .halt
        // OP_OUT: begin
        //     if(rd == 0)
        //         halt = 1'b1;
        //     else
        //         $error("does not support OUT instruction");
        // end

        // addi
        OP_ADDI: begin
            rd_prime = rs1_contents + imm6;
            pc_prime = pc_prime + 1;
        end
        
        // shf
        OP_SHF: begin
            if(imm6 >= 0)
                rd_prime = rs1_contents << imm6;
            else
                rd_prime = rs1_contents >> imm6;
            pc_prime = pc_prime + 1;
        end
        
        // lw
        OP_LW: begin
        end
        
        // sw
        OP_SW: begin
        end
        
        // lli
        OP_LLI: begin
            rd_prime[7:0] = imm8;
            rd_prime[WORD_SIZE-1:8] = {8{imm8[7]}};
            pc_prime = pc_prime + 1;
        end
        
        // lui
        OP_LUI: begin
            rd_prime = imm8 << 8 + rd_contents[7:0];
            pc_prime = pc_prime + 1;
        end
        
        // beq
        OP_BEQ: begin
            if(rd_contents == 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end
        
        // bne
        OP_BNE: begin
            if(rd_contents != 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end
        
        // bgt
        OP_BGT: begin
            if(rd_contents > 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end
        
        // bge
        OP_BGE: begin
            if(rd_contents >= 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end
        
        // blt
        OP_BLT: begin
            if(rd_contents < 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end
        
        // ble
        OP_BLE: begin
            if(rd_contents <= 0)
                pc_prime = pc_prime + 1 + imm8;
            else
                pc_prime = pc_prime + 1;
        end

        default: $error("unknown opcode %b", opcode);
    endcase
end

endmodule