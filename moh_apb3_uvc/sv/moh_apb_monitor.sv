`ifndef __MOH_APB_MONITOR
`define __MOH_APB_MONITOR

class moh_apb_monitor extends uvm_monitor;
  `uvm_component_utils(moh_apb_monitor)

  moh_apb_seq_item  m_seq_item;

  //Analysis Ports
  uvm_analysis_port#(moh_apb_seq_item)  m_item_collected_port;
  uvm_analysis_port #(moh_apb_seq_item) m_request_port; //parial
  virtual interface moh_apb_if m_vif;

  int           delay_valid = 0;
  int           delay_ready = 0;
  logic [31:0]  cov_ascii_addr, cov_apb_addr, cov_pwdata, cov_prdata;
  logic         cov_dir;
  logic [8:0]   cov_sof, cov_eof;
  t_resp        cov_pslverr;

  //This covergroup is specific for the ascii register module
  //It checks if all the possibilites of sof and eof register were covered
  covergroup cov_sof_eof;
    cp_sof :  coverpoint cov_sof {
       bins sof_bins[256] = {[0:255]};
     }
     cp_eof :  coverpoint cov_eof {
       bins eof_bins[256] = {[0:255]};
     }
  endgroup : cov_sof_eof

  //This covergroup is generic for the APB UVC
  //it checks properties of APB Bus module
  //like did we get a write transfer without wait states, read transfer
  //wait states etc.
   covergroup cv_signal;
     prdata : coverpoint cov_prdata {
       bins apb_prdata[256] = {[0:256]};
     }
     // This is a generic coverpoint for apb
     apb_addr : coverpoint cov_apb_addr {
       bins apb_addresses[256] = {[0:255]};
     }
     // This is a coverpoint specificlly for ascii_register bank
     ascii_addr : coverpoint cov_ascii_addr {
       // These legal bins are the addresses for ascii_register bank
       bins         reg_addresses []  = {0,2,4,6,8,10};
       illegal_bins non_reg_addresses = {1,3,5,7,9 ,[11:$]};
     }
     dir     : coverpoint cov_dir;
     pslverr : coverpoint cov_pslverr;
     delay_valid : coverpoint delay_valid{
       bins zero               = {0};
       bins one                = {1};
       bins two                = {2};
       bins three              = {3};
       bins four               = {4};
       bins five_to_ten        = {[5:10]};
       bins ten_to_twenty      = {[11:20]};
       bins bigger_than_twenty = {[20:$]};
     }
     delay_ready : coverpoint delay_ready{
       bins zero               = {0};
       bins one                = {1};
       bins two                = {2};
       bins three              = {3};
       bins four               = {4};
       bins five_to_ten        = {[5:10]};
       bins ten_to_twenty      = {[11:20]};
       bins bigger_than_twenty = {[20:$]};
     }
     cross_valid_dir           : cross delay_valid , dir;
     cross_ready_dir           : cross delay_ready , dir;
     cross_pslverr_dir         : cross pslverr     , dir;
     cross_apb_address_ready   : cross delay_ready , ascii_addr;
     cross_apb_address_valid   : cross delay_valid , ascii_addr ;
     cross_ascii_address_valid : cross delay_valid , apb_addr;
     cross_ascii_address_ready : cross delay_ready , apb_addr;
   endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    m_request_port = new("m_request_port", this);
    m_item_collected_port = new("m_item_collected_port", this);
    cv_signal   = new();
    cov_sof_eof = new();
  endfunction : new

  function void build_phase(uvm_phase phase);
    if(!apb_vif_config::get(this, get_full_name(), "vif", m_vif))
      `uvm_error("NOVIF", { "virtual interface must be set for: ", get_full_name(), "vif"})
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    process _trans_wait;
    process _delay;
    forever begin
      wait(m_vif.reset == 1'b1);// built in function

      fork
        begin
          _trans_wait = process::self();
          monitor_trans();
        end
        begin
          _delay = process::self();
          monitor_delay_cv();
        end

        wait(m_vif.reset == 1'b0);
      join_any

      _trans_wait.kill();
      _delay.kill();
    end
  endtask : run_phase

  // This function measures the delay of the valid and the delay in the ready
  // The delay of the valid is the delay of the T1 phase to happen
  // The delay of the ready is the delay of the T2 phase to happen
  // There should not be any delin the third phase
  task monitor_delay_cv();
    forever begin
      @(m_vif.mon_cb);
      if(m_vif.mon_cb.psel == 1'b0)
        delay_valid++;
      if(m_vif.mon_cb.psel == 1'b1 && m_vif.mon_cb.penable == 1'b1 && m_vif.mon_cb.pready == 1'b0) // there is neve a delay in the ready from the dut
        delay_ready++;
      if(m_vif.mon_cb.psel == 1'b1 && m_vif.mon_cb.penable == 1'b1 && m_vif.mon_cb.pready == 1'b1) begin
        cv_signal.sample();
        delay_valid = 0;
        delay_ready = 0;
      end
    end
  endtask : monitor_delay_cv

  task monitor_trans();
    forever begin
      m_seq_item = moh_apb_seq_item::type_id::create("m_seq_item", this);

      //this should start recording the transaction
      void'(begin_tr(m_seq_item, "Monitor_apb_transaction"));

      @(m_vif.mon_cb iff( m_vif.mon_cb.psel  & ~m_vif.mon_cb.penable  ));
      if(m_vif.mon_cb.pwrite)begin
        m_seq_item.m_dir = WRITE;
      end else if(m_vif.mon_cb.pwrite == 1'b0)begin
        m_seq_item.m_dir = READ;
      end

      //m_request_port writes to sequencer
      `uvm_info(get_type_name(), "Writing to request port", UVM_HIGH)
      m_request_port.write(m_seq_item.clone());

      @(m_vif.mon_cb iff(m_vif.mon_cb.pready));
      m_seq_item.m_prdata  = m_vif.mon_cb.prdata;
      m_seq_item.m_addr    = m_vif.mon_cb.paddr;
      m_seq_item.m_pwdata  = m_vif.mon_cb.pwdata;
      cov_dir              = m_seq_item.m_dir;
      cov_ascii_addr       = m_seq_item.m_addr;
      cov_apb_addr         = m_seq_item.m_addr;
      cov_pwdata           = m_seq_item.m_pwdata;
      cov_prdata           = m_seq_item.m_prdata;


      // This part is for handling error response
      if(m_vif.mon_cb.pslverr)begin
        m_seq_item.m_pslverr = BAD_RESP;
      end else begin
        m_seq_item.m_pslverr = GOOD_RESP;
      end
      cov_pslverr = m_seq_item.m_pslverr;

      if(m_seq_item.m_addr == 8'h4 && m_seq_item.m_dir == WRITE) begin
        cov_sof = m_seq_item.m_pwdata;
      end else if(m_seq_item.m_addr == 8'h6 && m_seq_item.m_dir == WRITE)begin
        cov_eof = m_seq_item.m_pwdata;
      end

      // Here we sample different cover points to see if their value
      // changed or remained the same
      `uvm_info(get_type_name(), "Sampling coverpoints for coverage", UVM_HIGH)
      cv_signal.sample();
      cov_sof_eof.sample();

      end_tr(m_seq_item);
      m_item_collected_port.write(m_seq_item.clone());
    end
  endtask : monitor_trans

endclass

`endif
