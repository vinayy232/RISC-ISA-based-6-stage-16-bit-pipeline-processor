module decode(clk,irf,RA,RB,RC,opertn,check_c,check_z,do_comp,check_imm,imm_value,pc_fetch,pc_decode);
input clk;
input [15:0]irf,pc_fetch;
output reg [2:0] RA,RB,RC;
output reg [4:0]opertn;
output reg check_c;
output reg check_z;
output reg check_imm;
output reg do_comp; 
output reg [5:0]imm_value ;
output reg [15:0]pc_decode;
wire [2:0] opr1,opr2,opr3,func;
wire [3:0] opcode;
assign opcode=irf[15:12];
assign func=irf[2:0];
assign opr1=irf[11:9];
assign opr2=irf[8:6];
assign opr3=irf[5:3];
localparam ADI=5'b00000;localparam ADA=5'b00001;localparam ADC=5'b00010;localparam ADZ=5'b00011;localparam AWC=5'b00100;localparam ACA=5'b00101;
localparam ACC=5'b00110;localparam ACZ=5'b00111;localparam ACW=5'b01000;localparam NDU=5'b01001;localparam NDC=5'b01010;localparam NDZ=5'b01011;
localparam NCU=5'b01100;localparam NCC=5'b01101;localparam NCZ=5'b01110;localparam LLI=5'b01111;localparam LW=5'b10000;localparam SW=5'b10001;
localparam LM=5'b10010;localparam SM=5'b10011;localparam BEQ=5'b10100;localparam BLT=5'b10101;localparam BLE=5'b10110;localparam JAL=5'b10111;
localparam JLR=5'b11000;localparam JRI=5'b11001;
always@(posedge clk)
begin
	case(opcode)
	4'b00_00: 
		begin
		   opertn<=ADI;
			do_comp<=0;
			check_c<=0;
			check_z<=0;
			RA<=opr1;
			RB<=opr2;
			RC <= opr2;
			check_imm<=1;
			imm_value<=irf[5:0];				
		end
	4'b00_01:
		begin
			case(func)
			3'b000: 
				begin
					opertn<=ADA;
					do_comp<=0;
					check_c<=0;
					check_z<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
					
				end
			3'b010:
				begin
					opertn<=ADC;
					do_comp<=0;
					check_c<=1;
					check_z<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
					
				end
			3'b001:
				begin
					opertn<=ADZ;
					do_comp<=0;
					check_c<=0;
					check_z<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
					
				end
			3'b011:
				begin
					opertn<=AWC;
					do_comp<=0;
					check_c<=0;
					check_z<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
					
				end
			3'b100:
				begin
					opertn<=ACA;
					do_comp<=1;
					check_c<=0;
					check_z<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;		
				end
				
			3'b110:
				begin
					opertn<=ACC;
					check_c<=1;
					check_z<=0;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;		
				end
			
			3'b101:
				begin
					opertn<=ACZ;
					check_c<=0;
					check_z<=1;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;		
				end
		  3'b111:
				begin
					opertn<=ACW;
					check_c<=0;
					check_z<=0;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;		
				end
		  endcase//end of ADD
		end
	4'b00_10:
		begin
		  case(func)
		  3'b000: 
				begin
					opertn<=NDU;
					check_c<=0;
					check_z<=0;
					do_comp<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
				end
			3'b010:
				 begin
					opertn<=NDC;
					check_c<=1;
					check_z<=0;
					do_comp<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
				 end
			3'b001:
				 begin
					opertn<=NDZ;
					check_c<=0;
					check_z<=1;
					do_comp<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
				 end
			3'b100:
				 begin
					opertn<=NCU;
					check_c<=0;
					check_z<=0;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
				 end
			3'b110:
				 begin
					opertn<=NCC;
					check_c<=1;
					check_z=0;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;
				 end
			3'b101:
				 begin
					opertn<=NCZ;
					check_c<=0;
					check_z<=1;
					do_comp<=1;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;			
				 end
			endcase//end of NAND
				
		end
	4'b00_11:
		begin
			opertn<=LLI;
			check_c<=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr2; // unnecessary adding, since it will take imm value only
			RB<=opr2;
			RC<=opr1;
			check_imm<=1; // done 1 so that imm value gets converted to opr2
			imm_value<=irf[5:0];	
		end
	4'b01_00:
		begin
			opertn<=LW;
			check_c<=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr2;
			RB<=opr2; // unnecessary adding, since it will take imm value only
			RC<=opr1;
			check_imm<=1; // done 1 so that imm value gets converted to opr2
			imm_value<=irf[5:0];	
		end
	4'b01_01:
		begin
			opertn<=SW;	// rb is in opr2 and imm is also going, In reg file opr2 from reg a and imm value is added to get address 
			check_c<=0;	// and from rc address data from location pointed from rc is fed as an operand 1 to alu
			check_z<=0;
			do_comp<=0;
			RA<=opr2;
			RB<=opr2; // unnecessary adding, since it will take imm value only
			RC<=opr1;
			check_imm<=1; // done 1 so that imm value gets converted to opr2
			imm_value<=irf[5:0];	
		end
	4'b10_00:
		begin
			opertn<=BEQ;
			check_c=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			check_imm<=0; //immediate value is utilized in reg file itself , no need to pass through alu
			imm_value<=irf[5:0];		
		end
	4'b10_01:
		begin
			opertn<=BLT;
			check_c<=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			check_imm<=0; //immediate value is utilized in reg file itself , no need to pass through alu
			imm_value<=irf[5:0];
		end
	4'b10_10:
		begin
			opertn<=BLE;
			check_c<=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			check_imm<=0; //immediate value is utilized in reg file itself , no need to pass through alu
			imm_value<=irf[5:0];
		end
	4'b11_00:
		begin
			opertn<=JAL; //jalr ra, Imm9
			check_c=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			RC<=opr1;	//write back address was RA
			check_imm<=1; // done 1 so that imm value gets converted to opr2
			imm_value<=irf[5:0];
			//imm_value_9bit<=irf[8:0]; //9bit imm offset
		end	
	4'b11_01:
		begin
			opertn<=JLR; //jlr ra, rb
			check_c=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			RC<=opr1;
			check_imm<=0; //imm = 000_000 in problem statement
			imm_value<=irf[5:0];  //imm = 000_000 in problem statement 
		end
	4'b11_11:
		begin
			opertn<=JRI; //jri ra, Imm9 
			check_c=0;
			check_z<=0;
			do_comp<=0;
			RA<=opr1;
			RB<=opr2;
			check_imm<=1; // done 1 so that imm value gets converted to opr2
			imm_value<=irf[5:0];
			//imm_value_9bit<=irf[8:0]; //9bit imm offset
		end						
	default:
				 begin
					opertn<=5'dz;
					check_c<=0;
					check_z<=0;
					do_comp<=0;
					RA<=opr1;
					RB<=opr2;
					RC<=opr3;
					check_imm<=0;
					imm_value<=6'b0;			
				 end
		
	endcase
	pc_decode<=pc_fetch;
end

endmodule
