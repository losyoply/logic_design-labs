`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_fpga (clk, reset, enable, flip, max, min, seg, AN);
input clk, reset;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output [0:6] seg;
output [3:0] AN;

reg [0:6] seg;
reg [3:0] AN;
reg [3:0] out;
reg direction;
reg [0:6] seg_out1, seg_out2, seg_direction;
reg flip_dclk, reset_dclk;

//dealing the input flip & reset & clk
wire flip_one_pulse, reset_one_pulse, rst_n_one_pulse;
reg dclk_counting;
reg [25:0] ct_counting; //clk: 100MHz, desired counting frequence: 0.5Hz (2s for each cycle) ->1/10^8 * 2*28 is about 2.6sec
reg [18:0] ct_digit;
 
debounce_and_one_pulse f1(clk, flip, flip_one_pulse);
debounce_and_one_pulse r1(clk, reset, reset_one_pulse);
not n1(rst_n_one_pulse, reset_one_pulse);

always@(posedge clk) begin
    if(rst_n_one_pulse == 1'b0) begin
        ct_counting<= 26'b0;
        dclk_counting<=1'b0;
        ct_digit<=19'b0;
    end
    else begin
        ct_counting<= ct_counting + 1'b1;
        dclk_counting <= (ct_counting == 26'b0);
        ct_digit <= ct_digit + 1'b1;
    end
end

//dealing the output out & direction
always@(*) begin
    case(ct_digit[18:17])
    2'b00: begin
    AN = 4'b0111;
    seg = seg_out1;
    end
    2'b01: begin
    AN = 4'b1011;
    seg = seg_out2;
    end
    2'b10: begin
    AN = 4'b1101;
    seg = seg_direction;
    end
    2'b11: begin
    AN = 4'b1110;
    seg = seg_direction;
    end
    default: begin
    AN = 4'b1111;
    seg = 7'b1111111;
    end
    endcase

    case(direction)
    1'b0: seg_direction = 7'b1100011;
    1'b1: seg_direction = 7'b0011101; 
    endcase

  // 9             8               7                6                5           
 //7'b0000100, 7'b0000000, 7'b0001111, 7'b0100000, 7'b0100100,

  //4                 3               2               1               0
  //7'b1001100, 7'b0000110, 7'b0010010, 7'b1001111, 7'b0000001
    case(out)
    4'b0000: begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0000001; //0
    end
    4'b0001:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b1001111; //1
    end
    4'b0010:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0010010; //2
    end
    4'b0011:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0000110; //3
    end  
    4'b0100:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b1001100; //4
    end
    4'b0101:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0100100; //5
    end
    4'b0110:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0100000; //6
    end
    4'b0111:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0001111; //7
    end
    4'b1000:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0000000; //8
    end
    4'b1001:begin
    seg_out1 = 7'b0000001; //0
    seg_out2 = 7'b0000100; //9
    end
    4'b1010:begin 
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b0000001; //0
    end
    4'b1011:begin
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b1001111; //1
    end
    4'b1100:begin
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b0010010; //2
    end
    4'b1101:begin
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b0000110; //3
    end
    4'b1110:begin
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b1001100; //4
    end
    4'b1111: begin
    seg_out1 = 7'b1001111; //1
    seg_out2 = 7'b0100100; //5
    end
    endcase 
end 

//the counting function
always@(posedge clk) begin 
    if(flip_one_pulse == 1'b1) flip_dclk <= 1'b1;
    else if(flip_one_pulse == 1'b0 && dclk_counting) flip_dclk <= 1'b0;
    if(reset_one_pulse == 1'b1) reset_dclk <= 1'b1;
    else if(reset_one_pulse == 1'b0 && dclk_counting) reset_dclk <= 1'b0;
    if(dclk_counting) begin
        if(reset_dclk == 1'b1) begin
            out <= min;
            direction <= 1'b1;
        end
        else if(enable == 1'b1) begin
                if(min >= max || out > max || out < min) begin
                //remain its direction and value
                end
                else begin
                    if(flip_dclk == 1'b1) begin
                        direction <= !direction;
                        out <= (!direction == 1'b1) ? out + 1'b1 : out - 1'b1;
                    end
                    else begin
                        if (direction == 1'b1 && out == max) begin
                            out <= out - 1'b1;
                            direction <= !direction;
                        end
                        else if(direction == 1'b0 && out == min) begin
                            out <= out + 1'b1;
                            direction <= !direction;
                        end
                        else out <= (direction == 1'b1) ? out + 1'b1 : out - 1'b1;
                    end
                end
         end
         else begin
         //rst_n = 1'b1 && enable = 1'b0: remain its direction and value
         end
    end
    else;//do nothing
end
endmodule

module debounce_and_one_pulse(clk, a, a_one_pulse);
input clk;
input a;
output a_one_pulse;
reg a_one_pulse, a_debounced_delay;
reg [3:0] DFF;
wire a_debounced;

always @(posedge clk) 
begin
 DFF[3:1] <= DFF[2:0];
 DFF[0] <= a;
end
assign a_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

always @(posedge clk) begin
a_debounced_delay <= a_debounced;
a_one_pulse <= (a_debounced & !a_debounced_delay);
end

endmodule
