module camera_control (
  input clk,
  input reset,
  
  // Camera Clock and Reset
  output cam_reset,
  output cam_xclk,

  // I2C Stream interface
  output host_in_ready,
  input  host_in_valid,
  input [7:0] host_in_bits,
  input  host_out_ready,
  output host_out_valid,
  output[7:0] host_out_bits,

  // Camera I2C bus
  inout cam_scl,
  inout cam_sda
);

assign cam_reset = !reset;

// Generate 25MHz clock output
reg [2:0] count;
initial count = 3'd0;

always @(posedge clk)
  count <= count + 3'd1;

assign cam_xclk = count[2];

// Instantiate stream to I2C bridge
wire i2c_scl_out, i2c_sda_out;

I2CStream i2c (
  .clk(clk),
  .reset(reset),

  .io_host_in_ready(host_in_ready),
  .io_host_in_valid(host_in_valid),
  .io_host_in_bits(host_in_bits),
  
  .io_host_out_ready(host_out_ready),
  .io_host_out_valid(host_out_valid),
  .io_host_out_bits(host_out_bits),

  .io_bus_scl_in(cam_scl),
  .io_bus_scl_out(i2c_scl_out),
  .io_bus_sda_in(cam_sda),
  .io_bus_sda_out(i2c_sda_out)
);

// Tristates to drive low
assign cam_scl = i2c_scl_out ? 1'bz : 1'b0;
assign cam_sda = i2c_sda_out ? 1'bz : 1'b0;

endmodule
