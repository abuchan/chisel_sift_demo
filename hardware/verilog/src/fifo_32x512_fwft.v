module fifo_32x512_fwft (
  clk,
  srst,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty,
  valid
);

  input clk;
  input srst;
  input [31 : 0] din;
  input wr_en;
  input rd_en;
  output [31 : 0] dout;
  output full;
  output empty;
  output valid;
endmodule

