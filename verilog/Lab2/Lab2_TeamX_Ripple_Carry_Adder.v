`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [7:0] a, b;
input cin;
output cout;
output [7:0] sum;

wire[6:0] c;

Full_Adder a1(a[0], b[0], cin, c[0], sum[0]);
Full_Adder a2(a[1], b[1], c[0], c[1], sum[1]);
Full_Adder a3(a[2], b[2], c[1], c[2], sum[2]);
Full_Adder a4(a[3], b[3], c[2], c[3], sum[3]);
Full_Adder a5(a[4], b[4], c[3], c[4], sum[4]);
Full_Adder a6(a[5], b[5], c[4], c[5], sum[5]);
Full_Adder a7(a[6], b[6], c[5], c[6], sum[6]);
Full_Adder a8(a[7], b[7], c[6], cout, sum[7]);

endmodule
module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire a1,b2,b3;
wire coutnot,  cinnot;
NOT_nand n2(cinnot, cin);
Majority m1(cin,a,b,cout);
NOT_nand n1(coutnot, cout);
Majority m2(cinnot,a,b,b2);
Majority m3(cin,coutnot,b2,sum);
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

module Majority(a, b, c, out);
input a, b, c;
output out;
wire tmp1, tmp2, tmp3, tmp4;
AND_nand and1(tmp1, a, b);
AND_nand and2(tmp2, a, c);
AND_nand and3(tmp3, c, b);
OR_nand or1(tmp4, tmp1, tmp2);
OR_nand or2(out, tmp4, tmp3);
endmodule


