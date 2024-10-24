module parsing_inst(
	input 		[5:0] opcode,
	input 		[4:0] addr_rs,
	input 		[4:0] addr_rt,
	input 		[5:0] funct,
	input 		equal,
	input 		[4:0] write_reg_reg0,
	input 		reg_write_reg0,
	input 		is_load_reg0,
	input 		[4:0] write_reg_m,
	input 		reg_write_m,
	input 		is_load_m,
	output 	reg	 mem_or_reg,
	output 	reg	 reg_wr_en,
	output 	reg	 mem_used,
	output 	reg	 mem_write,
	output 	reg	 [3:0] alu_ctrl_inst,
	output 	reg	 [1:0] pc_src,
	output 	reg	 [1:0] src_A,
	output 	reg	 [1:0] src_B,
	output 	reg	 [1:0] reg_d0,
	output 	reg	 is_load_en,
	output 	reg	 ext_sign_num,
	output 	reg	 [1:0] forward_a,
	output 	reg	 [1:0] forward_b,
	output 	reg	 forward_m,
	output 	reg	 en_reg,
	output 	reg	 en_f,
	output 	reg	 rst_reg,
	output 	reg	 rst_reg0,
	output 	reg	 is_display 
   );

parameter
	A_RS     = 0,
	A_SA     = 1,
	A_LINK   = 2;

parameter
	B_RT     = 0,
	B_IMM    = 1,
	B_LINK   = 2,
	B_BRANCH = 3;

//function
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

parameter
	ADDR_RD    = 0,
	ADDR_RT    = 1,
	ADDR_LINK  = 2;


