///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: apb_base_test.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_base_test
//DESCRIPTION: The apb_base_test class acts as the top-level control layer of the verification environment. It is responsible for creating and managing the environment, and coordinating the overall simulation flow.It holds a handle to the environment (apb_env) and a virtual interface, which is passed from the top module. The virtual interface allows the test to indirectly connect lower-level components like the driver and monitor to the DUT signals.
//Version: 1
//Date: 14-05-2026
//Time: 3:00 pm
//
/////////////////////////////////////
class apb_base_test;

  virtual apb_inf vif;

  apb_env env;

  apb_rand_xtn       randxtn;
  apb_directed_xtn   dirxtn;
  apb_boundary_xtn   boundxtn;
  apb_transition_xtn transxtn;
  apb_wr_rd_same_addr_xtn wrsamextn;
  apb_cov_xtn covxtn;

  //Function connect
  function void connect (virtual apb_inf vif);
    
    this.vif = vif;
    env.connect(vif);

  endfunction

  //Build
  function void build();
     
    env = new();

    env.build();

    `sv_do_on(APB_RAND_TEST,randxtn);

    `sv_do_on(APB_DIRECTED_TEST,dirxtn);
	
    `sv_do_on(APB_BOUNDARY_TEST,boundxtn);
	
    `sv_do_on(APB_TRANSITION_TEST,transxtn);
	
    `sv_do_on(APB_WR_RD_SAME_TEST,wrsamextn);
	
    `sv_do_on(APB_COV_TEST,covxtn);

  endfunction

  //Run
  task run();

    $display("==========TEST START==========");

    fork
      env.run();
    join_none
    #0;
  
  endtask
endclass
