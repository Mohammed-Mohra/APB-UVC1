`ifndef __MOH_APB_COMPLETER_DRIVER
`define __MOH_APB_COMPLETER_DRIVER

class moh_apb_completer_driver extends uvm_driver #(moh_apb_seq_item);
  `uvm_component_utils(moh_apb_completer_driver)

  virtual interface moh_apb_if m_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!apb_vif_config::get(this, "", "vif", m_vif))
      `uvm_error("NOVIF", {"virtual interface must be set for", get_full_name(),"vif"})
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    get_and_drive();
  endtask : run_phase

  task get_and_drive();
    init_completer();
    forever begin
      // The port will get the transaction from the sequencer
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), "Drive APB completer signals", UVM_HIGH)
      repeat(req.m_delay_ready)
      @(m_vif.mon_cb);
      // T2 the Pready goes high
      m_vif.drv_cb.pready <= 1'b1;
      if (req.m_dir == WRITE) begin
        m_vif.drv_cb.prdata <= 'hz;
      end else begin
        m_vif.drv_cb.prdata <= req.m_prdata;
      end

      // T3 Signals are reset in this phase
      @( m_vif.mon_cb);
      m_vif.drv_cb.pready <= 1'b0;
      m_vif.drv_cb.prdata <= 'hz;
      seq_item_port.item_done(req);
    end
  endtask : get_and_drive

  task init_completer();
    m_vif.pready <= 1'b0;
  endtask

endclass : moh_apb_completer_driver

`endif
