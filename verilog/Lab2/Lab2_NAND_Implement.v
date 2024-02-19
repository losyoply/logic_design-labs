`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [2:0] sel;
output out;
wire notsel0, notsel1, notsel2;
NOT_nand not1(notsel1, sel[1]);
NOT_nand not2(notsel0, sel[0]);
NOT_nand not3(notsel2, sel[2]);

wire tmp000, tmp001, tmp010, tmp011, tmp100, tmp101, tmp110111;
wire tmp, tmp1, tmp2, tmp3, tmp4, tmp5;

AND_nand a1(tmp, notsel0, notsel1);
AND_nand a2(tmp000, tmp, notsel2);

nand n1(out000, a, b);

AND_nand a5(tmp1, notsel2, notsel1);
AND_nand a6(tmp001, tmp1, sel[0]);

AND_nand a9(out001, a, b);

AND_nand a10(tmp2, notsel2, notsel0);
AND_nand a11(tmp010, tmp2, sel[1]);
OR_nand or1(out010, a, b);

AND_nand a14(tmp3, notsel2, sel[0]);
AND_nand a15(tmp011, tmp3, sel[1]);
NOR_nand nor1(out011, a, b);

AND_nand a18(tmp4, notsel1, notsel0);
AND_nand a19(tmp100, tmp4, sel[2]);

XOR_nand xor1(out100, a, b);

AND_nand a22(tmp5, notsel1, sel[0]);
AND_nand a23(tmp101, tmp5, sel[2]);
XNOR_nand xnor1(out101, a, b);

AND_nand a26(tmp110111, notsel1, notsel2);
NOT_nand not1000(out11, a);
wire q, w, e, r, t, y, u;
AND_nand o(q, out000, tmp000);
AND_nand p(w, out001, tmp001);
AND_nand ll(e, out010, tmp010);
AND_nand qq(r, out011, tmp011);
AND_nand ee(t, out100, tmp100);
AND_nand uu(y, out101, tmp101);
AND_nand yy(u, out11, tmp110111);
wire ans, ans1, ans2, ans3, ans4;
OR_nand qa(ans, q, w);
OR_nand ws(ans1, ans, e);
OR_nand ed(ans2, ans1, r);
OR_nand rf(ans3, ans2, t);
OR_nand tg(ans4, ans3, y);
OR_nand yh(out, ans4, u);




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
