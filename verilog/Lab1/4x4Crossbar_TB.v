`timescale 1ns/1ps

module Crossbar_4x4_4bit_t;
reg [3:0] in1 = 4'b0001;
reg [3:0] in2 = 4'b0010;
reg [3:0] in3 = 4'b0011;
reg [3:0] in4 = 4'b0100;
reg [4:0] control = 5'b00000;
wire [3:0] out1;
wire[3:0] out2;
wire[3:0] out3;
wire[3:0] out4;

Crossbar_4x4_4bit Cross4x4TB(
    .in1(in1),
    .in2 (in2),
    .in3 (in3),
    .in4(in4),
    .control (control),
    .out1 (out1),
    .out2 (out2),
    .out3 (out3),
    .out4 (out4)
);
initial begin
    repeat(2**6-1)begin
        #1 control = control + 4'b0001;
        in1 = 1;
        in2 = 2;
        in3 = 3;
        in4 = 4;
    end
    #1 $finish;
end
endmodule