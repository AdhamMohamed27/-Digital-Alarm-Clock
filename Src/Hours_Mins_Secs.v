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


odule Hours_Mins_Secs
(input clk, rst,en,enh,enm,Up_Down_en, output [12:0]count);


wire [3:0] c1;
wire [2:0] c2;
wire [3:0] c3;
wire [1:0] c4;
wire [3:0] c5;
wire [2:0] c6;

wire enableminunits,  enablemintens, enableh, enablehtens;
assign enableminunits = en ? (c6==5 & c5==9) : enm;
assign enablemintens = en ? (c1==9& c6==5 & c5==9) : (Up_Down_en ? ((c1 == 9)? enm: 0) :((c1 == 0)? enm: 0)); 
assign enableh = en? (c1==9& c6==5 & c5==9 & c2==5) : (Up_Down_en ? ((c2==5)? enh: 0) :((c2==0) ? enh: 0));  //Has bugss to be fixed 
assign enablehtens= en? (c1==9&&c2==5&&c3==9&&c6==5&&c5==9) : (Up_Down_en ? ((c3== 4) ? enh:0) : ((c3==0)? enh:0));  //Has bugs to be fixed 
modTen mod_secs(clk,rst,en,Up_Down_en,c5);
mod_Six mod_secs_tens(clk,rst,en&&c5==9,Up_Down_en,c6);
modTen mod_Ten(clk, rst,enableminunits,Up_Down_en, c1);  //0
mod_Six mod_Six(clk, rst,enablemintens,Up_Down_en, c2); //1
modTen mod_Ten1(clk, rst||(c4==2&&c3==4),enableh,Up_Down_en, c3);  //0
modThree mod_three(clk, rst||(c4==2&&c3==4),enablehtens,Up_Down_en, c4); //1


assign count = {c4, c3, c2, c1};

endmodule
