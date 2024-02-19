module Ping_Pong_Counter_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
wire direction;
wire [3:0] out;

// specify duration of a clock cycle.
parameter cyc = 10;
// generate clock.
always#(cyc/2)clk = !clk;

Ping_Pong_Counter PPC(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .direction(direction),
    .out(out)
);
initial begin
    @ (negedge clk)
    rst_n = 1'b0;
    @ (negedge clk)
    rst_n = 1'b1;
    @ (negedge clk)
    repeat(2**3)begin
        #(cyc * 4);
    end
    #1 $finish;
end

endmodule