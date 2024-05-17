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


module Digital_Clock_Mod(input clk, en, reset,input BTNC,BTNR,BTNL,BTNU,BTND,
 output [6:0]segments, output reg DP,output[3:0] anode_active, output reg[4:0] led);

reg Up_Down_en;
reg enable_clock;
wire [1:0] sel;wire [3:0] numbers;
wire[2:0] minutes_tens;
wire[3:0] minutes; 
wire[3:0] hours;
wire[1:0] hours_tens; 
wire clk_1hz;
reg enMins;
reg enHours;
wire clk_200;
reg [2:0] state, nextState;

parameter [2:0] 
Clock_State=3'b000,
AdjustMode=3'b001,
Adjust_mode=3'b110,
Adjust_mins_clock=3'b010,
Adjust_hours_clock=3'b011,
Adjust_mins_alarm=3'b100,
Adjust_hours_alarm=3'b101;

wire [4:0] outbutton;
Pushbutton_detector pbuttonC(.clk(clk_200), .rst(reset), .pushB(BTNC), .out(outbutton[0]));
Pushbutton_detector pbuttonR(.clk(clk_200), .rst(reset), .pushB(BTNR), .out(outbutton[1]));
Pushbutton_detector pbuttonL(.clk(clk_200), .rst(reset), .pushB(BTNL), .out(outbutton[2]));
Pushbutton_detector pbuttonU(.clk(clk_200), .rst(reset), .pushB(BTNU), .out(outbutton[3]));
Pushbutton_detector pbuttonD(.clk(clk_200), .rst(reset), .pushB(BTND), .out(outbutton[4]));

Clock_Divider #(5000000) clockdiv_1hz(clk,reset,clk_1hz);
Clock_Divider #(250000) clock200 (clk,reset,clk_200);

