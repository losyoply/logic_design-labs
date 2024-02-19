`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;
wire [7:0] p, g;
wire c1, c2, c3, c4, c5, c6, c7, g03, p03, g47, p47;
Full_Adder f1(a[0], b[0], c0, s[0], p[0], g[0]);
Full_Adder f2(a[1], b[1], c1, s[1], p[1], g[1]);
Full_Adder f3(a[2], b[2], c2, s[2], p[2], g[2]);
Full_Adder f4(a[3], b[3], c3, s[3], p[3], g[3]);

CLA4G q1(p[0], g[0], p[1], g[1], p[2], g[2], p[3], g[3], c0, c1, c2, c3, g03, p03);
CLA2G qq1(p03, g03, p47, g47, c0, c4, c8);

CLA4G q2(p[4], g[4], p[5], g[5], p[6], g[6], p[7], g[7], c4, c5, c6, c7, g47, p47);

Full_Adder f5(a[4], b[4], c4, s[4], p[4], g[4]);
Full_Adder f6(a[5], b[5], c5, s[5], p[5], g[5]);
Full_Adder f7(a[6], b[6], c6, s[6], p[6], g[6]);
Full_Adder f8(a[7], b[7], c7, s[7], p[7], g[7]);


endmodule

module CLA2G(p0, g0, p1, g1, c0, c1, c2);
input p0, g0, p1, g1, c0;
output c1, c2;
wire tmp1, tmp2, c1tmp;
AND_nand and1(tmp1, p0, c0);
OR_nand and2(c1, g0, tmp1);
OR_nand and3(c1tmp, g0, tmp1);

AND_nand and4(tmp2, p1, c1tmp);
OR_nand and5(c2, g1, tmp2);

endmodule

module CLA4G(p0, g0, p1, g1, p2, g2, p3, g3, c0, c1, c2, c3, g03, p03);
input p0, g0, p1, g1, p2, g2, p3, g3, c0;
output c1, c2, c3, g03, p03;
wire tmp1, c1tmp;
wire tmp2, c2tmp;
wire tmp3;
//wire tmp4, c4tmp;
AND_nand and1(tmp1, p0, c0);
OR_nand and2(c1, g0, tmp1);
OR_nand and3(c1tmp, g0, tmp1);

AND_nand and4(tmp2, p1, c1tmp);
OR_nand and5(c2, g1, tmp2);
OR_nand and6(c2tmp, g1, tmp2);

AND_nand and7(tmp3, p2, c2tmp);
OR_nand and8(c3, g2, tmp3);

wire tmp4, tmp5;
AND_nand and9(tmp4, p0, p1);
AND_nand and10(tmp5, p2, p3);
AND_nand and11(p03, tmp4, tmp5);

wire tmp6, tmp7, tmp8, tmp9;
AND_nand and12(tmp6, g2, p3); //
AND_nand and13(tmp7, g1, p3);
AND_nand and14(tmp8, tmp7, p2); //
AND_nand and15(tmp9, g0, p3);
AND_nand and16(tmp10, p2, p1);
AND_nand and17(tmp11, tmp9, tmp10);//
OR_nand or1(tmp12, g3, tmp6);
OR_nand or2(tmp13, tmp8, tmp11);
OR_nand or3(g03, tmp12, tmp13);

endmodule



////////////////////////////////////////////////////////////////////////

module Full_Adder (a, b, cin, sum, p, g);
input a, b, cin;
output sum, p, g;
wire a1, a2, a3;
XOR_nand xor1(p, a, b);
XOR_nand xor2(a1, a, b);
XOR_nand xor3(sum, a1, cin);
AND_nand and1(g, a, b);

endmodule

module AND_nand(out, a, b);
    input a, b;
    output out;
    wire tmp;
    nand n1(tmp, a, b);
    nand n2(out, tmp, tmp);
    endmodule

module OR_nand(out, a, b);
    input a, b;
    output out;
    wire tmp1, tmp2;
    nand n1(tmp1, a, a);
    nand n2(tmp2, b, b);
    nand n3(out, tmp1, tmp2);
    endmodule


module NOT_nand(out, a);

    input a;
    output out;
    nand n1(out, a, a);
    endmodule


module NOR_nand(out,a, b);

    input a, b;
    output out;
    wire tmp;
    OR_nand or1(tmp, a, b);
    NOT_nand not1(out, tmp);
    endmodule


module XOR_nand(out, a, b);

    input a, b;
    output out;
    wire tmp1, tmp2, tmp3;
    nand n1(tmp1, a, b);
    nand n2(tmp2, a, tmp1);
    nand n3(tmp3, b, tmp1);
    nand n4(out, tmp2, tmp3);
    endmodule


module XNOR_nand(out, a, b);

    input a, b;
    output out;
    wire tmp;
    XOR_nand xor1(tmp, a, b);
    NOT_nand not1(out, tmp);
    endmodule