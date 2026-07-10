`timescale 1ns/1ps

module baud_gen_tb;

//=====================================
// Parameters
//=====================================
parameter CLK_FREQ  = 100000000;
parameter BAUD_RATE = 9600;

//=====================================
// Testbench Signals
//=====================================
reg clk;
reg rst;
wire baud_tick;

//=====================================
// DUT Instantiation
//=====================================
baud_gen #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) uut (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
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

    #100;
    rst = 1'b0;

    // Run long enough to observe baud_tick
    #2000000;

    $finish;
end

endmodule