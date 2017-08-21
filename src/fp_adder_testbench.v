`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:02:29 06/15/2017
// Design Name:   FP_Adder
// Module Name:   /home/jeet/Desktop/lab8/fp_adder/fp_adder_testbench.v
// Project Name:  fp_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FP_Adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fp_adder_testbench;

	// Inputs
	reg clk;
	reg rst;
	reg enable;
	reg [31:0] N1;
	reg [31:0] N2;
	reg valid;
	// Outputs
	wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	FP_Adder uut (
		.clk(clk), 
		.rst(rst), 
		.enable(enable), 
		.N1(N1), 
		.N2(N2), 
		.valid(valid), 
		.result(result)
	);
	
	reg [31:0] R;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		enable = 0;
		N1 = 0;
		N2 = 0;
		valid=0;
		// Add stimulus here
		forever begin 
		enable=1'b1;
		valid=1;
		clk = ~clk;
		#20;
		
		end 
	end

initial begin
				
		N1=32'b00000000000000000000000000000000;
		N2=32'b00000000000000000000000000000000;
		R=32'b00000000000000000000000000000000;
#200;
$display (" TC 01 ....... %h %h ", R,  result ); 
		if ( R != result ) $display ("Failed TC 1 ....... %h %h ", R,  result ); 

//25.25+ -25.25 			
		N1= 32'b01000001110010100000000000000000;
		N2= 32'b11000001110010100000000000000000;
		R= 32'b00000000000000000000000000000000;
#200;
$display (" TC 02 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 2 ....... %h %h ", R,  result ); 

//25.25+0.0 			
		N1= 32'b01000001110010100000000000000000;
		N2= 32'b00000000000000000000000000000000;
		R = 32'b01000001110010100000000000000000;
#200;
$display (" TC 03 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 3 ....... %h %h ", R,  result ); 
		
		

//1.0000008 + (-1.0000009)  		
		N1= 32'b0_01101010_10101101011111110010101;
		N2= 32'b1_01101010_11100011001011110000111;
		R = 32'b1_01100111_10101101011111110010000;
#200;
$display (" TC 04 ....... %b %b ", R,  result );
		if ( R != result ) $display ("Failed TC 4 ....... %h %h ", R,  result );

//25.25+25.25 			
		N1= 32'b01000001110010100000000000000000;
		N2= 32'b01000001110010100000000000000000;
		R = 32'b01000010010010100000000000000000;
#200;
$display (" TC 04 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 4 ....... %h %h ", R,  result );
			

//-25.2259+(-18.8767) 			
		N1= 32'b11000001110010011100111010100101;
		N2= 32'b11000001100101110000001101111011;
		R = 32'b11000010001100000110100100010000;
#200;
$display (" TC 05 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 5 ....... %h %h ", R,  result );
		

//9.022E8+(9.022E-8) 			
		N1= 32'b01001110010101110001100111101011;
		N2= 32'b00110011110000011011111011111000;
		R = 32'b01001110010101110001100111101011;
#200;
$display (" TC 06 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 6 ....... %h %h ", R,  result );
//1.5+1.5 -->MANTISSA ADDIITON OVERFLOW CASE  			
		N1= 32'b00111111110000000000000000000000;
		N2= 32'b00111111110000000000000000000000;
		R = 32'b01000000010000000000000000000000;
#200;
$display (" TC 07 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC 7 ....... %h %h ", R,  result );
	end   
endmodule

