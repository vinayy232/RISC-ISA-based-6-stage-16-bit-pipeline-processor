module data_memory(clk,reset,d_mem_addr,d_mem_opertn,wr_rd,d_mem_wr_data_l,d_mem_wr_data_h,d_mem_rd_data_l,d_mem_rd_data_h);
input clk;
input reset;
input [15:0]d_mem_addr;
input d_mem_opertn;
input wr_rd; //wr_rd=0 read, wr_rd=1 write
input [7:0]d_mem_wr_data_l,d_mem_wr_data_h;
output reg [7:0]d_mem_rd_data_l,d_mem_rd_data_h;
reg [7:0] d_mem[127:0];

initial
begin
	d_mem[0]=8'b0000_0110;
	d_mem[1]=8'b0000_0000;
	d_mem[2]=8'b0000_0001;
	d_mem[3]=8'b0100_0000;
	d_mem[4]=8'b0000_0010;
	d_mem[5]=8'b1000_0000;
	d_mem[6]=8'b0000_0011;
	d_mem[7]=8'b0010_0000;
	d_mem[8]=8'b1000_0100;//
	d_mem[9]=8'b0100_0000;
	d_mem[10]=8'b0011_0011;
	d_mem[11]=8'b1001_1001;
end
//always@(*)
//begin
//	//rd1<=dmem_rd_data_l;
//	//rd2<=dmem_rd_data_h;
//	
//	if(d_mem_opertn==1'b1&& wr_rd==1'b0)      // if there is mem opertn(not idle state) and wr_rd is 0 which means read
//		begin
//			d_mem_rd_data_l<=d_mem[d_mem_addr];
//			d_mem_rd_data_h<=d_mem[d_mem_addr+1];//to read two bytes
//		end
//end

always@(posedge clk or posedge reset)
begin	
	if(reset==1'b1)
		begin
			d_mem_rd_data_l<=8'b0;
			d_mem_rd_data_h<=8'b0;
			
		end
	else
	begin
		
		if(d_mem_opertn==1'b1&& wr_rd==1'b0)      // if there is mem opertn(not idle state) and wr_rd is 0 which means read
		begin
			d_mem_rd_data_l<=d_mem[d_mem_addr];
			d_mem_rd_data_h<=d_mem[d_mem_addr+16'b1];//to read two bytes
		end
		else if(d_mem_opertn==1'b1 && wr_rd==1'b1) // if there is an mem opertn(not idle state) and wr_rd is 1 which means write 
		begin
			d_mem[d_mem_addr]<=d_mem_wr_data_l;
			d_mem[d_mem_addr+16'b1]<=d_mem_wr_data_h;//to write two bytes
		end
		else begin
			d_mem_rd_data_l <= d_mem_wr_data_l; //pass data for register operation
			d_mem_rd_data_h <= d_mem_wr_data_h;
		end
	end

end



endmodule
