`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 03:48:12 PM
// Design Name: 
// Module Name: mod_Six
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


module mod_Six(input clk, rst,en,Up_Down_en, output [2:0]count);

Mod_N_Counter  #(3,6)modt (clk, rst,en,Up_Down_en, count);

endmodule
