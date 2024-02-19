`timescale 1ns/1ps 

module Booth_Multiplier_4bit_t;

reg clk = 1'b1;
reg rst_n = 1'b1;
reg start = 1'b0;
reg signed [3:0] a = 4'd3;
reg signed [3:0] b = 4'd6;
wire signed [7:0] p;

Booth_Multiplier_4bit BM(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .p(p)
);

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;


// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (negedge clk) rst_n = 1'b1;
    @ (negedge clk)
    @ (negedge clk) a = 4'd4;
    @ (negedge clk) b = 4'd7;
    @ (negedge clk) start = 1'b1;
    @ (negedge clk) start = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) a = 4'd3;
    @ (negedge clk) b = 4'd6;
    @ (negedge clk) start = 1'b1;
    @ (negedge clk) start = 1'b0;
    @ (negedge clk) a = 4'd2;
    @ (negedge clk)
    @ (negedge clk) b = 4'd4;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) a = 4'd7;
    @ (negedge clk) b = 4'd4;
    @ (negedge clk) start = 1'b1;
    @ (negedge clk) start = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) $finish;
end

endmodule
