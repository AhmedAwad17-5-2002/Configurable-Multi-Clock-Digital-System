module RX_start_chk (
input            sampled_bit,
input            strt_chk_en,
input      [4:0] edge_cnt,
input      [5:0] Prescale,
input            ARSTn,
input            clk,
output reg       strt_glitch
);

always @(posedge clk or negedge ARSTn) begin 
	if (~ARSTn) begin
		strt_glitch<=0;
	end
	else if(strt_chk_en && ((edge_cnt==(Prescale>>1)+2)))
	    strt_glitch <= sampled_bit;
	else
	    strt_glitch <= 1'b0; 
end

endmodule