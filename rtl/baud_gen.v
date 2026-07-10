`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ  = 100000000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input rst,
    output reg baud_tick
);

localparam integer BAUD_COUNT = (CLK_FREQ / BAUD_RATE) - 1;

reg [31:0] count;

always @(posedge clk)
begin
    if (rst)
    begin
        count <= 0;
        baud_tick <= 1'b0;
    end
    else
    begin
        if (count == BAUD_COUNT)
        begin
            count <= 0;
            baud_tick <= 1'b1;
        end
        else
        begin
            count <= count + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule