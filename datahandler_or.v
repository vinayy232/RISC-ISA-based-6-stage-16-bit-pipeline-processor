module datahandler_or (reset,clk,func,read_a1,read_a2,rf_write_address,alu_out_ip,data_dep_sig1, data_dep_sig2,data_frm_dh);
	input [4:0] func;
	input reset,clk;
	
	input[2:0] read_a1,read_a2,rf_write_address;
	input[15:0] alu_out_ip;
	output reg[15:0] data_frm_dh;
	reg [2:0] read_a1_ns1,read_a2_ns1,rf_write_address_ns1;
	reg [2:0] read_a1_ns2,read_a2_ns2,rf_write_address_ns2;
	reg [2:0] read_a1_ns3,read_a2_ns3,rf_write_address_ns3;
	//input [15:0] pc_decode;
	reg [4:0]func_nextinstn1,func_nextinstn2,func_nextinstn3;
	output reg data_dep_sig1, data_dep_sig2;
	//reg data_dep_sig1ns2, data_dep_sig2ns2;
	reg [15:0] alu_out_ipns2,alu_out_ipns3;
//	reg [15:0] pc_dec_ns1,pc_dec_ns2;

always@(posedge clk or posedge reset) begin
	if(reset==1) begin
		func_nextinstn1 <= 5'd0;
		//data_dep_sig1 <= 1'b0;
		//data_dep_sig2 <= 1'b0;
		//pc_dec_ns1 <= 16'dz;
		//func_nextinstn2 <= 5'd0;
	end else begin
		func_nextinstn1 <= func;
		read_a1_ns1 <= read_a1;
		read_a2_ns1 <= read_a2;
		rf_write_address_ns1 <= rf_write_address;
		alu_out_ipns2 <= alu_out_ip;
		//pc_dec_ns1 <= pc_decode;
	end
end

always@(posedge clk or posedge reset) begin
	if(reset==1) begin
		//func_nextinstn1 <= 5'd0;
		func_nextinstn2 <= 5'd0;
		//pc_dec_ns2 <= 16'dz;
	end else begin
		func_nextinstn2 <= func_nextinstn1;
		read_a1_ns2 <= read_a1_ns1;
		read_a2_ns2 <= read_a2_ns1;
		rf_write_address_ns2 <= rf_write_address_ns1;
		alu_out_ipns3 <= alu_out_ipns2;
		//pc_dec_ns2 <= pc_dec_ns1;
	end
end

always@(posedge clk or posedge reset) begin
	if(reset==1) begin
		//func_nextinstn1 <= 5'd0;
		func_nextinstn3 <= 5'd0;
		//pc_dec_ns2 <= 16'dz;
	end else begin
		func_nextinstn3 <= func_nextinstn2;
		read_a1_ns3 <= read_a1_ns2;
		read_a2_ns3 <= read_a2_ns2;
		rf_write_address_ns3 <= rf_write_address_ns2;
		//pc_dec_ns2 <= pc_dec_ns1;
	end
end

always@(*) begin
	if(reset==1) begin
		data_dep_sig1 <= 1'b0;
		data_dep_sig2 <= 1'b0;
	end
	
	if( ( func > 5'd0 && func < 5'd15)  && (func_nextinstn1 > 5'd0 && func_nextinstn1 < 5'd15)) begin
		//immediate dependency
		if (rf_write_address_ns1 == read_a1) begin
			data_dep_sig1 <= 1;
			data_frm_dh <= alu_out_ip;
		end else begin
			data_dep_sig1 <= 0;
			//data_frm_dh1 <= 16'd0;
		end
		
		if (rf_write_address_ns1 == read_a2) begin
			data_dep_sig2 <= 1;
			data_frm_dh <= alu_out_ip;
		end else begin
			data_dep_sig2 <= 0;
			//data_frm_dh2 <= 16'd0;
		end
	end 
	
	//1 cycle depencdency
	if( ( func > 5'd0 && func < 5'd15)  && (func_nextinstn2 > 5'd0 && func_nextinstn2 < 5'd15)) begin	
		if (rf_write_address_ns2 == read_a1) begin
			//data_dep_sig1ns2 <= 1;
			data_dep_sig1 <= 1;
			data_frm_dh <= alu_out_ipns2;
		end else begin
			data_dep_sig1 <= 0;
			//data_frm_dh1 <= 16'd0;
		end
		
		if (rf_write_address_ns2 == read_a2) begin
			//data_dep_sig2ns2 <= 1;
			data_dep_sig2 <= 1;
			data_frm_dh <= alu_out_ipns2;
		end else begin
			data_dep_sig2 <= 0;
			
			//data_frm_dh2 <= 16'd0;
		end
	end
	
	// 2 cycle dependency
	if( ( func > 5'd0 && func < 5'd15)  && (func_nextinstn3 > 5'd0 && func_nextinstn3 < 5'd15)) begin		
		if (rf_write_address_ns3 == read_a1) begin
			//data_dep_sig1ns2 <= 1;
			data_dep_sig1 <= 1;
			data_frm_dh <= alu_out_ipns3;
		end else begin
			data_dep_sig1 <= 0;
			//data_frm_dh1 <= 16'd0;
		end
		
		if (rf_write_address_ns3 == read_a2) begin
			//data_dep_sig2ns2 <= 1;
			data_dep_sig2 <= 1;
			data_frm_dh <= alu_out_ipns3;
		end else begin
			data_dep_sig2 <= 0;
			
			//data_frm_dh2 <= 16'd0;
		end	
	end
end	
endmodule
