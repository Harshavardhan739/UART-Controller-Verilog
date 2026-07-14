`timescale 1ns/1ps

module uart_rx #(
    parameter DATA_BITS   = 8,
    parameter STOP_BITS   = 1,
    parameter PARITY_EN   = 0,
    parameter PARITY_TYPE = 0
)(
    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [DATA_BITS-1:0] data_out,
    output reg rx_done,
    output reg parity_error,
    output reg framing_error,
    output reg busy,
    output reg [2:0] state
);

//=====================================
// Internal Registers
//=====================================
reg [DATA_BITS-1:0] shift_reg;
reg [3:0] bit_count;
reg [1:0] stop_count;
reg parity_bit;


//=====================================
// FSM State Definitions
//=====================================
parameter IDLE   = 3'b000;
parameter START  = 3'b001;
parameter DATA   = 3'b010;
parameter PARITY = 3'b011;
parameter STOP   = 3'b100;

//=====================================
// Sequential Logic
//=====================================
always @(posedge clk)
begin

    if(rst)
    begin
        data_out      <= {DATA_BITS{1'b0}};
        rx_done       <= 1'b0;
        parity_error  <= 1'b0;
        framing_error <= 1'b0;
        busy          <= 1'b0;

        shift_reg     <= {DATA_BITS{1'b0}};
        bit_count     <= 4'd0;
        stop_count    <= 2'd0;
        parity_bit    <= 1'b0;


        state <= IDLE;
    end

    else
    begin

        case(state)


        //=====================================
        // IDLE STATE
        //=====================================
        IDLE:
        begin
            rx_done       <= 1'b0;
            parity_error  <= 1'b0;
            framing_error <= 1'b0;
            busy          <= 1'b0;

          
            if(rx == 1'b0)
            begin
                busy       <= 1'b1;
                bit_count  <= 4'd0;
                stop_count <= 2'd0;
                state      <= START;
            end
        end

        //=====================================
        // START STATE
        //=====================================
        START:
        begin
            if(baud_tick)
                state <= DATA;
        end

        //=====================================
        // DATA STATE
        //=====================================
        DATA:
        begin
            if(baud_tick)
            begin
                shift_reg <= {rx, shift_reg[DATA_BITS-1:1]};

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
            if(baud_tick)
            begin
                parity_bit <= rx;

                if(PARITY_EN)
                begin
                    if(PARITY_TYPE == 0)
                    begin
                        // Even Parity Check
                        parity_error <= (rx != (^shift_reg));
                    end
                    else
                    begin
                        // Odd Parity Check
                        parity_error <= (rx != (~(^shift_reg)));
                    end
                end
                else
                begin
                    parity_error <= 1'b0;
                end

                state <= STOP;
            end
        end

        //=====================================
        // STOP STATE
        //=====================================
        STOP:
        begin
            if(baud_tick)
            begin
                //=====================================
                // Framing Error Detection
                //=====================================
                if(rx != 1'b1)
                begin
                    framing_error <= 1'b1;
                end
                else
                begin
                    framing_error <= 1'b0;
                end

                if(stop_count == STOP_BITS-1)
                begin
                    stop_count   <= 2'd0;
                    data_out     <= shift_reg;
                    rx_done      <= 1'b1;
                    busy         <= 1'b0;
                    state        <= IDLE;
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
            state         <= IDLE;
            busy          <= 1'b0;
            rx_done       <= 1'b0;
            parity_error  <= 1'b0;
            framing_error <= 1'b0;
            bit_count     <= 4'd0;
            stop_count    <= 2'd0;
            parity_bit    <= 1'b0;
        end

        endcase

    end

end

endmodule