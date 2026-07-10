`timescale 1ns/1ps

module uart_top #(
    parameter CLK_FREQ  = 100000000,
    parameter BAUD_RATE = 9600,
    parameter DATA_BITS = 8,
    parameter STOP_BITS = 1
)(
    input clk,
    input rst,
    input tx_start,
    input [DATA_BITS-1:0] data_in,

    output [DATA_BITS-1:0] data_out,
    output tx,
    output rx_done,
    output busy
);

//=====================================
// Internal Signals
//=====================================
wire baud_tick;
wire tx_line;
wire busy_tx;
wire [1:0] tx_state;
wire [1:0] rx_state;

//=====================================
// Baud Generator Instantiation
//=====================================
baud_gen #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
)
baud_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//=====================================
// UART Transmitter Instantiation
//=====================================
uart_tx #(
    .DATA_BITS(DATA_BITS),
    .STOP_BITS(STOP_BITS)
)
tx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx_line),
    .busy(busy_tx),
    .state(tx_state)
);

//=====================================
// UART Receiver Instantiation
//=====================================
uart_rx #(
    .DATA_BITS(DATA_BITS),
    .STOP_BITS(STOP_BITS)
)
rx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(tx_line),
    .data_out(data_out),
    .rx_done(rx_done),
    .busy(busy),
    .state(rx_state)
);

//=====================================
// Output Assignment
//=====================================
assign tx = tx_line;

endmodule