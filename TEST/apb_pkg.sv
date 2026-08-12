///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_base_test.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_base_test
//DESCRIPTION: this includes all files of environment
//Version: 1
//Date: 21-04-2026
//Time: 10:00 am
//
/////////////////////////////////////

package apb_pkg;

  event reset_start_ev;
  event reset_done_ev;
  event drv_done;
  event mon_done;
  event scb_done;

  //definitions
  `include "apb_defines.sv"

  int raise_ctr = 0;
  bit reset = 0;

  function automatic void raise_objection();
    raise_ctr++;
    $display("[OBJECTION] Raised -> count = %0d", raise_ctr);
  endfunction

  function automatic void drop_objection();
    raise_ctr--;
    $display("[OBJECTION] Dropped -> count = %0d", raise_ctr);
  endfunction


  //base class
  `include "sv_sequence_item.sv"

  //transaction
  `include "apb_trans.sv"

  //testcases
  `include "apb_gen_base.sv"
  `include "apb_rand_xtn.svh"
  `include "apb_sanity_xtn.svh"
  `include "apb_boundary_xtn.svh"
  `include "apb_transition_xtn.svh"
  `include "apb_wr_rd_same_xtn.svh"
  `include "apb_cov_xtn.svh"
  `include "apb_reset_xtn.svh"
  `include "apb_error_xtn.svh"


  //components
  `include "apb_driver.sv"
  `include "apb_monitor.sv"
  `include "apb_ref_model.sv"
  `include "apb_coverage.sv"
  `include "apb_scoreboard.sv"

  //environment
  `include "apb_env.sv"

  //test
  `include "apb_base_test.sv"


endpackage

