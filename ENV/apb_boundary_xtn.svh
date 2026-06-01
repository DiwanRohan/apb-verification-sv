import apb_pkg::*;

class apb_boundary_xtn extends apb_gen_base;

  task run();

    apb_pkg::raise_objection();

    repeat (`NUM_TRANSACTIONS) begin

      `SV_DO_WITH(trans, {paddr inside {0, `ADDR_MAX}; pwdata inside {0, `DATA_MAX};})

    end

    apb_pkg::drop_objection();

  endtask

endclass
