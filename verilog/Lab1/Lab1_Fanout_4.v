`timescale 1ns/1ps

module Fanout_4(in, out);
input in;
output [3:0] out;
wire [3:0] outs;
not not1(outs[0], outs[1], outs[2], outs[3], in);
not not2 [3:0](out, outs);
endmodule
