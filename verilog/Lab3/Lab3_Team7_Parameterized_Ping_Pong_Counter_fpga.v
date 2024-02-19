`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst, enable, flip, max, min, an, sseg);
input clk, rst;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output reg [3:0] an;
output reg [7:0] sseg;

reg direction;
reg [3:0] out;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        out <= min;
        direction <= 1'b1;
    end
    else if(enable == 1'b1 && max > min && out<=max && out>=min) begin
        if(flip == 1) direction = ~direction;
        if((direction==1'b1 && out < max) || out==min)begin
            direction <= 1'b1; 
            out <= out + 1'b1;
        end
        else if((direction==1'b0 && out > min) || out==max)begin
            direction <= 1'b0;
            out <= out - 1'b1;
        end
    end

end
//deal with fpga 7 segment
//https://blog.csdn.net/Reborn_Lee/article/details/106878249
wire [3:0] ten, one, dir;
wire [3:0] An;
wire [7:0]SSeg;
Decimal Dc(out, ten, one);
deal_with_dir DWD(direction, dir);
led_hex LED(clk, rst, dir, dir, one, ten, 4'b1111, An, SSeg);
always@(*)begin
    an = An;
    sseg = SSeg;
end


endmodule

module deal_with_dir(direction, dir);
    input direction;
    output reg[3:0] dir;
    always@(*)begin
        if(direction==1'b1) dir = 4'ha;
        else dir = 4'hb;
    end
endmodule

module Decimal(num, Ten, One);
    input [3:0]num;
    output reg[3:0] Ten, One;
    always@(*)begin
        if(num > 4'h9)begin
            Ten = 4'b0001;
            One = num - 4'ha;
        end
        else begin
            Ten = 4'b0000;
            One = num;
        end
    end 
endmodule

module led_hex(clk, rst, hex0, hex1, hex2, hex3, dp_in, an, sseg);
    input clk, rst;
    input [3:0] hex0, hex1, hex2, hex3, dp_in;
    output reg [3:0] an;
    output reg [7:0] sseg;
    //16 bit for 50 Mhz=5*10^4 < 2^16=6xxxx     100Mhz=10^5<2^17?  the first two bits are ? cycle
    reg [18:0] regN;
    reg [3:0] hex_in;
    reg dp;
    
    always@(posedge clk or posedge rst)begin
        if(rst) regN <= 0;
        else regN <= regN + 1;
    end
    
    always@(*)begin
        case(regN[18:17])
            2'b00:begin
                an = 4'b1110;
                hex_in = hex0;
                dp = dp_in[0];
            end
            2'b01:begin
                an = 4'b1101;
                hex_in = hex1;
                dp = dp_in[1];
            end
            2'b10:begin
                an = 4'b1011;
                hex_in = hex2;
                dp = dp_in[2];
            end
            default:begin
                an = 4'b0111;
                hex_in = hex3;
                dp = dp_in[3];
            end
        endcase
    end
    
    always@(*)begin
        case(hex_in)//abcdefg
            4'h0: sseg[6:0] = 7'b0000001;
            4'h1: sseg[6:0] = 7'b1001111;
            4'h2: sseg[6:0] = 7'b0010010;
            4'h3: sseg[6:0] = 7'b0000110;
            4'h4: sseg[6:0] = 7'b1001100;
            4'h5: sseg[6:0] = 7'b0100100;
            4'h6: sseg[6:0] = 7'b0100000;
            4'h7: sseg[6:0] = 7'b0001111;
            4'h8: sseg[6:0] = 7'b0000010;
            4'h9: sseg[6:0] = 7'b0000100;
            4'ha: sseg[6:0] = 7'b0011101;//dir = 1;
            4'hb: sseg[6:0] = 7'b1100011;//dir = 0;   
        endcase
        sseg[7] = dp;
    end
endmodule