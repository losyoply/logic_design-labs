module FPGA_1A2B(clk, rst, start, enter, in, led, an, sseg);
input clk, rst, start, enter;
input [3:0]in;
output reg[15:0]led;
output reg[3:0] an;
output reg[7:0] sseg;
parameter init = 3'b000;
parameter guess1 = 3'b001;
parameter guess2 = 3'b010;
parameter guess3 = 3'b011;
parameter guess4 = 3'b100;
parameter show_result = 3'b101;


reg [2:0]state, next_state;

wire rst_de, rst_one, start_de, start_one, enter_de, enter_one;
wire [3:0] An_rst, An_start, An_enter, An_debug;
wire [7:0] SSeg_rst, SSeg_start, SSeg_enter, SSeg_debug;
reg [15:0] seven_seg_enter;


reg[15:0] ans;
wire[3:0] ans0,ans1,ans2,ans3;
reg [3:0]gu3, gu2, gu1, gu0;
reg [3:0] A, B;

reg [16:0]clk_17;  //clk  freq* 1/2**17
reg [24:0]clk_25;
reg flicker;
reg flash;
reg [1:0]refresh_cnt;

//module onepulse(pb_debounced, clk, pb_one_pulse);
debounce owo0(rst_de, rst, clk);
onepulse qwq0(rst_de, clk, rst_one);
debounce owo1(start_de, start, clk);
onepulse qwq1(start_de, clk, start_one);
debounce owo2(enter_de, enter, clk);
onepulse qwq2(enter_de, clk, enter_one);
random_four_num rfn(clk, rst, ans3, ans2, ans1, ans0);
led_hex seven_seg0(clk, 1'b0, 4'h1, 4'ha, 4'h2, 4'hb, 4'b1111, An_rst, SSeg_rst);
led_hex seven_seg1(clk, 1'b0, 4'h0, 4'h0, 4'h0, 4'h0, 4'b1111, An_start, SSeg_start);
led_hex seven_seg2(clk, 1'b0, seven_seg_enter[15:12], seven_seg_enter[11:8], seven_seg_enter[7:4], seven_seg_enter[3:0], 4'b1111, An_enter, SSeg_enter);
led_hex seven_seg3(clk, 1'b0, 4'h5, 4'h4, 4'h8, 4'h7, 4'b1111, An_debug, SSeg_debug);

always@(posedge clk)begin//state
    if(rst_one)
        state <= init;
    else
        state <= next_state;
