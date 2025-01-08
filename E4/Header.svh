`ifndef HEADER
 `define HEADER

parameter BUS_WIDTH = 32;
parameter WIDTH = 8;
parameter DEPTH = 2048;
//parameter ADDR = 11;

typedef enum logic [6:0] {    // Dec 
    R_type      = 7'b0110011, //  51 
    I_type_load = 7'b0000011, //   3 
    I_type_imm  = 7'b0010011, //  19
    I_type_jump = 7'b1100111, // 103
    S_type      = 7'b0100011, //  35 
    U_type_1    = 7'b0010111, //  23 
    U_type_2    = 7'b0110111, //  55
    B_type      = 7'b1100011, //  99
    J_type      = 7'b1101111  // 111
} type_opcode_e;

typedef enum logic [5:0] {  // {R, funct7[30], funct7[25], funct3}
// if it is R_type R=1 and if I_type_imm R=0
    add     = {1'b1,2'b00,3'b000},
    sub     = {1'b1,2'b10,3'b000},
    sll     = {1'b1,2'b00,3'b001},
    slt     = {1'b1,2'b00,3'b010},
    sltu    = {1'b1,2'b00,3'b011},
    xor_    = {1'b1,2'b00,3'b100},
    srl     = {1'b1,2'b00,3'b101},
    sra     = {1'b1,2'b10,3'b101},
    or_     = {1'b1,2'b00,3'b110}, 
    and_    = {1'b1,2'b00,3'b111}, 
     
    addi    = {1'b0,2'bxx,3'b000},
    slli    = {1'b0,2'b00,3'b001},
    slti    = {1'b0,2'bxx,3'b010},
    sltiu   = {1'b0,2'bxx,3'b011}, 
    xori    = {1'b0,2'bxx,3'b100},
    srli    = {1'b0,2'b00,3'b101},
    srai    = {1'b0,2'b10,3'b101}, 
    ori     = {1'b0,2'bxx,3'b110},
    andi    = {1'b0,2'bxx,3'b111} 
} type_R_I_op_e;


typedef enum logic [2:0] {  // {funct3}    
    beq    = 3'b000,
    bne    = 3'b001,
    blt    = 3'b100,
    bge    = 3'b101, 
    bltu   = 3'b110,
    bgeu   = 3'b111    
} type_B_op_e;

//declaring an instance of enum variable
//type_opcode_e opcode;
//type_R_I_op R_I_op;
//type_B_op B_op;

`endif


//typedef enum logic [9:0] {  // {funct7, funct3}
//    lb      = {7'b0000000,3'b000},
//    lh      = {7'b0000000,3'b001},
//    lw      = {7'b0000000,3'b010},
////    ld      = {7'b0000000,3'b011},
//    lbu     = {7'b0000000,3'b100},
//    lhu     = {7'b0000000,3'b101}
////    lwu     = {7'b0000000,3'b110}  
//} type_I_load_op;

//typedef enum logic [9:0] {  // {funct7, funct3}    
//    sb    = {7'b0000000,3'b000},
//    sh    = {7'b0000000,3'b001},
//    sw    = {7'b0000000,3'b010} 
////    sd    = {7'b0000000,3'b011}    
//} type_S_op;



//typedef enum logic [9:0] {  // {funct7, funct3}
//    add     = {7'b0000000,3'b000},
//    sub     = {7'b0100000,3'b000},
//    sll     = {7'b0000000,3'b001},
//    slt     = {7'b0000000,3'b010},
//    sltu    = {7'b0000000,3'b011},
//    xor_    = {7'b0000000,3'b100},
//    srl     = {7'b0000000,3'b101},
//    sra     = {7'b0100000,3'b101},
//    or_     = {7'b0000000,3'b110}, 
//    and_    = {7'b0000000,3'b111} 
//} type_R_op;

//typedef enum logic [9:0] {  // {funct7, funct3}    
//    addi    = {7'b0000000,3'b000},
//    slli    = {7'b0000000,3'b001},
//    slti    = {7'b0000000,3'b010},
//    sltiu   = {7'b0000000,3'b011}, 
//    xori    = {7'b0000000,3'b100},
//    srli    = {7'b0000000,3'b101},
//    srali   = {7'b0100000,3'b101}, 
//    ori     = {7'b0000000,3'b110},
//    andi    = {7'b0000000,3'b111}    
//} type_I_imm_op;


//typedef enum logic [9:0] {  // {funct7, funct3}    
//    jalr    = {7'b0000000,3'b000} 
//} type_I_jump_op;

//typedef enum logic [9:0] {  // {funct7, funct3}    
//    jal    = {7'b0000000,3'b000} 
//} type_J_op;

//typedef enum logic [9:0] {  // {funct7, funct3}    
//    auipc   = {7'b0000000,3'b000},
//    lui     = {7'b0000000,3'b001}    
//} type_U_op;



//typedef enum logic [4:0] {  // {funct7[30], funct7[25], funct3}
//    add     = {2'b00,3'b000},
//    sub     = {2'b10,3'b000},
//    sll     = {2'b00,3'b001},
//    slt     = {2'b00,3'b010},
//    sltu    = {2'b00,3'b011},
//    xor_    = {2'b00,3'b100},
//    srl     = {2'b00,3'b101},
//    sra     = {2'b10,3'b101},
//    or_     = {2'b00,3'b110}, 
//    and_    = {2'b00,3'b111}, 
     
//    addi    = {2'bxx,3'b000},
//    slli    = {2'b00,3'b001},
//    slti    = {2'bxx,3'b010},
//    sltiu   = {2'bxx,3'b011}, 
//    xori    = {2'bxx,3'b100},
//    srli    = {2'b00,3'b101},
//    srai    = {2'b10,3'b101}, 
//    ori     = {2'bxx,3'b110},
//    andi    = {2'bxx,3'b111} 
//} type_R_I_op_e;
