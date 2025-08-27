//extends 9 bit to 16 bit data, TODO: make it generic using parameter WIDTH
module zeroextend16 (
  input [8:0] input9bit,
  output [15:0] output16bit
);

  assign output16bit[8:0] = input9bit; //assign lower bits as it is
  assign output16bit[15:9] = 7'b0000000;     //extend zero to higher bits of output

endmodule
