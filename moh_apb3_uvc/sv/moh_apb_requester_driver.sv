`ifndef __MOH_APB_REQUESTER_DRIVER
`define __MOH_APB_REQUESTER_DRIVER

class moh_apb_requester_driver extends uvm_driver #(moh_apb_seq_item);
  `uvm_component_utils(moh_apb_requester_driver)

  virtual interface moh_apb_if    m_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!apb_vif_config::get(this, "", "vif", m_vif))
      `uvm_error("NOVIF", {"virtual interface must be set for", get_full_name(),"vif"})
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    // This task is supposed to drive signals from sequence item to interface
    get_and_drive();
  endtask : run_phase

  // Gets packets from the sequencer and passes them to the driver.
  task get_and_drive();
    init_requester();
    wait (m_vif.reset === 1'h1);

    // The forever sequence keeps running until there is no sequence left to
    // be sent to the DUT
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), " Drive APB requester signals", UVM_LOW)
      // This task is supposed to drive signals from sequence item to interface
      repeat(req.m_packet_delay) @(m_vif.mon_cb);

      // T1 phase starts here
      m_vif.drv_cb.psel   <= 1'b1;
      m_vif.drv_cb.pwrite <= req.m_dir;
      m_vif.drv_cb.paddr  <= req.m_addr;

      if(req.m_dir == READ) begin
        m_vif.drv_cb.pwrite <= 1'b0;
        m_vif.drv_cb.pwdata <= 'hz;
      end else if (req.m_dir == WRITE) begin
        m_vif.drv_cb.pwdata <= req.m_pwdata;
        m_vif.drv_cb.pwrite <= 1'b1;
      end

      // T2 phase starts here
      @(m_vif.mon_cb);
      m_vif.drv_cb.psel    <= 1'b1;
      m_vif.drv_cb.paddr   <= req.m_addr;
      m_vif.drv_cb.penable <= 1'b1;

      // T3 phase starts here
      @(m_vif.mon_cb iff (m_vif.mon_cb.pready));
      m_vif.drv_cb.psel    <= 1'b0;
      m_vif.drv_cb.penable <= 1'b0;
      m_vif.drv_cb.pwrite  <= 1'b0;
      m_vif.drv_cb.pwdata  <=  'hz;
      m_vif.drv_cb.paddr   <=  'hz;

      seq_item_port.item_done(req);
    end
  endtask : get_and_drive

  virtual task  init_requester();
    m_vif.drv_cb.psel    <= 1'b0;
    m_vif.drv_cb.penable <= 1'b0;
    m_vif.drv_cb.pwrite  <= 1'b0;
    m_vif.drv_cb.pwdata  <=  'hz;
    m_vif.drv_cb.paddr   <=  'hz;
  endtask : init_requester

endclass : moh_apb_requester_driver

`endif
