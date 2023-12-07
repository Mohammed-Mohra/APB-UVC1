`ifndef __MOH_APB_VIRTUAL_SEQUENCE
`define __MOH_APB_VIRTUAL_SEQUENCE

class moh_apb_virtual_sequence extends uvm_sequence;
  `uvm_object_utils (moh_apb_virtual_sequence)
  //This is a pointer pointing to the virtual sequencer
  `uvm_declare_p_sequencer (moh_apb_virtual_sequencer)

  function new( string name = "moh_apb_virtual_sequence");
    super.new(name);
  endfunction 

  // These are objects of the requester and completer sequnces to be
  // performed
  small_seq_completer       m_completer_seq;
  small_generic_seq         m_requester_seq; 

  task pre_body();
    m_completer_seq  = small_seq_completer::type_id::create("m_completer_seq");
    m_requester_seq  = small_generic_seq::type_id::create("m_requester_seq");
  endtask

  task body();
    // This body task is to start both theaster and the completer sequences
    fork
      begin
        m_requester_seq.start(p_sequencer.p_seqr_requester);
      end
      begin
        m_completer_seq.start(p_sequencer.p_seqr_completer);
      end
    join_any
  endtask

endclass

`endif
