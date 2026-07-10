`timescale 1ns/1ps

module uart_rx_tb;

//=====================================
// Parameters
//=====================================
parameter CLK_FREQ  = 100000000;
parameter BAUD_RATE = 9600;
parameter DATA_BITS = 8;
parameter STOP_BITS = 2;

// UART Bit Time (in ns)
localparam integer BIT_TIME = 1000000000 / BAUD_RATE;

//=====================================
// Testbench Input Signals
//=====================================
reg clk;
reg rst;
reg rx;

//=====================================
// Testbench Output Signals
//=====================================
wire baud_tick;
wire [DATA_BITS-1:0] data_out;
wire rx_done;
wire busy;
wire [1:0] state;

//=====================================
// Baud Rate Generator Instantiation
//=====================================
baud_gen #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) uut_baud (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//=====================================
// UART Receiver Instantiation
//=====================================
uart_rx #(
    .DATA_BITS(DATA_BITS),
    .STOP_BITS(STOP_BITS)
) uut_rx (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done),
    .busy(busy),
    .state(state)
);

//=====================================
// Clock Generation (100 MHz)
//=====================================
initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

//=====================================
// Test Stimulus
//=====================================
initial
begin

    // Initialize Inputs
    rst = 1'b1;
    rx  = 1'b1;

    // Apply Reset
    #100;
    rst = 1'b0;

    // Wait a few clock cycles
    repeat(5) @(posedge clk);

    //=====================================
    // UART Frame (LSB First)
    //=====================================

    // Start Bit
    rx = 1'b0;
    #BIT_TIME;

    //=====================================
    // Data Bits
    //=====================================
    if (DATA_BITS == 8)
    begin
        // 8'hA5 = 10100101
        rx = 1'b1; #BIT_TIME;   // Bit0
        rx = 1'b0; #BIT_TIME;   // Bit1
        rx = 1'b1; #BIT_TIME;   // Bit2
        rx = 1'b0; #BIT_TIME;   // Bit3
        rx = 1'b0; #BIT_TIME;   // Bit4
        rx = 1'b1; #BIT_TIME;   // Bit5
        rx = 1'b0; #BIT_TIME;   // Bit6
        rx = 1'b1; #BIT_TIME;   // Bit7
    end
    else
    begin
        // 7'h25 = 0100101
        rx = 1'b1; #BIT_TIME;   // Bit0
        rx = 1'b0; #BIT_TIME;   // Bit1
        rx = 1'b1; #BIT_TIME;   // Bit2
        rx = 1'b0; #BIT_TIME;   // Bit3
        rx = 1'b0; #BIT_TIME;   // Bit4
        rx = 1'b1; #BIT_TIME;   // Bit5
        rx = 1'b0; #BIT_TIME;   // Bit6
    end

    //=====================================
    // Stop Bit(s)
    //=====================================
    rx = 1'b1;

    if (STOP_BITS == 2)
        #(2 * BIT_TIME);
    else
        #BIT_TIME;

    // Keep Line Idle
    #(5 * BIT_TIME);

    $finish;

end

endmodule