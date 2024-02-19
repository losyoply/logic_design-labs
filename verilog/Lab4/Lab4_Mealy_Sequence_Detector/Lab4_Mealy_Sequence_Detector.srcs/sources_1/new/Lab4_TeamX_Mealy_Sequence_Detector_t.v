`timescale 1ns / 1ps
module Lab4_TeamX_Mealy_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;
Mealy_Sequence_Detector MSD(
    .clk(clk), 
    .rst_n(rst_n),
    .in(in),
    .dec(dec)
);
always #10 clk = ~clk;


initial begin
    #10
    rst_n = 1'b1;
    in = 1'b0;
    #20
    in = 1'b1;
    #60
    in = 1'b0;
    #20
    in = 1'b1;
    #40
    in = 1'b0;
    #20
    in = 1'b1;
    #20
    in = 1'b0;
    #40
    in = 1'b1;
    #20
    in = 1'b0;
    #20
    in = 1'b1;
    #20
    in = 1'b0;
    #40
    in = 1'b1;
    #20
    in = 1'b1;
    #20
    in = 1'b1;
    #20
    in = 1'b1;
    #20
    #50
    $finish;
end
endmodule
