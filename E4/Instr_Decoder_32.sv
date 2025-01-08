`timescale 1ns / 1ps
`include "Header.svh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2024 11:05:03 AM
// Design Name: 
// Module Name: Instr_Decoder_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Instr_Decoder_32(input logic [4:0] instr_rd,instr_rs1,instr_rs2,
                        output logic [4:0] addr_rd, addr_rs1, addr_rs2);
    
    always_comb begin
        addr_rd  =  instr_rd;
        addr_rs1 = instr_rs1;
        addr_rs2 =  instr_rs2;
    end
                
endmodule


//    always_comb begin
//        case(instr_i[6:0])
//            R_type      : begin 
//                            rd =  instr_i[11:7];
//                            rs1 = instr_i[19:15];
//                            rs2 =  instr_i[24:20];
//                        end
//            I_type_load, I_type_imm, I_type_jump : begin 
//                            rd =  instr_i[11:7];
//                            rs1 = instr_i[19:15];
//                            rs2 =  5'b00000;
//                        end
//            S_type, B_type      : begin 
//                            rd =  5'b00000;
//                            rs1 = instr_i[19:15];
//                            rs2 =  instr_i[24:20];
//                        end
//            U_type_1, U_type_2, J_type    : begin 
//                            rd =  instr_i[11:7];
//                            rs1 = 5'b00000;
//                            rs2 =  5'b00000;
//                        end
//            default     : begin 
//                            rd =  5'b00000;
//                            rs1 = 5'b00000;
//                            rs2 =  5'b00000;
//                        end 
//        endcase
//    end
    
