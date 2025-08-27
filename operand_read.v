module operand_read(
reset,clk,rf_write_en,read_a1,read_a2,rf_writea_pipeline,rf_write_data,out_d1,out_d2,imm6bit,
checkimm,func,func_reg,rf_write_address,rf_writea_regf, wbout_data,checkr_c, checkr_z, checkr_comp,
checkr_cout,checkr_zout,checkr_compout,pc_decode,pc_operands_read,bj_flag,alu_out_ip,reg0,reg1,reg2,reg3,reg4, reg5,reg6, reg7);

input reset,clk,rf_write_en;
input[2:0] read_a1,read_a2,rf_write_address, rf_writea_pipeline;
input[15:0] rf_write_data,alu_out_ip;

input [5:0] imm6bit;
input checkimm,bj_flag ;
input checkr_c, checkr_z, checkr_comp;
input [4:0] func;
input [15:0] pc_decode;

output reg[15:0] out_d1,out_d2, wbout_data;
output reg[4:0] func_reg;

output reg [2:0] rf_writea_regf;
output reg [15:0] reg0, reg1,reg2, reg3,reg4, reg5,reg6, reg7;
output reg checkr_cout,checkr_zout,checkr_compout;
output reg [15:0] pc_operands_read;


wire [15:0] out_d1_w,out_d2_w, wbout_data_w;
wire [4:0] func_reg_w;
wire [2:0] rf_writea_regf_w;
wire [15:0] reg0_w, reg1_w,reg2_w, reg3_w,reg4_w, reg5_w,reg6_w, reg7_w,data_frm_dh_w ;
wire data_dep_sig1_w,data_dep_sig2_w; 
//wire checkr_cout_w,checkr_zout_w,checkr_compout_w;

register_file reg_file_dut(reset,clk,rf_write_en,read_a1,read_a2,rf_writea_pipeline,rf_write_data,out_d1_w,out_d2_w,imm6bit,
									checkimm,func,func_reg_w,rf_write_address,rf_writea_regf_w,wbout_data_w,pc_decode,bj_flag,
									data_dep_sig1_w,data_dep_sig2_w,data_frm_dh_w,reg0_w, reg1_w,reg2_w, reg3_w,reg4_w, reg5_w,reg6_w, reg7_w);
									

datahandler_or	datahandler_or_dut (reset,clk,func,read_a1,read_a2,rf_write_address,alu_out_ip,data_dep_sig1_w,data_dep_sig2_w,data_frm_dh_w);

always@(*) begin
	
	out_d1 <= out_d1_w;
	out_d2 <= out_d2_w;
	wbout_data <= wbout_data_w;
	func_reg <= func_reg_w;
	rf_writea_regf <= rf_writea_regf_w;	
	reg0 <= reg0_w;
	reg1 <= reg1_w;
	reg2 <= reg2_w;
	reg3 <= reg3_w;
	reg4 <= reg4_w;
	reg5 <= reg5_w;
	reg6 <= reg6_w;
	reg7 <= reg7_w;
//	checkr_cout <= checkr_cout_w;
//	checkr_zout <= checkr_zout_w;
//	checkr_compout <= checkr_compout_w;

end									

always@(posedge clk or posedge reset) begin
		if(reset==1) begin
			//out_d1 <= 16'd0;
			//out_d2 <= 16'd0;
			checkr_cout <= 1'b0;
			checkr_zout <= 1'b0;
			checkr_compout<= 1'b0;
		end else begin 
		//func_reg <= func;
//		rf_writea_regf <= rf_write_address;
		checkr_cout <= checkr_c;
		checkr_zout <= checkr_z;
		checkr_compout<= checkr_comp;	
		pc_operands_read<=pc_decode;
		end
end									
endmodule

