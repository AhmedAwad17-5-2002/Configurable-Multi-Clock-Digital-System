module PULSE_GEN (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input enable,
	output pulse	
);

reg enable_reg;
always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		enable_reg <= 0;
	end else begin
		enable_reg <= enable;
	end
end

assign pulse= (!enable_reg) & enable;
endmodule