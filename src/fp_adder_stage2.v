`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:59 06/15/2017 
// Design Name: 
// Module Name:    fp_adder_stage2 
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
module fp_adder_stage2#(parameter FP_SIZE = 32,parameter FRAC_SIZE = 23)
(
	num_1,
	num_2,
	exponent_1,
	exponent_2,
	significand_1,
	significand_2,
	result_significand,
	carryout);
	
	input wire [FP_SIZE-1:0] num_1;
	input wire [FP_SIZE-1:0] num_2;
	input wire [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_1;
	input wire [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_2;
	input wire [FRAC_SIZE:0] significand_1;
	input wire [FRAC_SIZE:0] significand_2;
	output reg [FRAC_SIZE:0] result_significand;
	output reg carryout;
	
	always@(*) begin
		carryout='d0;
		{carryout,result_significand} = {1'b0, significand_1} + {1'b0, significand_2};
		
		if((num_1[FP_SIZE-1] != num_2[FP_SIZE-1]) && result_significand[FRAC_SIZE]==1'b1 && carryout==1'b0) begin
			result_significand=~result_significand;
			result_significand=result_significand+24'd1;
		end
	end
endmodule
