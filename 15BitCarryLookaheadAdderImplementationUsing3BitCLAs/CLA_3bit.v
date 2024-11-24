// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_3bit (
  input  [2:0] C    ,
  input  [2:0] D    ,
  input        Cin  ,
  input        mode , // 0 --> addition , 1 --> subtraction
  output [2:0] RES  ,
  output       Carry
);

  /* Your design goes here */

  //wires first
  wire [2:0] P, G, D_forsubstraction;
  wire [2:0] carrie; // this is for the carries in between cla s
  
  //propogation and generate assignment
  assign P = C^D;
  assign G = C&D;

  //now the carries for 3 bit cla
  assign carrie[0] = Cin;
  assign carrie[1] = G[0] | (P[0] & carrie[0]);
  assign carrie[2] = G[1] | (P[1] & carrie[1]);
  assign Carry = G[2] | (P[2] & carrie[2]);


  //result
  assign RES = P^carrie;

endmodule 