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
// Description: Modular N Counter with up and down counting capability.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Mod_N_Counter #(parameter x = 4, n = 10)(input clk, reset, en, Up_Down_en, output reg [x-1:0] count);

always @(posedge clk, posedge reset) begin
    if (reset)
        count <= 0;  // Reset the counter to 0
    else if (en) begin  // Check if the counter is enabled
        if (Up_Down_en) begin
            // Count up
            if (count == n - 1)
                count <= 0;  // Wrap around if the maximum is reached
            else
                count <= count + 1;  // Increment the counter
        end else begin
            // Count down
            if (count == 0)
                count <= n - 1;  // Wrap around if the minimum is reached
            else
                count <= count - 1;  // Decrement the counter
        end
    end
end

endmodule
