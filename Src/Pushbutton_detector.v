`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 10:37:11 PM
// Design Name: 
// Module Name: Pushbutton_detector
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



module Pushbutton_detector(input clk,input pushB, input rst,output out );
wire clk_out;
wire Q1;
wire Q2; 
    debouncer dc(.clk(clk),.rst(rst),.in(pushB),.out(Q1));
    sync sync1(.clk(clk),.sig(Q1), .sig1(Q2));
    Rising_edge_detector red(.clk(clk),.rst(rst),.w(Q2),.z(out));
endmodule