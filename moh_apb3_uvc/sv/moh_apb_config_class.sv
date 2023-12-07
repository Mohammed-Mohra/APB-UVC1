`ifndef __MOH_APB_CONFIG_CLASS
`define __MOH_APB_CONFIG_CLASS

//This class has properties to conifigure APB UVC
class moh_apb_config_class extends uvm_object;

  //functional coverage
  bit m_has_functional_coverage = 0;
  // This configures whether UVC is active -meaning UVC has driver and sequencer- or UVC is passive - has only monitor.
  uvm_active_passive_enum m_is_active = UVM_ACTIVE;
  // this determines the APB UVC mode requester or passive
  t_uvc_mode m_mode = COMPLETER;

  `uvm_object_utils_begin(moh_apb_config_class)
  `uvm_field_int   (m_has_functional_coverage             ,UVM_ALL_ON)
  `uvm_field_enum  (t_uvc_mode ,m_mode                    ,UVM_DEFAULT)
  `uvm_field_enum  (uvm_active_passive_enum ,m_is_active  ,UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name= "moh_apb_config_class");
    super.new(name);
  endfunction : new

endclass : moh_apb_config_class

`endif