end
always@(*)begin//next_state
    case(state)
        init:begin
            if(start_one) next_state = guess1;
            else next_state = init;
        end
        guess1:begin
            if(enter_one) next_state = guess2;
            else next_state = guess1;
        end
        guess2:begin
            if(enter_one) next_state = guess3;
            else next_state = guess2;
        end
        guess3:begin
            if(enter_one) next_state = guess4;
            else next_state = guess3;
        end
        guess4:begin
            if(enter_one) next_state = show_result;
            else next_state = guess4;
        end
        show_result:begin
            if(enter_one && A==3'd4)
                next_state = init;
            else if(enter_one && A!=3'd4)
                next_state = guess1;
            else next_state = show_result;
        end
    endcase
end

always@(posedge clk)begin
    if(clk_17 == 17'b11111111111111111)
        refresh_cnt <= refresh_cnt + 2'b1;
    if(clk_25 == 25'b1111111111111111111111111)
        flash <= !flash; 
end
always@(posedge clk)begin
    clk_17 <= clk_17 + 17'b1;   
    clk_25 <= clk_25 + 25'b1; 
 end

always@(*)begin
    if(refresh_cnt == 2'd0)begin
        if(flicker)begin
            an[0]  = flash; 
        end
        else an[0] = 1'b0;
    end
    else an[0] = 1'b1;
    an[1]=refresh_cnt==1?1'b0:1'b1;
    an[2]=refresh_cnt==2?1'b0:1'b1;
    an[3]=refresh_cnt==3?1'b0:1'b1;
end

always@(posedge clk)begin//output
    case(state)
        init:begin
            ans <= {ans3,ans2,ans1,ans0};
           // an <= An_rst;
            sseg <= SSeg_rst;
            gu3 <= gu3;
            gu2 <= gu2;
            gu1 <= gu1;
            gu0 <= gu0;
            flicker <= 1'b0;
        end
        guess1:begin
            ans <= ans;
            //an <= An_enter;
            
            sseg <= SSeg_enter;
            gu3 <= in;
            gu2 <= gu2;
            gu1 <= gu1;
            gu0 <= gu0;
            flicker <= 1'b1;
        end
        guess2:begin
            ans <= ans;
            //an <= An_enter;
        
            sseg <= SSeg_enter;
            gu3 <= gu3;
            gu2 <= in;
            gu1 <= gu1;
            gu0 <= gu0;
            flicker <= 1'b1;
        end
        guess3:begin
            ans <= ans;
            //an <= An_enter;
            
            sseg <= SSeg_enter;
            gu3 <= gu3;
            gu2 <= gu2;
            gu1 <= in;
            gu0 <= gu0;
            flicker <= 1'b1;
        end
        guess4:begin
            ans <= ans;
            //an <= An_enter;
           
            sseg <= SSeg_enter;
            gu3 <= gu3;
            gu2 <= gu2;
            gu1 <= gu1;
            gu0 <= in;
            flicker <= 1'b1;
        end
        show_result:begin
            ans <= ans;
           // an <= An_enter;
            sseg <= SSeg_enter;
            gu3 <= gu3;
            gu2 <= gu2;
            gu1 <= gu1;
            gu0 <= gu0;
            flicker <= 1'b0;
        end    
    endcase
end
always@(*)begin
    if(state==init) led = 16'b0;
    else led = ans;
end
always@(*)begin//seven_seg_enter
    case(state)
        init:begin
            seven_seg_enter = 16'd0;
        end
        guess1:begin
            seven_seg_enter = {12'd0, in};
        end
        guess2:begin
            seven_seg_enter = {8'd0,gu3,in};
        end
        guess3:begin
            seven_seg_enter = {4'd0, gu3, gu2, in};
        end
        guess4:begin
            seven_seg_enter = {gu3, gu2, gu1, in};
        end
        show_result:begin
            seven_seg_enter = {A, 4'ha, B, 4'hb};
        end
    endcase
end
always@(*)begin
A = (gu0==led[3:0]) + (gu1==led[7:4]) + (gu2==led[11:8]) + (gu3==led[15:12]);
B = (gu0==led[7:4]) + (gu0==led[11:8]) + (gu0==led[15:12]) +
    (gu1==led[3:0]) + (gu1==led[11:8]) + (gu1==led[15:12]) +
    (gu2==led[3:0]) + (gu2==led[7:4]) + (gu2==led[15:12]) +
    (gu3==led[3:0]) + (gu3==led[7:4]) + (gu3==led[11:8]);  
end



endmodule

//lab4 basic3
module LFSR(num, clk, rst);
output[3:0] num;
input  clk, rst;
reg[3:0] num;
reg[4:0] out;
wire feed;
assign feed = !(out[2]^out[4]);
always@(posedge clk) begin
    if(rst) begin
        out <= 5'b10111;
    end
    else begin
        out={out[3:0], feed};
    end
end
always @(*) begin
    if(out[1:0] == 2'b01) num = 1'b1 + out[4:2];
    else if(out[1:0] == 2'b10)begin
        num = 2'd2 + out[4:2];
    end
    else num = out[4:2];
end

endmodule

module random_four_num(clk, rst, ans3, ans2, ans1, ans0);
output reg [3:0] ans3, ans2, ans1, ans0;
input clk, rst;
wire [3:0]a0;
LFSR lfsr(a0, clk, rst);
always@(posedge clk) begin
    if(rst)begin
         ans3 <= 4'd0;
         ans2 <= 4'd4;
         ans1 <= 4'd7;
         ans0 <= 4'd9;
    end
    else begin
            if (a0 != ans2 && a0 != ans1 && a0 != ans0) {ans3, ans2, ans1, ans0} <= {ans2, ans1, ans0, a0};
            else {ans3, ans2, ans1, ans0} <= {ans3, ans2, ans1, ans0};
        end
end
endmodule

//from lab3 fpga
module led_hex(clk, rst, hex3, hex2, hex1, hex0, dp_in, an, sseg);
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
            4'h8: sseg[6:0] = 7'b0000000;
            4'h9: sseg[6:0] = 7'b0000100;
            4'ha: sseg[6:0] = 7'b0001000;
            4'hb: sseg[6:0] = 7'b1100000;   
        endcase
        sseg[7] = dp;
    end
endmodule


//https://www.cnblogs.com/oomusou/archive/2008/08/09/verilog_dlatch_dff.html
module DFF(clk, rst, en, d, q);
input clk, rst, en, d;
output reg q;
always@(posedge clk or posedge rst)
    if(rst) q <= 0;
    else if (en) q <= d;
endmodule

module clock_div(clk, rst, slow_clk);
    input clk, rst;
    output reg slow_clk;
    reg [40:0]counter;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            counter <= 0;
        end
        else begin
            counter <= (counter>=40'd29999999)?0:counter+1'b1;
            slow_clk <= (counter < 40'd25000)?1'b0:1'b1;
        end
    end
endmodule



module debounce(pb_debounced, pb, clk);
    output pb_debounced;
    input pb;
    input clk;
    reg[3:0] dff;
    always @(posedge clk) begin
        dff[3:1] <= dff[2:0];
        dff[0] <= pb;
    end
    assign pb_debounced = ((dff == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse(pb_debounced, clk, pb_one_pulse);
    input pb_debounced;
    input clk;
    output pb_one_pulse;
    reg pb_one_pulse;
    reg pb_debounced_delay;
    always @(posedge clk) begin
        pb_one_pulse <= pb_debounced & !(pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;    
    end
endmodule