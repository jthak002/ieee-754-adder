# Implementation of IEEE 754 FP Adder on FPGA Board
## URL:http://ieeexplore.ieee.org/document/564761/
### Instructions
Verilog code is present in the 'src' folder. To simulate the code add it the Xilinx ISE Design Suite project using the 'Add copy of source'  option and then synthesize the code using the 'Synthsize-XST' option under the processes tab.

Once the Synthesize process is completed, switch to simulation and run the 'Behavorial Check Syntax' and execute the 'Simulate Behavorial Model' to see the outputs of the `fp_adder_testbench`.

### Modifying and Adding the test cases
Additional test cases can be added to the test bench by more instances of the test case blocks:
``` //Test block <N>
N1= 32'b01000001110010100000000000000000;
N2= 32'b00000000000000000000000000000000;
R = 32'b01000001110010100000000000000000;
#200;
$display (" TC 03 ....... %b %b ", R,  result ); 
		if ( R != result ) $display ("Failed TC <N> ....... %h %h ", R,  result );
```

Replace the values of `N1`, `N2` with the values of the 2 addends and `R` with the value of result. add this code block to `fp_adder_testbench`. 
