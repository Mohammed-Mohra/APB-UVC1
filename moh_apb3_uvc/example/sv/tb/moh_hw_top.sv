module moh_hw_top;

  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;
  logic         psel;
  logic [7:0]   addr;
  logic [15:0]  wdata;
  logic         enable;
  logic         write;
  logic [15:0]  rdata;
  logic         ready;
  logic         slverr;
  logic         rand_var;

  moh_apb_if    in0(.clk(clock), .reset(reset) );

  //CLKGEN module generate clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(1'b1),
    .clock_period(32'd10)
  );

  initial begin
    reset <= 1'b1;
    @(posedge clock)
    reset <= 1'b0;
    @(posedge clock)
    reset <= 1'b1;
  end

endmodule
