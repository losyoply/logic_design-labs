`timescale 1ns / 1ps

module Lab5_GCD_TB;
reg clk, rst_n;
reg start;
reg [15:0] a;
reg [15:0] b;
wire done;
wire [15:0] gcd;

Greatest_Common_Divisor gcddd(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .done(done),
    .gcd(gcd)
);
always #1 clk = ~clk;
integer i;
initial begin
  clk = 1'b1;
  rst_n = 1'b1;
  start = 1'b0;
  #2 rst_n = 0; #2 rst_n = 1;
  repeat(2) @(posedge clk);

  for(i=0;i<20;i=i+1) begin
    start <= 1;
    a <= $urandom()%20+1; // no zero input
    b <= $urandom()%20+1;
    @(posedge done);
   end

end

endmodule
