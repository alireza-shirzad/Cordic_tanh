module cordic_tb();
	/// parameters
	parameter num_of_tests = 1000;
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	///
	parameter period = 10;
	localparam cycle = period/2;
	parameter latency = 2*word_SZ*period;
	localparam sim_duration = num_of_tests*period + latency;
	// DUT assigning 
	reg clk;
	reg [word_SZ-1:0] angle;
	wire [word_SZ-1:0] out;
	cordic cor(.angle(angle),.out(out),.clk(clk));
	// Integer Declaration
integer op, op_out, k;
	// File handling 

	initial
	begin
	$dispaly("Cordic tanh simulation started");
	op=$fopen ("test.txt","r");
	op_out=$fopen ("test_result.txt","w");
	end
	
	always @(posedge clk) k <= $fscanf (op, "%b \n", angle);
	always @(posedge clk) $fwrite (op_out,"%b \n",out);
	
	// clock generator
	always
	begin
		clk = 0; #cycle; clk = 1; #cycle;
	end
	
initial #sim_duration $stop;
initial #sim_duration $finish;
endmodule