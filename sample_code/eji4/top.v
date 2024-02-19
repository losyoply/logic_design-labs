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
        if(stop) {left, right} = 4'b1111;
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

