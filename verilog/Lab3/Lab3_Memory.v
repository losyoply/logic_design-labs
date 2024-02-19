`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output reg [7:0] dout;

reg [7:0] mem [127:0];

 always @(posedge clk)
    if(wen && !ren) mem[addr] <= din;
  
    
 always @(posedge clk)
 begin
     if(ren == 1'b1) dout <= mem[addr];
     else dout <= 8'd0;
 end

    
endmodule
