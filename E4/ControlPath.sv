`timescale 1ns/1ps
`include "Header.svh"
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 01/25/2024 11:04:00 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module ControlPath( input logic [4:0] funct, // {inst[30],inst[25],inst[14:12]} // {funct7[30], funct7[25], funct3}
                input logic [6:0] opcode,
                input logic rst,
                output logic wr_en,rd_en,reg_wr,sel_A,sel_B,
                output logic [3:0] alu_op,
                output logic [2:0] br_type,imm_gen,
                output logic [1:0] wb_sel
            );

logic R,I,S,L,B,auipc,lui,jal,jalr;
`define Type {R,I,S,L,B,auipc,lui,jal,jalr} // Declare bus
`define Control {imm_gen,sel_A, sel_B,wb_sel,reg_wr}

type_R_I_op_e alu;
 assign alu = type_R_I_op_e'({R,funct});  
type_opcode_e OPCODE;
 assign OPCODE = type_opcode_e'(opcode);  
 
    always_comb begin    // Check instruction type (9-bit Decoder)
        if (!rst) 
            `Type <= 0;  
        else begin 
            case(OPCODE)//Type {R,I,S,L,B,auipc,lui,jal,jalr} 
                R_type      :`Type <= 9'b100000000; 
                I_type_imm  :`Type <= 9'b010000000; 
                S_type      :`Type <= 9'b001000000; 
                I_type_load :`Type <= 9'b000100000;
                B_type      :`Type <= 9'b000010000; 
                U_type_1    :`Type <= 9'b000001000;
                U_type_2    :`Type <= 9'b000000100;
                J_type      :`Type <= 9'b000000010;
                I_type_jump :`Type <= 9'b000000001;
                default     :`Type <= 9'b000000000; // Default is None 
            endcase    
        end 
    end
    
    always_comb begin  //  Choosing alu_op using: R,I,lui,funct3,funct7
        if (R | I) begin  
            case(alu)// R_type, funct7[30], funct7[25], funct3
                add      :  alu_op <= 0;
                addi     :  alu_op <= 0;
                sub      :  alu_op <= 1;
                sll      :  alu_op <= 2;
                slli     :  alu_op <= 2;
                srl      :  alu_op <= 3;
                srli     :  alu_op <= 3;
                sra      :  alu_op <= 4; 
                srai     :  alu_op <= 4;
                and_     :  alu_op <= 5;
                andi     :  alu_op <= 5;
                or_      :  alu_op <= 6;
                ori      :  alu_op <= 6;
                xor_     :  alu_op <= 7;
                xori     :  alu_op <= 7;
                sltu     :  alu_op <= 8;
                sltiu    :  alu_op <= 8;
                slt      :  alu_op <= 9;
                slti     :  alu_op <= 9;
                default  :  alu_op <= 0; // Default is add
            endcase    
        end
        else if(lui)
            alu_op <= 10;//alu_op for out = B
        else 
            alu_op <= 0;//all other instructions use operation A + B of ALU
    end
    
    always_comb begin//for wr_en
        wr_en <= S;
    end

    always_comb begin//for rd_en
        rd_en <= L;
    end

    always_comb begin//3-bit Encoder    // for br_type
        case({jal,jalr,B})
            3'b100 : br_type <= 3 ; // jal  (unconditional jump)
            3'b010 : br_type <= 3 ; // jalr (unconditional jump)
            3'b001 : br_type <= funct[2:0] ;// funct 3 of B_Type (possible due to exploitable design of branch_cond)
            default: br_type <= 2;   //no jump
        endcase
    end
    
    always_comb begin // 9 bit Encoder
        case(`Type)//Type {R,I,S,L,B,auipc,lui,jal,jalr}
                         //Control {imm_gen,sel_A, sel_B,wb_sel,reg_wr}
            9'b100000000 :`Control<= {3'bzzz,1'b1,1'b1,2'b01,1'b1};//R
            9'b010000000 :`Control<= {3'b000,1'b1,1'b0,2'b01,1'b1};//I
            9'b001000000 :`Control<= {3'b001,1'b1,1'b0,2'bzz,1'b0};//S
            9'b000100000 :`Control<= {3'b000,1'b1,1'b0,2'b00,1'b1};//L
            9'b000010000 :`Control<= {3'b010,1'b0,1'b0,2'bzz,1'b0};//B
            9'b000001000 :`Control<= {3'b011,1'b0,1'b0,2'b01,1'b1};//auipc
            9'b000000100 :`Control<= {3'b011,1'b1,1'b0,2'b01,1'b1};//lui
            9'b000000010 :`Control<= {3'b100,1'b0,1'b0,2'b10,1'b1};//jal
            9'b000000001 :`Control<= {3'b000,1'b1,1'b0,2'b10,1'b1};//jalr
            default: `Control <= 0; // All control signals 0 for None Type
        endcase
    end
        
endmodule


//////////////////////////////////////////////////////////////////////////////////      
//opcode    Type     Description             ALU     sel_A   sel_B   wb_sel  imm_gen     br_type   alu_op  reg_wr      d_wr
// 3:       I-Type   Load                    yes     1       1       2       0           none      0       1           0
// 19:      I-Type   immediate operation     yes     1       1       1       0           none      xxxx    1           0
// 23:      U-Type   auipc                   yes     0       1       1       4(u)        none      0       1           0
// 35:      S-Type   Store                   yes     1       1       z       1           none      0       0           1
// 51:      R-Type   register operation      yes     1       0       1       z           none      xxxx    1           0
// 55:      U-Type   lui                     no      1       1       1       4(u)        none      copy    1           0
// 99:      B-Type   conditional branch      yes     0       1       z       2           xxx       0       0           0
// 103:     I-Type   jalr                    yes     1       1       0       0           uncond    0       1           0
// 111:     J-Type   jal                     yes     1       1       0       3           uncond    0       1           0
//////////////////////////////////////////////////////////////////////////////////
//categories:   R,Ii,S,L,B,J



//type_opcode_e opcode;
//assign opcode =  type_opcode_e inst[6:0]; 
//type_R_I_op_e alu;
//assign alu =  type_R_I_op_e {R,inst[30],inst[25],inst[14:12]};
// typedef enum {inst[6:0]} type_opcode_e; 
// type_opcode_e opcode;
// typedef enum {ALU} type_R_I_op_e; 
// type_R_I_op_e alu;

//case({R,funct})// R_type, funct7[30], funct7[25], funct3
//    {1'b1,add}      :  alu_op <= 0;
//    {1'b0,addi}     :  alu_op <= 0;
//    {1'b1,sub}      :  alu_op <= 1;
//    {1'b1,sll}      :  alu_op <= 2;
//    {1'b0,slli}     :  alu_op <= 2;
//    {1'b1,srl}      :  alu_op <= 3;
//    {1'b0,srli}     :  alu_op <= 3;
//    {1'b1,sra}      :  alu_op <= 4; 
//    {1'b0,srai}     :  alu_op <= 4;
//    {1'b1,and_}     :  alu_op <= 5;
//    {1'b0,andi}     :  alu_op <= 5;
//    {1'b1,or_}      :  alu_op <= 6;
//    {1'b0,ori}      :  alu_op <= 6;
//    {1'b1,xor_}     :  alu_op <= 7;
//    {1'b0,xori}     :  alu_op <= 7;
//    {1'b1,sltu}     :  alu_op <= 8;
//    {1'b0,sltiu}    :  alu_op <= 8;
//    {1'b1,slt}      :  alu_op <= 9;
//    {1'b0,slti}     :  alu_op <= 9;
//    default  :  alu_op <= 0; // Default is add
//endcase   