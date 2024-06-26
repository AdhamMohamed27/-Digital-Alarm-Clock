`timescale 1ns / 1ps

module Alarm_Adjust(
 input clk, rst, enh, enm, Up_Down_en,
    output [12:0] count
);

wire [2:0] alarm_minutes_tens;
wire [3:0] alarm_minutes;
wire [3:0] alarm_hours;
wire [1:0] alarm_hours_tens;


wire enable_min_units, enable_min_tens, enable_hour_units, enable_hour_tens;


assign enable_min_units =  enm;
assign enable_min_tens = (Up_Down_en ? (alarm_minutes == 9 ? enm : 0) : (alarm_minutes == 0 ?  (alarm_minutes_tens == 0 ? 0: enm): 0));
                            
                    
assign enable_hour_units =  enh;

assign enable_hour_tens = (Up_Down_en ? (alarm_hours == 9 ? enh : 0) : (alarm_hours == 0 ? (alarm_hours_tens == 0 ? 0: enh): 0));




 modTen mod_Ten_min_units_A(
    .clk(clk), 
    .rst(rst), 
    .en(enable_min_units), 
    .Up_Down_en(Up_Down_en), 
    .count(alarm_minutes)
);

mod_Six mod_Six_min_tens_A(
    .clk(clk), 
    .rst(rst), 
    .en(enable_min_tens), 
    .Up_Down_en(Up_Down_en), 
    .count(alarm_minutes_tens)
);

modTen mod_Ten_hour_units_A(
    .clk(clk), 
    .rst(rst || (hour_tens == 2 && hour_units == 4)), 
    .en(enable_hour_units), 
    .Up_Down_en(Up_Down_en), 
    .count(alarm_hours)
);

modThree mod_three_hour_tens_A(
    .clk(clk), 
    .rst(rst || (hour_tens == 2 && hour_units == 4)), 
    .en(enable_hour_tens), 
    .Up_Down_en(Up_Down_en), 
    .count(alarm_hours_tens)
);

assign count = {alarm_hours_tens, alarm_hours, alarm_minutes_tens, alarm_minutes};





endmodule