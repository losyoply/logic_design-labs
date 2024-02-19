`timescale 1ns/1ps
//https://github.com/laplaceyc/VLSI_Design-Implementation/blob/master/Lab3_Parameterized_Pingpong_Counter/lab03_pingpong.v
//https://github.com/laplaceyc/VLSI_Design-Implementation/tree/master/Lab3_Parameterized_Pingpong_Counter
module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output direction;
output [3:0] out;
reg direction;
reg [3:0] out;
wire[3:0] up, down;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out <= min;
        direction <= 1'b1;
    end
    else if(enable == 1'b1 && max > min && out<=max && out>=min) begin
        if((direction==1'b1 && out < max) || out==min)begin
            if(flip==1'b1)begin
                direction <= 1'b0;
                out <= down;
            end
            else begin
                direction <= 1'b1; 
                out <= up;
            end
        end
        else if((direction==1'b0 && out > min) || out==max)begin
            if(flip==1'b1)begin
                direction <= 1'b1; 
                out <= up;
            end
            else begin
                direction <= 1'b0;
                out <= down;
            end
        end
    end
end
assign up = out + 1'b1;
assign down = out - 1'b1;

endmodule