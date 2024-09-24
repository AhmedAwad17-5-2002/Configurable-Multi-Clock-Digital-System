module RST_SYNC #(parameter NUM_STAGES=2)
(
	input clk,    // Clock
	input RST,
	output SYNC_RST	
);

wire [NUM_STAGES-1:0] output_of_stages;
genvar i;

generate
	for(i=0;i<NUM_STAGES;i=i+1) begin
		if(i==0)
			DFF U0 (.clk(clk),.rst_n(RST),.D(1'b1),.Q(output_of_stages[i]));
		else if (i != NUM_STAGES-1)
			DFF U0 (.clk(clk),.rst_n(RST),.D(output_of_stages[i-1]),.Q(output_of_stages[i]));
		else 
			DFF U0 (.clk(clk),.rst_n(RST),.D(output_of_stages[i-1]),.Q(SYNC_RST));
	end
endgenerate

endmodule