`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:02:50 06/14/2017 
// Design Name: 
// Module Name:    fp_adder_stage1 
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
module fp_adder_stage1#(parameter FP_SIZE = 32,parameter FRAC_SIZE = 23)
		(
		N1,
		N2,
		significand_1,
		shifted_significand_2,
		exponent_1,
		exponent_2,
		exponent_difference,
		sign_bit,
		num_1,
		num_2
    );
	input wire [FP_SIZE-1:0] N1;
	input wire [FP_SIZE-1:0] N2;
	output reg [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_1;
	output reg [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_2;
	output reg [(FP_SIZE-FRAC_SIZE-1)-1:0] exponent_difference;
	output reg [FRAC_SIZE:0] significand_1;
	output reg [FRAC_SIZE:0] shifted_significand_2;
	output reg sign_bit;
	output reg [FP_SIZE-1:0] num_1; //register to store values of the number 1 after they have been received
	output reg [FP_SIZE-1:0] num_2; //register to store values of the number 2 after they have been received
	reg [FRAC_SIZE:0] significand_2;
	 
	 always@(*)begin
		//num_1='d0;
		//num_2='d0;
		significand_2='d0;
		if (N2[30:23] > N1[30:23]) begin
			num_1=N2;
			num_2=N1;
		end else begin
			num_1=N1;
			num_2=N2;
		end
		
		exponent_1 = num_1[30:23];
		exponent_2 = num_2[30:23];
		
		significand_1[22:0]=num_1[22:0];
		significand_2[22:0]=num_2[22:0];
		if (exponent_1 == 'd0) begin
			significand_1[23] = 1'b0;
		end else begin
			significand_1[23] = 1'b1;
		end
		
		if (exponent_2 == 'd0) begin
			significand_2[23] = 1'b0;
		end else begin
			significand_2[23] = 1'b1;
		end

		exponent_difference = $signed(exponent_1) - $signed(exponent_2);
		
		if(exponent_difference[7]==1'b1)begin
			exponent_difference=~exponent_difference;
			exponent_difference=exponent_difference+8'b00000001;
		end
		
		shifted_significand_2 = significand_2 >> exponent_difference;
		
		if (shifted_significand_2>significand_1) begin
			sign_bit=num_2[FP_SIZE-1];
		end else begin
			sign_bit=num_1[FP_SIZE-1];
		end

		if (num_1[FP_SIZE-1] != num_2[FP_SIZE-1]) begin
			shifted_significand_2 = ~ shifted_significand_2;
			shifted_significand_2 = shifted_significand_2 + 'd1;
		end
	 end
endmodule
