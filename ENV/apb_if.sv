///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_if.sv
//AUTHOR NAME: Rohan Diwan
//INTERFACE NAME: apb_if
//DESCRIPTION: This file contains the interface and modports for the project RAM_verification, it also defines a clocking block which will defining the input and output skew which will tell us when the sampling and driving will happen during posedge.
//Version: 1
//Date: 14-04-2026
//Time: 12:15 pm
//
/////////////////////////////////////

//Guard Statement to avoid multiple compilation of a file
`ifndef APB_INF_SV
`define APB_INF_SV

`include "apb_defines.sv"

interface apb_if (
    input logic pclk
);

  //ACTIVE LOW RESET SIGNAL
  logic                   prstn;

  //APB CONTROL SIGNALS
  logic                   psel;
  logic                   penable;
  logic                   pwrite;

  //APB ADDRESS/DATA
  logic [`ADDR_WIDTH-1:0] paddr;
  logic [`DATA_WIDTH-1:0] pwdata;
  logic [`DATA_WIDTH-1:0] prdata;
  logic [(`DATA_WIDTH/8)-1:0] pstrb;

  //APB SLAVE SIGNALS
  logic                   pready;
  logic                   pslverr;


  //DRIVER CLOCKING BLOCK
  clocking drv_cb @(posedge pclk);

    default input #1 output #1;

    //DRIVEN TO DUT
    output prstn;

    output psel;
    output penable;
    output pwrite;

    output paddr;
    output pwdata;
    output pstrb;

    //SAMPLED FROM DUT
    input prdata;
    input pready;
    input pslverr;

  endclocking

  //MONITOR CLOCKING BLOCK
  clocking mon_cb @(posedge pclk);

    default input #1;

    input prstn;

    input psel;
    input penable;
    input pwrite;

    input paddr;
    input pwdata;
    input pstrb;

    input prdata;
    input pready;
    input pslverr;

  endclocking

  //MODPORTS
  modport DRV_MP(clocking drv_cb);

  modport MON_MP(clocking mon_cb);

endinterface

`endif
