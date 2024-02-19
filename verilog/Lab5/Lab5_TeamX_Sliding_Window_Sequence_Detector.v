`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

parameter [3:0] s1 = 4'b0000, s2 = 4'b0001, s3 = 4'b0010, s4 = 4'b0011, s5 = 4'b0100, ONE = 4'b0101, ZERO = 4'b0110, s6 = 4'b0111;
reg [3:0] state, nxt_state;
reg dec;

always @(posedge clk) begin
    if(~rst_n) begin
        state<=s1;
    end
    else begin
        state<=nxt_state;
    end
end

always@(*) begin
    case(state)
        s1:
            dec = 1'b0;      
        s2:
            dec = 1'b0;    
        s3:
            dec = 1'b0;
        s4:
            dec = 1'b0;    
        s5:
            dec = 1'b0;  
        ONE:
            dec = 1'b0;
        ZERO:
            dec = 1'b0;
        s6:
            if(in) dec = 1'b1;
            else dec = 1'b0;
         default:
            dec = 1'bx;  
    endcase
end

always @(*) begin
    case(state) 
        s1:
            if(in) nxt_state = s2;
            else nxt_state = s1;
        s2:
            if(in) nxt_state = s3;
            else nxt_state = s1;
        s3:
            if(in) nxt_state = s3;
            else nxt_state = s4;
        s4:
            if(in) nxt_state = s2;
            else nxt_state = s5;
        s5:
            if(in) nxt_state = ONE;
            else nxt_state = s1;
        ONE:
            if(in) nxt_state = s3;
            else nxt_state = ZERO;
        ZERO:
            if(in) nxt_state = ONE;
            else nxt_state = s6;
        s6:
            if(in) nxt_state = s2;
            else nxt_state = s1;
        default:
            ;
    endcase
end
endmodule 

