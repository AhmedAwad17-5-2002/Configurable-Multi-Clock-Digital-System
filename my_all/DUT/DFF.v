module DFF #(parameter BUS_WIDTH=1
)(
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [BUS_WIDTH-1:0] D,
	output reg [BUS_WIDTH-1:0] Q	
);

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		Q <= 0;
	end else begin
		Q <= D;
	end
end

endmodule