`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:59 06/14/2017 
// Design Name: 
// Module Name:    fp_adder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FP_Adder 
	#(
		parameter FP_SIZE = 32,
		parameter FRAC_SIZE = 23,
		parameter EXP_SIZE = 8
	)
	(
		input clk,
		input rst,
		input enable,
		input[FP_SIZE-1:0]  N1,
		input[FP_SIZE-1:0]  N2,
		input wire valid,
		output reg[FP_SIZE-1:0] result
	);


	wire [FRAC_SIZE:0] stg1_significand_1;
	wire [FRAC_SIZE:0] stg1_significand_2;
	wire [(FP_SIZE-FRAC_SIZE-1)-1:0] stg1_exponent_1;
	wire [(FP_SIZE-FRAC_SIZE-1)-1:0] stg1_exponent_2;
	wire [(FP_SIZE-FRAC_SIZE-1)-1:0] stg1_exponent_difference;
	wire stg1_sign_bit;
	wire [FP_SIZE-1:0] stg1_num_1;
	wire [FP_SIZE-1:0] stg1_num_2;
	reg [FP_SIZE-1:0] c_N1;
	reg [FP_SIZE-1:0] c_N2;
	wire[FRAC_SIZE:0] stg2_result_significand;
	wire stg2_carryout;
	
	wire [FP_SIZE-1:0] stg3_result;
	wire stg3_zero;
	
	
	//********REGSITER_BANK_WIRES**************************
	
	//***REGSITER BANK 1************************
		wire [23:0] rb11_out;	//significand_1 register bank 1
		wire [23:0] rb12_out;	//significand_2 register bank 1
		wire [7:0] 	rb13_out;	//exponent_1 register bank 1	
		wire [7:0] 	rb14_out;	//exponent_2 register bank 1 ----> DO NOT NEED-->REMOVE LATER
		wire [7:0] 	rb15_out;	//exponent_difference register bank 1
		wire [31:0] rb16_out;	//num_1 register bank 1
		wire [31:0] rb17_out;	//num_2 register bank
		wire 			rb18_out;	//sign_bit register bank 1
	//***REGSITER BANK 2************************
		wire [31:0] rb21_out; 	//num_1 register bank 2
		wire [31:0] rb22_out;	//num_2 register bank 2
		wire [23:0] rb23_out;	//result_significand stg2 register bank 2
		wire 			rb24_out;	//sign bit register bank 2
		wire 			rb25_out;	//carryout bit register bank 2
		wire [7:0] rb26_out;		//exponent_1 register bank 2	
	//***REGSITER BANK 3************************
		wire [31:0] rb31_out;	//FP_ADDER result register bank 3
		wire 			rb32_out;	//FP_ADDER ZERO BIT register bank 3
	
	//*******STAGE_1_INSTANTIATION***************
	always@(*) begin
		if(valid) begin
			c_N1 = N1;
			c_N2 = N2;
		end else begin
			c_N1='d0;
			c_N2='d0;
		end
	end
	fp_adder_stage1 #(FP_SIZE,FRAC_SIZE) stage_1 
		(
		.N1(c_N1),
		.N2(c_N2),
		.significand_1(stg1_significand_1),
		.shifted_significand_2(stg1_significand_2),
		.exponent_1(stg1_exponent_1),
		.exponent_2(stg1_exponent_2),
		.exponent_difference(stg1_exponent_difference),
		.sign_bit(stg1_sign_bit),
		.num_1(stg1_num_1),
		.num_2(stg1_num_2)
    );
	 
	//significand_1 register bank 1
	gen_register #24 rb11 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_significand_1),
									.data_out(rb11_out));
	//significand_2 register bank 1
	gen_register #24 rb12 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_significand_2),
									.data_out(rb12_out));
	//exponent_1 register bank 1						
	gen_register #8 rb13 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_exponent_1),
									.data_out(rb13_out));
	
	//exponent_2 register bank 1
	gen_register #8 rb14 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_exponent_2),
									.data_out(rb14_out));
									
	//exponent_difference register bank 1
	gen_register #8 rb15 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_exponent_difference),
									.data_out(rb15_out));
	
	//num_1 register bank 1
	gen_register #32 rb16 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_num_1),
									.data_out(rb16_out));
	
	//num_2 register bank 1
	gen_register #32 rb17 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_num_2),
									.data_out(rb17_out));
	
	//sign_bit register bank 1
	gen_register #1 rb18 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg1_sign_bit),
									.data_out(rb18_out));
									
	
	//*******STAGE_2_INSTANTIATION***************
	 fp_adder_stage2 #(FP_SIZE,FRAC_SIZE) stage_2
	 (
	 .num_1(rb16_out),
		.num_2(rb17_out),
		.exponent_1(rb13_out),
		.exponent_2(rb14_out),
		.significand_1(rb11_out),
		.significand_2(rb12_out),
		.result_significand(stg2_result_significand),
		.carryout(stg2_carryout));
		
	//num_1 register bank 2
	gen_register #32 rb21 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(rb16_out),
									.data_out(rb21_out));
	//num_2 register bank 2
	gen_register #32 rb22 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(rb17_out),
									.data_out(rb22_out));
	
	//result_significand stg2 register bank 2
	gen_register #24 rb23 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg2_result_significand),
									.data_out(rb23_out));
									
	//sign bit register bank 2
	gen_register #1 rb24 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(rb18_out),
									.data_out(rb24_out));
									
	//carryout bit register bank 2
	gen_register #1 rb25 (.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg2_carryout),
									.data_out(rb25_out));
									
	//exponent_1 register bank 2
	gen_register #8 rb26(.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(rb13_out),
									.data_out(rb26_out));
									

	fp_adder_stage3 #(FP_SIZE,FRAC_SIZE) stage3
	(
		.num_1(rb21_out),
		.num_2(rb22_out),
		.carryout(rb25_out),
		.sign_bit(rb24_out),
		.exponent_1(rb26_out),
		.significand(rb23_out),
		.result(stg3_result),
		.zero(stg3_zero)
    );
	 
	gen_register #32 rb31(.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg3_result),
									.data_out(rb31_out));
	gen_register #1 rb32(.clk(clk),
									.rst(rst),
									.write_en(enable),
									.data_in(stg3_zero),
									.data_out(rb32_out));
	
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			result<='d0;
		end else begin
			result<=rb31_out;
		end
	end
endmodule 