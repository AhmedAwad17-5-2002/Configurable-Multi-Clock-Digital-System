module TX_FSM(clk,ARSTn,DATA_VALID,PAR_EN,serial_done,mux_sel,busy,serial_en,cs_out);
	parameter IDEL=3'b000,
	          START=3'b001,
	          DATA=3'b011,
	          PARITY=3'b010,
	          STOP=3'b110;

	input clk,ARSTn,serial_done,DATA_VALID,PAR_EN;
	output reg [1:0] mux_sel;
	output reg busy,serial_en;
	output [2:0] cs_out;

	reg [2:0] cs,ns;

	always@(posedge clk, negedge ARSTn) begin
		if(~ARSTn)
			cs<=IDEL;
		else
			cs<=ns;
	end


	always @(*) begin 
		case (cs)
			IDEL : 
			       if(DATA_VALID)
			         ns = START;
			       else
			       	 ns = IDEL;


			START : ns = DATA;


			DATA : 
			       if(~serial_done)
			         ns = DATA;

			       else begin
			       	 if (PAR_EN==0) 
			       	 	ns = STOP;
			       	 else
			       	 	ns = PARITY;
			       end
			       	 
		    
		    PARITY : ns = STOP;

		    STOP :
		          if(!DATA_VALID) 
		            ns = IDEL;
		          else 
		          	ns = IDEL;


			default : ns = IDEL;
		endcase
	end


	always @(*) begin 
		case (cs)

			IDEL : begin
				     mux_sel=2'b11;
				     busy=1'b0;
				     serial_en=1'b0;
			       end
		    
            
            START : begin
            	      mux_sel=2'b00;
            	      busy=1'b1;
            	      if(ns==DATA)
            	      	serial_en=1;
            	      else
            	        serial_en=1'b0;
                    end


            DATA : begin
            	     mux_sel=2'b01;
            	     busy=1'b1;
            	     if(serial_done)
            	     	serial_en=1'b0;
            	     else
            	     	serial_en=1'b1;
                   end


            PARITY : begin
            	       mux_sel=2'b10;
            	       busy=1'b1;
            	       serial_en=1'b0;
            	     end
 
            
            STOP : begin
            	     mux_sel=2'b11;
            	     busy=1'b1;
            	     serial_en=1'b0;
            	   end
			default : begin
			            busy=1'b0;
			            serial_en=1'b0;
			            mux_sel=2'b00;
			          end
		endcase
	end

	assign cs_out=cs;

endmodule