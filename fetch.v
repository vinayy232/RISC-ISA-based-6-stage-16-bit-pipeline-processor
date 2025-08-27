module fetch(clk,reset,i_mem_addr,irf,pc_fetch);

input clk,reset;
input [15:0] i_mem_addr;
output reg [15:0]irf;
output reg [15:0]pc_fetch;
wire [15:0] imem_2_ir;
wire [15:0]irf1;
wire [7:0] i_mem_data_l,i_mem_data_h;

instruction_memory imem_inst1 (reset,i_mem_addr,i_mem_data_l,i_mem_data_h);
ir ir_inst1 (clk,reset,imem_2_ir,irf1);


assign imem_2_ir = {i_mem_data_h,i_mem_data_l};

always@(*)
begin
irf<=irf1;
end
always@(posedge clk)
begin
pc_fetch<=i_mem_addr;
end
endmodule