`timescale 1ns/1ps

module Content_Addressable_Memory_t;
    reg clk = 1'b0;
    reg wen = 1'b0;
    reg ren = 1'b0;
    reg [7:0] din = 8'd0;
    reg [3:0] addr = 4'd0;
    wire [3:0] dout;
    wire hit;
    // specify duration of a clock cycle.
    parameter cyc = 10;

    // generate clock.
    always#(cyc/2)clk = !clk;
    Content_Addressable_Memory CAM(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .din(din),
        .addr(addr),
        .dout(dout),
        .hit(hit)
    );
    // uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
    // initial begin
    //     $fsdbDumpfile("Memory.fsdb");
    //     $fsdbDumpvars;
    // end
    initial begin
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd4;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        addr = 4'd7;
        din = 8'd8;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        addr = 4'd15;
        din = 8'd35;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        addr = 4'd9;
        din = 8'd8;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b1;
        addr = 4'd0;
        din = 8'd4;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b1;
        addr = 4'd0;
        din = 8'd8;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b1;
        addr = 4'd0;
        din = 8'd35;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b1;
        addr = 4'd6;
        din = 8'd87;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b1;
        addr = 4'd0;
        din = 8'd6;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b1;
        addr = 4'd3;
        din = 8'd87;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b0;
        addr = 4'd2;
        din = 8'd78;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b1;
        addr = 4'd6;
        din = 8'd78;
        @(negedge clk)
        wen = 1'b1;
        ren = 1'b1;
        addr = 4'd0;
        din = 8'd87;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        wen = 1'b0;
        ren = 1'b0;
        addr = 4'd0;
        din = 8'd0;
        @(negedge clk)
        $finish; 
    end

endmodule