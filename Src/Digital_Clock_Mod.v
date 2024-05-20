`timescale 1ns / 1ps

module Digital_Clock_Mod(
    input clk, en, reset,
    input BTNC, BTNR, BTNL, BTNU, BTND,
    output [6:0] segments, 
    output reg DP,
    output [3:0] anode_active, 
    output reg [5:0] led,
    output buzzer
);

reg clk_input;
reg match;

reg Up_Down_en;
reg enable_clock;
wire [1:0] sel;
wire [3:0] numbers;
wire [3:0] numbers_a;
reg [3:0] display;
wire [2:0] minutes_tens;
wire [3:0] minutes; 
wire [3:0] hours;
wire [1:0] hours_tens; 
wire [2:0] minutes_tens_a;
wire [3:0] minutes_a; 
wire [3:0] hours_a;
wire [1:0] hours_tens_a; 
wire clk_1hz;
reg enMins;
reg enHours;
reg enHours_a;
reg enMins_a;
wire clk_200;
wire clk_buzz;
reg [2:0] state, nextState;

parameter [2:0] 
    Clock_State = 3'b000,
    AlarmMod = 3'b001,
    Adjust_mode = 3'b110,
    Adjust_mins_clock = 3'b010,
    Adjust_hours_clock = 3'b011,
    Adjust_mins_alarm = 3'b100,
    Adjust_hours_alarm = 3'b111;

wire [4:0] outbutton;
Pushbutton_detector pbuttonC(.clk(clk_200), .rst(reset), .pushB(BTNC), .out(outbutton[0]));
Pushbutton_detector pbuttonR(.clk(clk_200), .rst(reset), .pushB(BTNR), .out(outbutton[1]));
Pushbutton_detector pbuttonL(.clk(clk_200), .rst(reset), .pushB(BTNL), .out(outbutton[2]));
Pushbutton_detector pbuttonU(.clk(clk_200), .rst(reset), .pushB(BTNU), .out(outbutton[3]));
Pushbutton_detector pbuttonD(.clk(clk_200), .rst(reset), .pushB(BTND), .out(outbutton[4]));

Clock_Divider #(50000000) clockdiv_1hz(clk, reset, clk_1hz);
Clock_Divider #(250000) clock200(clk, reset, clk_200);
Clock_Divider #(12500000) clockbuzz(clk, reset, clk_buzz);

//STATE SEQUENCE: CLOCK -> ADJUST -> HOURS_C -> MINS_C -> HOURS_A -> MINS_A

always @ (*) 
case (state)
Clock_State: 
        if(minutes==minutes_a & minutes_tens==minutes_tens_a & hours==hours_a & hours_tens==hours_tens_a & {sec_units,sec_tens} == 7'd0) begin 
            clk_input = clk_1hz;
            nextState= AlarmMod;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            led[5]=clk_buzz;
            match=clk_buzz;
        end
        else if (outbutton == 5'b00001) begin 
            clk_input = clk_200;
            nextState = Adjust_mode;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            led[5]=1'b0;
            enMins = 0;
            enHours = 0;
            Up_Down_en = 1;
            enable_clock = 0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
         
        end
        else begin 
            clk_input = clk_1hz;
            nextState = Clock_State;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            led[5]=1'b0;
             enMins_a = 0;
            enHours_a = 0;
         end
AlarmMod: 
           if(outbutton != 5'd0) begin 
            clk_input = clk_1hz;
            nextState = Clock_State;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            led[5]=1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
           end
           else begin 
            clk_input = clk_1hz;
           nextState= AlarmMod;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            led[5]=clk_buzz;
            match=clk_buzz;
            end

Adjust_mode: 
        if (outbutton == 5'b00001) begin // BTNC
            clk_input = clk_1hz;
            nextState = Clock_State;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            match=0;
            enMins_a = 0;
            enHours_a = 0;
        end
        else if (outbutton == 5'b00010) begin  // BTNR
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b1;
            led[2] = 1'b0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enable_clock = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end   
        else if (outbutton == 5'b00100) begin  // BTNL
            nextState = Adjust_hours_alarm;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b0;
            led[2] = 1'b0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b0;
            led[4] = 1'b1;
            led[5]=1'b0;
            enable_clock = 0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else begin
            nextState = Adjust_mode;
            led[0] = 1'b1;
            clk_input = clk_200;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enMins = 0;
            enHours = 0;
            Up_Down_en = 1;
            enable_clock = 0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end

Adjust_hours_clock: 
        if (outbutton[0] == 1'b1) begin  
            nextState = Clock_State;
            clk_input = clk_1hz;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            led[5]=1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[1] == 1'b1) begin 
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0; 
            led[2] = 1'b1;
            led[5]=1'b0;
            enable_clock = 0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton == 5'b00100) begin  // BTNL
            nextState = Adjust_mins_alarm;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b0;
            led[2] = 1'b0;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b1;
            Up_Down_en = 1;
            led[4] = 1'b0;
            enable_clock = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[3] == 1'b1) begin // BTNU
            nextState = Adjust_hours_clock;
            enable_clock = 0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 1;
            clk_input = clk_200;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b1;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[4] == 1'b1) begin // BTND
            nextState = Adjust_hours_clock;
            clk_input = clk_200;
            enable_clock = 0;
            Up_Down_en = 0;
            enMins = 0;
            enHours = 1;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b1;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else begin
            nextState = Adjust_hours_clock;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b0;
            led[2] = 1'b1;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enable_clock = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
    
Adjust_mins_clock: 
        if (outbutton[0] == 1'b1) begin  
            nextState = Clock_State;
            clk_input = clk_1hz;
            Up_Down_en = 1;
            enable_clock = 1;
            enMins = 0;
            enHours = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[1] == 1'b1) begin 
            nextState = Adjust_hours_alarm;
            clk_input = clk_200;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b1;
            enable_clock = 0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
         else if (outbutton == 5'b00100) begin  // BTNL
            nextState = Adjust_hours_alarm;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b0;
            led[2] = 1'b0;
            enMins = 0;
            enHours = 0;
            led[4] = 1'b0;
            Up_Down_en = 1;
            led[4] = 1'b0;
            enable_clock = 0;
            enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        
        else if (outbutton[3] == 1'b1) begin // BTNU
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            enable_clock = 0;
            Up_Down_en = 1;
            enMins = 1;
            enHours = 0;
            led[0] = 1'b1;
            led[1] = 1'b1;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[4] == 1'b1) begin // BTND
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            enable_clock = 0;
            Up_Down_en = 0;
            enMins = 1;
            enHours = 0;
            led[0] = 1'b1;
            led[1] = 1'b1;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else begin
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            led[0] = 1'b1;
            led[1] = 1'b1;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enMins = 0;
            enHours = 0;
            enable_clock = 0;
            Up_Down_en = 1;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        
         
Adjust_mins_alarm: 
        if (outbutton[0] == 1'b1) begin  
            nextState = Clock_State;
            clk_input = clk_1hz;
            Up_Down_en = 1;
            enMins=0;
            enHours=0;
            enMins_a = 0;
            enHours_a = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            match=0;

        end
        else if (outbutton[1] == 1'b1) begin 
            nextState = Adjust_hours_clock;
            clk_input = clk_200;
           enMins=0;
          enHours=0;
            Up_Down_en = 1;
            enMins_a = 0;
            enHours_a = 0;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b1;
            led[3] = 1'b0;
            led[4] = 1'b0;
            match=0;
        end   
         else if (outbutton == 5'b00100) begin  // BTNL
            nextState = Adjust_hours_clock;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b0;
            led[2] = 1'b1;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enable_clock = 0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        
        else if (outbutton[3] == 1'b1) begin // BTNU
            nextState = Adjust_mins_alarm;
            clk_input = clk_200 ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            enMins_a = 1;
            enHours_a = 0;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b1;
            led[4] = 1'b0;
            match=0;
        end
        else if (outbutton[4] == 1'b1) begin // BTND
            nextState = Adjust_mins_alarm;
            clk_input = clk_200 ;
            enMins=0;
            enHours=0;
            Up_Down_en = 0;
            enMins_a = 1;
            enHours_a = 0;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b1;
            led[4] = 1'b0;
            match=0;
        end
        else begin
            nextState = Adjust_mins_alarm;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3]=1'b1;
            enMins_a = 0;
            enHours_a = 0;
            clk_input = clk_200 ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            match=0;
        end

Adjust_hours_alarm: 
        if (outbutton[0] == 1'b1) begin  
            nextState = Clock_State;
            clk_input = clk_1hz  ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            enMins_a = 0;
            enHours_a = 0;
            led[0] = 1'b0;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            match=0;
        end
        else if (outbutton[1] == 1'b1) begin 
            nextState = Adjust_mins_alarm;
            clk_input = clk_200  ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            enMins_a = 0;
            enHours_a = 0;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b1;
            led[4] = 1'b0;
            match=0;
        end
         else if (outbutton == 5'b00100) begin  // BTNL
            nextState = Adjust_mins_clock;
            clk_input = clk_200;
            led[0] = 1'b1; 
            led[1] = 1'b1;
            led[2] = 1'b0;
            Up_Down_en = 1;
            enMins = 0;
            enHours = 0;
            led[3] = 1'b0;
            led[4] = 1'b0;
            enable_clock = 0;
             enMins_a = 0;
            enHours_a = 0;
            match=0;
        end
        else if (outbutton[3] == 1'b1) begin // BTNU
            nextState = Adjust_hours_alarm;
            clk_input = clk_200  ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            enMins_a = 0;
            enHours_a = 1;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b1;
            match=0;
        end
        else if (outbutton[4] == 1'b1) begin // BTND
            nextState = Adjust_hours_alarm;
            clk_input = clk_200  ;
            enMins=0;
            enHours=0;
            Up_Down_en = 0;
            enMins_a = 0;
            enHours_a = 1;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b1;
            match=0;
        end
        else begin
            nextState = Adjust_hours_alarm;
            clk_input = clk_200 ;
            enMins=0;
            enHours=0;
            Up_Down_en = 1;
            enMins_a = 0;
            enHours_a = 0;
            led[0] = 1'b1;
            led[1] = 1'b0;
            led[2] = 1'b0;
            led[3] = 1'b0;
            led[4] = 1'b1;
            match=0;
        end
endcase

wire alarm_active;
wire [3:0] sec_units;
wire [2:0] sec_tens;
assign alarm_active = (state== Adjust_hours_alarm | state == Adjust_mins_alarm);
Mod_N_Counter #(2, 4) BC (clk_200, reset, en, Up_Down_en, sel); 
MUX_4X1 mux1({2'b00, hours_tens[1:0]}, hours[3:0], {1'b0, minutes_tens[2:0]}, minutes[3:0], sel, numbers);
MUX_4X1 mux2({2'b00, hours_tens_a[1:0]}, hours_a[3:0], {1'b0, minutes_tens_a[2:0]}, minutes_a[3:0], sel, numbers_a);

Hours_Mins_Secs HMS (clk_input, reset, enable_clock, enHours, enMins, Up_Down_en, {hours_tens, hours, minutes_tens, minutes},sec_units,sec_tens);
Alarm_Adjust alarm (clk_input,  reset, enHours_a, enMins_a , Up_Down_en,   {hours_tens_a, hours_a, minutes_tens_a,minutes_a});

always @(*) begin
    if (anode_active == 4'b1101 && clk_1hz && enable_clock)
        DP = 0; // active low, so the DP activates
    else 
        DP = 1;
end 



always @(posedge clk_200 or posedge reset) begin
    if (reset) begin
        state <= Clock_State;
    end
    else begin
        state <= nextState;
    end
end

always @(*) begin
display = alarm_active ? numbers_a : numbers;
end

Seven_Seg SDC(en, display, sel, segments, anode_active);


assign buzzer = (state == AlarmMod) ? clk_buzz:0;
endmodule