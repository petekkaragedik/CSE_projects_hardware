// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES
//Saghar Yeganehparast 33568
//Petek Karagedik 34042

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */

reg [15:0] mapA;
reg [15:0] mapB;
reg [2:0] Score_A, Score_B;
reg [2:0] input_count;
reg Z;

reg start_timer;
reg timer; //done signal
reg [7:0] timer_count;
reg [3:0] curr_state;

parameter [3:0] IDLE = 4'b0000;
parameter [3:0] SHOW_A = 4'b0001;
parameter [3:0] A_IN = 4'b0010;
parameter [3:0] ERROR_A = 4'b0011;
parameter [3:0] SHOW_B = 4'b0100;
parameter [3:0] B_IN = 4'b0101;
parameter [3:0] ERROR_B = 4'b0110;
parameter [3:0] SHOW_SCORE = 4'b0111;
parameter [3:0] A_SHOOT = 4'b1000;
parameter [3:0] A_SINK = 4'b1001;
parameter [3:0] A_WIN = 4'b1010;
parameter [3:0] B_SHOOT = 4'b1011;
parameter [3:0] B_SINK = 4'b1100;
parameter [3:0] B_WIN = 4'b1101;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    timer <= 0;
    timer_count <= 0;
  end else if (start_timer) begin
    if (timer_count == 50) begin
      timer <= 1;
      timer_count <= 0;
    end else begin
      timer_count <= timer_count + 1;
      timer <= 0;
    end
  end else begin
    timer <= 0;
  end
end

always @ (posedge clk or posedge rst) begin
  if(rst)begin
    curr_state <= IDLE;
    mapA <= 16'b0;
    mapB <= 16'b0;
    input_count <= 3'b0;
    Score_A <= 3'b000;
    Score_B <= 3'b000;
    Z <= 0;
    start_timer <= 0;
    shoot_flag <= 0;
  end
  else begin
    case (curr_state) 
      IDLE: begin
        if (start) begin
          curr_state <= SHOW_A;
        end
        else begin
          curr_state <= IDLE;
        end
      end
      SHOW_A: begin
        start_timer <= 1;
          if(timer) begin
            start_timer <= 0;
            curr_state <= A_IN;
          end
          else begin
            curr_state <= SHOW_A;
          end
        end
      A_IN: begin
        start_timer <= 0;
        if (pAb) begin
          if (mapA[4*Y+X]) begin
            curr_state <= ERROR_A;
          end
          else begin
            if (input_count > 2) begin
              mapA[4*Y+X] <= 1;
              input_count <= 0;
              curr_state <= SHOW_B;
            end
            else begin
              mapA[4*Y+X] <= 1;
              input_count <= input_count + 1;
              curr_state <= A_IN;
            end
          end
        end
        else begin
          curr_state <= A_IN;
        end
      end
      ERROR_A: begin
        start_timer <= 1;
        if (timer) begin
          start_timer <= 0;
          curr_state <= A_IN;
        end
        else begin
          curr_state <= ERROR_A;
        end
      end
      SHOW_B: begin
        start_timer <= 1;
        if(timer) begin
          start_timer <= 0;
          curr_state <= B_IN;
        end
        else begin
          curr_state <= SHOW_B;
        end
      end
      B_IN: begin
        start_timer <= 0;
        if (pBb) begin
          if (mapB[4*Y+X]) begin
            curr_state <= ERROR_B;
          end
          else begin
            if (input_count > 2) begin
              mapB[4*Y+X] <= 1;
              curr_state <= SHOW_SCORE;
            end
            else begin
              mapB[4*Y+X] <= 1;
              input_count <= input_count + 1;
              curr_state <= B_IN;
            end
          end
        end
        else begin
          curr_state <= B_IN;
        end
      end
      ERROR_B: begin
        start_timer <= 1;
        if (timer) begin
          start_timer <= 0;
          curr_state <= B_IN;
        end
        else begin
          curr_state <= ERROR_B;
        end
      end
      SHOW_SCORE: begin
        start_timer <= 1;
        if (timer) begin
          start_timer <= 0;
          curr_state <= A_SHOOT;
        end
        else begin
          curr_state <= SHOW_SCORE;
        end
      end
      A_SHOOT: begin
          if(pAb) begin
            if(mapB[4*Y+X]) begin
              Score_A <= Score_A + 1;
              Z <= 1;
              mapB[4*Y+X] <= 0;
              curr_state <= A_SINK;
            end
            else begin
              Score_A <= Score_A;
              Z <= 0;
              curr_state <= A_SINK;
            end
          end
          else begin
              curr_state <= A_SHOOT;
          end
      end
      A_SINK: begin
        start_timer <= 1;
        if (!timer) begin
          if(Z) begin
            curr_state <= A_SINK;
          end
          else begin
            curr_state <= A_SINK;
          end
        end
        else begin
          start_timer <= 0;
          if (Score_A > 3) begin
            curr_state <= A_WIN;
          end
          else begin
            curr_state <= B_SHOOT;
          end
        end
      end
      A_WIN: begin
        start_timer <= 1;
        if (timer) begin
          start_timer <= 0;
        end else begin
          curr_state <= A_WIN;
        end
      end
      B_SHOOT: begin
          if(pBb) begin
            if(mapA[4*Y+X]) begin
              Score_B <= Score_B + 1;
              Z <= 1;
              mapA[4*Y+X] <= 0;
              curr_state <= B_SINK;
            end
            else begin
              Score_B <= Score_B;
              Z <= 0;
              curr_state <= B_SINK;
            end
          end
          else begin
              curr_state <= B_SHOOT;
          end
        end
      B_SINK: begin
        start_timer <= 1;
        if (!timer) begin
          if(Z) begin
              curr_state <= B_SINK;
          end
          else begin
              curr_state <= B_SINK;
          end
        end
        else begin
          start_timer <= 0;
          if (Score_B > 3) begin
            curr_state <= B_WIN;
          end
          else begin
            curr_state <= A_SHOOT;
          end
        end
      end
      B_WIN: begin
        start_timer <= 1;
        if (timer) begin
          start_timer <= 0;
        end else begin
          curr_state <= B_WIN;
        end
      end
      default: curr_state <= IDLE;
    endcase
  end
