import apb_pkg::*;

class apb_transition_xtn extends apb_gen_base;

    task run();

        apb_pkg::raise_objection();

        repeat(`NUM_TRANSACTIONS/2) begin

            //WRITE
            `sv_do_with(trans, {kind_e == WRITE;})

            //READ
            `sv_do_with(trans, {kind_e == READ;})
        end

        apb_pkg::drop_objection();

    endtask

endclass