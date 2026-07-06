`timescale 1ns/1ps

module uart_rx(

    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [7:0] data_out,
    output reg rx_done,
    output reg busy,
    output reg [1:0] state

);

//=====================================
// Internal Registers
//=====================================
reg [7:0] shift_reg;
reg [3:0] bit_count;

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
        data_out  <= 8'd0;
        rx_done   <= 1'b0;
        busy      <= 1'b0;

        shift_reg <= 8'd0;
        bit_count <= 4'd0;

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
                busy      <= 1'b1;
                bit_count <= 4'd0;
                state     <= START;
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
                shift_reg <= {rx, shift_reg[7:1]};
                bit_count <= bit_count + 1;

                if(bit_count == 4'd7)
                begin
                    state <= STOP;
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
                data_out <= shift_reg;
                rx_done  <= 1'b1;
                busy     <= 1'b0;
                state    <= IDLE;
            end
        end

        default:
        begin
            state <= IDLE;
        end

        endcase

    end

end

endmodule