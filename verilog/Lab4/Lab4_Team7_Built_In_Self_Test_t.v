`timescale 1ns/1ps

module Built_In_Self_Test_t;
reg clk = 0;
reg rst_n = 1'b0;
reg scan_en = 1'b0;
wire scan_in;
wire scan_out;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Built_In_Self_Test BIST(
    .clk(clk),
    .rst_n(rst_n),
    .scan_en(scan_en),
    .scan_in(scan_in),
    .scan_out(scan_out)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Many_To_One_LFSR.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    
    @(negedge clk)
    scan_en = 1'b0;
    
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    @(negedge clk)
    scan_en = 1'b1;
    #(cyc * 16)
    $finish;
end
endmodule

