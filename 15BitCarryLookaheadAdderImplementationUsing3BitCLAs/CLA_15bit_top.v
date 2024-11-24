// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_15bit_top (
  input  [14:0] A   ,
  input  [14:0] B   ,
  input         mode, // 0 --> addition , 1 --> subtraction
  output [14:0] S   ,
  output        Cout,
  output        OVF
);

  /* Your design goes here */

  wire [14:0] B_forsubstraction =  B^{15{mode}};
  wire [4:0] carry;

  //xor-ing b with mode to decide addition substraction
  //assign B_forsubstraction = B^{15{mode}};
  assign carry[0] = mode; //first carry is mode

  //now will use 5 of 3 bit cla s
  // we are slicing the bits to pieces of 3 bits each to use in 3 bit cla s
  CLA_3bit cla0 (.C(A[2:0]), .D(B_forsubstraction[2:0]), .Cin(carry[0]), .mode(mode), .RES(S[2:0]), .Carry(carry[1]));
  CLA_3bit cla1 (.C(A[5:3]), .D(B_forsubstraction[5:3]), .Cin(carry[1]), .mode(mode), .RES(S[5:3]), .Carry(carry[2]));
  CLA_3bit cla2 (.C(A[8:6]), .D(B_forsubstraction[8:6]), .Cin(carry[2]), .mode(mode), .RES(S[8:6]), .Carry(carry[3]));
  CLA_3bit cla3 (.C(A[11:9]), .D(B_forsubstraction[11:9]), .Cin(carry[3]), .mode(mode), .RES(S[11:9]), .Carry(carry[4]));
  CLA_3bit cla4 (.C(A[14:12]), .D(B_forsubstraction[14:12]), .Cin(carry[4]), .mode(mode), .RES(S[14:12]), .Carry(Cout));

  //now the way to find overflow
  assign OVF = (A[14] & B_forsubstraction[14] & ~S[14]) | (~A[14] & ~B_forsubstraction[14] & S[14]);

endmodule 