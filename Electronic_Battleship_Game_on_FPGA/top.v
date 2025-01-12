// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk    ,
  input  [3:0] sw     ,
  input  [3:0] btn    ,
  output [7:0] led    ,
  output [7:0] seven  ,
  output [3:0] segment
);

/* Your module instantiations go to here. */

wire clocktouse;

clk_divider clk1(.clk_in(clk), .divided_clk(clocktouse));

wire button0;
wire button1;
//wire button2;
wire button3;

debouncer db0 (.clk(clocktouse), .rst(~btn[2]), .noisy_in(~btn[0]), .clean_out(button0));
debouncer db1 (.clk(clocktouse), .rst(~btn[2]), .noisy_in(~btn[1]), .clean_out(button1));
//debouncer db2 (.clk(clocktouse), .rst(~btn[2]), .noisy_in(~btn[2]), .clean_out(button2));
debouncer db3 (.clk(clocktouse), .rst(~btn[2]), .noisy_in(~btn[3]), .clean_out(button3));

wire [7:0]svn0;
wire [7:0]svn1;
wire [7:0]svn2;
wire [7:0]svn3;

battleship myBattleship (.clk(clocktouse), .rst(~btn[2]), .start(button1), .X(sw[3:2]), .Y(sw[1:0]), .pAb(button3), .pBb(button0), 
                          .disp0(svn0), .disp1(svn1), .disp2(svn2), .disp3(svn3), .led(led));

ssd mySSD (.clk(clk), .disp0(svn0), .disp1(svn1), .disp2(svn2), .disp3(svn3), .seven(seven), .segment(segment));

endmodule
