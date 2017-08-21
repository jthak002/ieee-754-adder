`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:20:54 06/15/2017 
// Design Name: 
// Module Name:    fp_adder_stage3 
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
module fp_adder_stage3#(parameter FP_SIZE = 32,parameter FRAC_SIZE = 23)
(
		num_1,
		num_2,
		carryout,
		sign_bit,
		exponent_1,
		significand,
		result,
		zero
    );
	input wire [FP_SIZE-1:0] num_1;
	input wire [FP_SIZE-1:0] num_2;
	output reg [FP_SIZE-1:0] result;
	input wire [FRAC_SIZE:0] significand;
	input wire [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_1;
	input wire carryout;
	input wire sign_bit;
	output reg zero;
	integer i; 
	reg [FRAC_SIZE:0] c_significand;
	reg [(FP_SIZE-FRAC_SIZE-1)-1:0] left_shift;
	reg [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent;
	always@(*) begin
		zero=1'b1; //The zero bit enabled by default--> if the 24th bit in the significand cannot 
						//be set to 1 by repeated left shift, then the number is a zero
		left_shift='d0;
		exponent='d0;
		c_significand=significand;
		
		if ((num_1[FP_SIZE-1]==num_2[FP_SIZE-1]) && carryout==1'b1) begin
			c_significand=c_significand>>1;
			c_significand[FRAC_SIZE]=1'b1;
			left_shift=-'d1;
			zero=1'b0;
		end else begin
			for(i=0;i<=24;i=i+1) begin
				if(c_significand[FRAC_SIZE]!=1'b1) begin 
					c_significand=c_significand<<1;
					left_shift=left_shift+'d1;
				end else begin
					zero=1'b0;
				end
			end
		end
		
		c_significand[FRAC_SIZE]=sign_bit; //THIS LOGIC IS IMPLEMENTED IN fp_adder_stage1
														//USING UNSIGED SIGNIFICANDS FOR COMPARISION
		if (zero) begin
			exponent='d0;
		end else begin 
			exponent=exponent_1-left_shift;
		end
		
		if (zero) begin
			result='d0;
		end else begin
			result={c_significand[FRAC_SIZE],exponent,c_significand[FRAC_SIZE-1:0]};
		end
	end
endmodule

