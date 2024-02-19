`timescale 1ns/1ps
////Output low black line, a white line output high
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [2:0] state;

    reg [2:0] next_state;
    parameter [2:0] STOP = 3'b000, TR = 3'b001, STR = 3'b010, TR_min = 3'b011, TL = 3'b100, STR_fail=3'b101,TL_min=3'b110, STRR = 3'b111;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always@(posedge clk)begin
        if(reset)begin
            state <= STOP;
        end
        else begin
            state <= next_state;
        end
    end
    always@(*)begin
       next_state = {left_signal, mid_signal, right_signal};
    end

endmodule
