module CLAadder_tb;

reg [7:0] a = 8'b0;

reg [7:0] b = 8'b0;

reg c0 = 1'b0;

wire [7:0] s;

wire c8;

Carry_Look_Ahead_Adder_8bit uut (.a(a),.b(b),.c0(c0),.s(s),.c8(c8) );

initial begin

#10 a=8'b00000001;b=8'b00000001;c0=1'b0;

#10 a=8'b00000001;b=8'b00000001;c0=1'b1;

#10 a=8'b00000010;b=8'b00000011;c0=1'b0;

#10 a=8'b10000001;b=8'b10000001;c0=1'b0;

#10 a=8'b00011001;b=8'b00110001;c0=1'b0;

#10 a=8'b00000011;b=8'b00000011;c0=1'b1;

#10 a=8'b11111111;b=8'b00000001;c0=1'b0;

#10 a=8'b11111111;b=8'b00000000;c0=1'b1;

#10 a=8'b11111111;b=8'b11111111;c0=1'b0;

#10 $stop;

end

endmodule