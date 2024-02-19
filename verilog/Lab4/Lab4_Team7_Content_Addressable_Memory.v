`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;
reg [3:0] dout;
reg hit;
reg [7:0]mem[15:0];

reg next_hit;
reg [3:0] next_dout;
reg [4:0] i;

always@(posedge clk)begin
    if(ren)begin
        dout <= next_dout;
        hit <= next_hit;
    end
    else if(wen && !ren)begin
        mem[addr] <= din;
        dout <= 1'b0;
        hit <= 1'b0;
    end
    else begin
        dout <= 1'b0;
        hit <= 1'b0;
    end
end

always@(*)begin
    next_hit = 1'b0;
    next_dout = 1'b0;
    if(mem[4'b1111] == din)begin
        next_hit = 1'b1;
        next_dout = 4'b1111;
    end
    else if(mem[4'b1110] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1110;
    end
    else if(mem[4'b1101] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1101;
    end
    else if(mem[4'b1100] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1100;
    end
    else if(mem[4'b1011] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1011;
    end
    else if(mem[4'b1010] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1010;
    end
    else if(mem[4'b1001] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1001;
    end
    else if(mem[4'b1000] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b1000;
    end
    else if(mem[4'b0111] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0111;
    end
    else if(mem[4'b0110] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0110;
    end
    else if(mem[4'b0101] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0101;
    end
    else if(mem[4'b0100] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0100;
    end
    else if(mem[4'b0011] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0011;
    end
    else if(mem[4'b0010] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0010;
    end
    else if(mem[4'b0001] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0001;
    end
    else if(mem[4'b0000] == din && !next_hit)begin
        next_hit = 1'b1;
        next_dout = 4'b0000;
    end
    else begin
        next_hit = next_hit;
        next_dout = next_dout; 
    end
    
    
end
endmodule
