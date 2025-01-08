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

module DataPath(input logic clk,rst,wr_en,rd_en,reg_wr,sel_A,sel_B,
                input logic [3:0] alu_op,
                input logic [2:0] br_type,imm_gen,
                input logic [1:0] wb_sel, 
                output logic [BUS_WIDTH-1:0] inst);

logic [BUS_WIDTH-1-2:0]Addr,Addr1,Addr2; // Do not have last 2 bits as they are 0 (for word alignment)
logic [BUS_WIDTH-1:0] addr, addr2, rdata, wbdata, rdata1, rdata2, imm32, ALU_A, ALU_B; 
logic br_taken;
logic [4:0] raddr1, raddr2, waddr;

Counter C1(.d(Addr),.q(Addr1)); // Counter Width is [BUS_WIDTH-1-2:0]
MUX2x1 m1(.sel1(br_taken),.in0({Addr1,2'b0}),.in1(addr),.out(addr2)); // MUX Width is [BUS_WIDTH-1:0]
ProgramCounter PC(.rst(rst),.clk(clk),.d(addr2[BUS_WIDTH-1:2]),.q(Addr)); // PC_FF Width is [BUS_WIDTH-1-2:0]

Instr_Mem M1(.addr({Addr,2'b0}),.inst(inst));

Instr_Decoder_32 D1(.instr_rd(inst[11:7]),.instr_rs1(inst[19:15]),.instr_rs2(inst[24:20]), .addr_rs1(raddr1), .addr_rs2(raddr2), .addr_rd(waddr));
ImmGen im(.instr(inst[BUS_WIDTH-1:7]), .imm_gen(imm_gen), .imm32(imm32));

Reg_file R1(.wr(reg_wr), .rst(rst), .clk(clk),.addr_rs1(raddr1), .addr_rs2(raddr2), .addr_rd(waddr), .rd(wbdata), .rs1(rdata1), .rs2(rdata2));
MUX2x1 m2(.sel1(sel_A),.in0({Addr,2'b0}),.in1(rdata1),.out(ALU_A));
MUX2x1 m3(.sel1(sel_B),.in0(imm32),.in1(rdata2),.out(ALU_B));

BranchCond b1(.br_type(br_type),.A(rdata1), .B(rdata2), .br_taken(br_taken));
ALU A1(.A(ALU_A),.B(ALU_B),.opselect_i(alu_op),.out(addr));

Data_Mem M2(.addr(addr), .wdata(rdata2), .clk(clk), .wr_en(wr_en), .rd_en(rd_en), .rdata(rdata));
Counter C2(.d(Addr),.q(Addr2)); //PC+4  // Counter Width is [BUS_WIDTH-1-2:0]
MUX3x1 m4(.sel2(wb_sel),.in0(rdata),.in1(addr),.in2({Addr2,2'b0}),.out(wbdata));

endmodule
