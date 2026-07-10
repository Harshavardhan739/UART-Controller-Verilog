`timescale 1ns/1ps

module uart_rx #(
    parameter DATA_BITS = 8,
    parameter STOP_BITS = 1
)(
    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [DATA_BITS-1:0] data_out,
    output reg rx_done,
    output reg busy,
    output reg [1:0] state
);

//=====================================
// Internal Registers
//=====================================
reg [DATA_BITS-1:0] shift_reg;
reg [3:0] bit_count;
reg [1:0] stop_count;

//=====================================
// FSM State Definitions
//=====================================
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

//=====================================
// Sequential Logic
//=====================================
always @(posedge clk)
begin

    if(rst)
    begin
        data_out   <= {DATA_BITS{1'b0}};
        rx_done    <= 1'b0;
        busy       <= 1'b0;

        shift_reg  <= {DATA_BITS{1'b0}};
        bit_count  <= 4'd0;
        stop_count <= 2'd0;

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
            rx_done <= 1'b0;
            busy    <= 1'b0;

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
            begin
                state <= DATA;
            end
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
            if(baud_tick)
            begin
                if(stop_count == STOP_BITS-1)
                begin
                    stop_count <= 2'd0;
                    data_out   <= shift_reg;
                    rx_done    <= 1'b1;
                    busy       <= 1'b0;
                    state      <= IDLE;
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
            state      <= IDLE;
            busy       <= 1'b0;
            rx_done    <= 1'b0;
            bit_count  <= 4'd0;
            stop_count <= 2'd0;
        end

        endcase

    end

end

endmodule