`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;
reg dclk;
reg clk1_2,clk1_3,clk1_4,clk1_8;
reg[3:0] count;
reg[1:0] count_3 ;

always @(posedge clk) begin
    if(rst_n == 1'b0)begin
        count <= 4'b0001;
        count_3 <= 2'b01;
        clk1_2 <= 1'b1;
        clk1_3 <= 1'b1;
        clk1_4 <= 1'b1;
        clk1_8 <= 1'b1;
    end
    else begin
        count <= count+1;
    
        if (count_3 == 2'b10) count_3 <= 2'b0;
        else count_3 <= count_3+1;
        
        clk1_2 <= (count%2) == 0?1:0;
        clk1_3 <= (count_3%3) == 0?1:0;
        clk1_4 <= (count%4) == 0?1:0;
        clk1_8 <= (count%8) == 0?1:0;
    end 
end

always @(*) begin
    if(sel == 2'b00)begin
        dclk = clk1_3;
    end
    else if(sel == 2'b01)begin
        dclk = clk1_2;
    end 
    else if(sel == 2'b10)begin
        dclk = clk1_4;
    end 
    else if(sel == 2'b11)begin
        dclk = clk1_8;
    end 
end

endmodule