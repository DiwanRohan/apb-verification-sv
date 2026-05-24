import apb_pkg::*;

class apb_cov_xtn extends apb_gen_base;

    bit [`ADDR_WIDTH-1:0] addr;

    task run();

        apb_pkg::raise_objection();

        // =====================================================
        // ADDRESS + KIND + DATA + TRANSITION COVERAGE
        // =====================================================

        repeat(50) begin

            // LOW RANGE WRITE
            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr inside {[0:(`ADDR_MAX/4)-1]};
                pwdata inside {[0:(`DATA_MAX/4)-1]};
            })

            // LOWMID RANGE WRITE
            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/4):(`ADDR_MAX/2)-1]};
                pwdata inside {[(`DATA_MAX/4):(`DATA_MAX/2)-1]};
            })

            // HIGHMID RANGE WRITE
            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/2):((3*`ADDR_MAX)/4)-1]};
                pwdata inside {[(`DATA_MAX/2):((3*`DATA_MAX)/4)-1]};
            })

            // HIGH RANGE WRITE
            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr inside {[((3*`ADDR_MAX)/4):`ADDR_MAX]};
                pwdata inside {[((3*`DATA_MAX)/4):`DATA_MAX]};
            })

        end


        // =====================================================
        // BOUNDARY ADDRESSES
        // =====================================================

        `sv_do_with(trans,{
            kind_e == WRITE;
            paddr == 0;
            pwdata == 0;
        })

        `sv_do_with(trans,{
            kind_e == WRITE;
            paddr == `ADDR_MAX;
            pwdata == `DATA_MAX;
        })


        // =====================================================
        // TRANSITION COVERAGE
        // =====================================================

        repeat(20) begin

            // WR -> WR
            `sv_do_with(trans,{kind_e == WRITE;})
            `sv_do_with(trans,{kind_e == WRITE;})

            // WR -> RD
            `sv_do_with(trans,{kind_e == WRITE;})
            `sv_do_with(trans,{kind_e == READ;})

            // RD -> WR
            `sv_do_with(trans,{kind_e == READ;})
            `sv_do_with(trans,{kind_e == WRITE;})

            // RD -> RD
            `sv_do_with(trans,{kind_e == READ;})
            `sv_do_with(trans,{kind_e == READ;})

        end


        // =====================================================
        // WRITE -> READ SAME ADDRESS
        // =====================================================

        repeat(50) begin

            addr = $urandom_range(0, `ADDR_MAX);

            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr == local::addr;
            })

            `sv_do_with(trans,{
                kind_e == READ;
                paddr == local::addr;
            })

        end


        // =====================================================
        // FORCE PRDATA BINS
        // =====================================================

        repeat(100) begin

            addr = $urandom_range(0, `ADDR_MAX);

            `sv_do_with(trans,{
                kind_e == WRITE;
                paddr == local::addr;
                pwdata inside {
                    0,
                    (`DATA_MAX/4),
                    (`DATA_MAX/2),
                    ((3*`DATA_MAX)/4),
                    `DATA_MAX
                };
            })

            `sv_do_with(trans,{
                kind_e == READ;
                paddr == local::addr;
            })

        end


        // =====================================================
        // RANDOM TRAFFIC
        // =====================================================

        repeat(300)
            `sv_do(trans)


        apb_pkg::drop_objection();

    endtask

endclass