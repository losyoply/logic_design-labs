`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [3:0] state;

    reg [3:0] next_state;
    parameter [3:0] STRI = 4'd1, RT = 4'd2, LT = 4'd3, B_RT = 4'd4, B_LT = 4'd5;

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
        if(left_signal==1'b1 && mid_signal==1'b0 && right_signal==1'b0)begin
            next_state = B_LT; // B_LT
        end
        else if(right_signal==1'b1 && mid_signal==1'b0 && left_signal==1'b0)begin
           next_state = B_RT; // B_RT
        end
        else if(left_signal==1'b1 && mid_signal==1'b1 && right_signal==1'b0)begin
            next_state = LT; // LT
        end
        else if(left_signal==1'b0 && mid_signal==1'b1 && right_signal==1'b1)begin
            next_state = RT; // RT
        end
//        else if(left_signal==1'b0 && mid_signal==1'b0 && right_signal==1'b0)begin
//            next_state = LT;
//        end
        else if(left_signal==1'b1 && mid_signal==1'b1 && right_signal==1'b1)begin
            next_state = B_RT;
        end
        else begin
            next_state = STRI;
        end
    end

endmodule
