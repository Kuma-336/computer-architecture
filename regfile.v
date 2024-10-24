module regfile(
	input  clk,
	input  [4:0] ch1,
	output  [31:0] data1,
	input  [4:0] ch2,
	output  [31:0] data2,
	input  en3,
	input  [4:0] ch3,
	input  [31:0] data3
   );
	//updata reg
	reg [31:0] regfile[1:31];
	
	always @(negedge clk) begin
		if (ch3 > 0 & en3 == 1) begin
			regfile[ch3] <= data3;
		end
	end
	
	assign data1 = (ch1 == 0) ? 0 : regfile[ch1];
	assign data2 = (ch2 == 0) ? 0 : regfile[ch2];

endmodule
