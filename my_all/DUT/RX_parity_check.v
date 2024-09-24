module RX_parity_check (
	input      par_chk_en,
	input      sampled_bit,
	input      PAR_TYP,
	input      [7:0] P_DATA,
	input      clk,
	input      ARST_n,
	input      [4:0] edge_cnt,
	input      [5:0] Prescale,
	input      PAR_STALL,
	output reg par_err
);

always @(posedge clk or negedge ARST_n) begin 
	// par_err<=0;
	if (~ARST_n) begin
		par_err<=0;
	end
	else if(par_chk_en && (edge_cnt==((Prescale>>1)+2))) begin
	   if(PAR_TYP==0) begin
		   if((^P_DATA)==sampled_bit)
			    par_err<=0;
			else
				par_err<=1;
		end

		else begin
		    if((~^P_DATA)==sampled_bit)
			    par_err<=0;
			else
				par_err<=1;
		end
   end
   // else if(~par_chk_en)
   // 	    par_err<=0;

	
end

endmodule 