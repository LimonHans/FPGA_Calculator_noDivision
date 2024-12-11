`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 01:43:53 PM
// Design Name: 
// Module Name: DataManager
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


module DataManager(
	input CLK,
	input EN,
	input rst,
	input [31:0]value_in,
	input [2:0]dot_in,
	input neg_in,
	output [31:0] value_out,
	output [2:0]dot_out,
	output neg_out
);
integer temp_value = 0, temp_dot = 0;
reg [31:0] value;
reg [2:0] dot;
reg neg;

assign value_out = value;
assign dot_out = dot;
assign neg_out = neg;

always @(posedge CLK)
begin
	if (EN)
	begin
		temp_value = rst?32'd0:value_in;
		temp_dot = rst?3'd0:dot_in;
		neg <= rst?1'b0:neg_in;
	end
	else
	begin
		temp_value = value;
		temp_dot = dot;
	end
	if (temp_value%10 == 0 && temp_dot > 0)
	begin
		temp_value = temp_value/10;
		temp_dot = temp_dot - 1;
	end
	value <= temp_value;
	dot <= temp_dot;
end

endmodule