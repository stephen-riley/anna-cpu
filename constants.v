parameter
    FETCH = 0,
    DECODE = 1,
    LOAD = 2,
    COMPUTE = 3,
    STORE = 4;

parameter 
    FUNC_ADD = 'b000,
    FUNC_SUB = 'b001,
    FUNC_AND = 'b010,
    FUNC_OR  = 'b011,
    FUNC_NOT = 'b100,
    
    OP_MATH = 'b0000,
    OP_JALR = 'b0001,
    OP_IN   = 'b0010,
    OP_OUT  = 'b0011,
    OP_ADDI = 'b0100,
    OP_SHF  = 'b0101,
    OP_LW   = 'b0110,
    OP_SW   = 'b0111,
    OP_LLI  = 'b1000,
    OP_LUI  = 'b1001,
    OP_BEQ  = 'b1010,
    OP_BNE  = 'b1011,
    OP_BGT  = 'b1100,
    OP_BGE  = 'b1101,
    OP_BLT  = 'b1110,
    OP_BLE  = 'b1111;