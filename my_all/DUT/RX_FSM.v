module RX_FSM (
	input clk,
	input ARSTn,
	input RX_IN,
	input PAR_EN,
	input par_err,
	input strt_glitch,
	input stp_err,
	input [3:0] bit_cnt,
	input [4:0] edge_cnt,
  input [5:0] Prescale,
	output reg dat_samp_en,
	output reg enable,
	output reg deser_en,
	output reg data_valid,
	output reg stp_chk_en,
	output reg strt_chk_en,
	output reg par_chk_en,
  output reg PAR_STALL
	);

    parameter IDEL=3'b000,
              START=3'b001,
              DATA=3'b011,
              PARITY=3'b010,
              STOP=3'b110;



    reg [2:0] cs,ns;

    always@(posedge clk , negedge ARSTn) begin
    	if(~ARSTn)
    		cs<=IDEL;
    	else
    		cs<=ns;
    end


always@(posedge clk)begin
  if (~ARSTn)
    data_valid<=0;
  else if(cs==STOP) begin
      if((~stp_err && ~strt_glitch) && ((edge_cnt == Prescale-1))) begin    
         if(PAR_EN && ~par_err)
              data_valid<=1; 
          else if(par_err)
              data_valid<=0;
          else
              data_valid<=1;    
      end
  else if(stp_err && strt_glitch)
       data_valid<=0;
  end

  // else if(cs==IDEL)
  //   data_valid<=data_valid;

  else if(cs==START) begin
    if(edge_cnt==2)
      data_valid<=0;
  end

end


    always @(*) begin 
    	case (cs)
    		IDEL : begin 
                // data_valid=0;
    			    if(~RX_IN)
    				   ns=START;
    			    else begin
               ns=IDEL;               
              end

    		       end

    		START : begin     
             // data_valid=0;         
             if(((edge_cnt==Prescale-1) && bit_cnt==4'b0000))
               begin
    			       if(strt_glitch)
    			       	    ns=IDEL;

    			       else 
                         ns=DATA;
    			     end

    			     else 
    			     	ns=START;   			       			     
    		        end


    		DATA : begin
          // data_valid=0;
    			    if(((edge_cnt==Prescale-1) && bit_cnt==4'b1000))
              begin
    			    	if(PAR_EN)
    			    		ns=PARITY;
    			    	else
    			    		ns=STOP;
    			    end

    			    else
    			    	ns=DATA;
    			   end


    	    PARITY : begin
            // data_valid=0;
    	               if(((edge_cnt==Prescale-1) && bit_cnt==4'b1001))
    	             	 ns=STOP;
    	               else
    	             	ns=PARITY;   	               	    	      
    	             end

    	    STOP : begin
    	               if(((edge_cnt==Prescale-1) && (bit_cnt==4'b1010 || bit_cnt==4'b1001)))
    	             	  ns=IDEL;
    	               else
    	             	 ns=STOP;   	               	    	      
    	           end


    		default :begin
                 ns=IDEL;
                 // data_valid=0;
               end
    	endcase
    end




    always @(*) begin
              PAR_STALL=0;
    	case (cs)
    		    IDEL : begin 
    			    if(~RX_IN) begin
    			            dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=1;
                      par_chk_en=0;                     
                    end
                    else begin
                      dat_samp_en=0;
                      enable=0;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=0;
                    end
    		       end

    		    START : begin

    			            dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=1;
                      par_chk_en=0;
    		        end

            DATA : begin
                      
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=1;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=0;                                          
                      
                   end

            PARITY : begin
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=1;
                      PAR_STALL=1;
                     end

            STOP : begin
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=1;
                      strt_chk_en=0;
                      par_chk_en=0;
                      PAR_STALL=1;

                   end

    		default : begin
    			              dat_samp_en=0;
                        enable=0;
                        deser_en=0;
                        stp_chk_en=0;
                        strt_chk_en=0;
                        par_chk_en=0;
                      end
    	endcase
    end
endmodule