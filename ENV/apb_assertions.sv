///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_assertions.sv
//AUTHOR NAME: Rohan Diwan
//MODULE NAME: apb_assertions
//DESCRIPTION: SystemVerilog Assertions (SVA) for checking APB interface protocol compliance.
//Version: 1
//Date: 25-06-2026
//Time: 12:15 pm
//
/////////////////////////////////////

`ifndef APB_ASSERTIONS_SV
`define APB_ASSERTIONS_SV

`include "apb_defines.sv"

module apb_assertions (
    input logic                   pclk,
    input logic                   prstn,
    input logic                   psel,
    input logic                   penable,
    input logic                   pwrite,
    input logic [`ADDR_WIDTH-1:0] paddr,
    input logic [`DATA_WIDTH-1:0] pwdata,
    input logic [`DATA_WIDTH-1:0] prdata,
    input logic                   pready,
    input logic                   pslverr
);

  //----------------------------------
  //ASSERTIONS
  //----------------------------------

  //Assertion 1
  //When penable is high psel should be high
  property penable_psel_check;
    @(posedge pclk) disable iff (!prstn) penable |-> psel;
  endproperty

  assert property (penable_psel_check)
  else $error("APB ASSERTION FAILED: PENABLE asserted without PSEL");

  //Assertion 2
  //SETUP should always go to ACCESS in next clock cycle
  property setup_to_access_check;
    @(posedge pclk) disable iff (!prstn) (psel && !penable) |=> penable;
  endproperty

  assert property (setup_to_access_check)
  else $error("APB ASSERTION FAILED: SETUP did not transition to ACCESS");

  //Assertion 3
  //PADDR must be stable during pready is low and in ACCESS state
  property p_addr_stable_wait;
    @(posedge pclk) disable iff (!prstn) (psel && penable && !pready) |-> $stable(
        paddr
    );
  endproperty

  assert property (p_addr_stable_wait)
  else $error("APB ASSERTION FAILED : PADDR changed during wait state");

  //Assertion 4
  //PWRITE must be stable during pready is low and in ACCESS state
  property p_write_stable_wait;
    @(posedge pclk) disable iff (!prstn) (psel && penable && !pready) |-> $stable(
        pwrite
    );
  endproperty

  assert property (p_write_stable_wait)
  else $error("APB ASSERTION FAILED : PWRITE changed during wait state");

  //Assertion 5
  //PWDATA must be stable during pready is low and in ACCESS state
  property p_pwdata_stable_wait;
    @(posedge pclk) disable iff (!prstn) (psel && penable && !pready && pwrite) |-> $stable(
        pwdata
    );
  endproperty

  assert property (p_pwdata_stable_wait)
  else $error("APB ASSERTION FAILED : PWDATA changed during write wait state");

  //Assertion 6
  //PSEL must remain high for wait states
  property p_psel_hold_wait;
    @(posedge pclk) disable iff (!prstn) (psel && penable && !pready) |-> psel;
  endproperty

  assert property (p_psel_hold_wait)
  else $error("APB ASSERTION FAILED : PSEL dropped during wait state");

  //Assertion 7
  //PENABLE must remain high for wait states
  property p_penable_hold_wait;
    @(posedge pclk) disable iff (!prstn) (psel && penable && !pready) |-> penable;
  endproperty

  assert property (p_penable_hold_wait)
  else $error("APB ASSERTION FAILED : PENABLE dropped during wait state");

  //Assertion 8
  //No unknown signal on any of the control signals
  property p_no_unknown_control;
    @(posedge pclk) disable iff (!prstn) !$isunknown(
        {psel, penable, pwrite, pready}
    );
  endproperty

  ap_no_unknown_control :
  assert property (p_no_unknown_control)
  else $error("APB ASSERTION FAILED : Unknown value detected on control signals");

  //Assertion 9
  //PSLVERR must valid only at the end of transaction
  property p_pslverr_valid;
    @(posedge pclk) disable iff (!prstn) pslverr |-> (psel && penable && pready);
  endproperty

  assert property (p_pslverr_valid)
  else $error("APB ASSERTION FAILED : PSLVERR asserted outside valid transfer completion");

  //Assertion 10
  //When reset happens psel and penable should be low
  property p_reset_behavior;
    @(posedge pclk) !prstn |-> (!psel && !penable);
  endproperty

  assert property (p_reset_behavior)
  else $error("APB ASSERTION FAILED : Invalid signal values during reset");

  //Assertion 11
  //ACCESS should come after SETUP
  property p_access_after_setup;
    @(posedge pclk) disable iff (!prstn) penable |-> $past(
        psel
    );
  endproperty

  assert property (p_access_after_setup)
  else $error("APB ASSERTION FAILED : ACCESS occurred without prior SETUP");

  //Assertion 12
  //IDLE state conditions check
  property p_idle_state_valid;
    @(posedge pclk) disable iff (!prstn) !psel |-> !penable;
  endproperty

  assert property (p_idle_state_valid)
  else $error("APB ASSERTION FAILED : Invalid IDLE state");

endmodule

`endif
