`ifndef __MOH_APB_COMPLETER_SEQUENCER
`define __MOH_APB_COMPLETER_SEQUENCER

class moh_apb_completer_sequencer extends uvm_sequencer #(moh_apb_seq_item);
  `uvm_component_utils(moh_apb_completer_sequencer)

  // The export and the fifo are to get the transactions from the APB
  // REQUESTER
  // They are connected with the monitor which monitors the signals between
  uvm_analysis_export #(moh_apb_seq_item) m_request_export;
  uvm_tlm_analysis_fifo #(moh_apb_seq_item)  m_request_fifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    m_request_fifo   = new("m_request_fifo", this);
    m_request_export = new("m_request_export", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_request_export.connect(m_request_fifo.analysis_export);
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : moh_apb_completer_sequencer

`endif
