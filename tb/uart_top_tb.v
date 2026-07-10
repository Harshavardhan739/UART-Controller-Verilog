`timescale 1ns/1ps

module uart_top_tb;

//=====================================
// Parameters
//=====================================
parameter CLK_FREQ  = 100000000;
parameter BAUD_RATE = 9600;
parameter DATA_BITS = 8;

// UART Bit Time (ns)
localparam integer BIT_TIME = 1000000000 / BAUD_RATE;

//=====================================
// Testbench Inputs
//=====================================
reg clk;
reg rst;
reg tx_start;
reg [DATA_BITS-1:0] data_in;

//=====================================
// Testbench Outputs
//=====================================
wire [DATA_BITS-1:0] data_out;
wire tx;
wire rx_done;
wire busy;

//=====================================
// UART Top Instantiation
//=====================================
uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE),
    .DATA_BITS(DATA_BITS)
) uut (

    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),

    .data_out(data_out),
    .tx(tx),
    .rx_done(rx_done),
    .busy(busy)

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

    // Wait a few clock cycles
    repeat(5) @(posedge clk);

    // Send Data
    data_in  = 8'hA5;
    tx_start = 1'b1;

    // Pulse tx_start for one clock cycle
    @(posedge clk);
    tx_start = 1'b0;

    // Wait for complete transmission and reception
    #(12 * BIT_TIME);

    $finish;
end

endmodule