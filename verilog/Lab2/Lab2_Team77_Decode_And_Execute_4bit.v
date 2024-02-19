`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [3:0] rs, rt;
input [2:0] sel;
output [3:0] rd;

wire [3:0] c_rt; //one's complement of rt
wire cmp_eq, cmp_gt;
wire [3:0] result [3:0];
wire [7:0] sel_h; //one-hat selecion signal 
wire [3:0] sel_tmp [7:0];
wire [3:0] or_tmp [5:0];

//Generating result for each selection
Adder_4bit rst0(rs, rt, 1'b0, result[0]);
NOT_4bit crt(c_rt, rt);
Adder_4bit rst1(rs, c_rt, 1'b1, result[1]);
AND_4bit rst2(result[2], rs, rt);
OR_4bit rst3(result[3], rs, rt);
Comparator cmp(cmp_eq, cmp_gt,rs, rt);

//Selecting
Decoder_3x8 D1(sel, sel_h);
AND_4item tmp0[3:0](sel_tmp, sel_h, result);

//circular left shift : tmp[4] = {rs[2:0], rs[3]} AND sel_h[4]
AND clr_l3(sel_tmp[4][3], sel_h[4], rs[2]);
AND clr_l2(sel_tmp[4][2], sel_h[4], rs[1]);
AND clr_l1(sel_tmp[4][1], sel_h[4], rs[0]);
AND clr_l0(sel_tmp[4][0], sel_h[4], rs[3]);

//arithmetic right shift: tmp[5] = {rt[3], rt[3:1]} AND sel_h[5]
AND ari_r3(sel_tmp[5][3], sel_h[5], rt[3]);
AND ari_r2(sel_tmp[5][2], sel_h[5], rt[3]);
AND ari_r1(sel_tmp[5][1], sel_h[5], rt[2]);
AND ari_r0(sel_tmp[5][0], sel_h[5], rt[1]);

//compare equal: tmp[6] = {3'b111, cmp_eq} AND sel_h[6]
AND eq3(sel_tmp[6][3], sel_h[6], 1'b1);
AND eq2(sel_tmp[6][2], sel_h[6], 1'b1); 
AND eq1(sel_tmp[6][1], sel_h[6], 1'b1); 
AND eq0(sel_tmp[6][0], sel_h[6], cmp_eq);

//compare greater: tmp[7] = {3'b101, cmp_eq} AND sel_h[7]
AND gt3(sel_tmp[7][3], sel_h[7], 1'b1);
AND gt2(sel_tmp[7][2], sel_h[7], 1'b0);
AND gt1(sel_tmp[7][1], sel_h[7], 1'b1);
AND gt0(sel_tmp[7][0], sel_h[7], cmp_gt);

OR_4bit or0(or_tmp[0], sel_tmp[0], sel_tmp[1]);
OR_4bit or1(or_tmp[1], sel_tmp[2], sel_tmp[3]);
OR_4bit or2(or_tmp[2], sel_tmp[4], sel_tmp[5]);
OR_4bit or3(or_tmp[3], sel_tmp[6], sel_tmp[7]);
OR_4bit or4(or_tmp[4], or_tmp[0], or_tmp[1]);
OR_4bit or5(or_tmp[5], or_tmp[2], or_tmp[3]);
OR_4bit or_rd(rd, or_tmp[4], or_tmp[5]);

endmodule

//Universal Gate 
module Universal_Gate (out, a, b);
input a, b;
output out;
wire b_bar;
not not_b(b_bar, b);
and and_out(out, a, b_bar);
endmodule

module NOT(out, a);
input a;
output out;
Universal_Gate uni_out(out, 1'b1, a);
endmodule

module AND(out, a, b);
input a, b;
output out;
wire b_bar;
NOT not_b(b_bar, b);
Universal_Gate uni_out(out, a, b_bar);
endmodule

module OR(out, a, b);//!
input a, b;
output out;
wire a_bar, nanb; //nanb for a_bar AND b_bar
NOT not_a(a_bar, a);
Universal_Gate uni_nanb(nanb, a_bar, b);
Universal_Gate uni_out(out, 1, nanb);
endmodule

module XOR(out, a, b);
input a, b;
output out;
wire [1:0] tmp;
Universal_Gate u0(tmp[0], a, b);
Universal_Gate u1(tmp[1], b, a);
OR or_tmp(out, tmp[0], tmp[1]);
endmodule

module NOT_4bit(out, a);
input [3:0] a;
output [3:0] out;
NOT nn[3:0](out, a);
endmodule

module AND_4bit(out, a, b);
input [3:0] a, b;
output [3:0] out;
AND aa[3:0](out, a, b);
endmodule

module OR_4bit(out, a, b);
input [3:0] a, b;
output [3:0] out;
OR oo[3:0](out, a, b);
endmodule

module AND_4item (out, a, b);
input a;
input [3:0] b;
output [3:0] out;
AND aa[3:0](out, a, b);
endmodule

//Adder and its submodule
module Adder_4bit(a, b, cin, sum);
input [3:0] a, b;
input cin;
output [3:0] sum;
wire [4:1] c;

Full_Adder f0(a[0], b[0], cin, c[1], sum[0]);
Full_Adder f1(a[1], b[1], c[1], c[2], sum[1]);
Full_Adder f2(a[2], b[2], c[2], c[3], sum[2]);
Full_Adder f3(a[3], b[3], c[3], c[4], sum[3]);
endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire tmp;
Majority majority_cout(a, b, cin, cout);
XOR xor_tmp(tmp, a, b);
XOR xor_sum(sum, tmp, cin);
endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire [2:0] tmp_and;
wire tmp_or;

AND and0(tmp_and[0], a, b);
AND and1(tmp_and[1], b, c);
AND and2(tmp_and[2], a, c);
OR or0(tmp_or, tmp_and[0], tmp_and[1]);
OR or1(out, tmp_or, tmp_and[2]);
endmodule

//Comparator
module Comparator(cmp_eq, cmp_gt,rs, rt);
input [3:0] rs, rt;
output cmp_eq, cmp_gt;
wire [3:0] gt, eq, eq_tmp;
wire [1:0] eq_and, or_tmp;
wire [2:0] gt_tmp;
 
//Function (Ai>Bi) = Ai AND Bi_bar
Universal_Gate gt0[3:0](gt, rs, rt);

//Function(Ai == Bi) = Ai XNOR Bi
XOR tmp0[3:0](eq_tmp, rs, rt);

NOT eq0[3:0](eq, eq_tmp);

//Comparison
AND and_eq0(eq_and[0], eq[3], eq[2]);
AND and_eq1(eq_and[1], eq_and[0], eq[1]);
AND and_cmpeq(cmp_eq, eq_and[1], eq[0]);

AND and_tmp0(gt_tmp[2], eq[3], gt[2]);
AND and_tmp1(gt_tmp[1], eq_and[0], gt[1]);
AND and_tmp2(gt_tmp[0], eq_and[1], gt[0]);

OR or_tmp0(or_tmp[0], gt[3], gt_tmp[2]);
OR or_tmp1(or_tmp[1], gt_tmp[1], gt_tmp[0]);
OR or_cmpgt(cmp_gt, or_tmp[0], or_tmp[1]);
endmodule

//Decoder
module Decoder_3x8(sel, out);
input [2:0] sel;
output [7:0] out;
wire [3:0] tmp;
wire [3:0]sel_bar;

NOT nn[2:0](sel_bar, sel);
AND tmp0(tmp[0], sel_bar[2], sel_bar[1]);
AND tmp1(tmp[1], sel_bar[2], sel[1]);
AND tmp2(tmp[2], sel[2], sel_bar[1]);
AND tmp3(tmp[3], sel[2], sel[1]);

AND D0(out[0], tmp[0], sel_bar[0]);
AND D1(out[1], tmp[0], sel[0]);
AND D2(out[2], tmp[1], sel_bar[0]);
AND D3(out[3], tmp[1], sel[0]);
AND D4(out[4], tmp[2], sel_bar[0]);
AND D5(out[5], tmp[2], sel[0]);
AND D6(out[6], tmp[3], sel_bar[0]);
AND D7(out[7], tmp[3], sel[0]);
endmodule