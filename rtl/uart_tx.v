`timescale 1ns/1ps

module uart_tx #(
    parameter DATA_BITS = 8
)(
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [DATA_BITS-1:0] data_in,

    output reg tx,
    output reg busy,
    output reg [1:0] state
);

//=====================================
// Internal Registers
//=====================================
reg [3:0] bit_count;
reg [DATA_BITS-1:0] shift_reg;

//=====================================
// FSM State Encoding
//=====================================
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

//=====================================
// UART Transmitter Sequential Logic
//=====================================
always @(posedge clk)
begin

    if(rst)
    begin
        tx        <= 1'b1;
        busy      <= 1'b0;
        bit_count <= 4'd0;
        shift_reg <= {DATA_BITS{1'b0}};
        state     <= IDLE;
    end

    else
    begin

        case(state)

        //=====================================
        // IDLE STATE
        //=====================================
        IDLE:
        begin
            tx   <= 1'b1;
            busy <= 1'b0;

            if(tx_start)
            begin
                shift_reg <= data_in;
                bit_count <= 4'd0;
                busy      <= 1'b1;
                state     <= START;
            end
        end

        //=====================================
        // START STATE
        //=====================================
        START:
        begin
            tx <= 1'b0;

            if(baud_tick)
                state <= DATA;
        end

        //=====================================
        // DATA STATE
        //=====================================
        DATA:
        begin
            tx <= shift_reg[0];

            if(baud_tick)
            begin
                shift_reg <= shift_reg >> 1;

                if(bit_count == DATA_BITS-1)
                begin
                    bit_count <= 4'd0;
                    state <= STOP;
                end
                else
                begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end

        //=====================================
        // STOP STATE
        //=====================================
        STOP:
        begin
            tx <= 1'b1;

            if(baud_tick)
            begin
                busy  <= 1'b0;
                state <= IDLE;
            end
        end

        //=====================================
        // DEFAULT
        //=====================================
        default:
        begin
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_count <= 4'd0;
            state     <= IDLE;
        end

        endcase

    end

end

endmodule