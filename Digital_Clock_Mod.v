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
reg [2:0] state, nextState;
parameter [2:0] 
Clock_State=3'b000,
AdjustMode=3'b001,
Adjust_mode=3'b110,
Adjust_mins_clock=3'b010,
Adjust_hours_clock=3'b011,
Adjust_mins_alarm=3'b100,
Adjust_hours_alarm=3'b101;
wire BTNC,BTNR,BTNL,BTNU,BTND;
genvar i;
generate 
for(i=0;i<10;i=i+1) begin
Pushbutton_detector pbutton(.clk(clk_out),.rst(rst),.pushB(pushB[i]),.out(outbutton[i]));
end
endgenerate
always @ (*) 
case (state)
Clock_State: if(BTNC==1'b0) nextState=Clock_State;
else nextState=Adjust_mode;

Adjust_mode: if (BNTC==1'b1) nextState = Clock_State;
 else if(BTNR==1'b1) nextState = Adjust_mins_clock;
 else if(BTNL==1'b1) nextstate=Adjust_mins_alarm;
 else nextState=Adjust_mode;

Adjust_mins_clock: if (BTNC==1'b1) nextState = Clock_State;
 else if(BTNR==1'b1) nextState = Adjust_hours_clock;
 else if(BTNL==1'b1) nextState =Adjust_mins_alarm;  //incomplete code, we need to make the satete wehre when we push BTNU or BTNL, we add/dec
 else nextState=Adjust_mins_clock;
Adjust_hours_clock: if (BTNC==1'b1) nextState = Clock_State;
 else if (BTNR==1'b1) nextState = Adjust_mins_clock;
 else if (BTNL==1'b1) nextState=Adjust_hours_alarm; //incomplete code, we need to make the satete wehre when we push BTNU or BTNL, we add/dec
 else nextState=Adjust_hours_clock;
 Adjust_hours_alarm: if (BTNC==1'b1) nextState = Clock_State;
 else if (BTNL==1'b1) nextState = Adjust_mins_alarm;
 else if (BTNR==1'b1) nextState=Adjust_mins_clock;
 else nextState=Adjust_hours_alarm; 
 
Adjust_mins_alarm:  if(BNTC==1'b1) nextState = Clock_State;
                    else if (BTNR==1'b1) nextState=Adjust_mins_alarm;
                    else if (BTNL==1'b1) nextState=Adjust_mins_alarm;
                    else nextState=Adjust_mins_alarm;
default: nextState = Clock_State;
endcase

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

 
