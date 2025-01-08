`timescale 1ns/1ps
`include "Header.svh"

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 01/25/2024 11:04:00 AM
// Design Name: 
// Module Name: Data_Mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_Mem( input logic [BUS_WIDTH-1:0]addr, [BUS_WIDTH-1:0]wdata, 
                input logic clk, wr_en, rd_en,
                output logic [BUS_WIDTH-1:0]rdata
            );
             
      logic [WIDTH-1:0] mem [DEPTH-1:0];
    logic [10:0] addr_;
    assign addr_ = addr[10:0];
    
    initial begin
        $readmemh("C:/DriveA/Workspaces/Vivado/CA_Lab/E4/data.mem", mem);
    end
      
    always_ff @(negedge clk) begin
        if(wr_en) begin
            {mem[addr_],mem[addr_+1],mem[addr_+2],mem[addr_+3]} <= wdata;
            $writememh("C:/DriveA/Workspaces/Vivado/CA_Lab/E4/data.mem", mem);
        end
        else
            mem <= mem;
    end 
    
    always_comb begin
        if(rd_en) 
            rdata <= {mem[addr_],mem[addr_+1],mem[addr_+2],mem[addr_+3]};
        else
            rdata <= 32'b0;
    end
    
endmodule


//    always_ff @ (posedge clk) begin
//         $writememh("C:/DriveA/Workspaces/Vivado/CA_Lab/E4/data.mem", mem);
//    end