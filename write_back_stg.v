module write_back_stg(reset, clk, wb_en_in, inp_data, out_data, write_back_en, rf_writea_wbin,
 rf_writea_wbout);
input reset, clk ,wb_en_in;
input [15:0] inp_data;
output reg[15:0] out_data;
output reg write_back_en;
input [2:0] rf_writea_wbin;
output reg [2:0] rf_writea_wbout;
//always@(posedge clk or posedge reset) begin
always@(*) begin
	if (reset) begin
		out_data <= 16'd0;
		write_back_en <= 1'b0;
	end else begin
		out_data <= inp_data;
		write_back_en <= wb_en_in;
		rf_writea_wbout <= rf_writea_wbin;
	end
end
endmodule
