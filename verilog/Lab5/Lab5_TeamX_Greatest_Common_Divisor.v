`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;
wire [1:0]countt;
reg [1:0]count;
parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
reg [1:0] state, next_state;
reg [15:0] a_buf, b_buf;
reg done;
reg[15:0] gcd;
always@(posedge clk)
  if(!rst_n) state <= WAIT;
  else state <= next_state;
//count
always@(*) begin
    if(state!=FINISH) count=1'b0;
end
//nxt_state
always@(*) begin
  case(state)
    WAIT:if(start)  next_state <= CAL;
         else    next_state <= WAIT;	
    CAL:  if(a_buf!=b_buf) next_state <= CAL;
         else             next_state <= FINISH;
    FINISH: if(count==2'b10)next_state <= WAIT;
            else next_state <= FINISH;
  endcase
end

always@(posedge clk)
     if(!rst_n)begin
		gcd    <= 16'b0;
		a_buf  <= 16'b0;
		b_buf  <= 16'b0;	
       // done   <= 1'b0;
        count <= 2'b0;
      end
     else begin
	    case(state)
        WAIT:begin
            if(start)begin
		       a_buf   <= a;
			   b_buf   <= b;            
             end
            // done   <= 1'b0;
           end
	    CAL:if(a_buf != b_buf)begin
		     if(a_buf > b_buf)begin
			    a_buf <= a_buf-b_buf;
				b_buf <= b_buf;
			 end
			 else begin
			    b_buf <= b_buf-a_buf;
				a_buf <= a_buf;			 
              end
           end		
		FINISH:begin
		    count<=countt;
            gcd <= b_buf;
            done   <= 1'b1;
          end
	    endcase
      end
assign countt=count+1'b1;
//output
always@(*) begin
    case(state)
        WAIT:begin
            done=1'b0;
            gcd=1'b0;
           end
	    CAL:if(a_buf != b_buf)begin
		     done=1'b0;
		     gcd=1'b0;
           end		
        default:
            done = 1'b0;
	    endcase
end
endmodule
