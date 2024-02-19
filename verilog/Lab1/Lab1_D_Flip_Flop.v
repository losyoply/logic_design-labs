`timescale 1ns/1ps

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;
wire clkk, m;

not rclk(clkk, clk);
D_Latch Master(clkk, d, m);
D_Latch Slave(clk, m, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;
wire dd, T, B , qq;

not n1(dd, d);
nand nand1(T, d, e);
nand nand2(B, dd, e);

nand nand3(q, T, qq);
nand nand4(qq, q, B); 

endmodule