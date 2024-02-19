`timescale 1ns / 1ps
module Lab5_TeamX_Sliding_Window_Sequence_Detector_tb;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;

parameter cyc = 10;
always #(cyc/2) clk = ~clk;

Sliding_Window_Sequence_Detector SW (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .dec (dec)
);
initial begin
    @ (negedge clk) 
    rst_n = 1'b1;
    in=1'b1;
    @ (negedge clk)
    @ (negedge clk)
    in = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    in = 1'b1;
    @ (negedge clk)
    in = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    in = 1'b1;
    @ (negedge clk)
    @ (negedge clk)
    in = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    in = 1'b1;
    @ (negedge clk)
    in = 1'b0;
    @ (negedge clk)
    in = 1'b1;
    @ (negedge clk)
    in = 1'b0;
    @ (negedge clk)
    @(negedge clk)
    in = 1'b1;
    @ (negedge clk)
    
    $finish;
end
endmodule
