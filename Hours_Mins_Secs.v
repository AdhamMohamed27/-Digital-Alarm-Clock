`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:48:48 PM
// Design Name: 
// Module Name: Hours_Mins_Secs
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


module Hours_Mins_Secs
(input clk, rst,en,Up_Down_en, output [12:0]count);


wire [3:0] c1;
wire [2:0] c2;
wire [3:0] c3;
wire [1:0] c4;
wire clk_out;


Clock_Divider #(700000) clock(clk, rst, clk_out);

modTen mod_Ten(clk_out, rst,en,Up_Down_en, c1);  //0
mod_Six mod_Six(clk_out, rst,en&&c1==9,Up_Down_en, c2); //1
modTen mod_Ten1(clk_out, rst||(c4==2&&c3==4),en&&c1==9&&c2==5,Up_Down_en, c3);  //0
modThree mod_three(clk_out, rst||(c4==2&&c3==4),en&&c1==9&&c2==5&&c3==9,Up_Down_en, c4); //1


assign count = {c4, c3, c2, c1};

endmodule
