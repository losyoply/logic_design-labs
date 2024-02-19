`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output [7:0] dout;
output valid;
//
wire [7:0] doutt [3:0];
wire [3:0] ren;
wire [3:0] error;
reg validd;
//reg valid;
FIFO_8 afi(clk, rst_n, wen[0], ren[0], a, doutt[0], error[0]);
FIFO_8 bfi(clk, rst_n, wen[1], ren[1], b, doutt[1], error[1]);
FIFO_8 cfi(clk, rst_n, wen[2], ren[2], c, doutt[2], error[2]);
FIFO_8 dfi(clk, rst_n, wen[3], ren[3], d, doutt[3], error[3]);
//state
parameter FIFOa = 2'b00;
parameter FIFOb = 2'b01;
parameter FIFOc = 2'b10;
parameter FIFOd = 2'b11;
reg [1:0] state;
reg [1:0] nxtstate;
//state change
always@(posedge clk)
begin
    if(~rst_n) state<=FIFOa;
    else if(state==FIFOa) state<=FIFOb ;
    else if(state==FIFOb) state<=FIFOc ;
    else if(state==FIFOc) state<=FIFOd ;
    else if(state==FIFOd) state<=FIFOa ;
    //else state<=FIFOa;
end
//can it read?
assign ren = (state==FIFOa&&~wen[0]) ? 4'b0001:
(state==FIFOb&&~wen[1]) ? 4'b0010:
(state==FIFOc&&~wen[2]) ? 4'b0100:
(state==FIFOd&&~wen[3]) ? 4'b1000 : 4'b0000;
//
assign dout = state==FIFOb ? doutt[0]:
state==FIFOc ? doutt[1]:
state==FIFOd ? doutt[2]:
doutt[3];
//is it valid
always@(posedge clk)begin
    if(ren[0]) validd<=1;
    else if(ren[1]) validd<=1;
    else if(ren[2]) validd<=1;
    else if(ren[3]) validd<=1;
    else validd<=0;
end
assign valid= ~validd ? 0 :
(error[0]||error[1]||error[2]||error[3] )? 0:1;
endmodule

///////

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;
reg error;
reg [7:0] dout;
/////
reg full_in, empty_in;
reg [7:0] mem [7:0];
reg [2:0] rp, wp;
//read data
always@(posedge clk)begin
    if(ren && ~empty_in)begin dout<=mem[rp]; end
    else begin dout<= 0; end
end
//mem write in
always@(posedge clk) begin
    if(wen && ~full_in && ~ren) mem[wp]<=din;
end
//wp increase
always@(posedge clk)
begin
    if(!rst_n) wp<=0;
    else begin
      if(wen && ~full_in && ~ren) wp<= wp+1'b1;
    end
end
//rp increase
always@(posedge clk)begin
    if(!rst_n) rp <= 0;
    else begin
      if(ren && ~empty_in) rp <= rp + 1'b1;
    end
end
//full_in
always@(posedge clk) begin
    if(!rst_n) full_in <= 1'b0;
    else begin
      if( (~ren && wen)&&((wp==rp-1)||(rp==3'b0&&wp==3'b111)))
          full_in <= 1'b1;
      else if(full_in && ren) full_in <= 1'b0;
    end
end
//empty_in
always@(posedge clk) begin
    if(!rst_n) empty_in <= 1'b1;
    else begin
      if((ren)&&(rp==wp-1 || (rp==3'b111 && wp==3'b000)))
        empty_in<=1'b1;
      else if(empty_in && wen && ~ren) empty_in<=1'b0;
    end
end
//err
always@(posedge clk) begin
    if(ren && empty_in) error <= 1'b1;
    else if(wen && ~ren && full_in) error <= 1'b1;
    else error <= 1'b0;
end
endmodule
