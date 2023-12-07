module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import moh_apb_pkg::*;

  import moh_apb_example_pkg::*;
  `include "moh_apb_example_env.sv"
  `include "moh_apb_base_test.sv"

  initial begin
    apb_vif_config::set(null, "uvm_test_top.m_tb.m_apb_env.m_requester_agent.*", "vif",moh_hw_top.in0);
    apb_vif_config::set(null, "uvm_test_top.m_tb.m_apb_env_passive.*", "vif",moh_hw_top.in0);

    apb_vif_config::set(null, "uvm_test_top.m_tb.m_apb_env_completer.m_completer_agent.*", "vif",moh_hw_top.in0);
    run_test("base_test");
  end
endmodule
