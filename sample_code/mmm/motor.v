module motor(
    input clk,
    input rst,
    input [2 :0]mode,
    output  [1:0]pwm
);

    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    parameter MAX = 8'b10000000,//50% duty
		  HALF= 8'b01000000,//25% duty
		  OFF = 8'b00000000;//0% duty
    parameter [2:0] STOP = 3'b000, TR = 3'b001, STR = 3'b010, TR_min = 3'b011, TL = 3'b100, STR_fail=3'b101,TL_min=3'b110, STRR = 3'b111;
    always@(*)begin
        case(mode)
    STOP: begin
    //at a "T" intersection 
    next_right_motor <= MAX; //會動再改成STOP
    next_left_motor <= MAX;
    end
    TR:begin
    //drifting to the right
    next_right_motor <= OFF;
    next_left_motor <= MAX;
    end
    STR:begin
    //ERROR (ignore)
    next_right_motor <= MAX;
    next_left_motor <= MAX;
    end
    TR_min:begin
    //went too far to the right
    next_right_motor <= HALF;
    next_left_motor <= MAX;
    end
    TL:begin
    //drifting to the left
    next_right_motor <= MAX;
    next_left_motor <= OFF;
    end
    STR_fail:begin
    //running in the middle
    next_right_motor <= MAX;
    next_left_motor <= MAX;
    end
    TL_min:begin
    //went too far to the left
    next_right_motor <= MAX;
    next_left_motor <= HALF;
    end
    STRR:begin
    //end of the line
    next_right_motor <= MAX;
    next_left_motor <= MAX;
    end
    
    endcase
    end


    assign pwm = {left_pwm, right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

