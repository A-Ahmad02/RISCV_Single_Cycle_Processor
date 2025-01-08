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

module BranchCond(input logic [2:0] br_type,
                   input logic [BUS_WIDTH-1:0] A, B,
                   output logic br_taken
                    );
    
    always_comb 
    begin
		case (br_type) // Used funct3 to decide branch except br_type = 2 and 3
			0 : br_taken = (A==B)? 1:0;	                     //beq
			1 : br_taken = (A!=B)? 1:0;	                     //bne
			2 : br_taken = 0;	                            //no jump
			3 : br_taken = 1;	       //jalr,jal (unconditional jump)
			4 : br_taken = ($signed(A) < $signed(B))?  1:0;	 //blt
			5 : br_taken = ($signed(A) >= $signed(B))? 1:0;	 //bge
			6 : br_taken = (A<B)?  1:0;	                     //bltu
			7 : br_taken = (A>=B)? 1:0;	                     //bgeu
			default: br_taken = 0;
        endcase
    end
                
endmodule
