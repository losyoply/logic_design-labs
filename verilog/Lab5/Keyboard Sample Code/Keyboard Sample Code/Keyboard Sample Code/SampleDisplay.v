module SampleDisplay(
	output pmod_1,
	output pmod_2,
	output pmod_4,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	parameter [8:0] W_CODES  = 9'b0_0001_1101;	// w => 1D
	parameter [8:0] S_CODES = 9'b0_0001_1011;	// s=> 1B
	parameter [8:0] R_CODES = 9'b0_0010_1101;
	parameter [8:0] ENTER_CODES = 9'b0_0101_1010;	// enter=> 5a
	parameter [8:0] EX_ENTER_CODES = 9'b1_0101_1010; //enter=>e05A
	assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	wire ENTER;
	parameter ONE_SEC_FREQ = 32'd1;	//one beat=1sec
	parameter HALF_SEC_FREQ = 32'd2;	//one beat=0.5sec
	parameter DUTY_BEST = 10'd512;
	reg[10:0] now__beat_freq;
	reg is_rev;
	wire beatFreq;
	reg [31:0] freq;
	wire [7:0] ibeatNum;
	reg re0;
	reg[1:0] count;
	KeyboardDecoder key_de (
	   .ENTER(ENTER),
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(rst),
					 .freq(now__beat_freq),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(rst),
						   .ibeat(ibeatNum),
						   .is_rev(is_rev),
						   .ENTER(ENTER)
);	
	
//Generate variant freq. of tones
always @(*) begin
	case (ibeatNum)
		8'd0: freq = 32'd262;	//Do-m
		8'd1: freq = 32'd294;	//Re-m
		8'd2: freq = 32'd330;	//Mi-m
		8'd3: freq = 32'd349;	//Fa-m
		8'd4: freq = 32'd392;	//Sol-m
		8'd5: freq = 32'd440;	//La-m
		8'd6: freq = 32'd494;	//Si-m
		8'd7: freq = 32'd524;	//Si-m
		8'd8: freq = 32'd588;	//Si-m
		8'd9: freq = 32'd660;	//Si-m
		8'd10: freq = 32'd698;	//Si-m
		8'd11: freq = 32'd784;	//Si-m
		8'd12: freq = 32'd880;	//Si-m
		8'd13: freq = 32'd988;	//Si-m
		8'd14: freq = 32'd1047;	//C6
		8'd15: freq = 32'd1175;
		8'd16: freq = 32'd1319;
		8'd17: freq = 32'd1397;
		8'd18: freq = 32'd1568;
		8'd19: freq = 32'd1760;
	    8'd20: freq = 32'd1976;
	    8'd21: freq = 32'd2093;
	    8'd22: freq = 32'd2349;
	    8'd23: freq = 32'd2637;
	    8'd24: freq = 32'd2794;
	    8'd25: freq = 32'd3136;
	    8'd26: freq = 32'd3520;
	    8'd27: freq = 32'd3951;
		8'd28: freq = 32'd4186;//C8

		default : freq = 32'd20000;	//Do-dummy
	endcase
end
//Music music00 ( .ibeatNum(ibeatNum),
//				.tone(freq)
//);
// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(rst), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);
always @ (posedge clk, posedge rst, posedge ENTER) begin
    if (rst||ENTER) begin
        now__beat_freq<=ONE_SEC_FREQ;
        is_rev<=1'b0;
    end 
    else begin
        if (been_ready && key_down[last_change] == 1'b1) begin
            if (last_change==W_CODES)begin
                is_rev<=1'b0;
            end 
            else if (last_change==S_CODES)begin
                is_rev<=1'b1;
            end
            else if (last_change==R_CODES)begin
                if(now__beat_freq==ONE_SEC_FREQ) now__beat_freq<=HALF_SEC_FREQ;
                else now__beat_freq <= ONE_SEC_FREQ;
            end
        end
    end
end
endmodule
