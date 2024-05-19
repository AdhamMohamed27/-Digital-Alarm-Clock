`timescale 1ns / 1ps


module Hours_Mins_Secs (
    input clk, rst, en, enh, enm, Up_Down_en,
    output [12:0] count,
    output [3:0] sec_units,
    output [2:0] sec_tens
);


wire [3:0] min_units;
wire [2:0] min_tens;
wire [3:0] hour_units;
wire [1:0] hour_tens;

wire enable_min_units, enable_min_tens, enable_hour_units, enable_hour_tens;


assign enable_min_units = en ? (sec_tens == 5 && sec_units == 9) : enm;
assign enable_min_tens = en ? (min_units == 9 && sec_tens == 5 && sec_units == 9) : 
                            (Up_Down_en ? (min_units == 9 ? enm : 0) : (min_units == 0 ?  (min_tens == 0 ? 0: enm): 0));
                            
                    
assign enable_hour_units = en ? (min_tens == 5 && min_units == 9 && sec_tens == 5 && sec_units == 9) : enh;

assign enable_hour_tens = en ? (hour_units == 9 && min_tens == 5 && min_units == 9 && sec_tens == 5 && sec_units == 9) : 
                           (Up_Down_en ? (hour_units == 9 ? enh : 0) : (hour_units == 0 ? (hour_tens == 0 ? 0: enh): 0));

modTen mod_secs(
    .clk(clk), 
    .rst(rst), 
    .en(en), 
    .Up_Down_en(Up_Down_en), 
    .count(sec_units)
);

mod_Six mod_secs_tens(
    .clk(clk), 
    .rst(rst), 
    .en(en && sec_units == 9), 
    .Up_Down_en(Up_Down_en), 
    .count(sec_tens)
);

modTen mod_Ten_min_units(
    .clk(clk), 
    .rst(rst), 
    .en(enable_min_units), 
    .Up_Down_en(Up_Down_en), 
    .count(min_units)
);

mod_Six mod_Six_min_tens(
    .clk(clk), 
    .rst(rst), 
    .en(enable_min_tens), 
    .Up_Down_en(Up_Down_en), 
    .count(min_tens)
);

modTen mod_Ten_hour_units(
    .clk(clk), 
    .rst(rst || (hour_tens == 2 && hour_units == 4)), 
    .en(enable_hour_units), 
    .Up_Down_en(Up_Down_en), 
    .count(hour_units)
);

modThree mod_three_hour_tens(
    .clk(clk), 
    .rst(rst || (hour_tens == 2 && hour_units == 4)), 
    .en(enable_hour_tens), 
    .Up_Down_en(Up_Down_en), 
    .count(hour_tens)
);

assign count = {hour_tens, hour_units, min_tens, min_units};

endmodule
