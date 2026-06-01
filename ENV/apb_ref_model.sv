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

    forever begin

      mon2ref_mbx.get(trans);

      predict_exp_prdata(trans);

      ref2scb_mbx.put(trans.clone());

      //this.trans.print("REFERENCE MODEL");

    end
  endtask

  //Predicting expected prdata
  task predict_exp_prdata(apb_trans t);

    //t.exp_prdata = prev_exp_prdata;

    if (!t.prstn) begin

      t.exp_prdata = 0;

      for (i = 0; i < `DEPTH; i++) mem[i] = 0;
    end else begin

      if (t.kind_e == READ) t.exp_prdata = mem[t.paddr];

      else mem[t.paddr] = t.pwdata;
    end
  endtask


endclass
