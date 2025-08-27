module execute(reset, clk, compl,check_c,check_z,operand_1, operand_2, 
					func, alu_out, write_b_f, carry_out, zero_out, mem_acs_out, rd_wr_ena, mem_adrs_out,rf_wa_ein, 
					rf_wa_eout,pc_operands_read,pc_execute, bj_sig,alu_out_comb);

input reset, clk, compl, check_c, check_z;
input [4:0] func;
input [15:0]pc_operands_read;
output reg [15:0]alu_out , mem_adrs_out;
wire  [15:0]alu_out_wire, mem_addrs_wire;
output reg carry_out, zero_out; 
output reg write_b_f, mem_acs_out, rd_wr_ena,bj_sig;
input [15:0] operand_1,operand_2;
input [2:0] rf_wa_ein;
output reg [2:0] rf_wa_eout;
output reg [15:0] pc_execute, alu_out_comb;
wire c_f_wire,z_f_wire,write_b_f_wire,for_carry_wire, for_zero_wire, mem_acs_wire, rd_wr_ena_wire,bj_sig_w;
wire [2:0]rf_win_wire, rf_wout_wire;
	
assign rf_win_wire = rf_wa_ein;				
alu_16 alu_16_dut(reset, clk, compl, for_carry_wire, for_zero_wire, check_c,check_z,operand_1, operand_2, 
						func, alu_out_wire,  c_f_wire, z_f_wire, write_b_f_wire, mem_acs_wire, rd_wr_ena_wire, mem_addrs_wire,bj_sig_w);
						
always@(*) begin

	carry_out <= c_f_wire;
	zero_out <= z_f_wire;
	rf_wa_eout <= rf_wout_wire;
	bj_sig <= bj_sig_w;
	alu_out_comb <= alu_out_wire;


end	
cond_code cond_code_dut(reset, clk, c_f_wire, for_carry_wire, z_f_wire, for_zero_wire,rf_win_wire,rf_wout_wire);	
always@(posedge clk)
begin
	pc_execute<=pc_operands_read;
	//added to make it clocked
	mem_acs_out <= mem_acs_wire;
	rd_wr_ena <= rd_wr_ena_wire;
	mem_adrs_out <= mem_addrs_wire;
	alu_out <= alu_out_wire;
	write_b_f <= write_b_f_wire;
end

endmodule
