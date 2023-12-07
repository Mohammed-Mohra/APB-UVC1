`ifndef __EXAMPLE_TEST_SVH
`define __EXAMPLE_TEST_SVH

class example_test extends base_test;
  `uvm_component_utils(example_test)

  function new( string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  moh_apb_virtual_sequence           m_apb_virt_seq;

  virtual task do_test();
    m_apb_virt_seq = moh_apb_virtual_sequence::type_id::create("m_apb_virt_seq");
    m_apb_virt_seq.start(m_tb.m_v_seqr);
  endtask

endclass

`endif
