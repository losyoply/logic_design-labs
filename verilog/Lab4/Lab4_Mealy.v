`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output out;
output [2:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
reg [2:0] state;
reg [2:0] next_state;
always@(posedge clk) begin
   if (~rst_n) state <= S0;
   else state <= next_state;
end

always@(*)
   case (state)
     S0    : if (in) next_state = S2;
               else     next_state = S0;
     S1      : if (in) next_state = S4;
               else     next_state = S0;
    S2      : if (in) next_state = S1;
               else     next_state = S5;
    S3      : if (in) next_state = S2;
               else     next_state = S3;           
    S4      : if (in) next_state = S4;
               else     next_state = S2;           
    S5      : if (in) next_state = S4;
               else     next_state = S3;  
     default :          next_state = S0;
   endcase  
   reg z;
  always@(*)
   case (state)
     S0    : if (in) z = 1'b1;
               else     z = 1'b0;      
     S1      : if (in) z = 1'b1;
               else     z = 1'b1;
      S2      : if (in) z = 1'b0;
               else     z = 1'b1;
     S3      : if (in) z = 1'b0;
               else     z = 1'b1;          
     S4      : if (in) z = 1'b1;
               else     z = 1'b1;          
     S5      : if (in) z = 1'b0;
               else     z = 1'b0;          
     default :          z = 1'b0;
   endcase
//reg out;
assign out = z;
/*always@(posedge clk)
   if (~rst_n) out <= 1'b0;
   else        out <= z;*/
endmodule
