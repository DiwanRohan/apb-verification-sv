`include "apb_if.sv"

module apb_tb_top;

  //import package
  import apb_pkg::*;

  //clock
  bit pclk;

  //interface instance
  apb_if intf (pclk);

  //test handle
  apb_base_test test;

  //clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // DUT instantiation
  apb_slave DUT (
      .pclk   (pclk),
      .prstn  (intf.prstn),
      .psel   (intf.psel),
      .penable(intf.penable),
      .paddr  (intf.paddr),
      .pwrite (intf.pwrite),
      .pwdata (intf.pwdata),
      .prdata (intf.prdata),
      .pready (intf.pready),
      .pslverr(intf.pslverr)
  );

  task static apply_reset(int count);

    $display("[%0t] APPLYING RESET", $time);

    // notify reset starting
    ->apb_pkg::reset_start_ev;
    apb_pkg : reset = 1;

    intf.prstn = 1'b0;

    intf.psel    = 0;
    intf.penable = 0;
    intf.paddr   = 0;
    intf.pwrite  = 0;
    intf.pwdata  = 0;
    //intf.pready  = `DEFAULT_PREADY;
    //intf.pslverr = 0;

    repeat (count) @(posedge pclk);

    intf.prstn = 1;

    @(posedge pclk);

    $display("[%0t] RESET DEASSERTED", $time);

    // notify reset complete
    apb_pkg::reset = 0;
    ->apb_pkg::reset_done_ev;

  endtask

  task static run_test();

    apply_reset(1);

    test = new();

    test.build();

    test.connect(intf);

    test.run();

    #0;

    wait (apb_pkg::raise_ctr == 0);

    $display("=== TEST END ===\n");

    $finish;
  endtask

  // test flow
  initial begin
    run_test();

    /*if(env.scb.fail_cnt>0) begin
        test.env.gen.print("GEN");
        test.env.drv.print("DRV");
        test.env.mon.print("MON");
        test.env.rm.print("REF");
        test.env.scb.print("SCB_ACT","SCB_EXP");
        //test.env.gen.print("GEN");
    end
   */
  end

  final begin
    if ((test.env.scb.fail_cnt == 0) && (test.env.scb.pass_cnt > 0)) begin
      $display(" ==========    ==========   ==========   ========== ");
      $display(" =        =    =        =   =            =	         ");
      $display(" =        =    =        =   =            =          ");
      $display(" ==========    ==========   ==========   ========== ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =   ==========   ========== ");
    end else begin
      $display(" ==========   ==========    ==========   =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =        =        =	         ");
      $display(" ==========   ==========        =        =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =        =        =	         ");
      $display(" =            =        =        =        =	         ");
      $display(" =            =        =    ==========   ===========");
    end
    $display("Pass_cnt = %0d", test.env.scb.pass_cnt);
    $display("Fail_cnt = %0d", test.env.scb.fail_cnt);
    test.env.cov.report();

  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule

