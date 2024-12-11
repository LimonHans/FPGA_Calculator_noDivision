`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hans
// 
// Create Date: 11/24/2024 05:06:11 PM
// Design Name: 
// Module Name: Master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// This Master.v file should depend on codes from LLH and HZY.
// The codes are keyboard input and calculator without DP. DP will be realized in other files.
// To fully use the above files, some modification shall be made:
// - input and output definitions in the module definition. (undone)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Master(
	input resonator_clk,
//  the following are for the keyboard
	output J11_K0,
	output J11_K1,
	output J11_K2,
	output J11_K3,
	input J11_K4,
	input J11_K5,
	input J11_K6,
	input J11_K7,
//  the following are for display
	output SMG_0,
	output SMG_1,
	output SMG_2,
	output SMG_3,
	output SMG_4,
	output SMG_5,
	output SMG_6,
	output SMG_7,
	output CON_A,
	output CON_B,
	output CON_C,
	output CON_D,
	output CON_E,
	output CON_F,
	output CON_G,
	output CON_DP
);
// define CLK
wire clk_1M; // this should be the global CLK
wire clk_10K; // CLK for Keyboard
wire clk_2K5; // CLK for debouncing inputs
wire clk_1K; // CLK for display
// define key
wire[4:0] raw_key;
wire[4:0] key;
// define instructions
wire[2:0] operator;
// define nums, which will be stored in data records
//wire[31:0] raw_num1, raw_num2, raw_num3;
//wire[2:0] raw_dot1, raw_dot2, raw_dot3;
wire[31:0] bus_value, value3_in, value1, value2, value3;
wire[2:0] bus_dot, dot3_in, dot1, dot2, dot3;
wire bus_neg, neg3_in, neg1, neg2, neg3;
wire rst_all;
wire bus_en1, bus_en2;
// calculator
wire neg3_in_byinstructor, calc_en;
// define LED
wire[1:0] display_sel;
wire[4:0] to_display;
wire[7:0] CONs;
wire[7:0] SMGs;
// DEBUG only
wire [3:0]debugger;
assign {CON_A, CON_B, CON_C, CON_D, CON_E, CON_F, CON_G, CON_DP} = CONs;
assign {SMG_0, SMG_1, SMG_2, SMG_3, SMG_4, SMG_5, SMG_6, SMG_7} = SMGs;

// use CLK_G as component
CLK_G #(.div(1)) clk_g_1Mhz(
	.raw_clk(resonator_clk),
	.clk(clk_1M) // 25MHz in real
);
CLK_G #(.div(2500)) clk_g_10Khz(
	.raw_clk(resonator_clk),
	.clk(clk_10K)
);
CLK_G #(.div(10000)) clk_g_2K5hz(
	.raw_clk(resonator_clk),
	.clk(clk_2K5)
);
CLK_G #(.div(25000)) clk_g_1Khz(
	.raw_clk(resonator_clk),
	.clk(clk_1K)
);

// use Keyboard for inputs reading, Debouncer for key debounce
Keyboard keyboard(
	.clk(clk_10K),
	.row({J11_K4, J11_K5, J11_K6, J11_K7}),
	.col({J11_K3, J11_K2, J11_K1, J11_K0}),
	.key(raw_key)
);
Debouncer debounce(
	.clk(clk_1K),
	.raw_key(raw_key),
	.out_key(key)
);

// Instructor
Instructor instructor(
	.clk(clk_1M),
	.key(key),
	.value(bus_value),
	.dot(bus_dot),
	.neg(bus_neg),
	.rst(rst_all),
	.EN_num1(bus_en1),
	.EN_num2(bus_en2),
	.neg3(neg3_in_byinstructor),
	.op(operator),
	.calc_en(calc_en),
	.display_sel(display_sel),
	.debugger(debugger)
);

// data records
DataManager dataNum1(
	.CLK(clk_1M),
	.EN(bus_en1),
	.rst(rst_all),
	.value_in(bus_value),
	.dot_in(bus_dot),
	.neg_in(bus_neg),
	.value_out(value1),
	.dot_out(dot1),
	.neg_out(neg1)
);
DataManager dataNum2(
	.CLK(clk_1M),
	.EN(bus_en2),
	.rst(rst_all),
	.value_in(bus_value),
	.dot_in(bus_dot),
	.neg_in(bus_neg),
	.value_out(value2),
	.dot_out(dot2),
	.neg_out(neg2)
);
DataManager dataNum3(
	.CLK(clk_1M),
	.EN(1'b1),
	.rst(rst_all),
	.value_in(value3_in),
	.dot_in(dot3_in),
	.neg_in(neg3_in),
	.value_out(value3),
	.dot_out(dot3),
	.neg_out(neg3)
);

// Calculator
Calculator calculator(
	.clk(clk_1M),
	.EN(calc_en),
	.num1(value1),
	.dot1(dot1),
	.num2(value2),
	.dot2(dot2),
	.neg3_in(neg3_in_byinstructor),
	.operator(operator),
	.num3(value3_in),
	.dot3(dot3_in),
	.neg3_out(neg3_in)
);

// use LED for displaying info, NOTE: to turn off an LED, pass value 4'hf
MUX_OL interMasterDisplay(
	.CLK(clk_1K),
	.value1(value1),
	.value2(value2),
	.value3(value3),
	.dot1(dot1),
	.dot2(dot2),
	.dot3(dot3),
	.neg1(neg1),
	.neg2(neg2),
	.neg3(neg3),
	.sel(display_sel),
	.debugger(debugger),
	.CON(CONs),
	.SEL(SMGs)
);

endmodule
