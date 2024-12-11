`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 09:47:47 AM
// Design Name: 
// Module Name: Debouncer
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


module Debouncer(
	input clk, // shall be a quarter of Keyboard's clock,
	           // however, a 1/10 clock is used since the keyboard is in a very bad condition
	input [4:0] raw_key,
	output reg[4:0] out_key
);
reg[4:0] temp_A, temp_B, temp_C, temp_D;

always @(posedge clk)
begin
	temp_D <= raw_key;
	temp_C <= temp_D;
	temp_B <= temp_C;
	temp_A <= temp_B;
	if (temp_A == temp_B && temp_B == temp_C && temp_C == temp_D)
		out_key <= temp_A;
end

endmodule
