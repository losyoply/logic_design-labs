`timescale 1ns/1ps
module fifo_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg wen,ren;
    reg [7:0] din;        
    wire [7:0] dout;       
    wire error; 
    
FIFO_8 sos (
	.clk (clk),
	.rst_n (rst_n),
  	.wen (wen),
  	.ren (ren),
  	.din (din),
  	.dout (dout),
  	.error (error)
);

always #10 clk = ~clk;

initial begin
 rst_n=0;
 din=8'b0;
 ren=1'b0;
 wen=1'b0;
 #20;
 rst_n=1;
 #20;
 wr(6); wr(11);
 #20;
 rd; 
 #20;
 wr(9);
 #20
 rd; 
 #20;
 rd; 
 #20;
 rd; 
 #20;
 rd; 
 #20;
 rd; 
 #20;
  wr(10);wr(11);wr(12);wr(10);wr(11);wr(12);wr(10);wr(11);wr(12);wr(10);wr(11);wr(12);
 #20
 $stop;
 
end 

task wr;
input[3:0] i;
begin
 wen=1'b1;
 din=i;
 #20;
 wen=1'b0;
end  
endtask

task rd; 
begin
 ren=1'b1; 
 #20
 ren=1'b0;
end  
endtask

endmodule