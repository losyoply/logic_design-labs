 `timescale 1ns/1ps

 module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);//,state);//remove state
 input clk, rst_n;
 input lr_has_car;
 output [2:0] hw_light;
 output [2:0] lr_light;
// output [2:0] state;

 parameter S0 = 3'd0;
 parameter S1 = 3'd1;
 parameter S2 = 3'd2;
 parameter S3 = 3'd3;
 parameter S4 = 3'd4;
 parameter S5 = 3'd5;

 reg[2:0] state;
 reg[2:0] next_state;
 wire [2:0] hw_light;
 wire [2:0] lr_light;
 reg [6:0] counter;
 reg [6:0] next_counter;
 reg exceed_80_cycle;

 always @(posedge clk) begin
     if(rst_n == 1'b0)begin
         state <= S0;
         counter <= 7'd1;
     end
     else begin
         state <= next_state;
         counter <= next_counter;
     end
 end
 

 always @(*) begin
     case(state)
     S0:begin
         if(lr_has_car == 1'b1)begin
             if(counter >= 7'd80 || exceed_80_cycle == 1'b1)begin
                 next_counter = 7'd1;
                 next_state = S1;
                 exceed_80_cycle = 1'b0;
             end
             else begin
                 next_counter = counter + 1'b1;
                 next_state = S0;
                 exceed_80_cycle = exceed_80_cycle;
             end
         end
         else begin
             if(counter >= 7'd80) begin
                 next_counter = 7'd1;
                 next_state = S0;
                 exceed_80_cycle = 1'b1;
             end
             else begin
                 next_counter = counter + 1'b1;
                 next_state = S0;
                 exceed_80_cycle = exceed_80_cycle;
             end
         end
     end
     S1:begin
         if(counter >= 7'd20)begin
             next_counter = 7'd1;
             next_state = S2;
         end
         else begin
            next_counter = counter + 1'b1;
            next_state = S1;
         end
         exceed_80_cycle = exceed_80_cycle;
     end
     S2:begin
         if(counter >= 7'd1)begin
             next_counter = 7'd1;
             next_state = S3;
         end
         else begin
            next_counter = counter + 1'b1; 
            next_state = S2;
         end
         exceed_80_cycle = exceed_80_cycle;
     end
     S3:begin
         if(counter >= 7'd80)begin
             next_counter = 7'd1;
             next_state = S4;
         end
         else begin
            next_counter = counter + 1'b1; 
            next_state = S3;
         end 
         exceed_80_cycle = exceed_80_cycle;
     end
     S4:begin
         if(counter >= 7'd20)begin
             next_counter = 7'd1;
             next_state = S5;
         end
         else begin
             next_counter = counter + 1'b1;
             next_state = S4;
         end
         exceed_80_cycle = exceed_80_cycle;
     end
     S5:begin
         if(counter >= 7'd1)begin
             next_counter = 7'd1;
             next_state = S0;
         end
         else begin
             next_counter = counter + 1'b1;
             next_state = S5;
         end
         exceed_80_cycle = exceed_80_cycle;
     end
     default:begin
         next_counter = 7'd1;
         next_state = S0;
         exceed_80_cycle = 1'b0;
     end
     endcase
 end

 assign hw_light = (state == S0)?3'b100:
                   (state == S1)?3'b010:3'b001;

 assign lr_light = (state == S3)?3'b100:
                   (state == S4)?3'b010:3'b001;

 endmodule
