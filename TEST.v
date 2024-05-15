`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 05:01:04 PM
// Design Name: 
// Module Name: TEST
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


module TEST();
reg clk,en,reset,Up_Down_en;
wire [6:0] segments;
wire DP;
wire [3:0] anode_active;
Digital_Clock_Mod dut( clk, en, reset,Up_Down_en, segments, DP, anode_active);

initial begin
clk=0;
forever #5
clk=~clk;
end 
initial begin
reset=1;
en=1;
Up_Down_en=0;
#10
reset=0;
#200 
$finish;
end
endmodule
