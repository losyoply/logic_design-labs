`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output [7:0] dout;
//
reg [3:0] rbaddr;
wire [6:0] wback;
wire [6:0] rback;
assign wback = waddr[6:0];
assign rback = raddr[6:0];
wire [6:0] addr[15:0];
wire [7:0] doutt0;wire [7:0] doutt1;wire [7:0] doutt2;wire [7:0] doutt3;
wire [3:0] r;
wire [3:0] w;
//always¾ãªv rbaddr
Bank b0(clk, r[0], w[0], raddr, waddr, din, doutt0);
Bank b1(clk, r[1], w[1], raddr, waddr, din, doutt1);
Bank b2(clk, r[2], w[2], raddr, waddr, din, doutt2);
Bank b3(clk, r[3], w[3], raddr, waddr, din, doutt3);
always@(posedge clk)begin
    rbaddr <= raddr[10:7];
end
//
assign dout = rbaddr==4'b0000 ? doutt0 :
rbaddr==4'b0001 ? doutt0:
rbaddr==4'b0010 ? doutt0:
rbaddr==4'b0011 ? doutt0:
rbaddr==4'b0100 ? doutt1:
rbaddr==4'b0101 ? doutt1:
rbaddr==4'b0110 ? doutt1:
rbaddr==4'b0111 ? doutt1:
rbaddr==4'b1000 ? doutt2:
rbaddr==4'b1001 ? doutt2:
rbaddr==4'b1010 ? doutt2:
rbaddr==4'b1011 ? doutt2:
rbaddr==4'b1100 ? doutt3:
rbaddr==4'b1101 ? doutt3:
rbaddr==4'b1110 ? doutt3:
doutt3 ;
assign r[0] = raddr[10:9]==2'b00 ? ren:0;
assign r[1] = raddr[10:9]==2'b01 ? ren:0;
assign r[2] = raddr[10:9]==2'b10 ? ren:0;
assign r[3] = raddr[10:9]==2'b11 ? ren:0;

assign w[0] = waddr[10:9]==2'b00 ? wen:0;
assign w[1] = waddr[10:9]==2'b01 ? wen:0;
assign w[2] = waddr[10:9]==2'b10 ? wen:0;
assign w[3] = waddr[10:9]==2'b11 ? wen:0;

endmodule

///////////////////////

module Bank(clk, ren, wen, raddr, waddr, din, dout);
input clk; input ren, wen; input [10:0] raddr, waddr; input [7:0] din; output[7:0] dout;
wire [7:0] doutt0;wire [7:0] doutt1;wire [7:0] doutt2;wire [7:0] doutt3;
wire [3:0]r,w;
assign r[0] = raddr[8:7]==2'b00 ? ren:0;
assign r[1] = raddr[8:7]==2'b01 ? ren:0;
assign r[2] = raddr[8:7]==2'b10 ? ren:0;
assign r[3] = raddr[8:7]==2'b11 ? ren:0;

assign w[0] = waddr[8:7]==4'b00 ? wen:0;
assign w[1] = waddr[8:7]==4'b01 ? wen:0;
assign w[2] = waddr[8:7]==4'b10 ? wen:0;
assign w[3] = waddr[8:7]==4'b11 ? wen:0;
///
wire nothing;
wire [6:0] addr[3:0];
assign addr[0] = ((waddr[8:7]!= 4'b00||~wen)&&(raddr[8:7]!=4'b00||~ren)) ? nothing: ren? raddr[6:0]:waddr[6:0];
assign addr[1] = ((waddr[8:7]!= 4'b01||~wen)&&(raddr[8:7]!=4'b01||~ren)) ? nothing: ren? raddr[6:0]:waddr[6:0];
assign addr[2] = ((waddr[8:7]!= 4'b10||~wen)&&(raddr[8:7]!=4'b10||~ren)) ? nothing: ren? raddr[6:0]:waddr[6:0];
assign addr[3] = ((waddr[8:7]!= 4'b11||~wen)&&(raddr[8:7]!=4'b11||~ren)) ? nothing: ren? raddr[6:0]:waddr[6:0];

Memory s0(clk, r[0], w[0], addr[0], din, doutt0);
Memory s1(clk, r[1],w[1], addr[1], din, doutt1);
Memory s2(clk, r[2], w[2], addr[2], din, doutt2);
Memory s3(clk, r[3],w[3], addr[3], din, doutt3);

reg [1:0]fff;
always@(posedge clk)begin
    fff <= raddr[8:7];
end

assign dout = fff==2'b00 ? doutt0 :
fff==2'b01 ? doutt1:
fff==2'b10 ? doutt2:
doutt3;

endmodule


module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output reg [7:0] dout;

reg [7:0] mem [127:0];

 always @(posedge clk)
    if(wen && !ren) mem[addr] <= din;
     
 always @(posedge clk)
 begin
     if(ren == 1'b1) dout <= mem[addr];
     else dout <= 8'b00000000;
 end  
endmodule
