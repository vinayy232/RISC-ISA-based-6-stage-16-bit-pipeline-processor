module fulladder16 (A, B,compl, Cin, Carry, Sum);
	input [15:0] A, B; 
	input compl,Cin;
	output reg Carry;	
	output reg[15:0] Sum;
	reg [16:0]adder_result;
	always@(*) begin
		adder_result<= A + B + Cin;
		Sum<=adder_result[15:0];
		if(compl==16'b1)
		begin
		Carry<=0;
		end
		else
		begin
		Carry<=adder_result[16] ? 1 : 0;
		end
		//Sum<=A^ B^ Cin;
		//Carry<=(A & B ) |(B & Cin) |(A & Cin);
	end 
endmodule
