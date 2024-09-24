module RX_data_sampling (
	input        clk,    // Clock
	input        ARSTn,  // Asynchronous reset active low
	input        data_samp_en,
	input  [4:0] edge_cnt,
	input        RX_IN,
	input  [5:0] prescale,
	output reg   sampled_bit	
);
reg  [2:0] samples; 
wire [5:0] half,pre_half,post_half;

assign half=(prescale>>1)-1'b1;
assign pre_half = half-1'b1;
assign post_half = half+1'b1;


always @(posedge clk or negedge ARSTn) begin 
	if(~ARSTn) 
		samples <= 3'b0;
	
	else
	 begin
		if(data_samp_en) begin
			if(edge_cnt==pre_half)
				samples[0]<=RX_IN;
			else if(edge_cnt==half)
				samples[1]<=RX_IN;
			else if(edge_cnt==post_half)
			    samples[2]<=RX_IN;
			else
			    samples<=samples;				
		end

		else
			samples<=3'b0;
	 end
end

always @(*) begin 
	    	sampled_bit = (samples[0] & samples[1])  | (samples[0] & samples[2]) | (samples[2] & samples[1]);
end

endmodule