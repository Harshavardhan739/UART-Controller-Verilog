`timescale 1ns/1ps

module uart_rx_tb;

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
wire [7:0] data_out;
wire rx_done;
wire busy;
wire [1:0] state;

//=====================================
// Baud Rate Generator Instantiation
//=====================================
baud_gen uut_baud(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//=====================================
// UART Receiver Instantiation
//=====================================
uart_rx uut_rx(
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
    rx  = 1'b1;      // UART Idle State

    // Apply Reset
    #20;
    rst = 1'b0;

    // Wait
    #20;

    //=====================================
    // Send UART Frame (8'hA5)
    // LSB First
    //=====================================

    // Start Bit
    rx = 1'b0;
    #104160;

    // Data Bits (A5 = 10100101)
    // LSB First = 1 0 1 0 0 1 0 1

    rx = 1'b1;   // Bit0
    #104160;

    rx = 1'b0;   // Bit1
    #104160;

    rx = 1'b1;   // Bit2
    #104160;

    rx = 1'b0;   // Bit3
    #104160;

    rx = 1'b0;   // Bit4
    #104160;

    rx = 1'b1;   // Bit5
    #104160;

    rx = 1'b0;   // Bit6
    #104160;

    rx = 1'b1;   // Bit7
    #104160;

    // Stop Bit
    rx = 1'b1;

    //=====================================
    // Wait Long Enough for UART Reception
    //=====================================
    #15000000;

    // End Simulation
    $finish;

end

endmodule