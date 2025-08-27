//extends 9 bit to 16 bit data, TODO: make it generic using parameter WIDTH
module signextend6to16 (input6bit, output16bit);
input [5:0] input6bit;
output [15:0] output16bit;


  assign output16bit[5:0] = input6bit; //assign lower bits as it is
  assign output16bit[15:6] = { {10{input6bit[5]}}};     //extend MSB sign bit of input to higher bits of output

endmodule
