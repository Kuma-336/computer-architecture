module ctrl_alu(
    input[31:0] instruction,
    input  [31:0] mem_data_rd,
    input clk,
    input rst,

    output reg is_display,
	output reg [31:0] write_data,
    output reg write_mem,
	output reg [31:0] alu_dout,
	output reg mem_en,
    output [31:0] pc_cycle
    );

parameter   PC_0   = 0;
parameter 	PC_1    = 1;
parameter 	PC_2      = 2;
parameter 	PC_3   = 3;

parameter ADDR_RD_0    = 0;
parameter 	ADDR_RT_1    = 1;
parameter 	ADDR_LINK_2  = 2;

parameter 	A_RS_0     = 0;
parameter 	A_SA_1     = 1;
parameter 	A_LINK_2   = 2;

parameter 	B_RT_0     = 0;
parameter 	B_IMM_1    = 1;
parameter 	B_LINK_2   = 2;


	wire [31:0] pc_cycle_add4;
	wire en_f;
	wire en_reg;
	wire rst_reg;
	
	reg [31:0] pc_cycle_reg;
	reg [31:0] instruction_reg;
	reg [31:0] pc_cycle_reg0;
	reg [31:0] pc_cycle_add4_reg;
	wire equal;
	wire reg_write_reg;
	wire mem_to_reg_reg;
	wire mem_write_reg;
	wire mem_used_reg;
	wire is_display_reg;
	wire [3:0] ALU_control_reg;
	wire [1:0] ALU_src_A_reg;
	wire [1:0] ALU_src_B_reg;	
	wire [1:0] reg_dst_reg;
	wire ext_sign_reg;
	wire is_load_reg;
	wire [1:0] pc_src_reg;
	wire [1:0] forward_a_reg;
	wire [1:0] forward_b_reg;
	wire forward_m_reg;
 	
	wire [31:0] rd1_reg;
	wire [31:0] rd2_reg;
	wire [31:0] ext_imm;
	wire [31:0] ext_shamt_reg;
	reg [31:0] rd1_fwding;
	reg [31:0] rd2_fwding;

	wire rst_reg0;
	
	reg reg_write_reg0;
	reg mem_to_reg_reg0;
	reg mem_write_reg0;
	reg mem_used_reg0;
	reg [3:0] ALU_control_reg0;
	reg [1:0] ALU_src_A_reg0;
	reg [1:0] ALU_src_B_reg0;
	reg [1:0] reg_dst_reg0;
	reg [31:0] rd1_reg0;
	reg [31:0] rd2_reg0;
	reg [4:0] rt_reg0;
	reg [4:0] rd_reg0;
	reg [31:0] ext_imm_reg;
	reg [31:0] ext_shamt_reg0;
	reg [31:0] src_A_reg0;
	reg [31:0] src_B_reg0;
	reg [4:0] write_reg_reg0;
	reg is_load_reg0;
	reg [1:0] forward_a_reg0;
	reg [1:0] forward_b_reg0;
	reg forward_m_reg0;
	reg [31:0] pc_plus4_reg0;
	reg is_display_reg0;
	wire [31:0] write_data_reg0;	
	wire [31:0] ALU_out_reg0;
	wire [2:0] flags;
	reg reg_write_m;
	reg mem_to_reg_m;
	reg zero_m;
	reg [4:0] write_reg_m;
	reg is_load_m;
	reg forward_m_m;

	reg reg_write_f;
	reg mem_to_reg_w;
	reg [31:0] ALU_out_w;
	reg [31:0] read_regata_w;
	reg [4:0] write_reg_w;
	wire [31:0] result_f;
	integer file_out;

	always @(posedge clk) begin
		if (rst) begin
			pc_cycle_reg <= 32'b0;
		end
		else if (en_f) begin
			case (pc_src_reg)
				PC_0: pc_cycle_reg <= pc_cycle_add4;
				PC_1: pc_cycle_reg <= {pc_cycle_reg0[31:28], instruction_reg[25:0], 2'b0};
				PC_2: pc_cycle_reg <= rd1_fwding;
				PC_3: pc_cycle_reg <= pc_cycle_add4_reg + {ext_imm[29:0], 2'b0};
			endcase
		end
	end
	
    assign pc_cycle = pc_cycle_reg;
	assign pc_cycle_add4 = pc_cycle + 4;
	
	always @(posedge clk) begin
		if (rst_reg) begin
			instruction_reg <= 0;
			pc_cycle_reg0 <= 0;
			pc_cycle_add4_reg <= 0;
		end
		else if (en_reg) begin
			instruction_reg <= instruction;
			pc_cycle_reg0 <= pc_cycle;
			pc_cycle_add4_reg <= pc_cycle_add4;
		end
	end

	
	assign ext_imm = (ext_sign_reg == 0) ? {16'b0,instruction_reg[15:0]} : {{16{instruction_reg[15]}},instruction_reg[15:0]};
	assign ext_shamt_reg = {27'b0,instruction_reg[10:6]};
	
	always @(*) begin
		rd1_fwding = rd1_reg;
		rd2_fwding = rd2_reg;
		case (forward_a_reg)
			0: rd1_fwding = rd1_reg;
			1: rd1_fwding = ALU_out_reg0;
			2: rd1_fwding = alu_dout;
			3: rd1_fwding = mem_data_rd;
		endcase
		case (forward_b_reg)
			0: rd2_fwding = rd2_reg;
			1: rd2_fwding = ALU_out_reg0;
			2: rd2_fwding = alu_dout;
			3: rd2_fwding = mem_data_rd;
		endcase
	end
	
	assign equal = (rd1_fwding == rd2_fwding) ? 1 : 0;

	always @(posedge clk) begin	
		if (rst_reg0) begin
			reg_write_reg0 <= 0;
			is_load_reg0 <= 0;
			mem_to_reg_reg0 <= 0;
			mem_write_reg0 <= 0;
			mem_used_reg0 <= 0;
			is_display_reg0 <= 0;
			ALU_control_reg0 <= 0;
			ALU_src_A_reg0 <= 0;
			ALU_src_B_reg0 <= 0;
			reg_dst_reg0 <= 0;
			rd1_reg0 <= 0;
			rd2_reg0 <= 0;
			ext_imm_reg <= 0;
			ext_shamt_reg0 <= 0;
			rt_reg0 <= 0;
			rd_reg0 <= 0;
			forward_a_reg0 <= 0;
			forward_b_reg0 <= 0;
			forward_m_reg0 <= 0;
			pc_plus4_reg0 <= 0;
		end
		else begin
			reg_write_reg0 <= reg_write_reg;
			is_load_reg0 <= is_load_reg;
			mem_to_reg_reg0 <= mem_to_reg_reg;
			mem_write_reg0 <= mem_write_reg;
			mem_used_reg0 <= mem_used_reg;
			ALU_control_reg0 <= ALU_control_reg;
			ALU_src_A_reg0 <= ALU_src_A_reg;
			ALU_src_B_reg0 <= ALU_src_B_reg;
			reg_dst_reg0 <= reg_dst_reg;
			rd1_reg0 <= rd1_fwding;
			rd2_reg0 <= rd2_fwding;
			ext_imm_reg <= ext_imm;
			ext_shamt_reg0 <= ext_shamt_reg;
			rt_reg0 <= instruction_reg[20:16];
			rd_reg0 <= instruction_reg[15:11];
			forward_a_reg0 <= forward_a_reg;
			forward_b_reg0 <= forward_b_reg;
			forward_m_reg0 <= forward_m_reg;
			pc_plus4_reg0 <= pc_cycle_add4_reg;
			is_display_reg0 <= is_display_reg;
		end
	end
	
	always @ (*) begin
		case (ALU_src_A_reg0)
			A_RS_0: src_A_reg0 = rd1_reg0;
			A_SA_1: src_A_reg0 = ext_shamt_reg0;
			A_LINK_2: src_A_reg0 = pc_plus4_reg0;
		endcase
		case (ALU_src_B_reg0)
			B_RT_0: src_B_reg0 = rd2_reg0;
			B_IMM_1: src_B_reg0 = ext_imm_reg;
			B_LINK_2: src_B_reg0 = 32'b0;
		endcase
		case (reg_dst_reg0)
			ADDR_RT_1: write_reg_reg0 = rt_reg0;
			ADDR_RD_0: write_reg_reg0 = rd_reg0;
			ADDR_LINK_2: write_reg_reg0 = 31;
		endcase
	end
	
	assign write_data_reg0 = rd2_reg0;
    	always @(posedge clk) begin	
		reg_write_m <= reg_write_reg0;
		mem_to_reg_m <= mem_to_reg_reg0;
		write_mem <= mem_write_reg0;
		mem_en <= mem_used_reg0;
		is_display <= is_display_reg0;
		zero_m <= flags[2];
		alu_dout <= ALU_out_reg0;
		write_reg_m <= write_reg_reg0;
		is_load_m <= is_load_reg0;
		forward_m_m <= forward_m_reg0;
		write_data <= forward_m_m ? result_f : write_data_reg0;
	end
	
	always @(posedge clk) begin
		reg_write_f <= reg_write_m;
		mem_to_reg_w <= mem_to_reg_m;
		ALU_out_w <= alu_dout;
		read_regata_w <= mem_data_rd;
		write_reg_w <= write_reg_m;
	end
	
	assign result_f = (mem_to_reg_w == 0) ? ALU_out_w : read_regata_w;
	 
	ALU alu(
		.rega(src_A_reg0),
		.regb(src_B_reg0),
		.alu_ctrl_s(ALU_control_reg0),
		.result(ALU_out_reg0),
		.flags(flags)
	);

	parsing_inst inst_parsing_inst(
		.opcode(instruction_reg[31:26]),
		.addr_rs(instruction_reg[25:21]),
		.addr_rt(instruction_reg[20:16]),
		.funct(instruction_reg[5:0]),
		.equal(equal),
		.write_reg_reg0(write_reg_reg0),
		.reg_write_reg0(reg_write_reg0),
		.is_load_reg0(is_load_reg0),
		.write_reg_m(write_reg_m),
		.reg_write_m(reg_write_m),
		.is_load_m(is_load_m),
		.reg_wr_en(reg_write_reg),
		.mem_or_reg(mem_to_reg_reg),
		.mem_write(mem_write_reg),
		.mem_used(mem_used_reg),
		.pc_src(pc_src_reg),
		.alu_ctrl_inst(ALU_control_reg),
		.src_A(ALU_src_A_reg),
		.src_B(ALU_src_B_reg),
		.reg_d0(reg_dst_reg),
		.ext_sign_num(ext_sign_reg),
		.is_load_en(is_load_reg),
		.forward_a(forward_a_reg),
		.forward_b(forward_b_reg),
		.forward_m(forward_m_reg),
		.en_f(en_f),
		.en_reg(en_reg),
		.rst_reg(rst_reg),
		.rst_reg0(rst_reg0),
		.is_display(is_display_reg)
	);
	
	regfile inst_regfile(
		.clk(clk),
		.ch1(instruction_reg[25:21]),
		.ch2(instruction_reg[20:16]),
		.ch3(write_reg_w),
		.data1(rd1_reg),
		.data2(rd2_reg),
		.data3(result_f),
		.en3(reg_write_f)
	);



endmodule
