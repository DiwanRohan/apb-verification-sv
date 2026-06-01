import apb_pkg::*;

class apb_directed_xtn extends apb_gen_base;

  //apb_trans trans;

  task write(bit [`ADDR_WIDTH-1:0] addr, bit [`DATA_WIDTH-1:0] data);

    trans.kind_e = WRITE;
    trans.paddr  = addr;
    trans.pwdata = data;
  endtask

  task read(bit [`ADDR_WIDTH-1:0] addr);
    trans.kind_e = READ;
    trans.paddr  = addr;
  endtask


  task run();

    trans = new();

    apb_pkg::raise_objection();

    write(16'hABCD, 16'h1234);
    send_item();

    write(16'hBCDE, 16'h4567);
    send_item();

    read(16'hABCD);
    send_item();

    read(16'hBCDE);
    send_item();

    //@mon_done;
    //#50;
    apb_pkg::drop_objection();

  endtask

endclass

