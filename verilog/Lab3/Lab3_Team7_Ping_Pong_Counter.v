`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [3:0] out;
reg direction;
reg [3:0] out;

always@(posedge clk) begin
    if(rst_n == 1'b0) begin
        out <= 4'b0;
        direction <= 1'b1;
    end
    else if(enable == 1'b1) begin
            if (direction == 1'b1 && out == 4'b1111) begin
                out <= out - 1'b1;
                direction <= !direction;
            end
            else if(direction == 1'b0 && out == 4'b0) begin
                out <= out + 1'b1;
                direction <= !direction;
            end
            else out <= (direction == 1'b1) ? out + 1'b1 : out - 1'b1;
     end
     else begin
     //do nothing
     end
end

endmodule

/*
out: 0,1,2,??,13,14,15,14,13,??,2,1,0,1,2,?? 
direction: 1,1,1,??..,1, 1, 1, 0, 0,??, 0,0,0,1,1,??
*/