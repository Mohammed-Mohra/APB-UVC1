interface moh_apb_if (input clk, input reset);

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic  [31:0]   paddr;  // addr_width
  logic           psel;
  logic           penable;
  logic           pwrite;
  logic  [31:0]   pwdata; //data_width
  logic  [31:0]   prdata; //data_width
  logic           pslverr;
  logic           pready;

  clocking mon_cb@(posedge clk); // monitor working
    input reset, paddr,psel,penable,pwrite,prdata, pwdata, pready, pslverr;
  endclocking

  clocking drv_cb@(posedge clk);
    output reset, paddr, psel, penable, pwrite, prdata, pwdata, pready, pslverr;
  endclocking

endinterface : moh_apb_if