reg clk_input;
always @ (*) 
case (state)
Clock_State: 
    if(outbutton ==5'b00001) begin 
        clk_input = clk_200;
        nextState=Adjust_mode;
        led[0]=1'b1;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;
        enMins=0;
        enHours=0;
        Up_Down_en=1;
        enable_clock=0;
    end
    else begin 
        clk_input = clk_1hz;
        nextState = Clock_State;
        Up_Down_en=1;
        enable_clock=1;
        enMins=0;
        enHours=0;
        led[0]=1'b0;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;
    end
Adjust_mode: 
    if (outbutton ==5'b00001) begin // BTNC
        clk_input = clk_1hz;
        nextState=Clock_State;
        Up_Down_en=1;
        enable_clock=1;
        enMins=0;
        enHours=0;
        led[0]=1'b0;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;
     end
    else if(outbutton==5'b00010) begin  // BTNR
        nextState = Adjust_mins_clock;
        clk_input = clk_200;
        led[0]=1'b1; 
        led[1]=1'b1;
        led[2]=1'b0;
        enMins=0;
        enHours=0;
        led[3]=1'b0;
        led[4]=1'b0;
        enable_clock=0;
    end   
     else if(outbutton==5'b00100) begin  // BTNL
        nextState = Adjust_mins_clock;
        clk_input = clk_200;
        led[0]=1'b1; 
        led[1]=1'b1;
        led[2]=1'b0;
        enMins=0;
        enHours=0;
        led[3]=1'b0;
        led[4]=1'b0;
        enable_clock=0;
    end
//    else if(outbutton==5'b00011=0) nextState=Adjust_mins_alarm; //BTNL
    else begin
        nextState=Adjust_mode;
        led[0]=1'b1;
        clk_input = clk_200;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;
        enMins=0;
        enHours=0;
        Up_Down_en=1;
        enable_clock=0;
    end

Adjust_mins_clock: 
if (outbutton[0]==1'b1) begin  
        nextState = Clock_State;
        clk_input = clk_1hz;
        Up_Down_en=1;
        enable_clock=1;
        enMins=0;
        enHours=0;
        led[0]=1'b0;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;

end
 else if(outbutton[1]==1'b1) begin 
  nextState=Adjust_hours_clock;
 led[0]=1'b1;
 led[1]=1'b0;
 led[3]=1'b0;
 led[4]=1'b0; 
 led[2]=1'b1;
 enable_clock=0;
 end
else if (outbutton[3]==1'b1) begin // BTNU
    nextState = Adjust_hours_clock;
    enable_clock=0;
    Up_Down_en=1;
    enMins=0;
    enHours=0;
    clk_input = clk_200;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 else if(outbutton[4]==1'b1) begin // BTND
    nextState = Adjust_hours_clock;
    clk_input = clk_200;
    enable_clock=0;
    Up_Down_en=0;
    enMins=0;
    enHours=1;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 //else if(outbutton[2]==1'b1) nextState =Adjust_mins_alarm;  //incomplete code, we need to make the satete wehre when we push BTNU or outbutton[2], we add/dec
 else begin
    nextState=Adjust_mins_clock;
    led[0]=1'b1; 
    led[1]=1'b1;
    clk_input = clk_200;
    led[2]=1'b0;
    enMins=0;
    enHours=0;
    led[3]=1'b0;
    led[4]=1'b0;
    enable_clock=0;
    if (outbutton[3]==1'b1) begin // BTNU
    nextState = Adjust_mins_clock;
    enable_clock=0;
    Up_Down_en=1;
    enMins=1;
    clk_input = clk_200;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 else if(outbutton[4]==1'b1) begin // BTND
    nextState = Adjust_mins_clock;
    clk_input = clk_200;
    enable_clock=0;
    Up_Down_en=0;
    enMins=1;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 end
 
Adjust_hours_clock: if (outbutton[0]==1'b1) begin 
 nextState = Clock_State;
        Up_Down_en=1;
        enable_clock=1;
        led[0]=1'b0;
        led[1]=1'b0;
        led[2]=1'b0;
        led[3]=1'b0;
        led[4]=1'b0;
        enMins=0;
        enHours=0;
 end
 else if (outbutton[1]==1'b1)  begin 
 nextState = Adjust_mins_clock;
 led[0]=1'b1; 
 led[1]=1'b1;
 led[2]=1'b0;
 led[3]=1'b0;
 led[4]=1'b0;
 enable_clock=0;
 end
  else if (outbutton[3]==1'b1) begin // BTNU
    nextState = Adjust_hours_clock;
    enable_clock=0;
    Up_Down_en=1;
    enMins=1;
    enHours=0;
    clk_input = clk_200;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 else if(outbutton[4]==1'b1) begin // BTND
    nextState = Adjust_hours_clock;
    clk_input = clk_200;
    enable_clock=0;
    Up_Down_en=0;
    enMins=1;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 //else if (outbutton[2]==1'b1) nextState=Adjust_hours_alarm; //incomplete code, we need to make the satete wehre when we push BTNU or outbutton[2], we add/dec
 else begin 
 nextState=Adjust_hours_clock;
 led[0]=1'b1;
 led[1]=1'b0;
 led[3]=1'b0;
 led[4]=1'b0; 
 led[2]=1'b1;
 enable_clock=0;
 
if (outbutton[3]==1'b1) begin // BTNU
    nextState = Adjust_hours_clock;
    enable_clock=0;
    Up_Down_en=1;
    enMins=0;
    enHours=1;
    clk_input = clk_200;
    enHours=0;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 else if(outbutton[4]==1'b1) begin // BTND
    nextState = Adjust_hours_clock;
    clk_input = clk_200;
    enable_clock=0;
    Up_Down_en=0;
    enMins=0;
    enHours=1;
    led[0]=1'b1;
    led[1]=1'b1;
    led[2]=1'b0;
    led[3]=1'b0;
    led[4]=1'b0;
 end
 end
// Adjust_hours_alarm: if (outbutton[0]==1'b1) begin
//  nextState = Clock_State;
  
// else if (outbutton[2]==1'b1) nextState = Adjust_mins_alarm;
// else if (outbutton[1]==1'b1) nextState=Adjust_mins_clock;
// else begin nextState=Adjust_hours_alarm; 
// led[0]=1'b1; 
// led[3]=1'b0;
// led[1]=1'b0;
// led[2]=1'b0;
// led[4]=1'b1;
//  enable_clock=0;
// if (outbutton[4]==1'b1) begin
//    Up_Down_en=1;
//    enMins=1;
//    enHours=0;
//    end
//    else if(outbutton[5]==1'b1) begin
//        Up_Down_en=0;
//       enMins=1;
//        enHours=0;
//  end
// end  
//Adjust_mins_alarm:  if(outbutton [0]==1'b1) nextState = Clock_State;
//                    else if (outbutton[1]==1'b1) nextState=Adjust_mins_clock;
//                    else if (outbutton[2]==1'b1) nextState=Adjust_hours_alarm;
//                    else begin 
//                    nextState=Adjust_mins_alarm;
//                    led[0]=1'b1; 
//                    led[4]=1'b0;
//                    led[1]=1'b0;
//                    led[2]=1'b0;
//                    led[3]=1'b1;
//                    led[4]=1'b0;
//                     enable_clock=0;
//                    if (outbutton[4]==1'b1) begin
//                    Up_Down_en=1;
//                        enMins=1;
//                        enHours=0;
//                        end
//            else if(outbutton[5]==1'b1) begin
//                Up_Down_en=0;
//                enMins=1;
//                enHours=0;
//          end
//          end
//default: nextState = Clock_State;
endcase

Mod_N_Counter #(2, 4) BC (clk_200, reset, en,Up_Down_en, sel); 
MUX_4X1 mux({2'b00,hours_tens[1:0]},hours[3:0],{1'b0,minutes_tens[2:0]},minutes[3:0], sel, numbers);

Hours_Mins_Secs HMS (clk_input,reset,enable_clock,enHours,enMins,Up_Down_en,{hours_tens,hours,minutes_tens,minutes});
always @(*) begin
    if(anode_active==4'b1101 && clk_1hz&& enable_clock)
        DP=0; //active low, so the DP activates
    else 
       DP=1;
    end 
always @(posedge clk_200, posedge reset)begin
    if(reset)begin
        state <= Clock_State;
    end
