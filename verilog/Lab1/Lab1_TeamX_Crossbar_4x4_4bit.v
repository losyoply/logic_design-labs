`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [3:0] in1, in2, in3, in4;
input [4:0] control;
output [3:0] out1, out2, out3, out4;

wire [3:0] A0, A1, B0, B1, C0, C1;

Crossbar_2x2_4bit a(in1, in2, control[0], A0, A1);
Crossbar_2x2_4bit b(in3, in4, control[1], B0, B1);
Crossbar_2x2_4bit c(A1, B0, control[2], C0, C1);
Crossbar_2x2_4bit d(A0, C0, control[3], out1, out2);
Crossbar_2x2_4bit e(C1, B1, control[4], out3, out4);
endmodule

//
module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2;
wire ctrl_bar;
wire [3:0] A0, A1, B0, B1;
not turnCtrl(ctrl_bar, control);
Dmux demuxA(in1, A0, A1, ctrl_bar);
Dmux demuxB(in2, B0, B1, control);
Mux muxC(A0, B0, ctrl_bar, out1);
Mux muxD(A1, B1, control, out2);
endmodule

module Mux(a, b, sel, f);
input[3:0] a, b;
input sel;
output[3:0] f;
wire sel_bar;
wire[3:0] aCheck, bCheck; 
not turnSel(sel_bar, sel);
and a1[3:0](aCheck, sel_bar, a);
and a2[3:0](bCheck, sel, b);
or o1[3:0](f, a, b);
endmodule


module Dmux(in, a, b, sel);
input [3:0] in;
input sel;
output[3:0] a, b;
wire sel_bar;
not turnSel(sel_bar, sel);
and a1[3:0](a, sel_bar, in);
and a2[3:0](b, sel, in);
endmodule