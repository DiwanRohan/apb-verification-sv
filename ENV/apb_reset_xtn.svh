// apb_reset_xtn.svh
// Verification sequence item that performs writes, reads, triggers reset, and verifies reset recovery.

import apb_pkg::*;

class apb_reset_xtn extends apb_gen_base;

  task run();

    apb_trans wr_trans;
    apb_trans rd_trans;
    apb_trans rst_trans;
    bit [`ADDR_WIDTH-1:0] test_addr = 16'h0004;

    apb_pkg::raise_objection();

    // 1. Perform a Write transaction to test_addr
    wr_trans = new();
    trans = wr_trans;
    wr_trans.kind_e = WRITE;
    wr_trans.paddr  = test_addr;
    wr_trans.pwdata = 32'hDEAD_BEEF;
    wr_trans.pstrb  = 4'b1111;
    $display("[%0t] [GEN] Sending Write to 0x%0h with data 0x%0h", $time, wr_trans.paddr, wr_trans.pwdata);
    send_item();

    // 2. Read back from test_addr to confirm write succeeded
    rd_trans = new();
    trans = rd_trans;
    rd_trans.kind_e = READ;
    rd_trans.paddr  = test_addr;
    rd_trans.pstrb  = 4'b0000;
    $display("[%0t] [GEN] Sending Read to 0x%0h to verify write", $time, rd_trans.paddr);
    send_item();

    // 3. Issue RESET command to trigger on-the-fly reset
    rst_trans = new();
    trans = rst_trans;
    rst_trans.kind_e = RESET;
    $display("[%0t] [GEN] Sending RESET transaction", $time);
    send_item();

    // 4. Read back from test_addr post-reset. Expected data is 32'h0
    rd_trans = new();
    trans = rd_trans;
    rd_trans.kind_e = READ;
    rd_trans.paddr  = test_addr;
    rd_trans.pstrb  = 4'b0000;
    $display("[%0t] [GEN] Sending Read to 0x%0h post-reset (expecting 0)", $time, rd_trans.paddr);
    send_item();

    // 5. Perform another Write post-reset
    wr_trans = new();
    trans = wr_trans;
    wr_trans.kind_e = WRITE;
    wr_trans.paddr  = test_addr;
    wr_trans.pwdata = 32'hCAFE_BABE;
    wr_trans.pstrb  = 4'b1111;
    $display("[%0t] [GEN] Sending Write to 0x%0h post-reset with data 0x%0h", $time, wr_trans.paddr, wr_trans.pwdata);
    send_item();

    // 6. Read back to confirm post-reset write succeeded
    rd_trans = new();
    trans = rd_trans;
    rd_trans.kind_e = READ;
    rd_trans.paddr  = test_addr;
    rd_trans.pstrb  = 4'b0000;
    $display("[%0t] [GEN] Sending Read to 0x%0h to verify post-reset write", $time, rd_trans.paddr);
    send_item();

    apb_pkg::drop_objection();

  endtask

endclass
