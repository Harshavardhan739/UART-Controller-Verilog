`timescale 1ns/1ps

module uart_tx #(
    parameter DATA_BITS   = 8,
    parameter STOP_BITS   = 1,
    parameter PARITY_EN   = 0,
    parameter PARITY_TYPE = 0
)(
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [DATA_BITS-1:0] data_in,

    output reg tx,
    output reg busy,
    output reg [2:0] state
);

//=====================================
// Internal Registers
//=====================================
reg [3:0] bit_count;
reg [1:0] stop_count;
reg [DATA_BITS-1:0] shift_reg;
reg parity_bit;

//=====================================
// FSM State Encoding
//=====================================
parameter IDLE   = 3'b000;
parameter START  = 3'b001;
parameter DATA   = 3'b010;
parameter PARITY = 3'b011;
parameter STOP   = 3'b100;

//=====================================
// UART Transmitter Sequential Logic
//=====================================
always @(posedge clk)
begin

    if(rst)
    begin
        tx         <= 1'b1;
        busy       <= 1'b0;
        bit_count  <= 4'd0;
        stop_count <= 2'd0;
        shift_reg  <= {DATA_BITS{1'b0}};
        parity_bit <= 1'b0;
        state      <= IDLE;
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
                shift_reg  <= data_in;
                bit_count  <= 4'd0;
                stop_count <= 2'd0;

                //=====================================
                // Parity Generation
                //=====================================
                if(PARITY_EN)
                begin
                    if(PARITY_TYPE == 0)
                        parity_bit <= ^data_in;      // Even Parity
                    else
                        parity_bit <= ~(^data_in);   // Odd Parity
                end
                else
                begin
                    parity_bit <= 1'b0;
                end

                busy  <= 1'b1;
                state <= START;
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

                    if(PARITY_EN)
                        state <= PARITY;
                    else
                        state <= STOP;
                end
                else
                begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end

        //=====================================
        // PARITY STATE
        //=====================================
        PARITY:
        begin
            tx <= parity_bit;

            if(baud_tick)
                state <= STOP;
        end

        //=====================================
        // STOP STATE
        //=====================================
        STOP:
        begin
            tx <= 1'b1;

            if(baud_tick)
            begin
                if(stop_count == STOP_BITS-1)
                begin
                    stop_count <= 2'd0;
                    busy <= 1'b0;
                    state <= IDLE;
                end
                else
                begin
                    stop_count <= stop_count + 1'b1;
                end
            end
        end

        //=====================================
        // DEFAULT
        //=====================================
        default:
        begin
            tx         <= 1'b1;
            busy       <= 1'b0;
            bit_count  <= 4'd0;
            stop_count <= 2'd0;
            parity_bit <= 1'b0;
            state      <= IDLE;
        end

        endcase

    end

end

endmodule