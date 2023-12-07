`ifndef __MOH_APB_REQUESTER_SEQUENCE_LIB
`define __MOH_APB_REQUESTER_SEQUENCE_LIB

class moh_apb_base_seq extends uvm_sequence #(moh_apb_seq_item);
  `uvm_object_utils(moh_apb_base_seq)

  function new(string name="moh_apb_base_seq");
    super.new(name);
  endfunction

endclass : moh_apb_base_seq

class small_generic_seq extends moh_apb_base_seq;
  `uvm_object_utils(small_generic_seq)

  function new(string name = "small_generic_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "small_generic_seq started", UVM_LOW)
    repeat(7) `uvm_do(req)
  endtask

endclass : small_generic_seq

`endif
