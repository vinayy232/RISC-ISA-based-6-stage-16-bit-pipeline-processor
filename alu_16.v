module alu_16(reset, clk, compl, carry_in, zero_in, checkc,checkz,operand_1, operand_2, func, alu_out,  c_f,
						z_f, write_b_f, mem_access, read_write_m, mem_address, bj_sig);
input reset,clk,compl,checkc,checkz;
input [15:0] operand_1,operand_2;

input [4:0] func;
output reg [15:0]alu_out;
output reg z_f,c_f, write_b_f;
output reg mem_access, read_write_m, bj_sig;
output reg [15 :0] mem_address;
input carry_in,zero_in;
wire carry_f,zero_f;
wire add_signal, nand_signal, wb_uncond, lli_sig, lw_sig, sw_sig, branch_sig, jump_sig;
wire carry_alu, write_b, int_mem_access;
wire[15:0] sum_out,opr_2,nand_out;
reg [1:0] wbdis_count;
assign wb_uncond = (func == 5'd0 || func == 5'd1 || func == 5'd4 || func == 5'd5 || func == 5'd8 || func == 5'd9 || func == 5'd12 
                     || func == 5'd15|| func == 5'd16 || func == 5'd23|| func == 5'd24) ? 1 : 0;
assign carry_alu = (func ==5'b00100 || func==5'b01000) ? carry_in : 1'b0; // to handle AWC,ACW Carry requirement
twos_complement two_c(operand_2, compl, opr_2); //to do twos complement when compl is 1


fulladder16 fulladd(operand_1, opr_2,compl, carry_alu, carry_f, sum_out );//here opr2 is the one which pass through twos comp and sign extend before reaching here

nand_16bit nand16(operand_1, opr_2, nand_out); 



assign write_b = ((checkc && carry_in) || (checkz && zero_in) || wb_uncond ) ? 1 : 0;

assign nand_signal = (func > 5'd8 && func < 5'd15 ) ? 1'b1 : 1'b0;
assign add_signal = (func < 5'd9 ) ? 1'b1 : 1'b0;
assign int_mem_access = (func > 5'd15 && func < 5'd20 ) ? 1'b1 : 1'b0; //memory access between 16 and 19
assign lli_sig = (func == 5'd15) ? 1'b1 : 1'b0; 
assign lw_sig = (func == 5'd16) ? 1'b1 : 1'b0;
assign sw_sig = (func == 5'd17) ? 1'b1 : 1'b0;
assign branch_sig = (func > 5'd19 && func < 5'd23 ) ? 1'b1 : 1'b0;
assign jump_sig = (func == 5'd23 || func == 5'd24 || func == 5'd25 ) ? 1'b1 : 1'b0 ;

always@(*) begin
	if (reset) begin
		alu_out <= 16'd0;
		write_b_f <= 1'b0;
		mem_address <= 16'd0;
		mem_access <= 1'b0;
		read_write_m <= 1'b0; // added to give proper value on reset
		bj_sig <= 1'b0;
	end else begin
//		write_b_f <= write_b;
		write_b_f <= (wbdis_count > 0) ? 0 : write_b; 
		mem_access <= int_mem_access;
		if (add_signal) begin
			alu_out <= sum_out;
			bj_sig <= 1'b0;
		end else if (nand_signal) begin 
			alu_out <= nand_out;
			bj_sig <= 1'b0;
		end else if (lli_sig) begin
			alu_out <= opr_2;
			bj_sig <= 1'b0;
		end else if (lw_sig) begin
			alu_out <= opr_2; // it can be changed to anything , since we are anyways doing load
			mem_address <= sum_out;
			read_write_m <= 1'b0;
			bj_sig <= 1'b0;
		end else if(sw_sig) begin
			alu_out <= operand_1;	// operand 1 consist the data from ra
			mem_address <= opr_2;	//opr2 itself contains rb + imm6 bit
			read_write_m <= 1'b1;	// to write in dmem
			bj_sig <= 1'b0;
		end else if(branch_sig) begin
		case(func)
			5'b10100: 
				begin
					if (operand_1 == opr_2) begin
						bj_sig <= 1'b1;
				
					end else begin
						bj_sig <= 1'b0;
						
					end
				end
			5'b10101:
				begin
					if (operand_1 < opr_2) begin
						bj_sig <= 1'b1;
						
					end else begin
						bj_sig <= 1'b0;
						
					end
				end
			5'b10110:
				begin
					if (operand_1 <= opr_2) begin
						bj_sig <= 1'b1;
						
					end else begin
						bj_sig <= 1'b0;
						
					end
				end
			default:
				begin
					bj_sig <= 1'b0;
					
				end
		endcase
					
		end else if (jump_sig) begin
				alu_out <= operand_1;
				bj_sig <= 1'b0;
		end						
	end
end
	
	//comb always block to handle carry forwading
always@(*) begin
	if (reset) begin
		c_f <= 1'b0;
		z_f <= 1'b0;

	end else begin
		if(wbdis_count==2'b00)
		begin
			if (add_signal) 
			begin
				if (sum_out == 16'd0) z_f <= 1'b1;
				else z_f <= 1'b0;
			end 
			else if (nand_signal) 
			begin 
				if (nand_out == 16'd0) z_f <= 1'b1;
				else z_f <= 1'b0;
			end
			c_f <= carry_f;
		end
	end
end
//
always@(posedge clk or posedge reset) begin
	if (reset) begin
		wbdis_count <= 2'b00;
	end else if(bj_sig) begin
		wbdis_count <= 2'b11;
	end else if(jump_sig) begin
		wbdis_count <= 2'b10;
	end else begin
		if(wbdis_count > 0 ) begin
			wbdis_count <= wbdis_count - 2'b01;
		end
	end
end	
endmodule
