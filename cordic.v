module cordic(angle,out,clk);
	/// parameters
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	/// input declaration
	input signed [word_SZ-1:0] angle;
	input clk;
	// output declaration
	output signed [word_SZ-1:0] out;
	// wires
	wire signed [word_SZ-1:0] x;
	wire signed [word_SZ-1:0] y;

	Cordic_hyp cordic_hyp(angle, clk, x, y);
	CORDIC_Div cordic_div(y, x, clk, out);

endmodule

module Cordic_hyp (z_in, clk, x_out, y_out);
	/// parameters
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	localparam num_OfStage = frac_SZ;
	/// input declaration
	input signed [word_SZ-1:0] z_in;
	input clk;
	/// output declaration
	output signed [word_SZ-1:0] x_out;
	output signed [word_SZ-1:0] y_out;
	/// generate structure to pipeline the design
	wire [word_SZ-1:0] x_stage_Out [num_OfStage-1:0];
	wire [word_SZ-1:0] y_stage_Out [num_OfStage-1:0];
	wire [word_SZ-1:0] z_stage_Out [num_OfStage-1:0];
	wire signed [word_SZ-1:0] x_in;
	wire signed [word_SZ-1:0] y_in;
	assign y_in = 0;
	assign x_in = 18'b010011010100011111;
	
	wire signed [31:0] atan_table [0:30];
   
   assign atan_table[00] = 18'b001000110010011111;
   assign atan_table[01] = 18'b000100000101100011;
   assign atan_table[02] = 18'b000010000000101011;
   assign atan_table[03] = 18'b000001000000000101; 
   assign atan_table[04] = 18'b000000100000000001;
   assign atan_table[05] = 18'b000000010000000000;
   assign atan_table[06] = 18'b000000001000000000;
   assign atan_table[07] = 18'b000000000100000000;
   assign atan_table[08] = 18'b000000000010000000;
   assign atan_table[09] = 18'b000000000001000000;
   assign atan_table[10] = 18'b000000000000100000;
   assign atan_table[11] = 18'b000000000000010000;
   assign atan_table[12] = 18'b000000000000001000;
   assign atan_table[13] = 18'b000000000000000100;
   assign atan_table[14] = 18'b000000000000000010;
   assign atan_table[15] = 18'b000000000000000001;
   assign atan_table[16] = 18'b000000000000000001;
   assign atan_table[17] = 18'b000000000000000000;
	
	
	// Initializing first stage
	Cordic_SubSection subCore(x_in,y_in,z_in,atan_table[0],clk,x_stage_Out[0],y_stage_Out[0],z_stage_Out[0]);
	defparam subCore.word_SZ = word_SZ, subCore.stage = 0, subCore.frac_SZ = frac_SZ;
	// Pipelining the stages
	genvar i;
   generate
		for (i=1; i < (num_OfStage); i=i+1)
		begin: XYZ
			Cordic_SubSection subCore(x_stage_Out[i-1],y_stage_Out[i-1],z_stage_Out[i-1],atan_table[i],clk,x_stage_Out[i],y_stage_Out[i],z_stage_Out[i]);
			defparam subCore.word_SZ = word_SZ, subCore.stage = i, subCore.frac_SZ = frac_SZ;
		end
   endgenerate
	/// Output assign
	assign x_out = x_stage_Out [num_OfStage-1];
	assign y_out = y_stage_Out [num_OfStage-1];
endmodule



module Cordic_SubSection(x_in,y_in,z_in,arcTan,clk,x_out,y_out,z_out);
	/// parameters
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	parameter stage = 0;
	// Input Output declaration
	input signed [word_SZ-1:0] y_in;
	input signed [word_SZ-1:0] x_in;
	input signed [word_SZ-1:0] z_in;
	input signed [word_SZ-1:0] arcTan;
	input clk;
	output reg signed [word_SZ-1:0] x_out;
	output reg signed [word_SZ-1:0] y_out;
	output reg signed [word_SZ-1:0] z_out;
	// Sign bit decider
	wire z_sign;
	assign z_sign = z_in[word_SZ-1];
	// shifted x calculation
	wire signed [word_SZ-1:0] x_shifted;
	wire signed [word_SZ-1:0] y_shifted;
	assign x_shifted = x_in >>> (stage+1);
	assign y_shifted = y_in >>> (stage+1);
	// shifted z calculation
	
	always @(posedge clk)
	begin
		x_out <= z_sign ? x_in - y_shifted    : x_in + y_shifted;
		y_out <= z_sign ? y_in - x_shifted    : y_in + x_shifted;
		z_out <= z_sign ? z_in + arcTan 	  : z_in - arcTan;
	end		
endmodule


module CORDIC_Div (y_in, x_in, clk, z_out);
	/// parameters
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	localparam num_OfStage = word_SZ-1;
	/// input declaration
	input signed [word_SZ-1:0] y_in;
	input signed [word_SZ-1:0] x_in;
	input clk;
	/// output declaration
	output signed [word_SZ-1:0] z_out;
	/// generate structure to pipeline the design
	wire [word_SZ-1:0] y_stage_Out [num_OfStage-1:0];
	wire [word_SZ-1:0] z_stage_Out [num_OfStage-1:0];
	wire signed [word_SZ-1:0] z_in;
	assign z_in = 0;
	// Initializing first stage
	CorDIC_Div_SubSection subDiv(x_in,y_in,z_in,clk,z_stage_Out[0],y_stage_Out[0]);
	defparam subDiv.word_SZ = word_SZ, subDiv.stage = 0, subDiv.frac_SZ = frac_SZ;
	// Pipelining the stages
	genvar i;
   generate
		for (i=1; i < (num_OfStage); i=i+1)
		begin: XYZ
			CorDIC_Div_SubSection subDiv(x_in,y_stage_Out[i-1],z_stage_Out[i-1],clk,z_stage_Out[i],y_stage_Out[i]);
			defparam subDiv.word_SZ = word_SZ, subDiv.stage = i, subDiv.frac_SZ = frac_SZ;
		end
   endgenerate
	/// Output assign
	assign z_out = z_stage_Out[num_OfStage-1];
endmodule



module CorDIC_Div_SubSection(x_in,y_in,z_in,clk,z_out,y_out);
	/// parameters
   parameter word_SZ = 18;   // width of input and output data
	parameter frac_SZ = 16;
	parameter stage = 0;
	// Input Output declaration
	input signed [word_SZ-1:0] y_in;
	input signed [word_SZ-1:0] x_in;
	input signed [word_SZ-1:0] z_in;
	input clk;
	output reg signed [word_SZ-1:0] z_out;
	output reg signed [word_SZ-1:0] y_out;
	// Sign bit decider
	wire y_sign;
	assign y_sign = y_in[word_SZ-1];
	// shifted x calculation
	wire signed [word_SZ-1:0] x_shifted;
	assign x_shifted = x_in >>> stage;
	// shifted z calculation
	localparam firstZero = stage+1;
	localparam lastZero = frac_SZ - stage;
	wire signed [word_SZ-1:0]z_shifted = {{firstZero{1'b0}},1'b1,{lastZero{1'b0}}};
	
	always @(posedge clk)
	begin
		y_out <= y_sign ? y_in + x_shifted    : y_in - x_shifted;
		z_out <= y_sign ? z_in - z_shifted 	  : z_in + z_shifted;
	end
		
endmodule
