import apb_pkg::*;

class apb_wr_rd_same_addr_xtn extends apb_gen_base;

  bit [`ADDR_WIDTH-1:0] addr;

  task run();

    apb_pkg::raise_objection();

    // ==========================================
    // ADDRESS RANGE COVERAGE
    // ==========================================

    repeat (20) begin

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[0:(`ADDR_MAX/4)-1]};
            })

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/4):(`ADDR_MAX/2)-1]};
            })

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/2):((3*`ADDR_MAX)/4)-1]};
            })

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[((3*`ADDR_MAX)/4):`ADDR_MAX]};
            })

    end


    // ==========================================
    // BOUNDARY ADDRESS COVERAGE
    // ==========================================

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            paddr == 0;
        })

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            paddr == `ADDR_MAX;
        })


    // ==========================================
    // DATA PATTERN COVERAGE
    // ==========================================

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            pwdata == 32'h0000_0000;
        })

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            pwdata == 32'hFFFF_FFFF;
        })

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            pwdata == 32'hAAAA_AAAA;
        })

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            pwdata == 32'h5555_5555;
        })


    // ==========================================
    // TRANSITION COVERAGE
    // ==========================================

    repeat (20) begin

      // WR -> WR
      `SV_DO_WITH(trans, {kind_e == WRITE;})
      `SV_DO_WITH(trans, {kind_e == WRITE;})

      // WR -> RD
      `SV_DO_WITH(trans, {kind_e == WRITE;})
      `SV_DO_WITH(trans, {kind_e == READ;})

      // RD -> WR
      `SV_DO_WITH(trans, {kind_e == READ;})
      `SV_DO_WITH(trans, {kind_e == WRITE;})

      // RD -> RD
      `SV_DO_WITH(trans, {kind_e == READ;})
      `SV_DO_WITH(trans, {kind_e == READ;})

    end


    // ==========================================
    // WRITE THEN READ SAME ADDRESS
    // ==========================================

    repeat (50) begin

      addr = $urandom_range(0, `ADDR_MAX);

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr == local::addr;
            })

      `SV_DO_WITH(trans,
                  {
                kind_e == READ;
                paddr == local::addr;
            })

    end


    // ==========================================
    // RANDOM TRAFFIC
    // ==========================================
    repeat (200) `SV_DO(trans)

    apb_pkg::drop_objection();

  endtask

endclass
