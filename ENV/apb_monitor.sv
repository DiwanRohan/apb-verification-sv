///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME  : apb_monitor.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME : apb_monitor
//DESCRIPTION: Monitor is responsible to take pin or system level activity coming from bus (interface) and convert it into the transaction or sequence level activity.Monitor collect transaction or sequence level activity from interface (bus) as per the protocol.It basically sample/monitor interface data adhering to the protocol and send it to other component (i.e. scoreboard, reference model/predictor, coverage collector etc.)
//Version: 1
//Date: 14-05-2026
//Time: 12:30 pm
//
/////////////////////////////////////
import apb_pkg::*;

class apb_monitor;

  mailbox #(apb_trans) mon2ref_mbx;
  mailbox #(apb_trans) mon2scb_mbx;

  virtual apb_if.MON_MP vif;

  apb_trans item_collected;

  int mon_count = 0;

  function void connect(mailbox#(apb_trans) mon2ref_mbx, mailbox#(apb_trans) mon2scb_mbx,
                        virtual apb_if.MON_MP vif);

    this.mon2ref_mbx = mon2ref_mbx;
    this.mon2scb_mbx = mon2scb_mbx;
    this.vif         = vif;

  endfunction


  task monitor();
    forever begin

      @(vif.mon_cb);

      if (vif.mon_cb.psel && vif.mon_cb.penable) begin

        item_collected = new();

        item_collected.paddr   = vif.mon_cb.paddr;
        item_collected.kind_e  = vif.mon_cb.pwrite ? WRITE : READ;
        item_collected.pslverr = vif.mon_cb.pslverr;

        while (vif.mon_cb.psel && vif.mon_cb.penable && !vif.mon_cb.pready) begin
          item_collected.wait_cycles++;
          @(vif.mon_cb);
        end

        if (item_collected.wait_cycles > 0)
          $display("Wait Cycles started and count = %0d", item_collected.wait_cycles);

        if (vif.mon_cb.pwrite) item_collected.pwdata = vif.mon_cb.pwdata;
        else item_collected.prdata = vif.mon_cb.prdata;

        //->mon_done;

        //item_collected.print("MONITOR");

        mon2ref_mbx.put(item_collected);
        mon2scb_mbx.put(item_collected);

        @(vif.mon_cb iff !vif.mon_cb.penable);

      end
    end
  endtask


  task run();
    monitor();
  endtask

endclass

/*

import apb_pkg::*;

class apb_monitor;

  //Mailbox declarations
  mailbox #(apb_trans) mon2ref_mbx;
  mailbox #(apb_trans) mon2scb_mbx;

  //Virtual Inteface to collect signals from dut
  virtual apb_if.MON_MP vif;

  //Connect function to connect the mailboxes
  function void connect (mailbox #(apb_trans) mon2ref_mbx, mailbox #(apb_trans) mon2scb_mbx, virtual apb_if.MON_MP vif);

    this.mon2ref_mbx = mon2ref_mbx;
    this.mon2scb_mbx = mon2scb_mbx;
    this.vif         = vif;

  endfunction

  //Handle of type apb_trans
  apb_trans item_collected;

  //Monitor function to collect signals from dut and assign it to item_collected packet
  task monitor();

    @(vif.mon_cb);

    if(vif.mon_cb.psel && vif.mon_cb.penable) begin

      item_collected.psel    = vif.mon_cb.psel;
      item_collected.penable = vif.mon_cb.penable;
      item_collected.pready  = vif.mon_cb.pready;

      item_collected.paddr   = vif.mon_cb.paddr;
      item_collected.pwrite  = vif.mon_cb.pwrite;

      if(vif.mon_cb.pwrite)
        item_collected.pwdata  = vif.mon_cb.pwdata;
      else
        item_collected.prdata  = vif.mon_cb.prdata;

      item_collected.pslverr = vif.mon_cb.pslverr;

    end

  endtask

  //RUN task for running the monitor
  task run();

    forever begin//(

      //Object creation for handle item_collected
      item_collected = new();

      //Receiving signals from dut and assigning them to item_collected object
      monitor();


      //Sending the object with all signals to reference model and scoreboard
      if(vif.mon_cb.pready) begin//(

        this.item_collected.print("MONITOR");

        mon2ref_mbx.put(item_collected);

        mon2scb_mbx.put(item_collected);

      end//)

    end//)

  endtask

endclass
*/

