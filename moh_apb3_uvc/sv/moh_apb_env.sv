`ifndef __MOH_APB_ENV
`define __MOH_APB_ENV

class moh_apb_env extends uvm_env;
  `uvm_component_utils(moh_apb_env)

  moh_apb_completer_agent      m_completer_agent;
  moh_apb_requester_agent      m_requester_agent;
  moh_apb_monitor              m_passive;
  moh_apb_config_class         m_apb_config;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase (phase);

    if (!uvm_config_db # (moh_apb_config_class)::get(this, get_full_name(), "m_apb_config", m_apb_config))
      `uvm_fatal("FATAL MSG", "Configuration object is not set properlty")

    if (m_apb_config.m_mode == REQUESTER) begin
      m_requester_agent = moh_apb_requester_agent::type_id::create("m_requester_agent", this);
    end else if (m_apb_config.m_mode == COMPLETER ) begin
      m_completer_agent  = moh_apb_completer_agent::type_id::create("m_completer_agent", this);
    end else if (m_apb_config.m_mode == PASSIVE) begin
      m_passive = moh_apb_monitor::type_id::create("m_passive", this);
    end
  endfunction : build_phase

endclass

`endif
