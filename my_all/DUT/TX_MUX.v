module TX_mux(one,zero,parity,data_s,mux_sel,mux_out);
    input one,zero,parity,data_s;
    input [1:0] mux_sel;
    output reg mux_out;

    always @(*) begin 
    	  case(mux_sel)
    		  2'b00 : mux_out = zero;
    		  2'b01 : mux_out = data_s;
    		  2'b10 : mux_out = parity;
    		  2'b11 : mux_out = one;
    	  endcase
    end
endmodule