parameter  // OPCODE
	INSTRUCTION_R          = 6'b000000, 
	FUNCTION_SLL      = 6'b000000,
	FUNCTION_SRL      = 6'b000010,
	FUNCTION_SRA      = 6'b000011,
	FUNCTION_SLLV     = 6'b000100,
	FUNCTION_SRLV     = 6'b000110, 
	FUNCTION_SRAV     = 6'b000111,
	FUNCTION_JR       = 6'b001000,
	FUNCTION_ADD      = 6'b100000,
	FUNCTION_ADDU     = 6'b100001,
	FUNCTION_SUB      = 6'b100010,
	FUNCTION_SUBU     = 6'b100011,
	FUNCTION_AND      = 6'b100100,
	FUNCTION_OR       = 6'b100101,
	FUNCTION_XOR      = 6'b100110,
	FUNCTION_NOR      = 6'b100111,
	FUNCTION_SLT      = 6'b101010,
	INSTRUCTION_J          = 6'b000010,
	INSTRUCTION_JAL        = 6'b000011,
	INSTRUCTION_BEQ        = 6'b000100,
	INSTRUCTION_BNE        = 6'b000101,
	INSTRUCTION_ADDI       = 6'b001000,
	INSTRUCTION_ADDIU      = 6'b001001,
	INSTRUCTION_ANDI       = 6'b001100,
	INSTRUCTION_ORI        = 6'b001101,
	INSTRUCTION_XORI       = 6'b001110,
	INSTRUCTION_LW         = 6'b100011,
	INSTRUCTION_SW         = 6'b101011,
	INSTRUCTION_STopcode       = 6'b111111;

	
	reg rs_t;
	reg link;
	reg rt_t;
	reg is_st; 
	
	always @(*) begin
		mem_write = 0;
		reg_wr_en = 0;
		mem_or_reg = 0;
		pc_src = 0;
		mem_used = 0;
		alu_ctrl_inst = ALU_ADD;
		src_A = A_RS;
		src_B = B_RT;
		reg_d0 = ADDR_RD;
		is_load_en = 0;
		ext_sign_num = 0;
		rt_t = 0;
		rs_t = 0;
		link = 0;
		is_display = 0;
		is_st = 0;

		case (opcode)
			// R 000000
			INSTRUCTION_R: begin
				case (funct)
					FUNCTION_ADD: begin
						alu_ctrl_inst = ALU_ADD;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_ADDU: begin
						alu_ctrl_inst = ALU_ADDU;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SUB: begin
						alu_ctrl_inst = ALU_SUB;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SUBU: begin
						alu_ctrl_inst = ALU_SUBU;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end				
					FUNCTION_AND: begin
						alu_ctrl_inst = ALU_AND;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_NOR: begin
						alu_ctrl_inst = ALU_NOR;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_OR: begin
						alu_ctrl_inst = ALU_OR;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_XOR: begin
						alu_ctrl_inst = ALU_XOR;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SLL: begin
						alu_ctrl_inst = ALU_SLL;
						src_A = A_SA;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SLLV: begin
						alu_ctrl_inst = ALU_SLLV;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SRL: begin
						alu_ctrl_inst = ALU_SRL;
						src_A = A_SA;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SRLV: begin
						alu_ctrl_inst = ALU_SRLV;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SRA: begin
						alu_ctrl_inst = ALU_SRA;
						src_A = A_SA;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_SRAV: begin
						alu_ctrl_inst = ALU_SRAV;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end	
					FUNCTION_SLT: begin
						alu_ctrl_inst = ALU_SLT;
						src_A = A_RS;
						src_B = B_RT;
						mem_or_reg = 0;
						reg_d0 = ADDR_RD;
						reg_wr_en = 1;
						rs_t = 1;
						rt_t = 1;
					end
					FUNCTION_JR: begin
						pc_src = 2;
						rs_t = 1;
						link = 1;
					end
				endcase
			end
			// I
			INSTRUCTION_ADDI: begin
				alu_ctrl_inst = ALU_ADD;
				src_A = A_RS;
				src_B = B_IMM;
				mem_or_reg = 0;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				rs_t = 1;
				ext_sign_num = 1;
			end
			INSTRUCTION_ADDIU: begin
				alu_ctrl_inst = ALU_ADDU;
				src_A = A_RS;
				src_B = B_IMM;
				mem_or_reg = 0;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				rs_t = 1;
				ext_sign_num = 0;
			end
			INSTRUCTION_ANDI: begin
				alu_ctrl_inst = ALU_AND;
				src_A = A_RS;
				src_B = B_IMM;
				mem_or_reg = 0;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				rs_t = 1;
				ext_sign_num = 0;
			end
			INSTRUCTION_ORI: begin
				alu_ctrl_inst = ALU_OR;
				src_A = A_RS;
				src_B = B_IMM;
				mem_or_reg = 0;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				rs_t = 1;
				ext_sign_num = 0;
			end
			INSTRUCTION_XORI: begin
				alu_ctrl_inst = ALU_XOR;
				src_A = A_RS;
				src_B = B_IMM;
				mem_or_reg = 0;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				rs_t = 1;
				ext_sign_num = 0;
			end
			INSTRUCTION_LW: begin
				alu_ctrl_inst = ALU_ADD;
				src_B = B_IMM;
				mem_or_reg = 1;
				mem_used = 1;
				reg_d0 = ADDR_RT;
				reg_wr_en = 1;
				ext_sign_num = 1;
				is_load_en = 1;
				rs_t = 1;		
			end
			INSTRUCTION_SW: begin
				alu_ctrl_inst = ALU_ADD;
				src_B = B_IMM;
				mem_write = 1;
				mem_used = 1;
				ext_sign_num = 1;
				is_st = 1;
				rs_t = 1;
				rt_t = 1;
			end
			INSTRUCTION_BEQ: begin
				if (equal) begin
					pc_src = 3;
					link = 1;
				end
				ext_sign_num = 1;
				rs_t = 1;
				rt_t = 1;
			end
			INSTRUCTION_BNE: begin
				if (~equal) begin
					pc_src = 3;
					link = 1;
				end
				ext_sign_num = 1;
				rs_t = 1;
				rt_t = 1;
			end
			// J
			INSTRUCTION_J: begin
				pc_src = 1;
				link = 1;
			end
			INSTRUCTION_JAL: begin
				pc_src = 1;
				alu_ctrl_inst = ALU_ADD;
				src_A = A_LINK;
				src_B = B_LINK;
				mem_or_reg = 0;
				reg_d0 = ADDR_LINK;
				reg_wr_en = 1;
				link = 1;
			end
			INSTRUCTION_STopcode: begin
				is_display = 1;
			end	
		endcase
	end
	
	reg reg_stall = 0;
	
	always @(*) begin
		reg_stall = 0;
		forward_a = 0;
		forward_b = 0;
		forward_m = 0;
		if (rs_t && addr_rs != 0) begin
			if (addr_rs == write_reg_reg0 && reg_write_reg0) begin
				if (is_load_reg0)
					reg_stall = 1;
				else
					forward_a = 1;
			end 
			else if (addr_rs == write_reg_m && reg_write_m) begin
				if (is_load_m)
					forward_a = 3;
				else
					forward_a = 2;
			end
		end
		if (rt_t && addr_rt != 0) begin
			if (addr_rt == write_reg_reg0 && reg_write_reg0) begin
				if (is_load_reg0) begin
					if (is_st)
						forward_m = 1;
					else 
						reg_stall = 1;
				end
				else
					forward_b = 1;
			end
			else if (addr_rt == write_reg_m && reg_write_m) begin
				if (is_load_m)
					forward_b = 3;
				else
					forward_b = 2;
			end
		end
	end
	
	always @(*) begin
		en_f = 1;
		en_reg = 1;
		rst_reg = 0;
		rst_reg0 = 0;
		if (link) begin
			rst_reg = 1;
		end
		else if (reg_stall) begin
			en_f = 0;
			en_reg = 0;
			rst_reg0 = 1;
		end
	end

endmodule
