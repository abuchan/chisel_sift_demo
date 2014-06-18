module xillydemo
  (
  input  PS_CLK,
  input  PS_PORB,
  input  PS_SRSTB,
  input  clk_100,
  input  otg_oc,   
  inout [14:0] DDR_Addr,
  inout [2:0] DDR_BankAddr,
  inout  DDR_CAS_n,
  inout  DDR_CKE,
  inout  DDR_CS_n,
  inout  DDR_Clk,
  inout  DDR_Clk_n,
  inout [3:0] DDR_DM,
  inout [31:0] DDR_DQ,
  inout [3:0] DDR_DQS,
  inout [3:0] DDR_DQS_n,
  inout  DDR_DRSTB,
  inout  DDR_ODT,
  inout  DDR_RAS_n,
  inout  DDR_VRN,
  inout  DDR_VRP,
  inout [53:0] MIO,
  inout [55:0] PS_GPIO,
  output  DDR_WEB,
  output [3:0] GPIO_LED,
  output [3:0] vga4_blue,
  output [3:0] vga4_green,
  output [3:0] vga4_red,
  output  vga_hsync,
  output  vga_vsync,

  output  audio_mclk,
  output  audio_dac,
  input   audio_adc,
  input   audio_bclk,
  input   audio_lrclk,

  output smb_sclk,
  inout  smb_sdata,
  output [1:0] smbus_addr,
  
  output cam_reset,
  output cam_xclk,
  inout cam_scl,
  inout cam_sda,
  input cam_pclk,
  input cam_vsync,
  input cam_hsync,
  input [7:0] cam_data
  ); 
   // Clock and quiesce
   wire    bus_clk;
   wire    quiesce;

   // Memory arrays
   reg [7:0] demoarray[0:31];
   
   reg [7:0] litearray0[0:31];
   reg [7:0] litearray1[0:31];
   reg [7:0] litearray2[0:31];
   reg [7:0] litearray3[0:31];

   // Wires related to /dev/xillybus_mem_8
   wire      user_r_mem_8_rden;
   wire      user_r_mem_8_empty;
   reg [7:0] user_r_mem_8_data;
   wire      user_r_mem_8_eof;
   wire      user_r_mem_8_open;
   wire      user_w_mem_8_wren;
   wire      user_w_mem_8_full;
   wire [7:0] user_w_mem_8_data;
   wire       user_w_mem_8_open;
   wire [4:0] user_mem_8_addr;
   wire       user_mem_8_addr_update;

   // Wires related to /dev/xillybus_read_32
   wire       user_r_read_32_rden;
   wire       user_r_read_32_empty;
   wire [31:0] user_r_read_32_data;
   wire        user_r_read_32_eof;
   wire        user_r_read_32_open;

   // Wires related to /dev/xillybus_read_8
   wire        user_r_read_8_rden;
   wire        user_r_read_8_empty;
   wire [7:0]  user_r_read_8_data;
   wire        user_r_read_8_eof;
   wire        user_r_read_8_open;

   // Wires related to /dev/xillybus_write_32
   wire        user_w_write_32_wren;
   wire        user_w_write_32_full;
   wire [31:0] user_w_write_32_data;
   wire        user_w_write_32_open;

   // Wires related to /dev/xillybus_write_8
   wire        user_w_write_8_wren;
   wire        user_w_write_8_full;
   wire [7:0]  user_w_write_8_data;
   wire        user_w_write_8_open;

   // Wires related to /dev/xillybus_audio
   wire        user_r_audio_rden;
   wire        user_r_audio_empty;
   wire [31:0] user_r_audio_data;
   wire        user_r_audio_eof;
   wire        user_r_audio_open;
   wire        user_w_audio_wren;
   wire        user_w_audio_full;
   wire [31:0] user_w_audio_data;
   wire        user_w_audio_open;
 
   // Wires related to /dev/xillybus_smb
   wire        user_r_smb_rden;
   wire        user_r_smb_empty;
   wire [7:0]  user_r_smb_data;
   wire        user_r_smb_eof;
   wire        user_r_smb_open;
   wire        user_w_smb_wren;
   wire        user_w_smb_full;
   wire [7:0]  user_w_smb_data;
   wire        user_w_smb_open;

   // Wires related to Xillybus Lite
   wire        user_clk;
   wire        user_wren;
   wire [3:0]  user_wstrb;
   wire        user_rden;
   reg [31:0]  user_rd_data;
   wire [31:0] user_wr_data;
   wire [31:0] user_addr;
   wire        user_irq;
   
   xillybus xillybus_ins (

    // Ports related to /dev/xillybus_mem_8
    // FPGA to CPU signals:
    .user_r_mem_8_rden(user_r_mem_8_rden),
    .user_r_mem_8_empty(user_r_mem_8_empty),
    .user_r_mem_8_data(user_r_mem_8_data),
    .user_r_mem_8_eof(user_r_mem_8_eof),
    .user_r_mem_8_open(user_r_mem_8_open),

    // CPU to FPGA signals:
    .user_w_mem_8_wren(user_w_mem_8_wren),
    .user_w_mem_8_full(user_w_mem_8_full),
    .user_w_mem_8_data(user_w_mem_8_data),
    .user_w_mem_8_open(user_w_mem_8_open),

    // Address signals:
    .user_mem_8_addr(user_mem_8_addr),
    .user_mem_8_addr_update(user_mem_8_addr_update),


    // Ports related to /dev/xillybus_read_32
    // FPGA to CPU signals:
    .user_r_read_32_rden(user_r_read_32_rden),
    .user_r_read_32_empty(user_r_read_32_empty),
    .user_r_read_32_data(user_r_read_32_data),
    .user_r_read_32_eof(user_r_read_32_eof),
    .user_r_read_32_open(user_r_read_32_open),


    // Ports related to /dev/xillybus_read_8
    // FPGA to CPU signals:
    .user_r_read_8_rden(user_r_read_8_rden),
    .user_r_read_8_empty(user_r_read_8_empty),
    .user_r_read_8_data(user_r_read_8_data),
    .user_r_read_8_eof(user_r_read_8_eof),
    .user_r_read_8_open(user_r_read_8_open),


    // Ports related to /dev/xillybus_write_32
    // CPU to FPGA signals:
    .user_w_write_32_wren(user_w_write_32_wren),
    .user_w_write_32_full(user_w_write_32_full),
    .user_w_write_32_data(user_w_write_32_data),
    .user_w_write_32_open(user_w_write_32_open),


    // Ports related to /dev/xillybus_write_8
    // CPU to FPGA signals:
    .user_w_write_8_wren(user_w_write_8_wren),
    .user_w_write_8_full(user_w_write_8_full),
    .user_w_write_8_data(user_w_write_8_data),
    .user_w_write_8_open(user_w_write_8_open),

    // Ports related to /dev/xillybus_audio
    // FPGA to CPU signals:
    .user_r_audio_rden(user_r_audio_rden),
    .user_r_audio_empty(user_r_audio_empty),
    .user_r_audio_data(user_r_audio_data),
    .user_r_audio_eof(user_r_audio_eof),
    .user_r_audio_open(user_r_audio_open),

    // CPU to FPGA signals:
    .user_w_audio_wren(user_w_audio_wren),
    .user_w_audio_full(user_w_audio_full),
    .user_w_audio_data(user_w_audio_data),
    .user_w_audio_open(user_w_audio_open),

    // Ports related to /dev/xillybus_smb
    // FPGA to CPU signals:
    .user_r_smb_rden(user_r_smb_rden),
    .user_r_smb_empty(user_r_smb_empty),
    .user_r_smb_data(user_r_smb_data),
    .user_r_smb_eof(user_r_smb_eof),
    .user_r_smb_open(user_r_smb_open),

    // CPU to FPGA signals:
    .user_w_smb_wren(user_w_smb_wren),
    .user_w_smb_full(user_w_smb_full),
    .user_w_smb_data(user_w_smb_data),
    .user_w_smb_open(user_w_smb_open),

    // Xillybus Lite signals:
    .user_clk ( user_clk ),
    .user_wren ( user_wren ),
    .user_wstrb ( user_wstrb ),
    .user_rden ( user_rden ),
    .user_rd_data ( user_rd_data ),
    .user_wr_data ( user_wr_data ),
    .user_addr ( user_addr ),
    .user_irq ( user_irq ),
			  			  
    // General signals
    .PS_CLK(PS_CLK),
    .PS_PORB(PS_PORB),
    .PS_SRSTB(PS_SRSTB),
    .clk_100(clk_100),
    .otg_oc(otg_oc),
    .DDR_Addr(DDR_Addr),
    .DDR_BankAddr(DDR_BankAddr),
    .DDR_CAS_n(DDR_CAS_n),
    .DDR_CKE(DDR_CKE),
    .DDR_CS_n(DDR_CS_n),
    .DDR_Clk(DDR_Clk),
    .DDR_Clk_n(DDR_Clk_n),
    .DDR_DM(DDR_DM),
    .DDR_DQ(DDR_DQ),
    .DDR_DQS(DDR_DQS),
    .DDR_DQS_n(DDR_DQS_n),
    .DDR_DRSTB(DDR_DRSTB),
    .DDR_ODT(DDR_ODT),
    .DDR_RAS_n(DDR_RAS_n),
    .DDR_VRN(DDR_VRN),
    .DDR_VRP(DDR_VRP),
    .MIO(MIO),
    .PS_GPIO(PS_GPIO),
    .DDR_WEB(DDR_WEB),
    .GPIO_LED(GPIO_LED),
    .bus_clk(bus_clk),
    .quiesce(quiesce),

    // VGA port related outputs
			    
    .vga4_blue(vga4_blue),
    .vga4_green(vga4_green),
    .vga4_red(vga4_red),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
  );

   assign      user_irq = 0; // No interrupts for now
   
   always @(posedge user_clk)
     begin
	if (user_wstrb[0])
	  litearray0[user_addr[6:2]] <= user_wr_data[7:0];

	if (user_wstrb[1])
	  litearray1[user_addr[6:2]] <= user_wr_data[15:8];

	if (user_wstrb[2])
	  litearray2[user_addr[6:2]] <= user_wr_data[23:16];

	if (user_wstrb[3])
	  litearray3[user_addr[6:2]] <= user_wr_data[31:24];
	
	if (user_rden)
	  user_rd_data <= { litearray3[user_addr[6:2]],
			    litearray2[user_addr[6:2]],
			    litearray1[user_addr[6:2]],
			    litearray0[user_addr[6:2]] };
     end
  
  parameter RESET_ADDR = 0;
  parameter SELECT_ADDR = 1;

  always @(posedge bus_clk) begin
    if(user_w_mem_8_wren)
      demoarray[user_mem_8_addr] <= user_w_mem_8_data;

    if(user_r_mem_8_rden) begin
      user_r_mem_8_data <= demoarray[user_mem_8_addr];
  end

  assign  user_r_mem_8_empty = 0;
  assign  user_r_mem_8_eof = 0;
  assign  user_w_mem_8_full = 0;

  wire user_reset;
  assign user_reset = demoarray[8'd0] == 8'hFF;
  
  wire img_ready, img_valid, img_fifo_full;
  assign img_ready = !img_fifo_full;

  wire [15:0] img_data;
  wire [31:0] img_fifo_data;
  wire img_sync, img_fifo_valid;

  // Image Data is:
  // RRRRRGGG_GGGBBBBB
  //
  // Image FIFO Data is (quad img data):
  // 00000000_RRRRR000_GGGGGG00_BBBBB000
  
  /*wire [31:0] quad_img_data;
  assign quad_img_data = {8'd0, img_data[15:11], 3'd0,
    img_data[10:5], 2'd0, img_data[4:0], 3'd0};

  assign img_fifo_data = img_sync ? 32'hFF_00_00_00 : quad_img_data;
  assign img_fifo_valid = img_sync | img_valid;
  
  assign img_fifo_data = quad_img_data;
  assign img_fifo_valid = img_valid;

  fifo_32x512 img_fifo(
    .clk(bus_clk),
    .srst(user_reset),

    .full(img_fifo_full),
    .wr_en(img_fifo_valid),
    .din(img_fifo_data),
    
    .rd_en(user_r_read_32_rden),
    .empty(user_r_read_32_empty),
    .dout(user_r_read_32_data)
  );
  
  wire img_top;
  reg img_eof;

  ImageCounter eof_count(
    .clk(bus_clk),
    .reset(user_reset),
    .io_en(user_r_read_32_rden & !user_r_read_32_empty),
    .io_top(img_top)
  );

  always @(posedge bus_clk) begin
    if (user_reset | user_r_read_32_empty)
      img_eof <= 1'b0;
    else if (img_top & user_r_read_32_rden)
      img_eof <= 1'b1;
  end

  //assign  user_r_read_32_eof = 0;
  assign  user_r_read_32_eof = img_eof;*/
  
  wire host_in_ready, host_in_valid, host_out_full, host_out_valid;
  wire [7:0] host_in_bits, host_out_bits;

  fifo_8x2048_fwft host_in_fifo(
    .clk(bus_clk),
    .srst(!user_w_write_8_open && !user_r_read_8_open),

    .full(user_w_write_8_full),
    .wr_en(user_w_write_8_wren),
    .din(user_w_write_8_data),
    
    .rd_en(host_in_ready),
    .valid(host_in_valid),
    .dout(host_in_bits)
  );
 
  fifo_8x2048 host_out_fifo (
    .clk(bus_clk),
    .srst(!user_w_write_8_open && !user_r_read_8_open),

    .din(host_out_bits),
    .wr_en(host_out_valid),
    .full(host_out_full),

    .rd_en(user_r_read_8_rden),
    .dout(user_r_read_8_data),
    .empty(user_r_read_8_empty)
  );
  
  assign  user_r_read_8_eof = 0;
  
  assign host_out_ready = !host_out_full;

  // Camera on PMOD
  camera cam(
    .clk(bus_clk),
    .reset(user_reset),

    .img_ready(img_ready),
    .img_valid(img_valid),
    .img_sync(img_sync),
    .img_data(img_data),

    .host_in_ready(host_in_ready),
    .host_in_valid(host_in_valid),
    .host_in_bits(host_in_bits),
	 
    .host_out_ready(host_out_ready),
    .host_out_valid(host_out_valid),
    .host_out_bits(host_out_bits),

    .cam_reset(cam_reset),
    .cam_xclk(cam_xclk),
	 
    .cam_sda(cam_sda),
	  .cam_scl(cam_scl),
	 
    .cam_pclk(cam_pclk),
    .cam_vsync(cam_vsync),
    .cam_hsync(cam_hsync),
    .cam_data(cam_data)
  );
  
  wire sse_select_ready, sse_select_valid;
  wire sse_img_in_ready, sse_img_in_valid;
  wire sse_img_out_ready, sse_img_out_valid;
  wire [31:0] sse_img_in_bits, sse_img_out_bits;
  wire [7:0] sse_select_bits;

  ScaleSpaceExtrema sse(
    .clk(bus_clk), 
    .reset(user_reset),
    
    .io_select_ready(sse_select_ready),
    .io_select_valid(sse_select_valid),
    .io_select_bits(sse_select_bits), // 8 bits

    .io_img_in_ready(sse_img_in_ready),
    .io_img_in_valid(sse_img_in_valid),
    .io_img_in_bits(sse_img_in_bits[23:0]), // 24 bits
    
    .io_img_out_ready(sse_img_out_ready),
    .io_img_out_valid(sse_img_out_valid),
    .io_img_out_bits(sse_img_out_bits[23:0]) // 24 bits
  );

  // Image input and output FIFOs
  wire img_fifo_reset;
  assign img_fifo_reset = (!user_w_write_32_open & !user_r_read_32_open);
  
  fifo_32x512_fwft img_in_fifo(
    .clk(bus_clk),
    .srst(img_fifo_reset),

    .full(user_w_write_32_full),
    .wr_en(user_w_write_32_wren),
    .din(user_w_write_32_data),
    
    //.rd_en(sse_img_in_ready),
    .rd_en(1'b1);
    //.valid(sse_img_in_valid),
    //.dout(sse_img_in_bits)
  );

  wire img_out_fifo_full;
  assign sse_img_out_ready = !img_out_fifo_full;

  fifo_32x512 img_out_fifo(
    .clk(bus_clk),
    .srst(img_fifo_reset),

    .full(img_out_fifo_full),
    .wr_en(sse_img_out_valid),
    .din(sse_img_out_bits),
    
    .rd_en(user_r_read_32_rden),
    .empty(user_r_read_32_empty),
    .dout(user_r_read_32_data)
  );

  assign  user_r_read_32_eof = 0;

   i2s_audio audio
     (
      .bus_clk(bus_clk),
      .clk_100(clk_100),
      .quiesce(quiesce),

      .audio_mclk(audio_mclk),
      .audio_dac(audio_dac),
      .audio_adc(audio_adc),
      .audio_bclk(audio_bclk),
      .audio_lrclk(audio_lrclk),
      
      .user_r_audio_rden(user_r_audio_rden),
      .user_r_audio_empty(user_r_audio_empty),
      .user_r_audio_data(user_r_audio_data),
      .user_r_audio_eof(user_r_audio_eof),
      .user_r_audio_open(user_r_audio_open),
      
      .user_w_audio_wren(user_w_audio_wren),
      .user_w_audio_full(user_w_audio_full),
      .user_w_audio_data(user_w_audio_data),
      .user_w_audio_open(user_w_audio_open)
      );
   
   smbus smbus
     (
      .bus_clk(bus_clk),
      .quiesce(quiesce),

      .smb_sclk(smb_sclk),
      .smb_sdata(smb_sdata),
      .smbus_addr(smbus_addr),

      .user_r_smb_rden(user_r_smb_rden),
      .user_r_smb_empty(user_r_smb_empty),
      .user_r_smb_data(user_r_smb_data),
      .user_r_smb_eof(user_r_smb_eof),
      .user_r_smb_open(user_r_smb_open),
      
      .user_w_smb_wren(user_w_smb_wren),
      .user_w_smb_full(user_w_smb_full),
      .user_w_smb_data(user_w_smb_data),
      .user_w_smb_open(user_w_smb_open)
      );

endmodule
