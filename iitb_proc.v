module iitb_proc (clk, reset, proc_out,irf_out, ra_out, rb_out, out_d1_out, out_d2_out, 
						alu_proc_out, carry_out,zero_out, dm_out, wb_out, wb_addr, reg_write_data, write_enable, function_alu, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 );

input clk, reset;
wire [15:0] pc,pc_fetch,pc_decode,pc_operands_read,pc_execute;
output reg [15:0] proc_out, irf_out, out_d1_out, out_d2_out,alu_proc_out , dm_out, wb_out, 
						reg_write_data, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
output reg [2:0] ra_out,rb_out,wb_addr;
output reg carry_out, zero_out, write_enable;
output reg[4:0] function_alu;
wire [15:0] i_mem_addr;
wire [15:0]irf;
wire carry_in_wire, zero_in_wire; 

wire [2:0] RA,RB,RC,rf_writea_regf, rf_writea_exec, rf_writea_mema, rf_writea_wb;
wire [4:0]opertn, funct_reg;
wire check_c;
wire check_z;
wire check_imm;
wire do_comp; 
wire[5:0]imm_value ;
wire [15:0]rf_write_data;
wire [15:0] out_d1,out_d2;
wire [15:0] alu_out, d_mem_wrap_rd_data, d_mem_wrap_addr, wb_data,alu_out_comb, reg_0, reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7;
wire write_b_f,write_b_fm,write_b_en,wr_rd_enable;
wire c_f;
wire z_f;
wire carry_out_w, zero_out_w, mem_acs_w;
wire check_creg, check_zreg, check_compreg, bj_f;

assign i_mem_addr = reg_0;

fetch fetch_dut(clk,reset,i_mem_addr,irf,pc_fetch);

decode decode_dut(clk,irf,RA,RB,RC,opertn,check_c,check_z,do_comp,check_imm,imm_value,pc_fetch,pc_decode);

operand_read operand_read_dut(reset,clk,write_b_en,RA,RB,rf_writea_wb,rf_write_data,out_d1,out_d2,imm_value,check_imm, opertn, funct_reg,
                           RC, rf_writea_regf, wb_data, check_c,check_z,do_comp,check_creg, check_zreg, check_compreg,pc_decode,
									pc_operands_read,bj_f,alu_out_comb, reg_0, reg_1, reg_2, reg_3, reg_4, reg_5,reg_6, reg_7);
					
execute execute_dut(reset, clk, check_compreg,check_creg,check_zreg,out_d1, out_d2, 
					funct_reg, alu_out, write_b_f, carry_out_w, zero_out_w, mem_acs_w, wr_rd_enable,d_mem_wrap_addr, 
					rf_writea_regf,rf_writea_exec,pc_operands_read,pc_execute,bj_f,alu_out_comb);
		
mem_acs_stg mem_acs_stg_dut(clk,reset,d_mem_wrap_addr,mem_acs_w,wr_rd_enable,alu_out,d_mem_wrap_rd_data,write_b_f, write_b_fm,
										rf_writea_exec, rf_writea_mema);
										
write_back_stg write_back_stg_dut(reset, clk, write_b_fm, d_mem_wrap_rd_data, rf_write_data, write_b_en,rf_writea_mema, rf_writea_wb);					

always@(*)
begin
	if(reset)
	begin
	proc_out <= 16'd0;

	end

	 else begin
	 
		proc_out <= alu_out;
		irf_out <= irf;
		ra_out <= RA;
		rb_out <= RB;
		out_d1_out <= out_d1;
		out_d2_out <= out_d2;
		alu_proc_out <= alu_out;
		carry_out <= carry_out_w;
		zero_out <= zero_out_w;
		dm_out <= d_mem_wrap_rd_data;
		wb_out <= rf_write_data;
		wb_addr <= rf_writea_wb;
		reg_write_data <= wb_data;
		write_enable <= write_b_en;
		function_alu <= funct_reg;
		reg0 <= reg_0;
		reg1 <= reg_1;
		reg2 <= reg_2;
		reg3 <= reg_3;
		reg4 <= reg_4;
		reg5 <= reg_5;
		reg6 <= reg_6;
		reg7 <= reg_7;
end
end

endmodule

//MIPS Processor by Group 18 - Vinaykumar, Anand, Karan