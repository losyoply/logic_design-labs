`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;

wire[3:0] A,B;
and_gate and00(a[0],b[0],p[0]);
and_gate and01(a[0],b[1],A[0]);
and_gate and02(a[0],b[2],A[1]);
and_gate and03(a[0],b[3],A[2]);

and_gate and10(a[1],b[0],B[0]);
and_gate and11(a[1],b[1],B[1]);
and_gate and12(a[1],b[2],B[2]);
and_gate and13(a[1],b[3],B[3]);

wire c3,c2,c1;
wire[3:0] C,D;
Full_Adder fa1(A[0],B[0],1'b0,c1,p[1]);
Full_Adder fa2(A[1],B[1],c1,c2,C[0]);
Full_Adder fa3(A[2],B[2],c2,c3,C[1]);
Full_Adder fa4(1'b0,B[3],c3,C[3],C[2]);

and_gate and20(a[2],b[0],D[0]);
and_gate and21(a[2],b[1],D[1]);
and_gate and22(a[2],b[2],D[2]);
and_gate and23(a[2],b[3],D[3]);

wire c6,c5,c4;
wire[3:0] E,F;
Full_Adder fa5(C[0],D[0],1'b0,c4,p[2]);
Full_Adder fa6(C[1],D[1],c4,c5,E[0]);
Full_Adder fa7(C[2],D[2],c5,c6,E[1]);
Full_Adder fa8(C[3],D[3],c6,E[3],E[2]);

and_gate and30(a[3],b[0],F[0]);
and_gate and31(a[3],b[1],F[1]);
and_gate and32(a[3],b[2],F[2]);
and_gate and33(a[3],b[3],F[3]);

wire c9,c8,c7;
Full_Adder fa9(E[0],F[0],1'b0,c7,p[3]);
Full_Adder fa10(E[1],F[1],c7,c8,p[4]);
Full_Adder fa11(E[2],F[2],c8,c9,p[5]);
Full_Adder fa12(E[3],F[3],c9,p[7],p[6]);


endmodule

module and_gate(a,b,out);
input a,b;
output out;
wire ab_bar;
nand nand_and0(ab_bar,a,b);
nand nand_and1(out,ab_bar,ab_bar);

endmodule

module or_gate(a,b,out);
input a,b;
output out;
wire a_bar,b_bar;
nand nand_and0(a_bar,a,a);
nand nand_and1(b_bar,b,b);
nand nand_and2(out,a_bar,b_bar);

endmodule

module xor_gate(a,b,out);
input a,b;
output out;
wire a_bar,b_bar,ab_bar,a_barb;
nand nand_and0(a_bar,a,a);
nand nand_and1(b_bar,b,b);
nand nand_and2(ab_bar,a,b_bar);
nand nand_and3(a_barb,a_bar,b);

nand nand_and4(out,a_barb,ab_bar);
endmodule


module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;
xor_gate xor1(a,b,sum);
and_gate and1(a,b,cout);
endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire c1,c2,s;

Half_Adder ha1(a,b,c1,s);
Half_Adder ha2(s,cin,c2,sum);
or_gate or1(c1,c2,cout);

endmodule

