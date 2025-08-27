module cond_code(reset, clk, carry_in, for_carry, zero_in, for_zero, rf_write_cc, rf_write_ccout);
input reset,clk,carry_in, zero_in;
output reg for_carry, for_zero;
input [2:0] rf_write_cc;
wire carry_temp, zero_temp;
wire [2:0] rf_write_temp;
assign carry_temp = carry_in;
assign zero_temp = zero_in; 
assign rf_write_temp = rf_write_cc;
output reg [2:0] rf_write_ccout;
always@(posedge clk)
begin
	if(reset) begin
		for_carry <= 1'b0;
		for_zero <= 1'b0;
	end else begin
	

		if (carry_temp == 1'b1) for_carry <= 1'b1; else for_carry <= 1'b0; 
		if (zero_temp == 1'b1) for_zero <= 1'b1; else for_zero <= 1'b0;
		rf_write_ccout <= rf_write_temp;
	end
end
endmodule
