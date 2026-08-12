///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME  : apb_ref_model.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME : apb_ref_model
//DESCRIPTION: Reference model is a verification component where you write a logic to generate expected output (checker logics). (Predicting the output). Also known as predictor.
//Version: 1
//Date: 14-05-2026
//Time: 12:30 pm
//
/////////////////////////////////////

import apb_pkg::*;

class apb_ref_model;

  //Mailbox declarations
  mailbox #(apb_trans)                   mon2ref_mbx;
  mailbox #(apb_trans)                   ref2scb_mbx;

  //Transaction handle of type apb_trans
  apb_trans                              trans;

  //Reference Memory
  reg                  [`DATA_WIDTH-1:0] mem             [`DEPTH];
  integer                                i;
  bit                  [`DATA_WIDTH-1:0] prev_exp_prdata;
  bit                  [`ADDR_WIDTH-1:0] prev_paddr;
  bit                                    prev_kind_e;

  //Connecting mailboxes
  function void connect(mailbox#(apb_trans) mon2ref_mbx, mailbox#(apb_trans) ref2scb_mbx);

    this.mon2ref_mbx = mon2ref_mbx;
    this.ref2scb_mbx = ref2scb_mbx;

  endfunction

  //Run function
  task run();
    fork
      forever begin
        mon2ref_mbx.get(trans);
        predict_exp_prdata(trans);
        ref2scb_mbx.put(trans.clone());
        //this.trans.print("REFERENCE MODEL");
      end
      forever begin
        @(apb_pkg::reset_start_ev);
        $display("[%0t] [REF] Reset detected, clearing reference memory", $time);
        for (i = 0; i < `DEPTH; i++) mem[i] = 0;
      end
    join
  endtask

  //Predicting expected prdata
  task predict_exp_prdata(apb_trans t);

    //t.exp_prdata = prev_exp_prdata;

    if (apb_pkg::reset) begin
      t.prdata = 0;
      t.pslverr = 0;
      for (i = 0; i < `DEPTH; i++) mem[i] = 0;
    end else begin
      t.pslverr = (t.paddr >= `DEPTH);
      if (t.kind_e == READ) begin
        if (t.paddr < `DEPTH) t.prdata = mem[t.paddr];
        else t.prdata = '0;
      end else begin
        if (t.paddr < `DEPTH) begin
          if (t.pstrb[0]) mem[t.paddr][7:0]   = t.pwdata[7:0];
          if (t.pstrb[1]) mem[t.paddr][15:8]  = t.pwdata[15:8];
          if (t.pstrb[2]) mem[t.paddr][23:16] = t.pwdata[23:16];
          if (t.pstrb[3]) mem[t.paddr][31:24] = t.pwdata[31:24];
        end
      end
    end
  endtask


endclass
