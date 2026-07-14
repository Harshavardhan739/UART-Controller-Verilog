`timescale 1ns/1ps

module uart_rx_tb;

//=====================================
// Parameters
//=====================================
parameter CLK_FREQ    = 100000000;
parameter BAUD_RATE   = 9600;
parameter DATA_BITS   = 8;
parameter STOP_BITS   = 2;
parameter PARITY_EN   = 1;
parameter PARITY_TYPE = 0;   // 0 = Even, 1 = Odd

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
wire parity_error;
wire framing_error;
wire busy;
wire [2:0] state;

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
    .STOP_BITS(STOP_BITS),
    .PARITY_EN(PARITY_EN),
    .PARITY_TYPE(PARITY_TYPE)
) uut_rx (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done),
    .parity_error(parity_error),
    .framing_error(framing_error),
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
    rst = 1'b1;
    rx  = 1'b1;

    #100;
    rst = 1'b0;

    repeat(5) @(posedge clk);

    //=====================================
    // Start Bit
    //=====================================
    rx = 1'b0;
    #BIT_TIME;

    //=====================================
    // Data Bits (LSB First)
    //=====================================
    if(DATA_BITS == 8)
    begin
        // 8'hA5 = 10100101
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b1; #BIT_TIME;
    end
    else
    begin
        // 7'h25
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
        rx = 1'b1; #BIT_TIME;
        rx = 1'b0; #BIT_TIME;
    end

    //=====================================
    // Parity Bit
    //=====================================
    if(PARITY_EN)
    begin
        if(PARITY_TYPE == 0)
            rx = ^8'hA5;       // Even parity
        else
            rx = ~(^8'hA5);    // Odd parity

        #BIT_TIME;
    end

    //=====================================
    // Stop Bit(s)
    //=====================================
    rx = 1'b1;

    if(STOP_BITS == 2)
        #(2 * BIT_TIME);
    else
        #BIT_TIME;

    #(5 * BIT_TIME);

    $finish;
end

endmodule