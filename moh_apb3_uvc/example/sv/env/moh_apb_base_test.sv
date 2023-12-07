`ifndef __MOH_APB_BASE_TEST
`define __MOH_APB_BASE_TEST

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  moh_apb_example_env        m_tb;
  moh_apb_virtual_sequence   m_apb_virt_seq;
  moh_apb_config_class       m_requester_apb_config;
  moh_apb_config_class       m_completer_apb_config;
  moh_apb_config_class       m_passive_apb_config;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this , "*", "recording_detail", 1);
    configure();
    m_tb           =  moh_apb_example_env     ::type_id::create("m_tb", this);
    m_apb_virt_seq =  moh_apb_virtual_sequence::type_id::create("m_apb_virt_seq");
  endfunction : build_phase

  virtual function void configure();
    configure_requester();
    configure_completer();
    configure_passive();
  endfunction : configure

  // configure requester APB
  virtual function void configure_requester();
    m_requester_apb_config = moh_apb_config_class::type_id::create("m_requester_apb_config");
    m_requester_apb_config.m_mode = REQUESTER; //requester
    uvm_config_db #(moh_apb_config_class) ::set(this, "*.m_apb_env.*","m_apb_config",m_requester_apb_config);
  endfunction : configure_requester

  //configure completer APB
  virtual function void configure_completer();
    m_completer_apb_config = moh_apb_config_class::type_id::create("m_completer_apb_config");
    m_completer_apb_config.m_mode = COMPLETER; //Completer
    uvm_config_db #(moh_apb_config_class) ::set(this, "*.m_apb_env_completer.*","m_apb_config", m_completer_apb_config);
  endfunction : configure_completer

  // configure the monitor
  virtual function void configure_passive();
    m_passive_apb_config = moh_apb_config_class::type_id::create("m_passive_apb_config");
    m_passive_apb_config.m_mode      = PASSIVE; 
    m_passive_apb_config.m_is_active = UVM_PASSIVE;
    uvm_config_db #(moh_apb_config_class) ::set(this, "*.m_apb_env_passive.*","m_apb_config", m_passive_apb_config);
  endfunction : configure_passive

  function void end_of_elaboration_phase(uvm_phase phase);
    // This function prints the topology of the environment from the top
    // module to the agents to the drivers and sequencers
    uvm_top.print_topology();
  endfunction 

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction 

  task run_phase(uvm_phase phase);
    uvm_objection _obj;
    phase.raise_objection(this);
    _obj = phase.get_objection();
    _obj.set_drain_time(this, 200ns);
    _obj.set_drain_time(this,15);
    do_test();
    phase.drop_objection(this);
  endtask

  virtual task do_test();
    `uvm_fatal("NOEX","only extensions of this class are supposed to be run") 
  endtask

endclass

`endif
