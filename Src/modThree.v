`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 03:45:02 PM
// Design Name: 
// Module Name: modThree
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


module modThree(input clk, rst,en,Up_Down_en, output [1:0]count);

Mod_N_Counter  #(2,3)modt (clk, rst,en,Up_Down_en, count);

endmodule

