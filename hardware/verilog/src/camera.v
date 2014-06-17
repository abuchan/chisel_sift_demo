module camera(
  input clk,
  input reset,

  // User Image output
  input img_ready,
  output img_valid,
  output img_sync,
  output [15:0] img_data,
  
  // I2CStream Control
  output host_in_ready,
  input  host_in_valid,
  input [7:0] host_in_bits,
  
  input  host_out_ready,
  output host_out_valid,
  output[7:0] host_out_bits,

  // Camera IO
  output cam_reset,
  output cam_xclk,
  
  inout cam_scl,
  inout cam_sda,
  
  input cam_pclk,
  input cam_vsync,
  input cam_hsync,
  input [7:0] cam_data
);

camera_control cctrl(
  .clk(clk),
  .reset(reset),

  .host_in_ready(host_in_ready),
  .host_in_valid(host_in_valid),
  .host_in_bits(host_in_bits),
  
  .host_out_ready(host_out_ready),
  .host_out_valid(host_out_valid),
  .host_out_bits(host_out_bits),
  
  .cam_reset(cam_reset),
  .cam_xclk(cam_xclk),
  
  .cam_scl(cam_scl),
  .cam_sda(cam_sda)
);

camera_capture ccap(
  .clk(clk),
  .reset(reset),

  .img_ready(img_ready),
  .img_valid(img_valid),
  .img_sync(img_sync),
  .img_data(img_data),

  .cam_pclk(cam_pclk),
  .cam_vsync(cam_vsync),
  .cam_hsync(cam_hsync),
  .cam_data(cam_data)
);
endmodule
