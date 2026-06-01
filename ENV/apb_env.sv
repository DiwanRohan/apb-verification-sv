///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_env.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_env
//DESCRIPTION: It takes handles of all the verification sub-components, it decalres all the mailboxes, and all the interfaces, it creates everything using the method build, it then takes connect method to call the verification sub-components and finally using the run method it makes all the verification sub-components to run task in parallel
//Version: 1
//Date: 14-05-2026
//Time: 2:30 pm
//
/////////////////////////////////////

import apb_pkg::*;

class apb_env;

  //Components
  apb_gen_base gen;
  apb_driver drv;
  apb_monitor mon;
  apb_ref_model rm;
  apb_scoreboard scb;
  apb_coverage cov;

  //Virtual Inteface
  virtual apb_if.DRV_MP vif;
  virtual apb_if.MON_MP vifm;

  //Mailboxes
  mailbox #(apb_trans) gen2drv_mbx;
  mailbox #(apb_trans) mon2ref_mbx;
  mailbox #(apb_trans) mon2scb_mbx;
  mailbox #(apb_trans) ref2scb_mbx;

  //Build
  function build();
    drv = new();
    mon = new();
    rm = new();
    scb = new();
    cov = new();

    gen2drv_mbx = new();
    mon2ref_mbx = new();
    mon2scb_mbx = new();
    ref2scb_mbx = new();

  endfunction

  //Connect
  function void connect(virtual apb_if vif);

    this.vif  = vif;
    this.vifm = vif;
    gen.connect(gen2drv_mbx);
    drv.connect(gen2drv_mbx, vif);
    mon.connect(mon2ref_mbx, mon2scb_mbx, vif);
    rm.connect(mon2ref_mbx, ref2scb_mbx);
    scb.connect(mon2scb_mbx, ref2scb_mbx, cov);

  endfunction

  //Run function
  task run();

    fork
      gen.run();
      drv.run();
      mon.run();
      rm.run();
      scb.run();
    join_none

  endtask

endclass
