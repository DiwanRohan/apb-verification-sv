///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: apb_scoreboard.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: apb_scoreboard
//DESCRIPTION: Scoreboard is responsible to check whether your design output is correct or not.It's collects expected value from reference model, actual value from monitor and compare those values and log the status.Functional Coverage can be part of Scoreboard
//Version: 1
//Date: 14-05-2026
//Time: 1:00 pm
//
/////////////////////////////////////

import apb_pkg::*;

class apb_scoreboard;

  //Mailboxes
  mailbox #(apb_trans) mon2scb_mbx;
  mailbox #(apb_trans) ref2scb_mbx;

  //Transaction handle
  apb_trans act, exp;
  apb_coverage cov;

  int pass_cnt, fail_cnt;

  //Queues for storing expexted and actual transaction packets
  apb_trans act_q[$];
  apb_trans exp_q[$];

  //Connect
  function void connect(mailbox#(apb_trans) mon2scb_mbx, mailbox#(apb_trans) ref2scb_mbx,
                        apb_coverage cov);

    this.mon2scb_mbx = mon2scb_mbx;
    this.ref2scb_mbx = ref2scb_mbx;
    this.cov = cov;

  endfunction

  //Print pass and fail count
  function void report();

    $display("PASS count = %0d", pass_cnt);
    $display("FAIL count = %0d", fail_cnt);

  endfunction

  task run();

    fork

      forever begin

        mon2scb_mbx.get(act);
        act_q.push_back(act);

        ref2scb_mbx.get(exp);
        exp_q.push_back(exp);

      end

      forever begin

        wait (act_q.size() > 0 && exp_q.size() > 0);

        act = act_q.pop_front();
        exp = exp_q.pop_front();

        compare(act, exp);

        //this.act.print("SCB");

        //->scb_done;
        cov.sample_coverage(act);

      end
    join_none

  endtask

  //Function to compare expected and actual value
  task compare(apb_trans act_tr, apb_trans exp_tr);
    // 1. Compare PRDATA for read transfers
    if (act_tr.kind_e == READ) begin
      if (act_tr.prdata === exp_tr.prdata) begin
        pass_cnt++;
      end else begin
        fail_cnt++;
        $display("[SCB FAIL] PRDATA Mismatch: ADDR=%0h Actual=%0h Expected=%0h", act_tr.paddr, act_tr.prdata, exp_tr.prdata);
      end
    end

    // 2. Compare PSLVERR for all transfers
    if (act_tr.pslverr === exp_tr.pslverr) begin
      pass_cnt++;
    end else begin
      fail_cnt++;
      $display("[SCB FAIL] PSLVERR Mismatch: ADDR=%0h Actual=%0b Expected=%0b", act_tr.paddr, act_tr.pslverr, exp_tr.pslverr);
    end

    // 3. Compare PSTRB for write transfers
    if (act_tr.kind_e == WRITE) begin
      if (act_tr.pstrb === exp_tr.pstrb) begin
        pass_cnt++;
      end else begin
        fail_cnt++;
        $display("[SCB FAIL] PSTRB Mismatch: ADDR=%0h Actual=%0b Expected=%0b", act_tr.paddr, act_tr.pstrb, exp_tr.pstrb);
      end
    end

  endtask


endclass
