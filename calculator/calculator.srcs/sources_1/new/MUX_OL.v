`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 09:40:43 AM
// Design Name: 
// Module Name: MUX_OL
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


module MUX_OL(
	input CLK,
	input [31:0] value1,
	input [31:0] value2,
	input [31:0] value3,
	input [2:0] dot1,
	input [2:0] dot2,
	input [2:0] dot3,
	input neg1,
	input neg2,
	input neg3,
	input [1:0] sel, // 00 -> num1, 01 -> num2, 10 -> num3
	input [3:0] debugger, // DEBUG only
	output [7:0] CON,
	output [7:0] SEL
);
reg[3:0] DS0;
reg[3:0] DS1;
reg[3:0] DS2;
reg[3:0] DS3;
reg[3:0] DS4;
reg[3:0] DS5;
reg[3:0] DS6;
reg[3:0] DS7;
reg[2:0] dot;
reg[31:0] num_todisplay;
reg[2:0] dot_todisplay;
reg neg_todisplay;

assign display_CLK = CLK;

always @(*)
begin
	if (sel == 2'b00)
	begin
		num_todisplay <= value1;
		dot_todisplay <= dot1;
		neg_todisplay <= neg1;
	end
	else if (sel == 2'b01)
	begin
		num_todisplay <= value2;
		dot_todisplay <= dot2;
		neg_todisplay <= neg2;
	end
	else if (sel == 2'b10)
	begin
		num_todisplay <= value3;
		dot_todisplay <= dot3;
		neg_todisplay <= neg3;
	end
	else
	begin
		num_todisplay <= 32'd0;
		dot_todisplay <= 3'd0;
		neg_todisplay <= 1'b0;
	end
end
always @(CLK)
begin
	if (num_todisplay > 32'd9999999)
	begin // display xxxOLxxx
		DS0 <= 4'hf;
		DS1 <= 4'hf;
		DS2 <= 4'hf;
		DS3 <= 4'ha;
		DS4 <= 4'hb;
		DS5 <= 4'hf;
		DS6 <= 4'hf;
		DS7 <= 4'hf;
		dot <= 3'd4;
	end
	else
	begin
		DS0 <= neg_todisplay?4'hc:4'hf;
		DS1 <= num_todisplay/1000000;
//		DS1 <= {2'b00, sel};
		DS2 <= (num_todisplay/100000)%10;
//		DS2 <= debugger;
		DS3 <= (num_todisplay/10000)%10;
		DS4 <= (num_todisplay/1000)%10;
		DS5 <= (num_todisplay/100)%10;
		DS6 <= (num_todisplay/10)%10;
		DS7 <= num_todisplay%10;
		dot <= dot_todisplay;
	end
end

LED display(
	.DS0(DS0),
	.DS1(DS1),
	.DS2(DS2),
	.DS3(DS3),
	.DS4(DS4),
	.DS5(DS5),
	.DS6(DS6),
	.DS7(DS7),
	.dot(dot),
	.CLK(CLK),
	.CON(CON),
	.SEL(SEL)
);

endmodule