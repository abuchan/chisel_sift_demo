module camera_control (
  input clk,
  input reset,

  inout cam_reset,
  inout cam_xclk,

  inout cam_scl,
  inout cam_sda
);

assign cam_reset = 1'b1;

assign cam_xclk = 1'bz;
assign cam_scl = 1'bz;
assign cam_sda = 1'bz;

endmodule
