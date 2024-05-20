`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:44:36 PM
// Design Name: 
// Module Name: MUX_4X1
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


module MUX_4X1(input [3:0]a, input [3:0]b, input [3:0]c, input [3:0]d,input [1:0]sel, output reg[3:0] out);
always@(*)
begin
    case(sel)
        2'd0:out = d;
        2'd1:out = c;
        2'd2: out = b;
        2'd3:out = a;
    endcase
end
endmodule
    