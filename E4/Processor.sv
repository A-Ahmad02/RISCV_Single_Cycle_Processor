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

module Processor( input logic clk, rst);

logic [BUS_WIDTH-1:0]inst; 
logic wr_en,rd_en,reg_wr,sel_A,sel_B;
logic [3:0] alu_op;
logic [2:0] br_type,imm_gen;
logic [1:0] wb_sel;

ControlPath c1(.funct({inst[30],inst[25],inst[14:12]}),.opcode(inst[6:0]),.br_type(br_type),.wr_en(wr_en),.rd_en(rd_en),.reg_wr(reg_wr),.wb_sel(wb_sel),.sel_A(sel_A),.sel_B(sel_B),.alu_op(alu_op),.imm_gen(imm_gen), .rst(rst));
DataPath dp1(.clk(clk),.rst(rst),.inst(inst),.br_type(br_type),.wr_en(wr_en),.rd_en(rd_en),.reg_wr(reg_wr),.wb_sel(wb_sel),.sel_A(sel_A),.sel_B(sel_B),.alu_op(alu_op),.imm_gen(imm_gen));

endmodule
