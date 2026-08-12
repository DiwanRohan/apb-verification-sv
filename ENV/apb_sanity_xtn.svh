// apb_sanity_xtn.svh
// Verification sequence item that generates directed write and read transactions as a basic sanity check.

import apb_pkg::*;

class apb_sanity_xtn extends apb_gen_base;

  task write(bit [`ADDR_WIDTH-1:0] addr, bit [`DATA_WIDTH-1:0] data);
    trans.kind_e = WRITE;
    trans.paddr  = addr;
    trans.pwdata = data;
    trans.pstrb  = 4'b1111;
  endtask

  task read(bit [`ADDR_WIDTH-1:0] addr);
    trans.kind_e = READ;
    trans.paddr  = addr;
    trans.pstrb  = 4'b0000;
  endtask

  task run();

    trans = new();

    apb_pkg::raise_objection();

    write(16'hABCD, 32'h1234_5678);
    send_item();

    write(16'hBCDE, 32'hABCD_EF01);
    send_item();

    read(16'hABCD);
    send_item();

    read(16'hBCDE);
    send_item();

    // 1. Write partial word (lower 16 bits only) to 16'hABCD
    trans = new();
    trans.kind_e = WRITE;
    trans.paddr  = 16'hABCD;
    trans.pwdata = 32'h5555_AAAA;
    trans.pstrb  = 4'b0011; // Write lower 2 bytes only
    $display("[%0t] [GEN] Sending Partial Write (Lower 16-bit): ADDR=16'hABCD Data=32'h5555_AAAA PSTRB=4'b0011", $time);
    send_item();

    // Read back from 16'hABCD. Expected data is 32'h1234_AAAA
    read(16'hABCD);
    send_item();

    // 2. Write partial word (upper 16 bits only) to 16'hBCDE
    trans = new();
    trans.kind_e = WRITE;
    trans.paddr  = 16'hBCDE;
    trans.pwdata = 32'h1111_2222;
    trans.pstrb  = 4'b1100; // Write upper 2 bytes only
    $display("[%0t] [GEN] Sending Partial Write (Upper 16-bit): ADDR=16'hBCDE Data=32'h1111_2222 PSTRB=4'b1100", $time);
    send_item();

    // Read back from 16'hBCDE. Expected data is 32'h1111_EF01
    read(16'hBCDE);
    send_item();

    apb_pkg::drop_objection();

  endtask

endclass
