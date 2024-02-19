`timescale 1ns / 1ps

module Multi_Bank_tb;
reg clk = 1'b0;
reg ren = 1'b0 ;
reg wen =1'b0;
reg [10:0] waddr;
reg [10:0] raddr;
reg [7:0] din;
wire [7:0] dout;

Multi_Bank_Memory mb(
    .clk(clk),
    .ren(ren),
    .wen(wen),
    .waddr(waddr),
    .raddr(raddr),
    .din(din),
    .dout(dout)
);
reg [3:0] idx;
always #10 clk = ~clk;
initial begin
   for(idx=0;idx<11;idx=idx+1)begin
        @ (negedge clk)
         wen = 1'b1;
         ren = 0;
        waddr = 11'b00000000000+idx;
       din = 99+2*idx;
    end
   for(idx=0;idx<11;idx=idx+1)begin
        @ (negedge clk)
         wen = 1'b1;
        ren = 1;
        waddr  =11'b11110000000+idx;
        raddr = 11'b00000000000+idx;
       din = 10+2*idx;
    end
       for(idx=0;idx<11;idx=idx+1)begin
        @ (negedge clk)
         ren = 1'b1;
         wen = 0;
        raddr = 11'b11110000000+idx;
       din = 0;
    end

    
    $finish;
    
end
endmodule
