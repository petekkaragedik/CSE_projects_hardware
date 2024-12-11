module matrixops_tb ();

  //Ports
  reg        clk  ;
  reg        rst  ;
  reg        enter;
  reg  [1:0] X    ;
  reg  [1:0] Y    ;
  wire       Z    ;

  matrixops dut (
    .clk  (clk  ),
    .rst  (rst  ),
    .enter(enter),
    .X    (X    ),
    .Y    (Y    ),
    .Z    (Z    )
  );

  // Half period of our clock signal
  parameter HP = 5;
  // Full period of our clock signal
  parameter FP = (2*HP);

  // For generating the clock signal
  always #HP clk = ~clk;

  initial begin
    //  * Our waveform is saved under this file.
    $dumpfile("matrixops_tb.vcd");

    // * Get the variables from the module.
    $dumpvars(0,matrixops_tb);

    $display("Simulation started.");
  
    clk = 1;
    rst = 1;
    X = 0;
    Y = 0;
    enter = 0;
    #(FP-1); // To avoid race conditions, modify inputs prior to the clock edge

    rst = 0;
    X = 0;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 0;
    #FP;

    rst = 0;
    X = 2;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 3;
    enter = 1;
    #FP;

    rst = 0;
    X = 3;
    Y = 3;
    enter = 1;
    #FP;

    rst = 0;
    X = 0;
    Y = 2;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 0;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 2;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 2;
    enter = 0;
    #FP;

    $display("Simulation finished.");
    $finish(); // Finish simulation.
  end

endmodule