module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right
    //,output reg [7:0] sseg,
    //output reg [3:0] an
);

    wire rst_op, rst_pb, stop;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, rrst_op);
    
    wire [3:0] mode;//owo?
    motor A(
        .clk(clk),
        .rst(rst_op),
        .mode(mode),//I
        //.pwm(pwm)//O
        .pwm({left_motor, right_motor})//O
    );

    sonic_top B(
        .clk(clk), 
        .rst(rst_op), 
        .Echo(echo),//I 
        .Trig(trig),//O
        .stop(stop)//O
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(rst_op), 
        .left_signal(left_signal),//I 
        .right_signal(right_signal),//I
        .mid_signal(mid_signal), //I
        .state(mode)//O owo?
       );

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if(stop) {left, right} = 4'b1010;
        else {left, right} = 4'b1010;
    end
    

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

//module led_hex(clk, rst, hex0, hex1, hex2, hex3, dp_in, an, sseg);
//    input clk, rst;
//    input [3:0] hex0, hex1, hex2, hex3, dp_in;
//    output reg [3:0] an;
//    output reg [7:0] sseg;
//    //16 bit for 50 Mhz=5*10^4 < 2^16=6xxxx     100Mhz=10^5<2^17?  the first two bits are ? cycle
//    reg [18:0] regN;
//    reg [3:0] hex_in;
//    reg dp;
    
//    always@(posedge clk or posedge rst)begin
//        if(rst) regN <= 0;
//        else regN <= regN + 1;
//    end
    
//    always@(*)begin
//        case(regN[18:17])
//            2'b00:begin
//                an = 4'b1110;
//                hex_in = hex0;
//                dp = dp_in[0];
//            end
//            2'b01:begin
//                an = 4'b1101;
//                hex_in = hex1;
//                dp = dp_in[1];
//            end
//            2'b10:begin
//                an = 4'b1011;
//                hex_in = hex2;
//                dp = dp_in[2];
//            end
//            default:begin
//                an = 4'b0111;
//                hex_in = hex3;
//                dp = dp_in[3];
//            end
//        endcase
//    end
    
//    always@(*)begin
//        case(hex_in)//abcdefg
//            4'h0: sseg[6:0] = 7'b0000001;
//            4'h1: sseg[6:0] = 7'b1001111;
//            4'h2: sseg[6:0] = 7'b0010010;
//            4'h3: sseg[6:0] = 7'b0000110;
//            4'h4: sseg[6:0] = 7'b1001100;
//            4'h5: sseg[6:0] = 7'b0100100;
//            4'h6: sseg[6:0] = 7'b0100000;
//            4'h7: sseg[6:0] = 7'b0001111;
//            4'h8: sseg[6:0] = 7'b0000000;
//            4'h9: sseg[6:0] = 7'b0000100;
//            4'ha: sseg[6:0] = 7'b0011101;//dir = 1;
//            4'hb: sseg[6:0] = 7'b1100011;//dir = 0;   
//        endcase
//        sseg[7] = dp;
//    end
//endmodule


