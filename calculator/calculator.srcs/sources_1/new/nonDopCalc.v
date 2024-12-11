`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 10:58:51 AM
// Design Name: 
// Module Name: nonDopCalc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Code from HZY, with small modifications on the '-' operator (move the judgement on whether
// an expression is negative to the upper struct Calculator)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module NonDopCalc(
	input clk,
	input EN,
	input [31:0] num1,
	input [31:0] num2,
	input [2:0] state,
	output reg[31:0] out
);

always@(posedge clk)
begin
	if (EN)
	begin
		case(state)
			3'b001: out <= num1 + num2;
			3'b010:
				if (num2 > num1)out <= num2 - num1;
				else out <= num1 - num2;
			3'b100: out <= num1*num2;
			default: out <= 32'd0;
		endcase
	end
end

endmodule
