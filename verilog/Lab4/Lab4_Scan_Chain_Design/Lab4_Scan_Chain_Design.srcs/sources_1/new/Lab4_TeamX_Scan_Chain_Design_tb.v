`timescale 1ns / 1ps
module Lab4_TeamX_Scan_Chain_Design_tb;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg scan_in;
reg scan_en = 1'b0;
wire scan_out;
Scan_Chain_Design SCD(
    .clk(clk),
    .rst_n(rst_n),
    .scan_in(scan_in),
    .scan_en(scan_en),
    .scan_out(scan_out)
);
always #10 clk = !clk;
initial begin
    #20
    @ (negedge clk) //b0
    rst_n = 1'b1;
    scan_en = 1'b1;
    scan_in = 1'b1;
    @ (negedge clk) //b1
    scan_in = 1'b1;
    @ (negedge clk) //b2
    scan_in = 1'b1;
    @ (negedge clk) //b3
    scan_in = 1'b1;
    @ (negedge clk) //a0
    scan_in = 1'b1;
    @ (negedge clk) //a1
    scan_in = 1'b1;
    @ (negedge clk) //a2
    scan_in = 1'b1;
    @ (negedge clk) //a3
    scan_in = 1'b1;
    
    @ (negedge clk)
    scan_en = 1'b0;
    scan_in = 1'b0;
    @ (negedge clk)//p0
    scan_en = 1'b1;
    
    #200
    $finish;
    
end
endmodule
