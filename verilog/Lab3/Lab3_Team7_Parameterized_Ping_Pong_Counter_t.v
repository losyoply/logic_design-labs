module Parameterized_Ping_Pong_Counter_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
reg flip = 1'b0;
reg [3:0] max = 4'b0100;
reg [3:0] min = 4'b0000;
reg [2:0] count = 3'b000; 
wire direction;
wire[3:0]out;

// specify duration of a clock cycle.
parameter cyc = 10;
// generate clock.
always#(cyc/2)clk = !clk;

Parameterized_Ping_Pong_Counter PPPC(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .flip(flip),
    .max(max),
    .min(min),
    .direction(direction),
    .out(out)
);
initial begin
    @ (negedge clk)
    rst_n = 1'b0;
    @ (negedge clk)
    rst_n = 1'b1;
    @ (negedge clk)
    repeat(2**5)begin
        @ (negedge clk)
            if(flip==1'b1) flip = 1'b0;
        @ (negedge clk)
        count = count + 1'b1;
        @ (negedge clk)
        if(count==3'b111)
            flip = 1'b1;
    end
    
    #1 $finish;
end
endmodule