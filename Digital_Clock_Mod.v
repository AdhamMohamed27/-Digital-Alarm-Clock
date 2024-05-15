`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 02:43:50 PM
// Design Name: 
// Module Name: Digital_Clock_Mod
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


module Digital_Clock_Mod(input clk, en, reset,Up_Down_en, output [6:0]segments, output reg DP,output[3:0] anode_active);

wire clk_out;
wire [1:0] sel;
wire [3:0] numbers;
wire[2:0] minutes_tens;
wire[3:0] minutes; 
wire[3:0] hours;
wire[1:0] hours_tens; 
wire clk_1hz;

Mod_N_Counter #(2, 4) BC (clk_out, reset, en,Up_Down_en, sel); 
MUX_4X1 mux({2'b00,hours_tens[1:0]},hours[3:0],{1'b0,minutes_tens[2:0]},minutes[3:0], sel, numbers);
Clock_Divider #(250000) clockdiv(clk, reset, clk_out);
Clock_Divider #(50000000) clockdiv_1hz(clk,reset,clk_1hz);
Hours_Mins_Secs HMS (clk,reset,en,Up_Down_en,{hours_tens,hours,minutes_tens,minutes});
always @(*) begin
    if(anode_active==4'b1101 && clk_1hz)
        DP=0; //active low, so the DP activates
    else 
       DP=1;
    end 
Seven_Seg SDC(en, numbers,sel,segments,anode_active);
endmodule

 
