module ir(clk,reset,imem_2_ir,irf1);
input clk;
input reset;
input [15:0]imem_2_ir;
output reg [15:0]irf1;
reg no_reset;
reg rst_flg;

always@(posedge clk or posedge reset)
begin
	if(reset==1'b1)
	begin
		irf1<=16'dz;
		rst_flg<=1'b1;
	end
		
	else 
	begin
		if(rst_flg==1)
		begin
			irf1<=16'dz;
			rst_flg<=0;
		end
		else	
		begin		
			irf1<=imem_2_ir;
		end
	end
end

endmodule 

  