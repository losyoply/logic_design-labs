`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;
//
wire notq, nott;
wire xorout, andout;
wire xorchild1, xorchild2;
not nq(notq, q);
not nt(nott, t);
//A xor B == (A and notB) or (notA and B)
and xorand1(xorchild1, q, nott);
and xorand2(xorchild2, notq, t);
or xoror(xorout, xorchild1, xorchild2);

and and1(andout, xorout, rst_n);

D_Flip_Flop dff(clk, andout, q);


endmodule

//
module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;
wire notclk, qq;

not not0(notclk, clk);
D_Latch Master(notclk, d, qq);
D_Latch Slave(clk, qq, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;
wire notd, upnand, downnand , notq;

not n1(notd, d);
nand nand1(upnand, d, e);
nand nand2(downnand, notd, e);

nand nand3(q, upnand, notq);
nand nand4(notq, q, downnand); 

endmodule