end

always @* begin
  disp3 = 8'b00000000;
  disp2 = 8'b00000000;
  disp1 = 8'b00000000;
  disp0 = 8'b00000000;
  led = 8'b00000000;

  case (curr_state)
    IDLE: begin
      disp3 = 8'b00000110;
      disp2 = 8'b01011110;
      disp1 = 8'b00111000;
      disp0 = 8'b01111001;
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
      if(timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
      end
    end
    SHOW_A: begin
      disp3 = 8'b01110111;
      disp2 = 8'b00000000;
      disp1 = 8'b00000000;
      disp0 = 8'b00000000;
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
      if(timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
      end
    end
    A_IN: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;
      if (X == 0)begin
        disp1 = 8'b00111111;
      end else if(X == 1) begin
        disp1 = 8'b00000110;
      end else if(X == 2) begin
        disp1 = 8'b01011011;
      end else begin

        disp1 = 8'b01001111;
      end
      if (Y == 0)begin
        disp0 = 8'b00111111;
      end else if(Y == 1) begin
        disp0 = 8'b00000110;
      end else if(Y == 2) begin
        disp0 = 8'b01011011;
      end else begin
        disp0 = 8'b01001111;
      end
      led[7] = 1;
      led[6:4] = input_count;
      led[3:0] = 4'b0000;
    end
    ERROR_A: begin
      disp3 = 8'b01111001;
      disp2 = 8'b01010000;
      disp1 = 8'b01010000;
      disp0 = 8'b01011100;
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
      if (timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
      end
    end
    SHOW_B: begin
      disp3 = 8'b01111100;
      disp2 = 8'b00000000;
      disp1 = 8'b00000000;
      disp0 = 8'b00000000;
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
      if(timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
      end
    end
    B_IN: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;
      if (X == 0)begin
        disp1 = 8'b00111111;
      end else if(X == 1) begin
        disp1 = 8'b00000110;
      end else if(X == 2) begin
        disp1 = 8'b01011011;
      end else begin
        disp1 = 8'b01001111;
      end
      if (Y == 0)begin
        disp0 = 8'b00111111;
      end else if(Y == 1) begin
        disp0 = 8'b00000110;
      end else if(Y == 2) begin
        disp0 = 8'b01011011;
      end else begin
        disp0 = 8'b01001111;
      end
      led[0] = 1;
      led[3:1] = input_count;
      led[7:4] = 4'b0000;
    end
    ERROR_B: begin
      disp3 = 8'b01111001;
      disp2 = 8'b01010000;
      disp1 = 8'b01010000;
      disp0 = 8'b01011100;
      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;
      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
      if (timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
      end
    end
    SHOW_SCORE: begin
      if (timer) begin
        //turning off the leds
        led[7] = 0;
        led[4] = 0;
        led[3] = 0;
        led[0] = 0;
        disp3 = 8'b00000000;
        disp2 = 8'b00000000;
        disp1 = 8'b00000000;
        disp0 = 8'b00000000;
      end
      else begin
        led[7] = 1;
        led[4] = 1;
        led[3] = 1;
        led[0] = 1;
        led[6] = 0;
        led[5] = 0;
        led[2] = 0;
        led[1] = 0;
        disp3 = 8'b00000000;
        disp2 = 8'b00111111;
        disp1 = 8'b01000000;
        disp0 = 8'b00111111;
      end
    end
    A_SHOOT: begin
      if(pAb) begin
        disp3 = 8'b00000000;
        disp2 = 8'b00000000;
        if (X == 0)begin
          disp1 = 8'b00111111;
        end else if(X == 1) begin
          disp1 = 8'b00000110;
        end else if(X == 2) begin
          disp1 = 8'b01011011;
        end else begin
          disp1 = 8'b01001111;
        end
        if (Y == 0)begin
          disp0 = 8'b00111111;
        end else if(Y == 1) begin
          disp0 = 8'b00000110;
        end else if(Y == 2) begin
          disp0 = 8'b01011011;
        end else begin
          disp0 = 8'b01001111;
        end
        led[7] = 1;
        led[6:4] = Score_A;
        led[3:1] = Score_B;
        led[0] = 0;
      end
      else begin
        disp3 = 8'b00000000;
        disp2 = 8'b00000000;
        if (X == 0)begin
          disp1 = 8'b00111111;
        end else if(X == 1) begin
          disp1 = 8'b00000110;
        end else if(X == 2) begin
          disp1 = 8'b01011011;
        end else begin
          disp1 = 8'b01001111;
        end
        if (Y == 0)begin
          disp0 = 8'b00111111;
        end else if(Y == 1) begin
          disp0 = 8'b00000110;
        end else if(Y == 2) begin
          disp0 = 8'b01011011;
        end else begin
          disp0 = 8'b01001111;
        end
        led[7] = 1;
        led[6:4] = Score_A;
        led[3:1] = Score_B;
        led[0] = 0;
       end
    end
    A_SINK: begin
      if (!timer) begin
        if(Z) begin
          disp3 = 8'b00000000;
          if (Score_A == 1)begin
            disp2 = 8'b00000110;
          end else if(Score_A == 2) begin
            disp2 = 8'b01011011;
          end else if(Score_A == 3) begin
            disp2 = 8'b01001111;
          end else if(Score_A == 4) begin
            disp2 = 8'b01100110;
          end else begin
            disp2 = 8'b00111111;
          end
          disp1 = 8'b01000000;
          if (Score_B == 1)begin
            disp0 = 8'b00000110;
          end else if(Score_B == 2) begin
            disp0 = 8'b01011011;
          end else if(Score_B == 3) begin
            disp0 = 8'b01001111;
          end else if(Score_B == 4) begin
            disp0 = 8'b01100110;
          end
          else begin
            disp0 = 8'b00111111;
          end
          led = 8'b11111111;
        end
        else begin
          disp3 = 8'b00000000;
          if (Score_A == 1)begin
            disp2 = 8'b00000110;
          end else if(Score_A == 2) begin
            disp2 = 8'b01011011;
          end else if(Score_A == 3) begin
            disp2 = 8'b01001111;
          end else if(Score_A == 4) begin
            disp2 = 8'b01100110;
          end else begin
            disp2 = 8'b00111111;
          end
          disp1 = 8'b01000000;
          if (Score_B == 1)begin
            disp0 = 8'b00000110;
          end else if(Score_B == 2) begin
            disp0 = 8'b01011011;
          end else if(Score_B == 3) begin
            disp0 = 8'b01001111;
          end else if(Score_B == 4) begin
            disp0 = 8'b01100110;
          end
          else begin
            disp0 = 8'b00111111;
          end
          led = 8'b00000000;
        end
      end
      else begin
        led = 8'b00000000;
      end
    end
    A_WIN: begin
      disp3 = 8'b01110111;
      if (Score_A == 1)begin
        disp2 = 8'b00000110;
      end else if(Score_A == 2) begin
        disp2 = 8'b01011011;
      end else if(Score_A == 3) begin
        disp2 = 8'b01001111;
      end else if(Score_A == 4) begin
        disp2 = 8'b01100110;
      end else begin
        disp2 = 8'b00111111;
      end
      disp1 = 8'b01000000;
      if (Score_B == 1)begin
        disp0 = 8'b00000110;
      end else if(Score_B == 2) begin
        disp0 = 8'b01011011;
      end else if(Score_B == 3) begin
        disp0 = 8'b01001111;
      end else if(Score_B == 4) begin
        disp0 = 8'b01100110;
      end
      else begin
        disp0 = 8'b00111111;
      end
      //DANCE PATTERN
      if (timer) begin
        led = 8'b00000000;
      end else begin
        led = 8'b11110000;
      end
    end
    B_SHOOT: begin
      if(pBb) begin
        disp3 = 8'b00000000;
        disp2 = 8'b00000000;
        if (Score_A == 1)begin
          disp2 = 8'b00000110;
        end else if(Score_A == 2) begin
          disp2 = 8'b01011011;
        end else if(Score_A == 3) begin
          disp2 = 8'b01001111;
        end else if(Score_A == 4) begin
          disp2 = 8'b01100110;
        end else begin
          disp2 = 8'b00111111;
        end
        disp1 = 8'b01000000;
        if (Score_B == 1)begin
          disp0 = 8'b00000110;
        end else if(Score_B == 2) begin
          disp0 = 8'b01011011;
        end else if(Score_B == 3) begin
          disp0 = 8'b01001111;
        end else if(Score_B == 4) begin
          disp0 = 8'b01100110;
        end
        else begin
          disp0 = 8'b00111111;
        end
        led[0] = 1;
        led[6:4] = Score_A;
        led[3:1] = Score_B;
        led[7] = 0;
      end
      else begin
        disp3 = 8'b00000000;
        disp2 = 8'b00000000;
        if (X == 0)begin
          disp1 = 8'b00111111;
        end else if(X == 1) begin
          disp1 = 8'b00000110;
        end else if(X == 2) begin
          disp1 = 8'b01011011;
        end else begin
          disp1 = 8'b01001111;
        end
        if (Y == 0)begin
          disp0 = 8'b00111111;
        end else if(Y == 1) begin
          disp0 = 8'b00000110;
        end else if(Y == 2) begin
          disp0 = 8'b01011011;
        end else begin
          disp0 = 8'b01001111;
        end
        led[7] = 0;
        led[6:4] = Score_A;
        led[3:1] = Score_B;
        led[0] = 1;
      end
    end
    B_SINK: begin
      if (!timer) begin
        if(Z) begin
          disp3 = 8'b00000000;
          if (Score_A == 1)begin
            disp2 = 8'b00000110;
          end else if(Score_A == 2) begin
            disp2 = 8'b01011011;
          end else if(Score_A == 3) begin
            disp2 = 8'b01001111;
          end else if(Score_A == 4) begin
            disp2 = 8'b01100110;
          end else begin
            disp2 = 8'b00111111;
          end
          disp1 = 8'b01000000;
          if (Score_B == 1)begin
            disp0 = 8'b00000110;
          end else if(Score_B == 2) begin
            disp0 = 8'b01011011;
          end else if(Score_B == 3) begin
            disp0 = 8'b01001111;
          end else if(Score_B == 4) begin
            disp0 = 8'b01100110;
          end
          else begin
            disp0 = 8'b00111111;
          end
          led = 8'b11111111;
        end
        else begin
          disp3 = 8'b00000000;
          if (Score_A == 1)begin
            disp2 = 8'b00000110;
          end else if(Score_A == 2) begin
            disp2 = 8'b01011011;
          end else if(Score_A == 3) begin
            disp2 = 8'b01001111;
          end else if(Score_A == 4) begin
            disp2 = 8'b01100110;
          end else begin
            disp2 = 8'b00111111;
          end
          disp1 = 8'b01000000;
          if (Score_B == 1)begin
            disp0 = 8'b00000110;
          end else if(Score_B == 2) begin
            disp0 = 8'b01011011;
          end else if(Score_B == 3) begin
            disp0 = 8'b01001111;
          end else if(Score_B == 4) begin
            disp0 = 8'b01100110;
          end
          else begin
            disp0 = 8'b00111111;
          end
          led = 8'b00000000;
        end
      end
      else begin
        led = 8'b00000000;
      end
    end
    B_WIN: begin
      disp3 = 8'b01111100;
      if (Score_A == 1)begin
        disp2 = 8'b00000110;
      end else if(Score_A == 2) begin
        disp2 = 8'b01011011;
      end else if(Score_A == 3) begin
        disp2 = 8'b01001111;
      end else if(Score_A == 4) begin
        disp2 = 8'b01100110;
      end else begin
        disp2 = 8'b00111111;
      end
      disp1 = 8'b01000000;
      if (Score_B == 1)begin
        disp0 = 8'b00000110;
      end else if(Score_B == 2) begin
        disp0 = 8'b01011011;
      end else if(Score_B == 3) begin
        disp0 = 8'b01001111;
      end else if(Score_B == 4) begin
        disp0 = 8'b01100110;
      end
      else begin
        disp0 = 8'b00111111;
      end
      //DANCE PATTERN
      if (timer) begin
        led = 8'b00000000;
      end else begin
        led = 8'b00001111;
      end
    end
    default: begin
  disp3 = 8'b00000000;
  disp2 = 8'b00000000;
  disp1 = 8'b00000000;
  disp0 = 8'b00000000;
  led = 8'b00000000;
end
  endcase
end
endmodule
