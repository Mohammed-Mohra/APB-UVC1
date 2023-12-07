`ifndef __MOH_APB_COMPLETER_AGENT
`define __MOH_APB_COMPLETER_AGENT

class moh_apb_completer_agent extends uvm_agent;
  `uvm_component_utils(moh_apb_completer_agent)
  moh_apb_completer_sequencer m_sequencer;
  moh_apb_completer_driver    m_driver;
  moh_apb_monitor             m_monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_monitor = moh_apb_monitor::type_id::create("m_monitor", this);
    if (is_active == UVM_ACTIVE) begin
      m_sequencer = moh_apb_completer_sequencer::type_id::create("m_sequencer", this);
      m_driver    = moh_apb_completer_driver::type_id::create("m_driver", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    // This is a TLM connection with the driver to the sequencer
    if (is_active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : moh_apb_completer_agent

`endif
