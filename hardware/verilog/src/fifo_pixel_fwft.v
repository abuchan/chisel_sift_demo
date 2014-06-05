module fifo_pixel_fwft(
  rst,
  wr_clk,
  rd_clk,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty,
  valid
);

input rst;
input wr_clk;
input rd_clk;
input [9 : 0] din;
input wr_en;
input rd_en;
output [9 : 0] dout;
output full;
output empty;
output valid;

endmodule

