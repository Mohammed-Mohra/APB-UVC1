`ifndef __MOH_APB_VIRTUAL_SEQUENCER
`define __MOH_APB_VIRTUAL_SEQUENCER

class moh_apb_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils (moh_apb_virtual_sequencer)

  function new( string name = "moh_apb_virtual_sequencer" ,uvm_component parent);
    super.new( name, parent);
  endfunction 

  //These are pointers pointing toward the sequencers of the requester and the
  //completer sequencers
  moh_apb_completer_sequencer    p_seqr_completer;
  moh_apb_requester_sequencer    p_seqr_requester;

endclass : moh_apb_virtual_sequencer

`endif
