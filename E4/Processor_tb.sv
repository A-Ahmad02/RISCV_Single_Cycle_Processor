`timescale 1ns / 1ps
`include "Header.svh"
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 01/17/2024 11:04:00 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Processor_tb;

logic rst, clk;

Processor UUT(
.rst(rst), .clk(clk)
);

initial // All initial blocks run in parallel
begin
    //initial value of clock
    clk = 1'b1;
    #5;
    //generating clock signal
    forever #50 clk = ~clk;
end

initial  //Driver
begin
    #5;
    rst = 1'b0; // Active low reset
    #5;
    rst = 1'b1;
    #1000;

//    $finish;
end

//initial  //Moniter
//begin
//$monitor("q=%h, en=%b", q, en);
//end
          
endmodule