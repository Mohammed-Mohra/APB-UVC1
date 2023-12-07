`ifndef __MOH_APB_SEQ_ITEM
`define __MOH_APB_SEQ_ITEM

class moh_apb_seq_item extends uvm_sequence_item;

  rand logic  [31:0]  m_select; // this to select which completer to select from incase there are many completer. This functionality is not added to the uvc
  rand logic  [31:0]  m_addr;
  rand t_dir          m_dir;  // This is for the direction of the transaction whether its READ or WRITE
  rand logic  [31:0]  m_pwdata;
  rand logic  [31:0]  m_prdata;
  rand t_resp         m_pslverr;
  rand int            m_packet_delay;
  rand int            m_delay_ready;

  `uvm_object_utils_begin(moh_apb_seq_item)
  `uvm_field_int  (         m_select,       UVM_ALL_ON)
  `uvm_field_int  (         m_addr,         UVM_ALL_ON)
  `uvm_field_enum (t_dir,   m_dir,          UVM_ALL_ON)
  `uvm_field_int  (         m_pwdata,       UVM_ALL_ON)
  `uvm_field_int  (         m_prdata,       UVM_ALL_ON)
  `uvm_field_int  (         m_delay_ready,  UVM_ALL_ON)
  `uvm_field_enum (t_resp,  m_pslverr,      UVM_ALL_ON)
  `uvm_field_int  (         m_packet_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new( string name = "moh_apb_seq_item");
    super.new(name);
  endfunction : new

  // All the members of the sequence item are randomised. This constraint
  // comes to determine the constraints and the intervals in which we want
  // to randomize our properties
  constraint packet_delay {m_packet_delay >=0; m_packet_delay<10;}
  constraint delay_ready  {m_delay_ready >=0; m_delay_ready<10;}
  constraint slver        {m_pslverr dist {GOOD_RESP :=80, BAD_RESP:=20};}

  virtual function moh_apb_seq_item clone();
    clone = moh_apb_seq_item::type_id::create("moh_apb_seq_item");
    clone.copy(this);
  endfunction : clone

endclass : moh_apb_seq_item

`endif
