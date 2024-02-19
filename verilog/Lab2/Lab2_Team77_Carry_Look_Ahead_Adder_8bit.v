`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;

wire[7:0]p,g;
wire[7:1]c;
wire [1:0] pg, gg;

subadder s0(a[0], b[0], c0, s[0], p[0], g[0]);
subadder s1(a[1], b[1], c[1], s[1], p[1], g[1]);
subadder s2(a[2], b[2], c[2], s[2], p[2], g[2]);
subadder s3(a[3], b[3], c[3], s[3], p[3], g[3]);
subadder s4(a[4], b[4], c[4], s[4], p[4], g[4]);
subadder s5(a[5], b[5], c[5], s[5], p[5], g[5]);
subadder s6(a[6], b[6], c[6], s[6], p[6], g[6]);
subadder s7(a[7], b[7], c[7], s[7], p[7], g[7]);

CLG_4bit CLG0to3(p[3:0], g[3:0], c0,c[1],c[2],c[3], pg[0],gg[0]);
CLG_4bit CLG5to7(p[7:4], g[7:4], c[4],c[5],c[6],c[7], pg[1],gg[1]);
CLG_2bit CLG48(c0,pg[0], gg[0], pg[1], gg[1], c[4], c8);
endmodule

module subadder(a, b, c, s, p, g);
input a, b, c;
output s, p, g;

xor_gate propagate(p, a, b);
and_gate generatee(g, a, b);
xor_gate sum(s, c, p);

endmodule

module CLG_4bit(p, g, c0,c1,c2,c3, pg,gg);
input[3:0] p, g;
input c0;
output c1,c2,c3;
output pg,gg;

//remeber g need to turn to g_bar!!!
wire[3:0] g_bar;
nand g3(g_bar[3],g[3],g[3]);
nand g2(g_bar[2],g[2],g[2]);
nand g1(g_bar[1],g[1],g[1]);
nand g0(g_bar[0],g[0],g[0]);

wire c1,c2,c3;
wire p0c0;
nand na01(p0c0,p[0],c0);
nand na11(c1,p0c0,g_bar[0]); 

wire p01c0,p1g0;
nand na02(p01c0,p[1],p[0],c0);
nand na002(p1g0,p[1],g[0]);
nand na12(c2,p1g0,p01c0,g_bar[1]); 

wire p012c0,p12g0,p2g1;
nand na03(p012c0,p[2],p[1],p[0],c0);
nand na003(p12g0,p[2],p[1],g[0]);
nand na0003(p2g1,p[2],g[1]);
nand na13(c3,p012c0,p12g0,p2g1,g_bar[2]); 

wire p0123;
nand pg0(p0123, p[0], p[1], p[2], p[3]);
nand pg1(pg, p0123, p0123);

wire g2p3, g1p23, g0p123;
nand gg0(g2p3, g[2], p[3]);
nand gg1(g1p23, g[1], p[2], p[3]);
nand gg2(g0p123, g[0], p[1], p[2], p[3]);
nand gg3(gg, g_bar[3], g2p3, g1p23, g0p123);

endmodule

module CLG_2bit(c0,pg0, gg0, pg1, gg1, c4, c8);
input c0, pg0, gg0, pg1, gg1;
output c4, c8;
wire gg0_bar, gg1_bar;

nand not_gg0(gg0_bar, gg0, gg0);
nand not_gg1(gg1_bar, gg1, gg1);

wire pg0c0;
nand c4_0(pg0c0, pg0, c0);
nand c4_1(c4, pg0c0, gg0_bar);

wire pg1gg0, pg01c0;
nand c8_0(pg1gg0, pg1, gg0);
nand c8_1(pg01c0, pg0, pg1, c0);
nand c8_2(c8, pg1gg0, pg01c0, gg1_bar);

endmodule

//Basic Gates
module xor_gate(out,a,b);
input a,b;
output out;
wire a_bar,b_bar,ab_bar,a_barb;
nand nand_and0(a_bar,a,a);
nand nand_and1(b_bar,b,b);
nand nand_and2(ab_bar,a,b_bar);
nand nand_and3(a_barb,a_bar,b);

nand nand_and4(out,a_barb,ab_bar);
endmodule

module and_gate(out,a,b);
input a,b;
output out;
wire ab_bar;
nand nand_and0(ab_bar,a,b);
nand nand_and1(out,ab_bar,ab_bar);

endmodule

module or_gate(out,a,b);
input a,b;
output out;
wire a_bar,b_bar;
nand nand_and0(a_bar,a,a);
nand nand_and1(b_bar,b,b);
nand nand_and2(out,a_bar,b_bar);

endmodule
