module RX_stop_chk (
    input            stp_chk_en,
    input            sampled_bit,
    input      [4:0] edge_cnt,
    input      [5:0] Prescale,
    input            clk,
    input            ARST_n,
    output reg       stp_err
);

always @(posedge clk or negedge ARST_n) begin
    if(~ARST_n)
        stp_err=0;
	else if (stp_chk_en && ((edge_cnt==(Prescale>>1)+1)))
		stp_err = ~sampled_bit;
    else if(~stp_chk_en)
        stp_err=0;

end

endmodule 