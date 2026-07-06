`timescale 1ns/1ps

module uart_top_tb;

//=====================================
// Testbench Inputs
//=====================================
reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

//=====================================
// Testbench Outputs
//=====================================
wire [7:0] data_out;
wire tx;
wire rx_done;
wire busy;

//=====================================
// UART Top Instantiation
//=====================================
uart_top uut (

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

    // Wait for transmission and reception
    #15000000;

    // End Simulation
    $finish;
end

endmodule