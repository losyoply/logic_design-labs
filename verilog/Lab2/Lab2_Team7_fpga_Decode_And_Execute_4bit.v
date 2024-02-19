`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel,out,an);
input [3:0] rs, rt;
input [2:0] sel;
output[3:0] an;
output[6:0] out;
wire [3:0] rd;

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

AND_4item tmp0(sel_tmp[0], sel_h[0], result[0]);
AND_4item tmp1(sel_tmp[1], sel_h[1], result[1]);
AND_4item tmp2(sel_tmp[2], sel_h[2], result[2]);
AND_4item tmp3(sel_tmp[3], sel_h[3], result[3]);

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

fpga_display fpga(rd,out,an);

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

module OR(out, a, b);
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
NOT n0(out[0],a[0]);
NOT n1(out[1],a[1]);
NOT n2(out[2],a[2]);
NOT n3(out[3],a[3]);
endmodule

module AND_4bit(out, a, b);
input [3:0] a, b;
output [3:0] out;
AND a0(out[0],a[0], b[0]);
AND a1(out[1],a[1], b[1]);
AND a2(out[2],a[2], b[2]);
AND a3(out[3],a[3], b[3]);
endmodule

module OR_4bit(out, a, b);
input [3:0] a, b;
output [3:0] out;
OR or0(out[0],a[0], b[0]);
OR or1(out[1],a[1], b[1]);
OR or2(out[2],a[2], b[2]);
OR or3(out[3],a[3], b[3]);
endmodule

module AND_4item (out, a, b);
input a;
input [3:0] b;
output [3:0] out;
AND a0(out[0], a, b[0]);
AND a1(out[1], a, b[1]);
AND a2(out[2], a, b[2]);
AND a3(out[3], a, b[3]);
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

//Compatator
module Comparator(cmp_eq, cmp_gt,rs, rt);
input [3:0] rs, rt;
output cmp_eq, cmp_gt;
wire [3:0] gt, eq, eq_tmp;
wire [1:0] eq_and, or_tmp;
wire [2:0] gt_tmp;
 
//Function (Ai>Bi) = Ai AND Bi_bar
Universal_Gate gt0(gt[0], rs[0], rt[0]);
Universal_Gate gt1(gt[1], rs[1], rt[1]);
Universal_Gate gt2(gt[2], rs[2], rt[2]);
Universal_Gate gt3(gt[3], rs[3], rt[3]);

//Function(Ai == Bi) = Ai XNOR Bi
XOR tmp0(eq_tmp[0], rs[0], rt[0]);
XOR tmp1(eq_tmp[1], rs[1], rt[1]);
XOR tmp2(eq_tmp[2], rs[2], rt[2]);
XOR tmp3(eq_tmp[3], rs[3], rt[3]);
NOT eq0(eq[0], eq_tmp[0]);
NOT eq1(eq[1], eq_tmp[1]);
NOT eq2(eq[2], eq_tmp[2]);
NOT eq3(eq[3], eq_tmp[3]);

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
wire [3:0] tmp, sel_bar;

NOT n0(sel_bar[0], sel[0]);
NOT n1(sel_bar[1], sel[1]);
NOT n2(sel_bar[2], sel[2]);

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

module fpga_display(rd,out,an);
input[3:0] rd;
output[3:0] an;
output[6:0] out;
reg[6:0] out;
always @(*) begin
    if(rd === 4'b0000)begin
        out = 7'b0000001;
    end
    else if(rd === 4'b0001)begin
        out = 7'b1001111;
    end
    else if(rd === 4'b0010)begin
        out = 7'b0010010;
    end
    else if(rd === 4'b0011)begin
        out = 7'b0000110;
    end
    else if(rd === 4'b0100)begin
        out = 7'b1001100;
    end
    else if(rd === 4'b0101)begin
        out = 7'b0100100;
    end
    else if(rd === 4'b0110)begin
        out = 7'b0100000;
    end
    else if(rd === 4'b0111)begin
        out = 7'b0001111;
    end
    else if(rd === 4'b1000)begin
        out = 7'b0000000;
    end
    else if(rd === 4'b1001)begin
        out = 7'b0001100;
    end
    else if(rd === 4'b1010)begin
        out = 7'b0001000;
    end
    else if(rd === 4'b1011)begin
        out = 7'b1100000;
    end
    else if(rd === 4'b1100)begin
        out = 7'b0110001;
    end
    else if(rd === 4'b1101)begin
        out = 7'b1000010;
    end
    else if(rd === 4'b1110)begin
        out = 7'b0110000;
    end
    else if(rd === 4'b1111)begin
        out = 7'b0111000;
    end
end


assign an = 4'b1110;

endmodule