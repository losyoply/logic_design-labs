`timescale 1ns/1ps

module T_Flip_Flop_t;

// input and output signals
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
wire q;

// generate clk
always#(1) clk = ~clk;
// test instance instantiation
Toggle_Flip_Flop TFF(
    .clk(clk),
    .t(t),
    .rst_n(rst_n),
    .q(q)
);

initial begin
    //rst==1
    @(negedge clk) rst_n = 1;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    //rst == 0 
    repeat(2)@(negedge clk) rst_n = 0;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    @(negedge clk) t = $random;
    #10 $finish;
end

endmodule