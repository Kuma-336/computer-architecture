
module ALU (
	input wire [31:0] rega,		//datain_a
	input wire [31:0] regb, 	//datain_b
	input wire [3:0] alu_ctrl_s,  // operation

	output reg [31:0] result,  // calculation result
	output reg [2:0] flags	// zero, negative, overflow
	);

parameter 
	ALU_ADD    = 4'd0,
	ALU_ADDU	= 4'd1,
	ALU_SUB    = 4'd2,
	ALU_SUBU 	= 4'd3,
	ALU_AND    = 4'd4,
	ALU_NOR		= 4'd5,
	ALU_OR		= 4'd6,
	ALU_XOR		= 4'd7,
	ALU_SLL		= 4'd8,
	ALU_SLLV	= 4'd9,
	ALU_SRL		= 4'd10,
	ALU_SRLV	= 4'd11,
	ALU_SRA		= 4'd12,
	ALU_SRAV	= 4'd13,
	ALU_SLT		= 4'd14;

reg[31:0] temp;
wire [2:0] overflow_test;
assign overflow_test = {rega[31],regb[31],result[31]};

	always @(*) begin
		result = 0;
		flags = 0;
		if(alu_ctrl_s == ALU_ADD) begin
			result = rega + regb;
			if(overflow_test == 6 || overflow_test == 1)
				flags[0] = 1;
			else 
				flags[0] = 0;
		end 
		else if(alu_ctrl_s == ALU_ADDU) begin
			result = rega + regb;
		end
		else if(alu_ctrl_s == ALU_SUB) begin
			result = rega - regb;
			if(overflow_test == 4 || overflow_test == 3)
				flags[0] = 1;
			else
				flags[0] = 0;
		end
		else if(alu_ctrl_s == ALU_SUBU) begin
			result = rega - regb;
		end
		else if(alu_ctrl_s == ALU_AND) begin
			result = rega & regb;
		end
		else if(alu_ctrl_s == ALU_NOR) begin
			result = ~(rega | regb);
		end
		else if(alu_ctrl_s == ALU_OR) begin
			result = rega | regb;
		end
		else if(alu_ctrl_s == ALU_XOR) begin
			result = rega ^ regb;
		end
		else if(alu_ctrl_s == ALU_SLL) begin
			result = regb << rega;
		end
		else if(alu_ctrl_s == ALU_SLLV) begin
			result = regb << rega[3:0];
		end
		else if(alu_ctrl_s == ALU_SRL) begin
			result = regb >> rega;
		end
		else if(alu_ctrl_s == ALU_SRLV) begin
			result = regb >> rega[3:0];
		end
		else if(alu_ctrl_s == ALU_SRA) begin
			result = $signed(regb) >>> rega; 
		end
		else if(alu_ctrl_s == ALU_SRAV) begin
			result = $signed(regb) >>> rega[3:0];
		end
		else if(alu_ctrl_s == ALU_SLT) begin
			temp = rega - regb;
			flags[1] = temp[31];
			result = temp[31];
		end

	end
	
endmodule
