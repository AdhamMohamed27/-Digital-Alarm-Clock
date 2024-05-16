`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:50:06 PM
// Design Name: 
// Module Name: modTen
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


module modTen
(input clk, rst,en,Up_Down_en, output [3:0]count);

Mod_N_Counter  #(4,10) MOD_ten_H (clk, rst,en,Up_Down_en, count);

endmodule

