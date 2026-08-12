`ifndef APB_SLAVE_SV
`define APB_SLAVE_SV

`include "apb_defines.sv"

module apb_slave (
  input  logic                   pclk,
  input  logic                   prstn,
  input  logic                   psel,
  input  logic                   penable,
  input  logic [`ADDR_WIDTH-1:0] paddr,
  input  logic                   pwrite,
  input  logic [`DATA_WIDTH-1:0] pwdata,
  input  logic [(`DATA_WIDTH/8)-1:0] pstrb,
  output logic                   pready,
  output logic [`DATA_WIDTH-1:0] prdata,
  output logic                   pslverr
);

  logic [`DATA_WIDTH-1:0] mem [`DEPTH];
  logic                   wait_active;
  logic [3:0]             wait_cnt;

  always_ff @(posedge pclk or negedge prstn) begin
    integer i;
    if (!prstn) begin
      for (i = 0; i < `DEPTH; i++)
        mem[i] <= '0;
    end
    else if (psel && penable && pready && pwrite && (paddr < `DEPTH)) begin
      if (pstrb[0]) mem[paddr][7:0]   <= pwdata[7:0];
      if (pstrb[1]) mem[paddr][15:8]  <= pwdata[15:8];
      if (pstrb[2]) mem[paddr][23:16] <= pwdata[23:16];
      if (pstrb[3]) mem[paddr][31:24] <= pwdata[31:24];
    end
  end

  always_comb begin
    prdata = '0;
    if (psel && penable && pready && !pwrite && (paddr < `DEPTH))
      prdata = mem[paddr];
  end

  always_comb begin
    pready = `DEFAULT_PREADY;
    if (psel && penable) begin
      if (wait_active) pready = 1'b0;
      else             pready = 1'b1;
    end
  end

  always_ff @(posedge pclk or negedge prstn) begin
    if (!prstn) begin
      wait_active <= 1'b0;
      wait_cnt    <= 0;
    end
    else if (psel && !penable && !wait_active) begin
      // Synthesizable, address-dependent wait state latency mapping
      case (paddr[1:0])
        2'b01: begin
          wait_active <= 1'b1;
          wait_cnt    <= 1;
        end
        2'b10: begin
          wait_active <= 1'b1;
          wait_cnt    <= 3;
        end
        2'b11: begin
          wait_active <= 1'b1;
          wait_cnt    <= 12;
        end
        default: begin
          wait_active <= 1'b0;
          wait_cnt    <= 0;
        end
      endcase
    end
    else if (wait_active && psel && penable) begin
      if (wait_cnt > 1)
        wait_cnt <= wait_cnt - 1;
      else begin
        wait_cnt    <= 0;
        wait_active <= 1'b0;
      end
    end
  end

  always_comb begin
    pslverr = psel && penable && pready && (paddr >= `DEPTH);
  end

endmodule

`endif
