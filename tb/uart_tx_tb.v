`timescale 1ns/1ps

module uart_tx_tb;

//=====================================
// Parameters
//=====================================
parameter CLK_FREQ  = 100000000;
parameter BAUD_RATE = 9600;
parameter DATA_BITS = 8;

// UART Bit Time (in ns)
localparam integer BIT_TIME = 1000000000 / BAUD_RATE;

//=====================================
// Testbench Input Signals
//=====================================
reg clk;
reg rst;
reg tx_start;
reg [DATA_BITS-1:0] data_in;

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
baud_gen #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) uut_baud (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//=====================================
// UART Transmitter Instantiation
//=====================================
uart_tx #(
    .DATA_BITS(DATA_BITS)
) uut_tx (
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
    rst      = 1'b1;
    tx_start = 1'b0;
    data_in  = {DATA_BITS{1'b0}};

    // Apply Reset
    #100;
    rst = 1'b0;

    // Wait for a few clock cycles
    repeat(5) @(posedge clk);

    // Send Data
    data_in  = 8'hA5;
    tx_start = 1'b1;

    // Pulse tx_start for one clock cycle
    @(posedge clk);
    tx_start = 1'b0;

    // Wait long enough for complete transmission
    #(12 * BIT_TIME);

    // End Simulation
    $finish;
end

endmodule