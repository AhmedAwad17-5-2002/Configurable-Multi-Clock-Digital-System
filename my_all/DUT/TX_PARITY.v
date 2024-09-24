module TX_PARITY #(parameter DATA_WIDTH=8) (
	input [DATA_WIDTH-1:0] DATA,
	input PAR_TYP, 
	input DATA_VALID,
	input PAR_EN,
	output reg parity
);


always @(*) begin 
  if (~PAR_EN)
	    parity = 0;
	else if(PAR_EN) begin
		  if (~PAR_TYP)  //even parity
			parity = ^DATA;
		  else
			parity = ~^DATA;
	end

  else
	   parity = 0;
end
endmodule 