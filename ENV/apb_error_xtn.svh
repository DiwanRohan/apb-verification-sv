// apb_error_xtn.svh
// Verification sequence item that generates normal and out-of-bounds (error-triggering) transactions.

import apb_pkg::*;

class apb_error_xtn extends apb_gen_base;

  task run();

    apb_trans wr_trans;
    apb_trans rd_trans;

    apb_pkg::raise_objection();

    // 1. Write to valid address (< 32768)
    wr_trans = new();
    trans = wr_trans;
    wr_trans.kind_e = WRITE;
    wr_trans.paddr  = 16'h0004;
    wr_trans.pwdata = 32'hAAAA_BBBB;
    wr_trans.pstrb  = 4'b1111;
    $display("[%0t] [GEN] Sending Valid Write: ADDR=0x%0h Data=0x%0h", $time, wr_trans.paddr, wr_trans.pwdata);
    send_item();

    // 2. Read back from valid address (expect pslverr = 0)
    rd_trans = new();
    trans = rd_trans;
    rd_trans.kind_e = READ;
    rd_trans.paddr  = 16'h0004;
    rd_trans.pstrb  = 4'b0000;
    $display("[%0t] [GEN] Sending Valid Read: ADDR=0x%0h", $time, rd_trans.paddr);
    send_item();

    // 3. Write to invalid address (>= 32768)
    wr_trans = new();
    trans = wr_trans;
    wr_trans.kind_e = WRITE;
    wr_trans.paddr  = 16'h8000; // 32768
    wr_trans.pwdata = 32'hCCCC_DDDD;
    wr_trans.pstrb  = 4'b1111;
    $display("[%0t] [GEN] Sending Invalid Write: ADDR=0x%0h Data=0x%0h (expecting PSLVERR)", $time, wr_trans.paddr, wr_trans.pwdata);
    send_item();

    // 4. Read from invalid address (>= 32768, expect pslverr = 1)
    rd_trans = new();
    trans = rd_trans;
    rd_trans.kind_e = READ;
    rd_trans.paddr  = 16'h8000;
    rd_trans.pstrb  = 4'b0000;
    $display("[%0t] [GEN] Sending Invalid Read: ADDR=0x%0h (expecting PSLVERR)", $time, rd_trans.paddr);
    send_item();

    apb_pkg::drop_objection();

  endtask

endclass
