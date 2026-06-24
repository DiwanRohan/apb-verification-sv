///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_trans.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_trans
//DESCRIPTION: This is the transaction packet of the SV Environment which is responsible for defining the rand variables for inputs to dut and constraints on them while also defining all the other ports.
//Version: 1
//Date: 14-05-2026
//Time: 9:30 am
//
/////////////////////////////////////

`ifndef APB_TRANS_SV
`define APB_TRANS_SV

`include "apb_defines.sv"

typedef enum bit {
  WRITE = 1'b1,
  READ  = 1'b0
} trans_kind_e;

//Child class consisting all the methods of class sv_sequence_item which are copy, clone, print
class apb_trans extends sv_sequence_item;

  // type of operation
  rand trans_kind_e kind_e;

  rand bit [`ADDR_WIDTH-1:0] paddr;
  rand bit [`DATA_WIDTH-1:0] pwdata;

  bit [`DATA_WIDTH-1:0] prdata;

  bit pslverr;
  int wait_cycles;


  function void copy(sv_sequence_item rhs);  //This is deep copy for handle
    apb_trans t;

    if (!$cast(t, rhs)) begin
      $display("CAST FAILED");
      return;
    end

    this.kind_e     = t.kind_e;
    this.paddr      = t.paddr;
    this.pwdata     = t.pwdata;
    this.prdata     = t.prdata;
    this.pslverr    = t.pslverr;

  endfunction

  function apb_trans clone();

    apb_trans t_copy = new();

    t_copy.copy(this);

    return t_copy;

  endfunction
  /*
  function void post_randomize();

    if(kind_e == WRITE)
      pwrite = 1'b1;

    else
      pwrite = 1'b0;

  endfunction
*/

  function void print(string id = "");

    $display("--------------------------------------------------");
    $display("[%0t] %s", $time, id);
    $display("--------------------------------------------------");
    $display("TRANS_KIND = %0s", kind_e);
    $display("PADDR      = %0h", paddr);

    if (kind_e == WRITE) $display("PWDATA     = %0h", pwdata);
    else $display("PRDATA     = %0h", prdata);

    $display("PSLVERR    = %0b", pslverr);

    $display("--------------------------------------------------");
    $display("");

  endfunction

endclass

`endif

