`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/21 14:34:58
// Design Name: 
// Module Name: LED
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


module LED(
// A -> 'O', B -> 'L', C -> '-'
	input[3:0] DS0,
	input[3:0] DS1,
	input[3:0] DS2,
	input[3:0] DS3,
	input[3:0] DS4,
	input[3:0] DS5,
	input[3:0] DS6,
	input[3:0] DS7,
	input[2:0] dot,
	input CLK,
	output reg[7:0] CON,
	output reg[7:0] SEL
);
integer CON_temp;

reg[2:0] num;
reg[3:0] to_display;

always @(posedge CLK)
begin
	if (num == 3'd7)
		num <= 0;
	else num <= num + 1;
end

always @(num)
begin	
	case (num)
		0: SEL <= ~8'b01111111;
		1: SEL <= ~8'b10111111;
		2: SEL <= ~8'b11011111;
		3: SEL <= ~8'b11101111;
		4: SEL <= ~8'b11110111;
		5: SEL <= ~8'b11111011;
		6: SEL <= ~8'b11111101;
		7: SEL <= ~8'b11111110;
		default: SEL <= 8'b00000000;
	endcase
	if (num + dot == 3'd7)
		CON_temp = 8'b11111110;
	else CON_temp = 8'b11111111;
	case (num)
		0: to_display <= DS0;
		1: to_display <= DS1;
		2: to_display <= DS2;
		3: to_display <= DS3;
		4: to_display <= DS4;
		5: to_display <= DS5;
		6: to_display <= DS6;
		7: to_display <= DS7;
		default: to_display <= 8'he;
	endcase
end

always @(to_display)
begin
	case(to_display)
		4'h0: CON = CON_temp & 8'b00000011;// ABCDEFG, DP
		4'h1: CON = CON_temp & 8'b10011111;
		4'h2: CON = CON_temp & 8'b00100101;
		4'h3: CON = CON_temp & 8'b00001101;
		4'h4: CON = CON_temp & 8'b10011001;
		4'h5: CON = CON_temp & 8'b01001001;
		4'h6: CON = CON_temp & 8'b01000001;
		4'h7: CON = CON_temp & 8'b00011111;
		4'h8: CON = CON_temp & 8'b00000001;
		4'h9: CON = CON_temp & 8'b00001001;
		4'ha: CON = CON_temp & 8'b00000011; // O
		4'hb: CON = CON_temp & 8'b11100011; // L
		4'hc: CON = CON_temp & 8'b11111101; // -
		4'hf: CON = CON_temp & 8'b11111111; // no display
		default: CON = 8'b11111111;
	endcase
end
endmodule