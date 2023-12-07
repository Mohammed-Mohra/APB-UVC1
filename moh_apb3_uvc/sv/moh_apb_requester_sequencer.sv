`ifndef __MOH_APB_REQUESTER_SEQUENCER
`define __MOH_APB_REQUESTER_SEQUENCER

class moh_apb_requester_sequencer extends uvm_sequencer #(moh_apb_seq_item);
  `uvm_component_utils(moh_apb_requester_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : moh_apb_requester_sequencer

`endif
