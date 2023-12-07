`ifndef __MOH_APB_EXAMPLE_ENV
`define __MOH_APB_EXAMPLE_ENV

class moh_apb_example_env extends uvm_env;
  `uvm_component_utils(moh_apb_example_env)

  moh_apb_env                 m_apb_env;
  moh_apb_env                 m_apb_env_completer;
  moh_apb_virtual_sequencer   m_v_seqr;
  moh_apb_env                 m_apb_env_passive;

  function new( string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase( uvm_phase phase);
    super.build_phase(phase);
    `uvm_info( "MSG"," Testbench build phase exec", UVM_HIGH)
    m_apb_env             =  moh_apb_env              ::type_id::create("m_apb_env", this);
    m_apb_env_completer   =  moh_apb_env              ::type_id::create("m_apb_env_completer", this);
    m_apb_env_passive     =  moh_apb_env              ::type_id::create("m_apb_env_passive", this);
    m_v_seqr              =  moh_apb_virtual_sequencer::type_id::create("m_v_seqr", this);
  endfunction : build_phase

  function void connect_phase( uvm_phase phase);
    m_v_seqr.p_seqr_requester     = m_apb_env.m_requester_agent.m_sequencer;
    m_v_seqr.p_seqr_completer     = m_apb_env_completer.m_completer_agent.m_sequencer;
    m_apb_env_passive.m_passive.m_request_port.connect(m_apb_env_completer.m_completer_agent.m_sequencer.m_request_export);
  endfunction : connect_phase

endclass : moh_apb_example_env

`endif
