`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:45:57 PM
// Design Name: 
// Module Name: Mod_N_Counter
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


module Mod_N_Counter #(parameter x=4,n=10)(input clk, reset,en,Up_Down_en, output reg [x-1:0]count);

always @(posedge clk, posedge reset) begin 
 if (reset == 1)
    count <= 0; // non-blocking assignment 
 // initialize flip flop here
 else begin 
 if(en) begin 
     if(count==n-1)
        count <=0;
     else
        count <= count + 1; // non-blocking assignment 
     end
 end
 // normal operation 
end
endmodule

