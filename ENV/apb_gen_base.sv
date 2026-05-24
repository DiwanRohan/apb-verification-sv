///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: apb_gen.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_gen
//DESCRIPTION: Responsible for stimulus/traffic (transaction items) generation and keep the same in mailbox which is further processed by driver i.e., stimulus generation could be through randomization (preferred), through a file, hardcoded values, DPI etc.
//Version: 1
//Date: 14-05-2026
//Time: 10:00 pm
//
/////////////////////////////////////

import apb_pkg::*;

virtual class apb_gen_base;

  local mailbox #(apb_trans) gen2drv_mbx;

  //rand int no_of_trans;

  //constraint NO_OF_TRANS_C {soft no_of_trans == 50;}

  apb_trans trans;

  function void connect(mailbox #(apb_trans) mbx);

    this.gen2drv_mbx = mbx;   
    
  endfunction

  //abstract run
  pure virtual task run();

  protected task send_item();

    this.gen2drv_mbx.put(trans);

    //this.trans.print("GENERATOR");

    @(drv_done);
    //@(scb_done);


  endtask

  function void print(string id = "");

    this.trans.print(id);

  endfunction

endclass
