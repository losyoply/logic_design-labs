`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [7:0] out;

    reg [7:0] nxt;
    
    always @(posedge clk) begin
        if (~rst_n) out <= 8'b10111101;
        else out <= nxt;
    end

    always @(*) begin
        nxt[0] = out[7];
        nxt[1] = out[0];
        nxt[2] = out[1] ^ out[7];
        nxt[3] = out[2] ^ out[7];
        nxt[4] = out[3] ^ out[7];
        nxt[5] = out[4];
        nxt[6] = out[5];
        nxt[7] = out[6];
    end

endmodule