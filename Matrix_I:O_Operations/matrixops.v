//how to run: iverilog -o matrixops.vvp matrixops.v matrixops_tb.v
// vvp matrixops.vvp

module matrixops (
  input            clk  ,
  input            rst  ,
  input            enter,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  output reg       Z
);

/* Your design goes here. */

//these are the possible states:
parameter [1:0] R = 2'b00;
parameter [1:0] S = 2'b01;
parameter [1:0] IN = 2'b10;
parameter [1:0] OUT = 2'b11;

reg [1:0] cState; //current state
reg [1:0] nState; //next state
reg [1:0] Z_next;

reg [15:0] M; //the matrix

reg [2:0] Cntr; //counter that counts inputs

always @ (posedge clk or posedge rst) begin
  if(rst)
    cState <= R;
  else
    cState <= nState;
    Z <= Z_next;

end
//combinational logic here - next state and eventually output
always @(*) begin
  case(cState)
    R: begin
      //next state is stop after resetting
      nState = S;
    end

    S: begin
      if(enter) begin
        nState = IN;
      end
    end

    IN: begin
      if (Cntr < 5) begin
        nState = IN; // stay in getting input up until you get all
      end
      else begin
        nState = OUT;
      end
    end

    OUT: begin
      nState = OUT;
    end
  default: nState = R;
  endcase

end

always @(posedge clk or posedge rst) begin
  if (rst) begin
    M <= 16'b0; //resetting all of the elements of the matrix
    Cntr <= 0; // reset cntr too
    Z_next <= 1'b0;
    Z <= 1'b0;
  end
  else if (nState == IN && enter) begin //everything ok to start
    M[4*Y+X] <= 1'b1; // filled that element of the matrix
    Cntr <= Cntr + 1;
  end
  else if (nState == OUT && enter) begin
    Z_next <= M[4*Y+X];
  end
  else begin
    Z_next <= Z_next;
  end
end


endmodule