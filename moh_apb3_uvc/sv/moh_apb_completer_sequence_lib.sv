`ifndef __MOH_APB_COMPLETER_SEQUENCE_LIB
`define __MOH_APB_COMPLETER_SEQUENCE_LIB

class moh_apb_base_completer_seq extends uvm_sequence #(moh_apb_seq_item);
  `uvm_object_utils(moh_apb_base_completer_seq)

  moh_apb_seq_item            m_request;
  // this is a pointer pointing to the completer sequencer
  `uvm_declare_p_sequencer (moh_apb_completer_sequencer)

  function new(string name="moh_apb_base_completer_seq");
    super.new(name);
  endfunction

endclass : moh_apb_base_completer_seq

class small_seq_completer extends moh_apb_base_completer_seq;
  `uvm_object_utils(small_seq_completer)

  function new( string name = "small_seq_completer");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), " Executing small sequence in completer", UVM_LOW)
    forever begin
      p_sequencer.m_request_fifo.get(m_request);
      // The main response from the completer sequence is to send back the address
      // on rdata line
      // This is just an example sequence to demonstrate the functionality
      // of the reactive completer In this example the response is to send back
      // the address
      if(m_request.m_dir == READ) begin
        `uvm_do_with(req, { req.m_dir == READ; req.m_prdata == m_request.m_addr;})
      end else begin
        `uvm_do_with(req, {req.m_dir == WRITE; })
      end
    end
  endtask

endclass : small_seq_completer

`endif
