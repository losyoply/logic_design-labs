`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [1:0] state;

    reg [1:0] next_state;
    parameter [1:0] STOP = 2'd0, STRI = 2'd1, RT = 2'd2, LT = 2'd3;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always@(posedge clk)begin
        if(reset)begin
            state <= STRI;
        end
        else begin
            state <= next_state;
        end
    end
    always@(*)begin
        if(left_signal==1'b1 && right_signal==1'b1 && mid_signal == 1'b1)begin
            next_state = STOP;
        end
        else if(left_signal==1'b1 && mid_signal==1'b0 && right_signal==1'b0)begin
            next_state = RT;
        end
        else if(right_signal==1'b1 && mid_signal==1'b0 && left_signal==1'b0)begin
           next_state = LT;
        end
        else begin
            next_state = STRI;
        end
    end

endmodule
