`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
reg [7:0] DFF;
reg [7:0] nxt;
always@(posedge clk) begin
    if(~rst_n) DFF<=8'b10111101;
    else DFF<= nxt;
end
reg Back;
always@(*) begin
    Back = (DFF[1]^DFF[2])^(DFF[3]^DFF[7]);
    nxt[7] = DFF[6];
    nxt[6] = DFF[5];
    nxt[5] = DFF[4];
    nxt[4] = DFF[3];
    nxt[3] = DFF[2];
    nxt[2] = DFF[1];
    nxt[1] = DFF[0];
    nxt[0] = Back;
end
always@(*)  out = DFF;
endmodule

