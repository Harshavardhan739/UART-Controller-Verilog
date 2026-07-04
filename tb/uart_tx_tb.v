`timescale 1ns/1ps

module uart_tx_tb;

//=====================================
// Testbench Input Signals
//=====================================
reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

//=====================================
// Testbench Output Signals
//=====================================
wire baud_tick;
wire tx;
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
// UART Transmitter Instantiation
//=====================================
uart_tx uut_tx(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
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
    tx_start = 1'b0;
    data_in = 8'h00;

    // Apply Reset
    #20;
    rst = 1'b0;

    // Wait for some time
    #20;

    // Send Data
    data_in = 8'hA5;
    tx_start = 1'b1;

    // Pulse tx_start for one clock cycle
    #10;
    tx_start = 1'b0;

    // Wait long enough for baud generator and UART transmission
    #15000000;

    // End Simulation
    $finish;
end

endmodule