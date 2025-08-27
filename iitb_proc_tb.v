
module iitb_proc_tb;
reg reset,clk;
//reg [15:0] pc;
wire [15:0] proc_out, irf_out;

wire [2:0] ra_out,rb_out;
wire [15:0] out_d1_out, out_d2_out,alu_proc_out, dmem_out, wback_out;
wire [2:0] wback_addr;
wire [15:0] reg_w_data;
wire carry_out, zero_out, write_en;
wire [4:0] func_alu;
wire [15:0] regf0,regf1, regf2, regf3, regf4, regf5, regf6, regf7;
iitb_proc dut(clk, reset, proc_out,irf_out, ra_out, rb_out, out_d1_out, out_d2_out,
				alu_proc_out, carry_out,zero_out, dmem_out, wback_out, wback_addr, reg_w_data, write_en, func_alu, regf0,
				   regf1, regf2, regf3, regf4, regf5, regf6, regf7);
 initial begin
		$dumpvars();
		
		clk=1'b0; reset =1'b0;
		#25 reset = 1'b1;
		#15 reset = 1'b0;

		#1000;
		$finish;
end
always #10 clk=~clk; //always every 10 ps clk_50 is getting toggled
endmodule