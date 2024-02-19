`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
parameter s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011;
parameter k1 = 4'b0100, k2 = 4'b0101;
parameter w1 = 4'b0110, w2 = 4'b0111, w3 = 4'b1000;
parameter fail = 4'b1001;
reg [3:0] state;
reg dec;
reg [3:0] nxt_state;
reg [1:0] count;
wire pluscount = count+2'b01;
always@(*) begin
    if(state ==s0) count = 2'b00;
end
always @(*) begin
    case(state) 
        s0:
            if(in) nxt_state = s1;
            else nxt_state = w1;
        s1:
            if(in) nxt_state = k1;
            else nxt_state = s2;
        s2:
            if(in) nxt_state = fail;
            else nxt_state = s3;
        s3:
            if(in) nxt_state = s0;
            else nxt_state = s0;
        w1:
            if(in) nxt_state = w2;
            else nxt_state = fail;
        w2:
            if(in) nxt_state = w3;
            else nxt_state = fail;
        w3:
            if(in) nxt_state = s0;
            else nxt_state = s0;
        k1:
            if(in) nxt_state = k2;
            else nxt_state = fail;
        k2:
            if(in) nxt_state = s0;
            else nxt_state = s0;
        fail:
            if(count==2'b11) nxt_state = s0;
            else nxt_state = fail;
        default:
            ;
    endcase
end
always @(posedge clk) begin
    if(~rst_n) begin
        state<=s0;
    end
    else begin
        state<=nxt_state;
        count<= count+2'b01;
    end
end
always@(*) begin
    case(state)
        s0:
            dec = 1'b0;
        s1:
            dec = 1'b0;      
        s2:
            dec = 1'b0;    
        s3:
            if(in) dec = 1'b1;
            else dec = 1'b0;
        w1:
            dec = 1'b0;    
        w2:
            dec = 1'b0;  
        w3:
            if(in) dec = 1'b1;
            else dec = 1'b0;
        k1:
            dec = 1'b0;
        k2:
            if(in) dec = 1'b0;
            else dec = 1'b1;
        fail:
             dec = 1'b0;
         default:
            dec = 1'bx;
            
    endcase
end
endmodule
