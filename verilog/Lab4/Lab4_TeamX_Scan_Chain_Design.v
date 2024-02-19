`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;
wire [3:0]a, b;
wire [7:0] p;

Multiplier m1(a, b, p);
SDFF s1(clk, scan_en, scan_in, rst_n, p[7], a[3]);
SDFF s2(clk, scan_en, a[3], rst_n, p[6], a[2]);
SDFF s3(clk, scan_en, a[2], rst_n, p[5], a[1]);
SDFF s4(clk, scan_en, a[1], rst_n, p[4], a[0]);
SDFF s5(clk, scan_en, a[0], rst_n, p[3], b[3]);
SDFF s6(clk, scan_en, b[3], rst_n, p[2], b[2]);
SDFF s7(clk, scan_en, b[2], rst_n, p[1], b[1]);
SDFF s8(clk, scan_en, b[1], rst_n, p[0], b[0]);

assign scan_out=b[0];


endmodule

module SDFF(clk, scan_en, scan_in, rst_n, data, Q);
input clk;
input scan_en, scan_in;
input rst_n;
input data;
output Q;
wire tmp, tmp2;
MUX mux1(data, scan_in, scan_en, tmp);
MUX mux2(1'b0, tmp, rst_n, tmp2);
DFF dff1(clk, tmp2, Q);
endmodule 

module DFF(clk, in, out);
input clk, in;
output out;
reg out;
always@(posedge clk) begin
    out<=in;
end
endmodule 

module MUX(data0, data1, sel, out);
input data0;
input data1;
input sel;
output out;
reg out;
    always @(data0,data1,sel)
    begin
        if(sel == 0) 
            out = data0;  
        else
            out = data1; 
    end
    
endmodule

module Multiplier(x, y, out);
input   [3:0] x, y;
output [7:0] out;
wire a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4,d1,d2,d3,d4;
wire o2,o3,o4,o6,o7,o8,o10,o11,o12;
wire r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
assign a1=x[0]&y[0];
assign a2=x[1]&y[0];
assign a3=x[2]&y[0];
assign a4=x[3]&y[0];
assign b1=x[0]&y[1];
assign b2=x[1]&y[1];
assign b3=x[2]&y[1];
assign b4=x[3]&y[1];
assign c1=x[0]&y[2];
assign c2=x[1]&y[2];
assign c3=x[2]&y[2];
assign c4=x[3]&y[2];
assign d1=x[0]&y[3];
assign d2=x[1]&y[3];
assign d3=x[2]&y[3];
assign d4=x[3]&y[3];

full_adder FA1(.a(a1),.b(1'b0),.cin(1'b0),.s(out[0]),.cout(r1));
full_adder FA2(.a(a2),.b(1'b0),.cin(r1),.s(o2),.cout(r2));
full_adder FA3(.a(a3),.b(1'b0),.cin(r2),.s(o3),.cout(r3));
full_adder FA4(.a(a4),.b(1'b0),.cin(r3),.s(o4),.cout(r4));
full_adder FA5(.a(b1),.b(o2),.cin(1'b0),.s(out[1]),.cout(r5));
full_adder FA6(.a(b2),.b(o3),.cin(r5),.s(o6),.cout(r6));
full_adder FA7(.a(b3),.b(o4),.cin(r6),.s(o7),.cout(r7));
full_adder FA8(.a(b4),.b(r4),.cin(r7),.s(o8),.cout(r8));
full_adder FA9(.a(c1),.b(o6),.cin(1'b0),.s(out[2]),.cout(r9));
full_adder FA10(.a(c2),.b(o7),.cin(r9),.s(o10),.cout(r10));
full_adder FA11(.a(c3),.b(o8),.cin(r10),.s(o11),.cout(r11));
full_adder FA12(.a(c4),.b(r8),.cin(r11),.s(o12),.cout(r12));
full_adder FA13(.a(d1),.b(o10),.cin(1'b0),.s(out[3]),.cout(r13));
full_adder FA14(.a(d2),.b(o11),.cin(r13),.s(out[4]),.cout(r14));
full_adder FA15(.a(d3),.b(o12),.cin(r14),.s(out[5]),.cout(r15));
full_adder FA16(.a(d4),.b(r12),.cin(r15),.s(out[6]),.cout(out[7]));

endmodule
module full_adder(a, b, cin, s, cout);
input   a, b, cin;
output s,cout;
wire p,g;
assign p=a^b;
assign g=a&b;
assign s=p^cin;
assign cout=g|(p&cin);

endmodule

