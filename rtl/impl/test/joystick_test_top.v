`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 04:00:44 PM
// Design Name: 
// Module Name: joystick_test_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module joystick_test_top(
    input           CLOCK_50,
    input           RESET_N,

    // LED output
    output          CORE_LED,
    output [3:0]    BOARD_LEDS,

    // MCP23S17 interface
    input           JS_INTA,
    output          JS_MOSI,
    input           JS_MISO,
    output          JS_CS,
    output          JS_SCK
);

// clock
wire        clk28;         // 28 MHz clock
wire        clk28_loc;     // 28 MHz clock local route

// io 
reg         reset;         // System reset state
wire        locked;        // Goes high when the clock is stable

// SPI Joystick
wire        ready;        // Indicates when the interface is ready
wire [7:0]  Joya;         // Joystick one results
wire [7:0]  Joyb;         // Joystick one results

// Use Xilinx IP to build 28MHz clock
// clk_wiz_0 instance_name
// (
//     // Clock out ports
//     .clk_out1(clk28),     // output clk_out1
//     // Status and control signals
//     .reset(1'b0), // input reset
//     .locked(locked),       // output locked
//     // Clock in ports
//     .clk_in1(CLOCK_50)      // input clk_in1
// );


wire        clkfbout_buf_clk_wiz_0;
wire        clkfbout_clk_wiz_0;
MMCME2_ADV
#(
    .BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (19.250),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (34.375),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000)
)
myclk (
    // Clock manager feedback
    .CLKFBOUT             (clkfbout_clk_wiz_0),
    .CLKFBIN              (clkfbout_buf_clk_wiz_0),
    // External ports
    .CLKIN1               (CLOCK_50),
    .RST                  (1'b0),
    .CLKOUT0              (clk28_loc),
    .LOCKED               (locked)
);

// Clock feedback
BUFG clkf_buf
(.O (clkfbout_buf_clk_wiz_0),
.I (clkfbout_clk_wiz_0));

// Output buffer to logic
BUFG clkout1_buf
(
    .O   (clk28),
    .I   (clk28_loc)
);

// Reset
always @(posedge clk28) begin
    reset <= 1'b0;
    if(~locked || ~RESET_N) begin
        reset <= 1'b1;
    end
end

    
 mcp23s17_input joy_test (
  .clk(clk28),    // 28MHz Clock in
  .rst(reset),    // Reset ah

  // Interrupt from mcp23s17
  .inta(JS_INTA),

  // SPI Interface
  .mosi(JS_MOSI),
  .miso(JS_MISO),
  .cs(JS_CS),
  .sck(JS_SCK),

  // State
  .ready(ready),  // Goes high when the MCP23S17 is configured

  // Joystick I/O
  .Joya(Joya),   // Joystick 1 output
  .Joyb(Joyb)    // Joystick 2 output
);

// Assign joystick signals to 4 leds
assign BOARD_LEDS[0] = Joya[0] && Joya[4] && Joyb[0] && Joyb[4];
assign BOARD_LEDS[1] = Joya[1] && Joya[5] && Joyb[1] && Joyb[5];
assign BOARD_LEDS[2] = Joya[2] && Joya[6] && Joyb[2] && Joyb[6];
assign BOARD_LEDS[3] = Joya[3] && Joya[7] && Joyb[3] && Joyb[7];

// The LED remains lid if something goes wrong
assign CORE_LED = locked && ready;

endmodule
