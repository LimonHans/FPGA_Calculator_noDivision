`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 10:58:51 AM
// Design Name: 
// Module Name: dopAdder
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


module DopAdder(
	input clk,
	input EN,
	input [31:0] num1,
	input [2:0] dot1,
	input [31:0] num2,
	input [2:0] dot2,
	input [2:0] op,
	output reg[31:0] aligned_num1,
	output reg[31:0] aligned_num2,
	output reg[2:0] dot3
);

integer i, temp_num1, temp_num2;

always @(posedge clk)
begin
	if (EN)
	begin
		temp_num1 = num1;
		temp_num2 = num2;
		if (op == 3'b100)
			dot3 <= dot1 + dot2;
		else
		begin
			if (dot1 > dot2)
			begin
				for (i = 0; i < (dot1 - dot2); i = i + 1)
					temp_num2 = temp_num2*10;
				dot3 <= dot1;
			end
			else if (dot2 > dot1)
			begin
				for (i = 0; i < (dot2 - dot1); i = i + 1)
					temp_num1 = temp_num1*10;
//				repeat (dot2 - dot1)aligned_num1 <= (aligned_num1<<3) + (aligned_num1<<1);
				dot3 <= dot2;
			end
			else dot3 <= dot1;
		end
		aligned_num1 <= temp_num1;
		aligned_num2 <= temp_num2;
	end
end

endmodule