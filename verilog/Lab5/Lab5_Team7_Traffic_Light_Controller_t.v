`timescale 1ns/1ps

module Traffic_Light_Controller_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0]lr_light;

Traffic_Light_Controller TLC(
    .clk(clk),
    .rst_n(rst_n),
    .lr_has_car(lr_has_car),
    .hw_light(hw_light),
    .lr_light(lr_light)
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
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) lr_has_car = 1'b1;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)lr_has_car = 1'b0;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) $finish;
end
endmodule