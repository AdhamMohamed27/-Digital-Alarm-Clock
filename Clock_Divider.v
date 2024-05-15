`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:46:51 PM
// Design Name: 
// Module Name: Clock_Divider
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


module Clock_Divider #(parameter n = 50000000)(input clk, rst, output reg clk_out);parameter WIDTH = $clog2(n);
reg [WIDTH-1:0] count;
always @ (posedge clk, posedge rst) begin
if (rst == 1'b1) begin
   count <= 32'b0;
end else if (count == n-1) begin
 count <= 32'b0;
end else begin
 count <= count + 1;
end
end
// Handle the output clock
always @ (posedge clk, posedge rst) begin
if (rst)begin // Asynchronous Reset
 clk_out <= 0;
end else if (count == n-1)begin
 clk_out <= ~ clk_out;
end
end
endmodule


