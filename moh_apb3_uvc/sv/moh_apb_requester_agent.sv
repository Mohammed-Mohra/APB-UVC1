`ifndef __MOH_APB_REQUESTER_AGENT
`define __MOH_APB_REQUESTER_AGENT

class moh_apb_requester_agent extends uvm_agent;
  `uvm_component_utils(moh_apb_requester_agent)

  moh_apb_requester_sequencer m_sequencer;
  moh_apb_requester_driver    m_driver;
  moh_apb_config_class        m_cfg;
  moh_apb_monitor             m_monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db # (moh_apb_config_class)::get(this, get_full_name(), "m_apb_config", m_cfg)) begin
      `uvm_fatal("FATAL MSG", "Configuration objecti is not set properlty")
    end

    m_monitor = moh_apb_monitor::type_id::create("m_monitor", this);

    if(m_cfg.m_is_active == UVM_ACTIVE) begin
      m_sequencer = moh_apb_requester_sequencer::type_id::create("m_sequencer", this);
      m_driver    = moh_apb_requester_driver   ::type_id::create("m_driver", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE)begin// This is a TLM connection with the driver to the sequencer so the sequence item is transfered from the sequencer to the driver
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  endfunction : connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : moh_apb_requester_agent

`endif
