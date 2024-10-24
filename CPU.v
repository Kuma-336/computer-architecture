`include "ctrl_alu.v"
`include "alu.v"
`include "parsing_inst.v"
`include "InstructionRAM.v"
`include "MainMemory.v"
`include "regfile.v"
module CPU(
	input clk,
	input rst
   );
	wire [31:0] pc_cycle,instr_data,mem_data_rd,write_data,alu_dout;
	wire is_display;			
	wire write_mem;			
	wire mem_en;			
//read instruction from bin,FETCH_ADDRESS + 1,transmit instruction to ctrl_alu
	InstructionRAM instruction_RAM(
		.CLOCK(clk),
		.FETCH_ADDRESS(pc_cycle >> 2),
		.ENABLE(1'b1),
		.DATA(instr_data)
	);
/*parse mips instruction ,then transmit to alu ,output correct result*/
	ctrl_alu alu(
    .clk					(clk),
    .rst					(rst),
	.instruction			(instr_data),
    .mem_data_rd			(mem_data_rd),
			
    .is_display				(is_display),
	.write_data				(write_data),
    .write_mem				(write_mem),
	.alu_dout				(alu_dout),
	.mem_en					(mem_en),
    .pc_cycle				(pc_cycle)
	);
	
	MainMemory main_memory(
		.CLOCK(clk),
		.ENABLE(mem_en),
		.FETCH_ADDRESS(alu_dout>>2),
		.EDIT_SERIAL({write_mem,alu_dout>>2,write_data}),
		.IS_DISPLAY(is_display),									//finish flag then write data.bin
		.DATA(mem_data_rd)
	);
endmodule
