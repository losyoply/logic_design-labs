`timescale 1ns/1ps
module Mux_4x1_4bit(a, b, c, d, sel, f);
input [3:0] a, b, c, d;
input [1:0] sel;
output [3:0] f;
wire [3:0] finalord;
wire [3:0] finalorc;
wire [3:0] finalorb;
wire [3:0] finalora;
wire rsel0;
wire rsel1;
not not0(rsel0, sel[0]);
not not1(rsel1, sel[1]);

and ad[3:0](finalord, sel[0], sel[1], d);

and ac[3:0](finalorc, rsel0, sel[1], c);

and ab[3:0](finalorb, sel[0], rsel1, b);

and aa[3:0](finalora, rsel0, rsel1, a);

or orr[3:0](f, finalora, finalorb, finalorc, finalord);


endmodule