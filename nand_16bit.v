module nand_16bit(in_1, in_2, out);

   output [15:0] out;
   input [15:0] in_1, in_2;

   assign out = ~(in_1&in_2);

endmodule	