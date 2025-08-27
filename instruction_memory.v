module instruction_memory(reset,i_mem_addr,i_mem_data_l,i_mem_data_h);
input [15:0]i_mem_addr;
input reset;
output reg [7:0]i_mem_data_l,i_mem_data_h;
reg [15:0] i_mem[100:0];

reg [15:0]i_mem_inter;

initial
begin
	i_mem[0]=16'b0001_011_100_001_0_10;  // R1=R3+R4 ADC -> no write back will happen since there is no carry initially, R1 will remain same
	i_mem[1]=16'b0001_110_111_010_0_00;  //R2=R6+R7 ADA -> result = 0 , carry generated
	i_mem[2]=16'b0001_011_110_101_0_10;  //R5=R3+R6 ADC
	i_mem[3]=16'b0001_100_111_001_0_00;  //R1=R4+R7 ADA
	
	i_mem[4]=16'b0001_011_111_010_0_01;  //R2=R3+R7 ADZ	
	i_mem[5]=16'b0001_100_110_101_0_00;  //R5=R4+R6 ADA 	
	i_mem[6]=16'b0001_011_011_001_1_10;  //R1=R3+R3 ACC	
	i_mem[7]=16'b0001_100_100_010_1_01;  //R2=R4+R4 ACZ	
//	
   i_mem[8]=16'b1001_011_100_000110;    //BLT R3<R4 IMM=4 == satisfy -> br addr = 16 + 6*2 = 28
//	
	i_mem[9]=16'b0001_110_110_101_0_00;  //R5=R6+R6 ADA flushed
	i_mem[10]=16'b0001_111_111_001_0_00;  //R1=R7+R7 ADA flushed
	i_mem[11]=16'b0001_110_111_001_0_11; //R1=R6+R7 AWC flushed
	i_mem[12]=16'b0001_011_110_010_0_00; //R2=R3+R6 ADA //not exec because of branch
 
	i_mem[13]=16'b0001_100_111_101_1_11; //R5=R4+R7 ACW	//not exec not exec because of branch
	i_mem[14]=16'b0001_100_110_010_0_00; //R2=R4+R6 ADA 	-- branch will come here and store result as 32772 in r2
	
	
	i_mem[15]=16'b0011_001_000_000_0_01; // LLI imm = 1 write addr = r1
	i_mem[16]=16'b0011_010_000_000_0_10; // LLI imm = 2 write addr = r2
	i_mem[17]=16'b0011_011_000_000_011; // LLI imm = 3 write addr = r3
	i_mem[18]=16'b0011_100_000_000_100; // LLI imm = 4 write addr = r4
	i_mem[19]=16'b0011_101_000_000_101; // LLI imm = 5 write addr = r5
	
	//immediated data dependency
	i_mem[20]=16'b0001_010_001_101_0_00; // r5 = r2 + r1  - r5 = 2 + 1 = 3
	i_mem[21]=16'b0001_101_001_100_0_00; // r4 = r5 + r1  - r4 = 3 + 1 = 4 note : 5 + 1 = 6 is incorrect
	
	
	i_mem[22]=16'b0011_001_000_000_0_01; // LLI imm = 1 write addr = r1
	i_mem[23]=16'b0011_010_000_000_0_10; // LLI imm = 2 write addr = r2
	i_mem[24]=16'b0011_011_000_000_011; // LLI imm = 3 write addr = r3
	i_mem[25]=16'b0011_100_000_000_100; // LLI imm = 4 write addr = r4
	i_mem[26]=16'b0011_101_000_000_101; // LLI imm = 5 write addr = r5
	i_mem[27]=16'b0010_101_110_011_1_00; //NCU when coomp=1
	i_mem[28]=16'b0010_100_101_110_0_01; //NDZ
	i_mem[29]=16'b0010_100_101_110_0_00;//NDU now r5 updated value of inst2 is used here
	i_mem[30]=16'b0100_010_001_000_1_11; // LW imm = 7 rb = 1  read_data= dmem [8] wa = 2
	i_mem[31]=16'b0101_011_001_000_1_01; // sW data from ra = 3 to dmem[rb + imm]
	i_mem[32]=16'b1101_011_100_000110;	   // JLR : pc = rb =4 , r3 <= pc +2
//	i_mem[32]=16'b1111_010_000000000;		//JRI
	i_mem[33]=16'b0001_110_110_101_0_00;  //R5=R6+R6 ADA flushed
	i_mem[34]=16'b0001_111_111_001_0_00;  //R1=R7+R7 ADA flushed

	//below instruction can be uncommented if some mechanism is to be tested
		//1 cycle later dependency
//	i_mem[0]=16'b0001_010_001_101_0_00; // r5 = r2 + r1  - r5 = 2 + 1 = 3
//	i_mem[1]=16'b0001_010_011_011_0_00;	// r3 = r2 + r3 = 2 + 3 =5
//	i_mem[2]=16'b0001_101_010_100_0_00; // r4 = r5 + r2  - r4 = 3 + 2 = 5 note : 5 + 1 = 6 is incorrect	

//		//2 cycle later dependency
//	i_mem[0]=16'b0001_010_001_101_0_00; // r5 = r2 + r1  - r5 = 2 + 1 = 3
//	i_mem[1]=16'b0001_010_011_011_0_00;	// r3 = r2 + r3 = 2 + 3 =5
//	i_mem[2]=16'b0001_110_010_111_0_00; // r7 = 6 + 2 = 8
//	i_mem[3]=16'b0001_101_001_100_0_00; // r4 = r5 + r1  - r4 = 3 + 1 = 4 note : 5 + 1 = 6 is incorrect
	
			//3 cycle later dependency
//	i_mem[0]=16'b0001_010_001_101_0_00; // r5 = r2 + r1  - r5 = 2 + 1 = 3
//	i_mem[1]=16'b0001_010_011_011_0_00;	// r3 = r2 + r3 = 2 + 3 =5
//	i_mem[2]=16'b0001_110_010_111_0_00; // r7 = 6 + 2 = 8
//	i_mem[3]=16'b0001_011_010_111_0_00; // r7 = 3 + 2 = 5
//	i_mem[4]=16'b0001_101_001_100_0_00; // r4 = r5 + r1  - r4 = 3 + 1 = 4 note : 5 + 1 = 6 is incorrect

// Branch and jump instruction check
	//i_mem[4]=16'b1000_010_010_000110;	// beq 2 = 2
	//i_mem[4]=16'b1001_010_011_000110;	// blt 2 < 3
	//i_mem[4]=16'b1010_010_011_000110;	// blt 2 < 3
	//i_mem[4]=16'b1100_010_000000110;	   // JAL : pc = pc + imm *2  , r2 <= pc +2 
	//i_mem[4]=16'b1101_011_110_000110;	   // JLR : pc = rb =20 , r3 <= pc +2
	//i_mem[4]=16'b1111_010_000000110;		//JRI

end

always@(*)
begin

		if(reset==1'b1)
	   begin
		  i_mem_inter<=16'dz;
		  i_mem_data_l<=8'dz;
		  i_mem_data_h<=8'dz;
		end
		else
		begin
					i_mem_inter<=i_mem[i_mem_addr/2];
					i_mem_data_h<=i_mem_inter[15:8];
		
					i_mem_data_l<=i_mem_inter[7:0];

		end
	
end



endmodule
