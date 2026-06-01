import apb_pkg::*;

class apb_rand_xtn extends apb_gen_base;

  task run();

    apb_pkg::raise_objection();

    repeat (`NUM_TRANSACTIONS) begin

      `SV_DO(trans)

    end

    apb_pkg::drop_objection();

  endtask

endclass
