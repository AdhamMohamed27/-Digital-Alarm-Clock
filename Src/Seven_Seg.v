`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 03:11:23 PM
// Design Name: 
// Module Name: Seven_Seg
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


module Seven_Seg(
input en,
input [3:0] num,
input [1:0] selector,
output reg [6:0] segments,
output reg [3:0] anode_active);
always @ (*) begin
if(en==1) begin
case(selector)
0:anode_active=4'b0111;
1:anode_active=4'b1011;
2:anode_active=4'b1101;
3:anode_active=4'b1110;
endcase
end
else begin
anode_active=4'b1111;
end
case(num)
0: segments = 7'b0000001;
1: segments = 7'b1001111;
2: segments = 7'b0010010;
3: segments = 7'b0000110;
4: segments = 7'b1001100;
5: segments = 7'b0100100;
6: segments = 7'b0100000;
7: segments = 7'b0001111;
8: segments = 7'b0000000;
9: segments = 7'b0000100;
endcase
end
endmodule 
