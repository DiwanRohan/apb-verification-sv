import apb_pkg::*;

class apb_cov_xtn extends apb_gen_base;

  bit [`ADDR_WIDTH-1:0] addr;

  localparam longint unsigned DataMaxU = (64'h1 << `DATA_WIDTH) - 1;
  localparam longint unsigned DataLowMax = (DataMaxU / 4) - 1;
  localparam longint unsigned DataLowMidMin = DataMaxU / 4;
  localparam longint unsigned DataLowMidMax = (DataMaxU / 2) - 1;
  localparam longint unsigned DataHighMidMin = DataMaxU / 2;
  localparam longint unsigned DataHighMidMax = ((3 * DataMaxU) / 4) - 1;
  localparam longint unsigned DataHighMin = (3 * DataMaxU) / 4;
  localparam longint unsigned DataHighMax = DataMaxU;
  localparam longint unsigned DataQ1 = DataMaxU / 4;
  localparam longint unsigned DataQ2 = DataMaxU / 2;
  localparam longint unsigned DataQ3 = (3 * DataMaxU) / 4;

  task run();

    apb_pkg::raise_objection();

    // =====================================================
    // ADDRESS + KIND + DATA + TRANSITION COVERAGE
    // =====================================================

    repeat (50) begin

      // LOW RANGE WRITE
      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[0:(`ADDR_MAX/4)-1]};
                pwdata inside {[0:DataLowMax]};
            })

      // LOWMID RANGE WRITE
      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/4):(`ADDR_MAX/2)-1]};
                pwdata inside {[DataLowMidMin:DataLowMidMax]};
            })

      // HIGHMID RANGE WRITE
      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[(`ADDR_MAX/2):((3*`ADDR_MAX)/4)-1]};
                pwdata inside {[DataHighMidMin:DataHighMidMax]};
            })

      // HIGH RANGE WRITE
      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr inside {[((3*`ADDR_MAX)/4):`ADDR_MAX]};
                pwdata inside {[DataHighMin:DataHighMax]};
            })

    end


    // =====================================================
    // BOUNDARY ADDRESSES
    // =====================================================

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            paddr == 0;
            pwdata == 0;
        })

    `SV_DO_WITH(trans,
                {
            kind_e == WRITE;
            paddr == `ADDR_MAX;
            pwdata == `DATA_MAX;
        })


    // =====================================================
    // TRANSITION COVERAGE
    // =====================================================

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


    // =====================================================
    // WRITE -> READ SAME ADDRESS
    // =====================================================

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


    // =====================================================
    // FORCE PRDATA BINS
    // =====================================================

    repeat (100) begin

      addr = $urandom_range(0, `ADDR_MAX);

      `SV_DO_WITH(trans,
                  {
                kind_e == WRITE;
                paddr == local::addr;
                pwdata inside {
                    0,
                    DataQ1,
                    DataQ2,
                    DataQ3,
                    DataMaxU
                };
            })

      `SV_DO_WITH(trans,
                  {
                kind_e == READ;
                paddr == local::addr;
            })

    end


    // =====================================================
    // RANDOM TRAFFIC
    // =====================================================

    repeat (300) `SV_DO(trans)


    apb_pkg::drop_objection();

  endtask

endclass
