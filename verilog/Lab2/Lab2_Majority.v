`timescale 1ns/1ps

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
