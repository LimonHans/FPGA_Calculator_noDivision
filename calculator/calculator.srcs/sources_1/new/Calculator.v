`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 10:58:51 AM
// Design Name: 
// Module Name: Calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// Depends on code from HZY, nonDopCalc specifically.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Calculator(
	input clk, // shall be 1MHz
	input EN,
	input [31:0] num1,
	input [2:0] dot1,
	input [31:0] num2,
	input [2:0] dot2,
	input neg3_in,
	input [2:0] operator, // 001 -> num1 + num2 = num3
	                      // 010 -> num1 - num2 = num3
	                      // 100 -> num1*num2 = num3
	output [31:0] num3,
	output [2:0] dot3,
	output neg3_out
);

assign flag_negative = (operator == 3'b010)?(num2 > num1):1'b0;
assign neg3_out = neg3_in^flag_negative;
wire [31:0] aligned_num1, aligned_num2;

DopAdder dopAdder(
	.clk(clk),
	.EN(EN),
	.num1(num1),
	.dot1(dot1),
	.num2(num2),
	.dot2(dot2),
	.op(operator),
	.aligned_num1(aligned_num1),
	.aligned_num2(aligned_num2),
	.dot3(dot3)
);

NonDopCalc nonDopCalc(
	.clk(clk),
	.EN(EN),
	.num1(aligned_num1),
	.num2(aligned_num2),
	.state(operator),
	.out(num3)
);

endmodule
