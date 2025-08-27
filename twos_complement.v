module twos_complement (binary_in, select_op, twos_comp);
 
input [15:0] binary_in; 
input select_op;	
output [15:0] twos_comp;   


assign twos_comp = select_op ? ((~binary_in) + 1'b1): binary_in;

endmodule