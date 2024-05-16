`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 10:43:16 PM
// Design Name: 
// Module Name: sync
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


module sync(input clk, input sig, output sig1);
wire meta;
dflipflop stage1(.clk(clk),.d(sig),.q(meta));
dflipflop stage2(.clk(clk),.d(meta),.q(sig1));

endmodule
