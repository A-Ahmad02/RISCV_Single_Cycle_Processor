`timescale 1ns / 1ps
`include "Header.svh"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2024 11:05:03 AM
// Design Name: 
// Module Name: ImmGen
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

module ImmGen(input logic [BUS_WIDTH-1:7] instr,
                input logic [2:0] imm_gen,
                output logic [BUS_WIDTH-1:0] imm32 
                    );
    always_comb begin
        case(imm_gen)
        3'b000: imm32 = {{20{instr[31]}}, instr[31:20]};         // I-type (jalr and L)
        3'b001: imm32 = {{20{instr[31]}}, instr[31:25], instr[11:7]};// S-type (stores)
        3'b010: imm32 = {{20{instr[31]}}, instr[7],  instr[30:25], instr[11:8], 1'b0};   // B-type
        3'b011: imm32 = {12'b0,instr[31:12]}; // U-type (auipc and lui)
		3'b100: imm32 = {{12{instr[31]}}, instr[19:12],  instr[20], instr[30:21], 1'b0};// J-type (jal)
        default:imm32 = 32'bz; // undefined (For R-Type and undefined cases)
        endcase
    end
                
endmodule
