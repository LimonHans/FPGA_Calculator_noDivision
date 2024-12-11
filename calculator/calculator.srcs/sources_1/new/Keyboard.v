`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: LLH
// 
// Create Date: 11/24/2024 05:37:26 PM
// Design Name: 
// Module Name: Keyboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// File by LLH, with a small modification by Hans (on the naming of the outputs and an initial part,
//                                                 also the logic of updating key)
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Keyboard(
	input wire clk,
	input wire [3:0] row,
	output reg [3:0] col,
	output reg [4:0] key
);

reg [1:0] state;
reg [9:0] counter; // counter is used to determine when to raise "the no input state"

initial
begin
	state <= 2'd0;
	col <= 4'b1111;
	key <= 5'b00000;
end

always @(posedge clk) begin
    case (state)
        0: begin col <= 4'b1110; state <= 1; end
        1: begin col <= 4'b1101; state <= 2; end
        2: begin col <= 4'b1011; state <= 3; end
        3: begin col <= 4'b0111; state <= 0; end
    endcase
//    if (row != 4'b1111) begin
        case ({row, col})
            8'b1110_1110: begin key <= 5'b00001; counter <= 12'd0; end// 7
            8'b1110_1101: begin key <= 5'b00010; counter <= 12'd0; end// 8
            8'b1110_1011: begin key <= 5'b00011; counter <= 12'd0; end// 9
            8'b1110_0111: begin key <= 5'b00100; counter <= 12'd0; end// *
            8'b1101_1110: begin key <= 5'b00101; counter <= 12'd0; end// 4
            8'b1101_1101: begin key <= 5'b00110; counter <= 12'd0; end// 5
            8'b1101_1011: begin key <= 5'b00111; counter <= 12'd0; end// 6
            8'b1101_0111: begin key <= 5'b01000; counter <= 12'd0; end// -
            8'b1011_1110: begin key <= 5'b01001; counter <= 12'd0; end// 1
            8'b1011_1101: begin key <= 5'b01010; counter <= 12'd0; end// 2
            8'b1011_1011: begin key <= 5'b01011; counter <= 12'd0; end// 3
            8'b1011_0111: begin key <= 5'b01100; counter <= 12'd0; end// +
            8'b0111_1110: begin key <= 5'b01101; counter <= 12'd0; end// 0
            8'b0111_1101: begin key <= 5'b01110; counter <= 12'd0; end// .
            8'b0111_1011: begin key <= 5'b01111; counter <= 12'd0; end// C
            8'b0111_0111: begin key <= 5'b10000; counter <= 12'd0; end// =
            default: counter <= counter + 1;
        endcase
//    end
    if (counter == 10'b1111111111)
    begin
    	counter <= 10'd0;
    	key <= 5'b00000;
    end
end

endmodule
