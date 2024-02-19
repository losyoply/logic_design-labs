//
//
//
//

module PlayerCtrl (
	input clk,
	input reset,
	input is_rev,
	input ENTER,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 28;

always @(posedge clk, posedge reset, posedge ENTER) begin
	if (reset||ENTER)
		ibeat <= 0;
	else if (ibeat < BEATLEAGTH&& is_rev==1'b0) 
		ibeat <= ibeat + 1;
	else if (0<ibeat&& is_rev==1'b1) 
		ibeat <= ibeat - 1;
	else 
		ibeat <= ibeat;
end

endmodule