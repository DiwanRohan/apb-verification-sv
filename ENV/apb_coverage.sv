import apb_pkg::*;

class apb_coverage;

  apb_trans trans;

  trans_kind_e prev_kind;

  //localparam ADDR_MAX = 2**`ADDR_WIDTH - 1;
  //localparam DATA_MAX = 2**`DATA_WIDTH - 1;

  bit addr_written[bit [`ADDR_WIDTH-1:0]];

  function void sample_coverage(apb_trans trans);

    this.trans = trans.clone();
    apb_cg.sample();

  endfunction

  covergroup apb_cg;

    option.per_instance = 1;

    cp_kind: coverpoint trans.kind_e {bins read = {READ}; bins write = {WRITE};}

    cp_paddr: coverpoint trans.paddr {
      //bins addr[]        = {[0:ADDR_MAX]};
      bins low_range = {[0 : (`ADDR_MAX / 4) - 1]};
      bins lowmid_range = {[(`ADDR_MAX / 4) : (`ADDR_MAX / 2) - 1]};
      bins highmid_range = {[(`ADDR_MAX / 2) : ((3 * `ADDR_MAX) / 4) - 1]};
      bins high_range = {[((3 * `ADDR_MAX) / 4) : `ADDR_MAX]};
      bins first_addr = {0};
      bins last_addr = {`ADDR_MAX};
    }

    cp_pwdata: coverpoint trans.pwdata iff (trans.pwrite) {
      bins low_range = {[0 : (`DATA_MAX / 4) - 1]};
      bins lowmid_range = {[(`DATA_MAX / 4) : (`DATA_MAX / 2) - 1]};
      bins highmid_range = {[(`DATA_MAX / 2) : (3 * `DATA_MAX / 4) - 1]};
      bins high_range = {[(3 * `DATA_MAX / 4) : `DATA_MAX]};
      bins first_data = {0};
      bins max_data = {`DATA_MAX};
    }

    cp_prdata: coverpoint trans.prdata iff (!trans.pwrite) {
      bins low_range = {[0 : (`DATA_MAX / 4) - 1]};
      bins lowmid_range = {[(`DATA_MAX / 4) : (`DATA_MAX / 2) - 1]};
      bins highmid_range = {[(`DATA_MAX / 2) : (3 * `DATA_MAX / 4) - 1]};
      bins high_range = {[(3 * `DATA_MAX / 4) : `DATA_MAX]};
      bins first_data = {0};
      bins max_data = {`DATA_MAX};
    }

    cp_transition: coverpoint trans.kind_e {
      bins wr_to_wr = (WRITE => WRITE);
      bins wr_to_rd = (WRITE => READ);
      bins rd_to_wr = (READ => WRITE);
      bins rd_to_rd = (READ => READ);
    }

    cp_wait_states: coverpoint trans.wait_cycles {
      bins no_wait = {0}; bins short_wait = {[1 : 4]}; bins long_wait = {[5 : 10]};
    }

    cp_pslverr: coverpoint trans.pslverr {bins no_error = {0}; bins error = {1};}

    /*cp_wr_rd_same_addr : coverpoint was_written iff(trans.kind_e == READ) {
bins written_before_read = {1};
bins read_before_write   = {0};
}*/

    /*cp_reset : coverpoint trans.reset_seen {
bins reset_asserted = {1};
bins normal_op = {0};
}*/

    cross_kind_addr  : cross cp_kind, cp_paddr;

    cross_kind_wait  : cross cp_kind, cp_wait_states;

    cross_kind_error : cross cp_kind, cp_pslverr;

    cross_addr_wait  : cross cp_paddr, cp_wait_states;

    cross_addr_data  : cross cp_paddr, cp_pwdata;

    //cross_wr_rd_wait : cross cp_wr_rd_same_addr, cp_wait_states;

    cross_kind_addr_error : cross cp_kind, cp_paddr, cp_pslverr;
  endgroup

  function new();
    apb_cg = new();
  endfunction

  //REPORT
  function void report();
    $display("======================================");
    $display("FUNCTIONAL COVERAGE = %0.2f %% ", apb_cg.get_coverage());
    $display("======================================");
  endfunction

endclass
