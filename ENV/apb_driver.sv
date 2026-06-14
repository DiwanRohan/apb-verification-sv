///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME  : apb_driver.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME : apb_driver
//DESCRIPTION: Driver responsible to takes transaction or sequence level activity(stimulus) coming from generator and convert it into the pin or system level activity.Driver drives the pin or system level activity via interface (bus) as per the protocol.It basically drives input data to design adhering to the protocol.
//Version: 1
//Date: 14-04-2026
//Time: 12:00 pm
//
/////////////////////////////////////
`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

typedef enum bit [1:0] {
  IDLE,
  SETUP,
  ACCESS
} apb_state_e;

class apb_driver;

  //VIRTUAL INTERFACE
  virtual apb_if.DRV_MP vif;

  //MAILBOX
  mailbox #(apb_trans) gen2drv_mbx;

  apb_state_e state;

  //TRANSACTION HANDLE
  apb_trans trans, trans_copy;

  function void connect(mailbox#(apb_trans) gen2drv_mbx, virtual apb_if.DRV_MP vif);
    this.gen2drv_mbx = gen2drv_mbx;
    this.vif = vif;
  endfunction

  // RUN
  task run();
    forever begin
      gen2drv_mbx.get(trans);
      //this.trans.print("DRIVER");
      send2dut(trans);
      ->drv_done;
    end
  endtask

  task send2dut(apb_trans trans);

    static bit first_transfer = 1;

    if (first_transfer) begin
      @(vif.drv_cb);
      first_transfer = 0;
    end

    //RESET CONDITION
    if (apb_pkg::reset) begin
      vif.drv_cb.psel    <= 1'b0;
      vif.drv_cb.penable <= 1'b0;
    end else begin

      //-------------------------------------------------
      //SETUP PHASE
      //PSEL    = 1
      //PENABLE = 0
      //-------------------------------------------------
      vif.drv_cb.psel    <= 1'b1;
      vif.drv_cb.penable <= 1'b0;

      vif.drv_cb.pwrite  <= trans.kind_e;
      vif.drv_cb.paddr   <= trans.paddr;
      vif.drv_cb.pwdata  <= trans.pwdata;


      //-------------------------------------------------
      //ACCESS PHASE
      //PSEL    = 1
      //PENABLE = 1
      //-------------------------------------------------
      @(vif.drv_cb);
      vif.drv_cb.penable <= 1'b1;

      //-------------------------------------------------
      //WAIT STATES
      //HOLD SAME VALUES UNTIL PREADY=1
      //-------------------------------------------------
      if (vif.drv_cb.pready !== 1'b1) begin

        do begin

          @(vif.drv_cb);

          vif.drv_cb.psel    <= 1'b1;
          vif.drv_cb.penable <= 1'b1;

          vif.drv_cb.pwrite  <= trans.kind_e;
          vif.drv_cb.paddr   <= trans.paddr;
          vif.drv_cb.pwdata  <= trans.pwdata;

        end while (vif.drv_cb.pready !== 1'b1);

      end

      //ERROR CHECK
      if (vif.drv_cb.pslverr) $display("[DRV] APB ERROR DETECTED ADDR=%0h", trans.paddr);

    end

  endtask

endclass

`endif
