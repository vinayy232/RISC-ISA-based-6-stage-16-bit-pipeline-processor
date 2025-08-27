module mem_acs_stg(clk,reset,d_mem_wrap_addr,mem_modif,wr_rd_enable,d_mem_wrap_wr_data,d_mem_wrap_rd_data,write_bin, write_bout,rf_writea_min,
 rf_writea_mout);
input clk,reset;
input [15:0]d_mem_wrap_addr;
input mem_modif,wr_rd_enable,write_bin;
input [15:0]d_mem_wrap_wr_data;
output reg [15:0]d_mem_wrap_rd_data;
output reg write_bout;
input [2:0] rf_writea_min;
output reg [2:0] rf_writea_mout;
wire [7:0]d_mem_rd_data_l,d_mem_rd_data_h;
wire [7:0]d_mem_wr_data_l,d_mem_wr_data_h;

data_memory d_mem_inst3(clk,reset,d_mem_wrap_addr,mem_modif,wr_rd_enable,d_mem_wr_data_l,d_mem_wr_data_h,d_mem_rd_data_l,d_mem_rd_data_h);

	assign d_mem_wr_data_l=d_mem_wrap_wr_data[7:0];
	assign d_mem_wr_data_h=d_mem_wrap_wr_data[15:8];
always@(*) 
begin d_mem_wrap_rd_data<={d_mem_rd_data_h,d_mem_rd_data_l}; 
end

always @(posedge clk) begin	
	write_bout <= write_bin;
	rf_writea_mout <= rf_writea_min;
end

endmodule
