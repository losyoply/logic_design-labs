`timescale 1ns / 1ps

module RoundRobinArbiter_tb;
reg clk=0;
reg rst_n=0;
reg [3:0] wen=4'b0000;
reg [7:0] a, b, c, d;
wire [7:0] dout;
wire valid;
//
Round_Robin_Arbiter RRA(
    .clk(clk), 
    .rst_n(rst_n),
    .wen(wen),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .dout(dout),
    .valid(valid)
);
//
always #10 clk = ~clk;
initial begin
    @ (negedge clk)
       wen = 4'b1111;
       rst_n = 1;
       a = 87;
       b = 56;
       c = 9;
       d = 13;
    @ (negedge clk)
       wen = 4'b1000;
       d = 85;   
    @ (negedge clk)
       wen = 4'b0100;
       c = 139;   
     @ (negedge clk)
       wen = 4'b0000;
    @ (negedge clk)
       wen = 4'b0000;
    @ (negedge clk)
       wen = 4'b0001;
       a = 51;
    @ (negedge clk)
       wen = 4'b0000;
    @ (negedge clk)
       wen = 4'b0000;  
       
       #100;
  $finish;
      
end
endmodule
