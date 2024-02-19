`timescale 1ns/1ps 
//https://www.youtube.com/watch?v=1ubyXuXxIWU
module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output signed [7:0] p;
reg signed [7:0] p;


parameter [1:0] WAIT = 2'd0, CAL = 2'd1, FINISH = 2'd2;
reg [1:0] state, next_state;
reg [2:0]count, next_count;

reg signed [3:0] x, y;
reg signed [8:0] z, next_z;
reg[3:0] temp;
reg[3:0] minus_y;

always@(posedge clk)begin//state
    if(!rst_n) state <= WAIT;
    else state <= next_state;       
end

always@(*)begin//next_state
    case(state)
        WAIT:begin
            if(start) next_state = CAL;
            else next_state = WAIT;
        end
        CAL:begin
            if(count==3'd3)next_state = FINISH;
            else next_state = CAL;
        end
        FINISH:begin
            next_state <= WAIT;
        end
    endcase
end
always@(*)begin//output
    case(state)
        WAIT:begin
            p = 1'b0;
            x = a;
            y = b;
        end
        CAL:begin
            x = x;
            y = y;
            p = 1'b0;
        end
        FINISH:begin
            x = x;
            y = y;
            if(y==4'd8) p = -z[8:1];
            else p = z[8:1];
        end
    endcase
end

always@(posedge clk)begin//count
    if(!rst_n) count <= 1'b0;
    case(state)
        WAIT: count <= 1'b0;
        CAL: count <= next_count;
        FINISH: count <= 1'b0;
    endcase
end
always@(*)begin//next_count
    if(!rst_n) next_count = 1'b0;
    else next_count = count + 1'b1;
end
always@(*)begin
    minus_y[0] = !y[0];
    minus_y[1] = !y[1];
    minus_y[2] = !y[2];
    minus_y[3] = !y[3];
    minus_y = minus_y + 1'b1;
end
always@(posedge clk)begin//z
    if(!rst_n) z <= 9'd0;
    else z <= next_z;
end

always@(*)begin//next_z
    case(state)
        WAIT:begin
            next_z = {4'd0, x, 1'd0};
        end
        CAL:begin
            if(z[1:0]==2'b10)begin//sub
                next_z[8:5] = z[8:5] + minus_y;
            end
            else if(z[1:0]==2'b01)begin//add
                next_z[8:5] = z[8:5] + y;
            end
            else begin//shift
            end
            next_z = {next_z[8], next_z[8:1]};
        end
        FINISH:begin
            next_z = next_z;
        end
    endcase
    
end

endmodule


