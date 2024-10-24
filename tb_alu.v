`timescale 1ns / 1ps
module tb_alu;

	// Inputs
	reg [31:0] rega;
	reg [31:0] regb;
	reg [3:0] alu_ctrl_s;

	// Outputs
	wire [31:0] result;
	wire [2:0] flags;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.rega(rega), 
		.regb(regb), 
		.alu_ctrl_s(alu_ctrl_s), 
		.result(result), 
		.flags(flags)
	);

	initial begin
		// Initialize Inputs
		rega = 5;
		regb = 3;
		alu_ctrl_s = 0;
        repeat(14)
		#100 alu_ctrl_s = alu_ctrl_s + 1;
	end

    initial begin
        #5000 $stop;
end
      
endmodule

