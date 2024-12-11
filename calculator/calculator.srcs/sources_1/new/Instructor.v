`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 02:37:46 PM
// Design Name: 
// Module Name: Instructor
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

// Instructor is a Mealy machine
module Instructor(
	input clk,
	input [4:0] key,
	output reg[31:0] value,
	output reg[2:0] dot,
	output reg neg,
	output reg rst,
	output reg EN_num1,
	output reg EN_num2,
	output reg neg3,
	output reg[2:0] op,
	output reg calc_en,
	output reg[1:0] display_sel,
	output [3:0] debugger // DEBUG only
);
reg[2:0] state;
assign debugger = {1'b0, state};
// 001 -> num1
// 010 -> num2
// 100 -> prepare
// 111 -> calc
// jumps:
// 001 -> 010: a symbol after at least one digit input, symbol -> op
// 010 -> 100: '='
//reg [31:0] value1, value2;
//reg [2:0] dot1, dot2;
//reg neg1, neg2, neg3;
reg func, jumper;
reg dotStart, neg1, neg2, isMulti;

initial
begin
	state <= 3'b001;
end

always @(posedge clk)
begin
	if (state == 3'b100)
	begin
		case ({neg1, neg2, isMulti})
			3'b100:
			begin
				op = (op == 3'b001)?(3'b010):(3'b001);
				neg3 = 1'b1;
			end
			3'b101: neg3 = 1'b1;
			3'b010: op = (op == 3'b001)?(3'b010):(3'b001);
			3'b011: neg3 = 1'b1;
			3'b110: neg3 = 1'b1;
			default;
			endcase
			state = 3'b111;
			calc_en <= 1'b1;
	end
	else if (key == 5'b00000)
		func <= 1'b1;
	else if (func == 1'b1)
	begin
		case (state)
			3'b001:
			begin
				rst <= 1'b0;
				EN_num1 <= 1'b1;
				EN_num2 <= 1'b0;
				if (key == 5'b01000 || key == 5'b01100 || key == 5'b00100) // - + *
				begin
					if (jumper == 1'b0)
					begin
						neg <= key == 5'b01000;
						neg1 <= key == 5'b01000;
					end
					else
					begin
						if (key == 5'b01000) begin op <= 3'b010; isMulti <= 1'b0; end
						else if (key == 5'b01100) begin op <= 3'b001; isMulti <= 1'b0; end
						else if (key == 5'b00100) begin op <= 3'b100; isMulti <= 1'b1; end
						state <= 3'b010;
						display_sel <= 2'b01;
						EN_num1 <= 1'b0;
						value <= 32'd0;
						dot <= 3'd0;
						dotStart <= 1'b0;
						neg <= 1'b0;
						jumper <= 1'b0;
					end
				end
				else if (key == 5'b01111)
				begin
					value <= 32'd0;
					dot <= 3'd0;
					dotStart <= 1'b0;
					neg <= 1'b0;
					jumper <= 1'b0;
				end
				else
				begin
					jumper <= 1'b1;
					case (key)
						5'b01101: begin value <= (value<<3) + (value<<1); dot <= dot + {2'b00, dotStart}; end
						5'b01001: begin value <= (value<<3) + (value<<1) + 1; dot <= dot + {2'b00, dotStart}; end
						5'b01010: begin value <= (value<<3) + (value<<1) + 2; dot <= dot + {2'b00, dotStart}; end
						5'b01011: begin value <= (value<<3) + (value<<1) + 3; dot <= dot + {2'b00, dotStart}; end
						5'b00101: begin value <= (value<<3) + (value<<1) + 4; dot <= dot + {2'b00, dotStart}; end
						5'b00110: begin value <= (value<<3) + (value<<1) + 5; dot <= dot + {2'b00, dotStart}; end
						5'b00111: begin value <= (value<<3) + (value<<1) + 6; dot <= dot + {2'b00, dotStart}; end
						5'b00001: begin value <= (value<<3) + (value<<1) + 7; dot <= dot + {2'b00, dotStart}; end
						5'b00010: begin value <= (value<<3) + (value<<1) + 8; dot <= dot + {2'b00, dotStart}; end
						5'b00011: begin value <= (value<<3) + (value<<1) + 9; dot <= dot + {2'b00, dotStart}; end
						5'b01110: begin dotStart <= 1'b1; end
						default;
					endcase
				end
			end
			3'b010:
			begin
				EN_num2 <= 1'b1;
				display_sel <= 2'b01;
				if (key == 5'b01000 || key == 5'b01100) // - +
				begin
					neg <= key == 5'b01000;
					neg2 <= key == 5'b01000;
				end
				else if (key == 5'b10000) // =
				begin
					state <= 3'b100;
					display_sel <= 2'b10;
					EN_num2 <= 1'b0;
					value <= 32'd0;
					dot <= 3'd0;
					dotStart <= 1'b0;
					neg <= 1'b0;
					neg3 <= 1'b0;
				end
				else
				begin
					case (key)
						5'b01101: begin value <= (value<<3) + (value<<1); dot <= dot + {2'b00, dotStart}; end
						5'b01001: begin value <= (value<<3) + (value<<1) + 1; dot <= dot + {2'b00, dotStart}; end
						5'b01010: begin value <= (value<<3) + (value<<1) + 2; dot <= dot + {2'b00, dotStart}; end
						5'b01011: begin value <= (value<<3) + (value<<1) + 3; dot <= dot + {2'b00, dotStart}; end
						5'b00101: begin value <= (value<<3) + (value<<1) + 4; dot <= dot + {2'b00, dotStart}; end
						5'b00110: begin value <= (value<<3) + (value<<1) + 5; dot <= dot + {2'b00, dotStart}; end
						5'b00111: begin value <= (value<<3) + (value<<1) + 6; dot <= dot + {2'b00, dotStart}; end
						5'b00001: begin value <= (value<<3) + (value<<1) + 7; dot <= dot + {2'b00, dotStart}; end
						5'b00010: begin value <= (value<<3) + (value<<1) + 8; dot <= dot + {2'b00, dotStart}; end
						5'b00011: begin value <= (value<<3) + (value<<1) + 9; dot <= dot + {2'b00, dotStart}; end
						5'b01110: begin dotStart <= 1'b1; end
						5'b01111:
						begin
							value <= 32'd0;
							dot <= 3'd0;
							dotStart <= 1'b0;
							neg <= 1'b0;
						end
						default;
					endcase
				end
			end
//			3'b100:
//			begin
//				case ({neg1, neg2, isMulti})
//					3'b100:
//					begin
//						op <= (op == 3'b001)?(3'b010):(3'b001);
//						neg3 <= 1'b1;
//					end
//					3'b101: neg3 <= 1'b1;
//					3'b010: op <= (op == 3'b001)?(3'b010):(3'b001);
//					3'b011: neg3 <= 1'b1;
//					3'b110: neg3 <= 1'b1;
//					default;
//				endcase
//				state <= 3'b111;
//			end
			3'b111:
			begin
				if (key == 5'b01111)
				begin
					state <= 3'b001;
					display_sel <= 2'b00;
					value <= 32'd0;
					dot <= 3'd0;
					dotStart <= 1'b0;
					neg <= 1'b0;
					neg3 <= 1'b0;
					rst <= 1'b1;
					EN_num1 <= 1'b1;
					EN_num2 <= 1'b1;
					calc_en <= 1'b0;
					jumper <= 1'b0;
				end
				else calc_en <= 1'b1;
			end
			default;
		endcase
		func <= 1'b0;
	end
end

endmodule
