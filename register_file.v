module register_file(
reset,clk,rf_write_en,read_a1,read_a2,rf_writea_pipeline,rf_write_data,out_d1,out_d2,imm6bit,
checkimm,func,func_reg,rf_write_address,rf_writea_regf, wbout_data,pc_decode,bj_flag,data_dep_sig1, data_dep_sig2,
alu_out_ip,reg0,reg1,reg2,reg3,reg4, reg5,reg6, reg7);

input reset,clk,rf_write_en;
input[2:0] read_a1,read_a2,rf_write_address, rf_writea_pipeline;
input[15:0] rf_write_data;//, pc_in; // added pc in input
input[15:0] alu_out_ip;
output reg[15:0] out_d1,out_d2, wbout_data;
wire [15:0] output16bit_dut, output9to16, sw_data;
input [5:0] imm6bit;
input checkimm,bj_flag,data_dep_sig1, data_dep_sig2;
input [15:0] pc_decode;

input [4:0] func;
output reg[4:0] func_reg;


reg[15:0] register_f[7:0];
wire [5:0]input6bit_dut;
output reg [2:0] rf_writea_regf;
output reg [15:0] reg0, reg1,reg2, reg3,reg4, reg5,reg6, reg7;
wire checkimm9, check_sw;
wire [8:0]imm9bit;
reg rst_flg;
reg [15:0] brjump_addr;
wire [15:0]jal_addr,jlr_addr,jri_addr;

initial begin

	out_d1 = 16'd0;
	out_d2 = 16'd0;

	register_f[1] = 16'd1;
	register_f[2] = 16'd2;
	register_f[3] = 16'd3;
	register_f[4] = 16'd4;
	register_f[5] = 16'd5;
	register_f[6] = 16'b1000000000000000;
	register_f[7] = 16'b1000000000000000; // only for carry check
end

assign checkimm9 = (func == 5'b01111) ? 1'b1 : 1'b0 ;	//signal to chck 9 bit immediate value
assign imm9bit = {read_a2, imm6bit};						//9 bit imm value form by 6 bit and 3 bit of reg_a2
assign check_sw = (func == 5'b10001) ? 1'b1 : 1'b0 ;	//check if store instruction is there

wire jump_and_link_f;
assign jump_and_link_f = (func == 5'd23 || func == 5'd24 || func == 5'd25 ) ? 1'b1 : 1'b0 ;
//jump address computation
assign jal_addr = pc_decode + (output9to16 * 2);
assign jlr_addr = register_f[read_a2];
assign jri_addr = register_f[read_a1] + (output9to16 * 2);	
			
signextend6to16 dut6to16(imm6bit, output16bit_dut);
zeroextend16 dut9to16(imm9bit, output9to16);

assign sw_data = register_f[read_a1] + output16bit_dut;	//data require for storing into data memory formed here

always@(posedge clk or posedge reset) begin
	
	if(reset==1) begin
		out_d1 <= 16'd0;
		out_d2 <= 16'd0;

		rst_flg<=1'b1;
		register_f[0] <= 16'bz; 
		
	end
	
	else begin
		if(data_dep_sig1) begin
			out_d1 <= alu_out_ip;
		end else begin
			if(check_sw) begin
				out_d1 <= register_f[rf_write_address]; // for store using dest address to get the value pointed by that address
			end else if(jump_and_link_f) begin
				out_d1 <= pc_decode + 16'd2;
			end else begin
				out_d1 <= register_f[read_a1];
			end
		end
		
		if(data_dep_sig2) begin
			out_d2 <= alu_out_ip;
		end else begin
			if(checkimm && (~ checkimm9) && (~ check_sw)) begin
				out_d2 <= output16bit_dut;
			end else if(checkimm && (checkimm9) && (~ check_sw)) begin
				out_d2 <= output9to16;	
			end else if(check_sw) begin
				out_d2 <= sw_data; // rb + imm 
			end else begin
				out_d2 <= register_f[read_a2];
			end
		end
	
		if(rf_write_en) begin
			register_f[rf_writea_pipeline] <= rf_write_data;
			wbout_data <= rf_write_data;
		end
		else begin
			wbout_data <= 16'dz;
		end
		
		//PC Handling below
		if(rst_flg==1)		
			begin
				register_f[0]<=16'b0;	//initial loading of r0 to 0 :pc
				rst_flg<=0;
				
			end
		else
		begin
			brjump_addr <= pc_decode + (output16bit_dut * 2);

			if (bj_flag) begin				
				register_f[0] <= brjump_addr;
			end else if (jump_and_link_f) begin
				if (func == 5'd23) begin //JAL jalr ra, Imm9			
					register_f[0] <= jal_addr;  //update pc					
				end
				if (func == 5'd24) begin //JLR jlr ra, rb		
					register_f[0] <= jlr_addr;  //update pc						
				end
				if (func == 5'd25) begin //JRI jri ra, Imm9			
					register_f[0] <= jri_addr;  //update pc						
				end								
			end else begin
				register_f[0] <= register_f[0] + 16'd2; 
			end
		end
		//clocked output
		func_reg <= func;
		rf_writea_regf <= rf_write_address;

		
	end
		
end
//Adding register file data to output
always@(*) begin
	
	reg0 <= register_f[0];
	reg1 <= register_f[1];
	reg2 <= register_f[2];
	reg3 <= register_f[3];
	reg4 <= register_f[4];
	reg5 <= register_f[5];
	reg6 <= register_f[6];
	reg7 <= register_f[7];
end	

endmodule	
