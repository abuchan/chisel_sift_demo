module camera_control (
  input clk,
  input reset,

  output cam_reset,
  output cam_xclk,

  inout cam_scl,
  inout cam_sda
);

assign cam_reset = !reset;

reg [2:0] count;
initial count = 3'd0;

always @(posedge clk)
  count <= count + 3'd1;

assign cam_xclk = count[2];

assign cam_scl = 1'bz;
assign cam_sda = 1'bz;

endmodule
