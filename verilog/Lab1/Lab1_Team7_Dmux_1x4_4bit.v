`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [3:0] in;
input [1:0] sel;
output [3:0] a, b, c, d;
wire [1:0] sel_bar;
not not1(sel_bar[0], sel[0]);
not not2(sel_bar[1], sel[1]);

and a1[3:0](a, sel_bar[1], sel_bar[0], in);
and a2[3:0](b, sel_bar[1], sel[0], in);
and a3[3:0](c, sel[1], sel_bar[0], in);
and a4[3:0](d, sel[1], sel[0], in);

endmodule