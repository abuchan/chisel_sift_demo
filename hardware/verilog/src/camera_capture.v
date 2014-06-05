module camera_capture (
  input clk,
  input reset,

  // User Image Outputs
  input img_ready,
  output reg img_valid,
  output img_sync,
  output reg [15:0] img_data,
  
  // Camera Inputs
  input cam_pclk,
  input cam_vsync,
  input cam_hsync,
  input cam_data[7:0]
);

wire cam_sync_data_valid;
wire [9:0] cam_sync_data;
wire cam_ready;

fifo_pixel_fwft fifo_in(
  .rst(reset),
  .wr_clk(cam_pclk),
  .rd_clk(clk),
  .din({cam_vsync, cam_hsync, cam_data}),
  .wr_en(1'b1),
  .rd_en(img_ready),
  .dout(cam_sync_data),
  .full(),
  .empty(),
  .valid(cam_valid)
);

initial img_valid = 1'b0;

reg last_frame_sync;
initial last_frame_sync = 1'b0;

assign frame_sync = ~last_frame_sync & cam_valid & vsync;

wire vsync, hsync;
wire [7:0] data;
reg [7:0] last_data;

wire cam_blanking;
assign cam_blanking = cam_valid & (~vsync | ~hsync);

assign vsync = cam_sync_data[9];
assign hsync = cam_sync_data[8];
assign data = cam_sync_data[7:0];

reg pixel_count;
initial pixel_count = 1'b0;

wire next_img_valid;
assign next_img_valid = cam_valid & (~cam_blanking) & pixel_count;

always @(posedge img_clk) begin
  if(cam_valid)
    last_frame_sync <= vsync;

  if (reset | cam_blanking) begin
    pixel_count <= 1'b0;
  end else if (img_ready & cam_valid) begin
    pixel_count <= ~pixel_count;
  end

  if (reset | (img_ready & ~next_img_valid)) begin
    img_valid <= 1'b0;
  end else if(img_ready & next_img_valid) begin
    img_valid <= 1'b1;
  end

  // Camera data is
  // P0: GGGBBBBB
  // P1: RRRRRGGG
  //
  // Image Data is
  // RRRRRGGG_GGGBBBBB
  if(img_ready & cam_valid) begin
    if(pixel_count) begin
      img_data <= {data, last_data};
    end else begin
      last_data <= data;
    end
  end
end

endmodule
