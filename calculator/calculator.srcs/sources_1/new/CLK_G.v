`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2024 11:06:44 AM
// Design Name: 
// Module Name: CLK_G
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


module CLK_G#(
	parameter div = 25
)(
	input raw_clk,
	output reg clk
);
reg[31:0] count;

always @(posedge raw_clk)
begin
	count = count + 1;
	if (count == div)
	begin
		count = 0;
		clk = ~clk;
	end
end

endmodule
