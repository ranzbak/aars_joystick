/********************************************/
/* minimig_openaars_top.v                   */
/* MiST Board Top File                      */
/*                                          */
/* 2019-2020, ranzbak@gmail.com             */
/********************************************/

`include "minimig_defines.vh"


module mcp23s17_input (
  input  wire           clk,    // 28MHz Clock in
  input  wire           rst,    // Reset ah

  // Interrupt from mcp23s17
  input  wire           inta,

  // SPI Interface
  output wire           mosi,
  input  wire           miso,
  output reg            cs,
  output wire           sck,

  // State
  output wire           ready,  // Goes high when the MCP23S17 is configured

  // Joystick I/O
  output wire [  7:0]   Joya,   // Joystick 1 output
  output wire [  7:0]   Joyb    // Joystick 2 output
);

// Defines
localparam  MCP_ADDR  = 3'b000;
localparam  MCP_READ  = 1'b1;
localparam  MCP_WRITE = 1'b0;

// MCP23S17 Register addresses (Bank = 0)
localparam [7:0] 
    REG_ADR_IODIRA  = 8'h00,    // IO direction
    REG_ADR_IODIRB  = 8'h01,
    REG_ADR_INTENA  = 8'h04,    // Interrupt enable on bits
    REG_ADR_INTENB  = 8'h05,
    REG_ADR_INTCAPA = 8'h10,    // Latched GPIO registers
    REG_ADR_INTCAPB = 8'h11,
    REG_ADR_GPIOA   = 8'h12,    // GPIO registers
    REG_ADR_GPIOB   = 8'h13,
    REG_ADR_IOCON   = 8'h0A;    // Configuration register

// MCP23S17 Config values
localparam [7:0]
    REG_VAL_IODIRA = 8'hFF,
    REG_VAL_INTENA = 8'hFF,
    REG_VAL_IOCON  = 8'b01000010; // {BANK, MIRROR, SEQOP, DISSLW, HAEN, ODR, INTPOL, Unused}



// SPI
reg   [7:0] TX_Byte;
reg         TX_DV;
wire        TX_Ready;
wire        RX_DV; 
wire  [7:0] RX_Byte;

// Joystick
reg [7:0] Joya_raw = 8'hff;
reg [7:0] Joyb_raw = 8'hff;

// SPI Master
SPI_Master 
#(
    .SPI_MODE(0),
    .CLKS_PER_HALF_BIT(2)
)
joy_spi_master
(
    // Control/Data Signals,
    .i_Clk     (clk      ), // FPGA Clock
    .i_Rst_L   (~rst     ), // FPGA Reset (al)

    // TX (MOSI) Signals
    .i_TX_Byte (TX_Byte  ), // Byte to transmit on MOSI
    .i_TX_DV   (TX_DV    ), // Data Valid Pulse with i_TX_Byte
    .o_TX_Ready(TX_Ready ), // Transmit Ready for next byte

    // RX (MISO) Signals
    .o_RX_DV   (RX_DV    ), // Data Valid pulse (1 clock cycle)
    .o_RX_Byte (RX_Byte  ), // Byte received on MISO

    // SPI Interface
    .o_SPI_Clk (sck      ),
    .i_SPI_MISO(miso     ),
    .o_SPI_MOSI(mosi     )
);

// MCP23S17 Write Register
reg [3:0] tx_pos = 0;
reg [2:0] tx_wait_cnt = 0;
reg       tx_wait = 0;
task write_mcp;
    input [7:0] reg_addr;
    input [7:0] cfg_value;
    output      tx_done;
    begin 
        // Init
        TX_DV <= 1'b0;
        tx_done <= 1'b0; 

        if (~tx_wait) begin
            // Chip select
            if (cs && ~tx_done) begin
                cs <= 1'b0;
                tx_pos <= 4'b0;
            end else begin
                // CS is asserted start!
                if(TX_Ready || tx_pos == 0) begin
                    TX_DV <= 1'b1;
                    case(tx_pos) 
                        0:
                            TX_Byte <= 8'h40;
                        1:
                            TX_Byte <= reg_addr;
                        2:
                            TX_Byte <= cfg_value;
                        default: begin
                            cs <= 1'b1;
                            tx_wait <=  1'b1;
                            tx_wait_cnt <= 3'b111;
                            tx_done <= 1'b1;
                        end
                    endcase
                    tx_pos <= tx_pos + 1;
                end
            end
        end else begin
            // Keep CS high for 8 cycles for the IC to detect it
            tx_wait_cnt <=  tx_wait_cnt - 1;
            if (tx_wait_cnt == 0) begin
                tx_done <= 1'b1;
                tx_wait <= 1'b0;
            end
        end
    end
endtask

// MCP23S17 Read n registers
reg [4:0] rx_pos = 0;
reg [2:0] rx_wait_cnt = 0;
reg       rx_wait = 0;
reg       tx_ready_ = 0;
reg       tx_ready_p = 0;
task read_mcp;
    input   [7:0] reg_addr;   // Address to start reading
    input   [4:0] num;        // Number of values to read in sequence
    output  [7:0] rx_data;    // Received data
    output  [4:0] rx_seq;     // Sequence number of the received byte
    output        rx_dv;      // Data received
    output        rx_done;    // Done receiving
    begin 

        // Init
        TX_DV   <= 1'b0;
        rx_done <= 1'b0; 
        rx_dv   <= 1'b0;

        // tx_ready_
        tx_ready_ <= TX_Ready;
        tx_ready_p <= 1'b0;
        if (~tx_ready_ && TX_Ready) begin
            tx_ready_p <= 1'b1;
        end

        // Chip select
        if (~rx_wait) begin 
            if (cs && ~rx_done) begin
                cs <= 1'b0;
                tx_pos <= 4'b0;
            end else begin
                // CS is asserted start!
                if(tx_ready_p || (tx_pos == 0)) begin
                    TX_DV <= 1'b1;
                    case(tx_pos)
                        0:
                            TX_Byte <= 8'h41;
                        1:
                            TX_Byte <= reg_addr;
                        default:
                            TX_Byte <= 8'h00;
                    endcase;

                    tx_pos <= tx_pos + 1;
                end

                // Byte received, after header return received bytes
                if(tx_pos >= 2 && RX_DV) begin
                    rx_dv <= 1'b1;
                    rx_seq <= tx_pos - 2; // position - header length
                    rx_data <= RX_Byte;

                    // When we are done, say so :-)
                    if(tx_pos >= (num + 2)) begin
                        cs <= 1'b1;
                        rx_wait <= 1'b1; 
                        rx_wait_cnt <= 3'b111;
                    end
                end
            end
        end else begin
            // Keep the CS high for 8 clock cycles to give the IC time to
            // detect the end of transmission.
            rx_wait_cnt <= rx_wait_cnt - 1;
            if (rx_wait_cnt == 0) begin
                rx_wait <= 1'b0;
                rx_done <= 1'b1;
            end
        end
    end
endtask

// MCP23S17 State machine 
localparam [4:0]
    ST_IDLE        = 0,
    ST_SET_IODIRA  = 1,
    ST_SET_IODIRB  = 2,
    ST_SET_INTENA  = 3,
    ST_SET_INTENB  = 4,
    ST_SET_IOCON   = 5,
    ST_WAITINT     = 10,
    ST_READ_GPIO   = 11,
    ST_DONE        = 12;
reg [4:0] mcp_state = ST_IDLE;

reg         st_done = 1'b0;  // Stage done, move to next stage
reg         st_dv   = 0;     // Data valid      
reg   [7:0] st_data = 0;     // Received data
reg   [4:0] st_seq  = 0;     // Sequence number of read data
always @(posedge clk) begin
    case (mcp_state)
        ST_IDLE: begin
            mcp_state <= ST_SET_IODIRA;
        end
        ST_SET_IODIRA: begin
            write_mcp(REG_ADR_IODIRA, 8'hff, st_done);
            if(st_done) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= ST_SET_IODIRB;
            end
        end
        ST_SET_IODIRB: begin
            write_mcp(REG_ADR_IODIRB, 8'hff, st_done);
            if(st_done) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= ST_SET_INTENA;
            end
        end
        ST_SET_INTENA: begin
            write_mcp(REG_ADR_INTENA, 8'hff, st_done);
            if(st_done) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= ST_SET_INTENB;
            end
        end
        ST_SET_INTENB: begin
            write_mcp(REG_ADR_INTENB, 8'hff, st_done);
            if(st_done) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= ST_SET_IOCON;
            end
        end
        ST_SET_IOCON: begin
            write_mcp(REG_ADR_IOCON, REG_VAL_IOCON, st_done);
            if(st_done) begin
                st_done <= 1'b0; // Ack done
                mcp_state <= ST_WAITINT;
            end
        end
        ST_WAITINT: begin
            if(inta)
                mcp_state <= ST_READ_GPIO;
        end
        ST_READ_GPIO: begin
            read_mcp(REG_ADR_INTCAPA, 2, st_data, st_seq, st_dv, st_done);
            if (st_dv) begin
                case(st_seq)
                    0:
                        Joya_raw <= st_data;
                    1:
                        Joyb_raw <= st_data;
                endcase
            end

            if(st_done) begin
                mcp_state <= ST_WAITINT;
            end
        end
    endcase

    // When reset the world stops
    if(rst) begin
        // Reset state machine
        mcp_state <= ST_IDLE;
        // Output all high, no switches activated
        Joya_raw <= 8'hff;
        Joyb_raw <= 8'hff;
    end
end

    
// Byte to pin mapping
// Connects the received values to the Joystick pinout of the Amiga
// 7  6  5       4     3   2     1     0
// 1, 1, Fire 2, Fire, Up, Down, Left, right
assign Joya = { 2'b11, Joya_raw[5], Joya_raw[4], Joya_raw[3], Joya_raw[2], Joya_raw[1], Joya_raw[0] };
assign Joyb = { 2'b11, Joyb_raw[1], Joyb_raw[2], Joyb_raw[3], Joyb_raw[4], Joyb_raw[5], Joyb_raw[6] }; // Inverted because of PCB layout

endmodule
