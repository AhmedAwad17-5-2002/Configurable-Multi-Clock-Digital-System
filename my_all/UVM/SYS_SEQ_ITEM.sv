package SYS_SEQ_ITEM;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	typedef enum logic [1:0] {Register_File_Write_command,
	                          Register_File_Read_command,
	                          ALU_Operation_command_with_operand, 
	                          ALU_Operation_command_with_No_operand
	                          } e_command_types;		
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	class SYS_SEQ_ITEM_C extends uvm_sequence_item;
		`uvm_object_utils(SYS_SEQ_ITEM_C);

	    rand logic rst_n;      // Asynchronous reset active low
        logic past1_rst_n=1, past2_rst_n, past3_rst_n, past4_rst_n, past5_rst_n;
	    bit past_rst_n=1;	    
	    logic valid1;	    
	    logic [2:0] edg_cnt;
	    logic [7:0] DIV_RATIO;
	    logic [3:0] REGFILE_ADDRESS;
        logic [3:0] ALU_FUN;
	    rand logic RX_IN;
        logic UART_CLK;
	    logic TX_OUT;
	    logic RX_PAR_ERR;
	    logic RX_STP_ERR;

        logic ref_mode;

	    logic TX_OUT_G;
	    logic RX_PAR_ERR_G;
	    logic RX_STP_ERR_G;
	    rand logic [7:0] REG_3_CONFIG={6'd32,1'b0,1'b1};
        logic [7:0] past_REG_3_CONFIG={6'd32,1'b0,1'b1};    
        int counter_frames;
        int counter_bits;

        logic [7:0] reg_file [15:0];
        logic [7:0] reg_file_data_out;
        logic [15:0] ALU_Result;

           rand e_command_types current_cmd;
           logic [1:0] CMD;
           e_command_types past_cmd=Register_File_Write_command;

           rand logic [7:0] current_frame;
           logic [7:0] past1_frame=8'h00;
           logic [7:0] past2_frame=8'h00;
           logic [7:0] past3_frame=8'h00;
           logic [7:0] past4_frame=8'h00;
           logic [7:0] past5_frame=8'h00;
	    

	    ////////////////////////////////////////////////////

	    function new(string name = "SYS_SEQ_ITEM_C");
	    	super.new(name);
	    endfunction : new

	    function string convert2string();
	    	return $sformatf(" %s\n reset=%0b\n RX_IN=%0b\n TX_OUT=%0b\n RX_PAR_ERR=%0b\n RX_STP_ERR=%0b\n TX_OUT_G=%0b\n RX_PAR_ERR_G=%0b\n RX_STP_ERR_G=%0b",
	    		             super.convert2string(), rst_n,RX_IN,TX_OUT,RX_PAR_ERR,RX_STP_ERR,TX_OUT_G,RX_PAR_ERR_G,RX_STP_ERR_G);
	    endfunction : convert2string

	    function string convert2string_stimulus();
	    	return $sformatf(" reset=%0b\n RX_IN=%0b\n TX_OUT=%0b\n RX_PAR_ERR=%0b\n RX_STP_ERR=%0b\n TX_OUT_G=%0b\n RX_PAR_ERR_G=%0b\n RX_STP_ERR_G=%0b",
	    		             rst_n,RX_IN,TX_OUT,RX_PAR_ERR,RX_STP_ERR,TX_OUT_G,RX_PAR_ERR_G,RX_STP_ERR_G);
	    endfunction : convert2string_stimulus

	    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        

        function void pre_randomize();
          
        endfunction 

        function void post_randomize();
        	if(~rst_n)
        		past_REG_3_CONFIG=8'h81;
        	else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
        		past_REG_3_CONFIG=past1_frame;

        	if(counter_bits==10) begin
                past_rst_n=rst_n;
                past5_rst_n=past4_rst_n;
                past4_rst_n=past3_rst_n;
                past3_rst_n=past2_rst_n;
                past2_rst_n=past1_rst_n;
                past1_rst_n=rst_n;       		
            end         
         //    REG_3_CONFIG=current_frame;
         

           if(counter_bits==10) begin
           past5_frame=past4_frame;
           past4_frame=past3_frame;           
           past3_frame=past2_frame;
           past2_frame=past1_frame;           
           end
           past1_frame=current_frame;
              ///////////////////////////////////////
           if(counter_frames==3 && counter_bits==10)
           	counter_frames=0;
           else if(counter_bits==10)
           	counter_frames=counter_frames+1;
           ///////////////////////////////////////
           if(counter_bits==10)
           	counter_bits=0;
           else
           	counter_bits=counter_bits+1;

           past_cmd=current_cmd;


        endfunction
// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
           constraint rst_cons {
           // if(current_frame==8'hFF && counter_bits==10)
           //  if(current_cmd==8'hAA || current_cmd==8'hCC)
           //      rst_n==1;
           //  else
           // 	    rst_n dist {0:/10 , 1:/90};
           // else
           // 	rst_n==past_rst_n;
           rst_n==1;
           }

           constraint rst2_cons {
           	rst_n dist {0:/10 , 1:/90};
           }

           constraint rst3_cons {
           	rst_n dist {0:/0 , 1:/100};
           }

           constraint CMD_cons {
           	if(!(counter_bits==10 && counter_frames==3))
           		current_cmd==past_cmd;
           }

           constraint frame_sent_cons {
              	if(counter_bits!=10)
              		current_frame==past1_frame;
              	else if(counter_frames==0)
              		current_frame inside {8'hAA, 8'hBB, 8'hCC, 8'hDD};
              	else if(counter_frames==1){
              		       if(past1_frame==8'hAA){
              		      	       current_frame inside {[8'h0 : 8'h0F]};
              		      	       current_frame dist {8'h02:/10, 8'h03:/15, [8'h00:8'h01]:/5, [8'h04 : 8'h0F]:/70};
              		      	    }
              		       else if(past1_frame==8'hBB)
              		      	       current_frame inside {[8'h0 : 8'h0F]};
              		       else if(past1_frame==8'hCC)
              		      		current_frame inside {[8'h0 : 8'hFF]};
              		       else 
              		      		current_frame inside {[8'h0 : 8'h0F]};
              		}

               else if(counter_frames==2){
                     	       if(past2_frame==8'hAA){
                     	       	if(past1_frame==8'h02)
                     	       	       current_frame[7:2]==6'd32;
                     	         else if(past1_frame==8'h03)                   	       		
                     	       	       current_frame inside {8'd4, 8'd8, 8'd16, 8'd32};  
                     	       	else if(past1_frame==8'h01)
                     	       	       current_frame!=8'h00;                   	       	       
                     	         else
              		      	              current_frame inside {[8'h0 : 8'hFF]};
              		      	      }
                              
               
              		             else if(past2_frame==8'hBB)
              		      	          current_frame == 8'hFF;
              		      	    else if(past2_frame==8'hCC)
              		      		   current_frame inside {[8'h1 : 8'hFF]};
              		      		   
              		      		else 
              		      		   current_frame == 8'hFF;
              		      	   }
              		      	 
              		               		     

               else{
                     	       if(past3_frame==8'hAA)
              		      	           current_frame == 8'hFF;
              		             else if(past3_frame==8'hBB)
              		      	           current_frame == 8'hFF;
              		      	    else if(past3_frame==8'hCC){
              		      		        if(past1_frame==8'b0)
              		      			         current_frame != 8'h03;
              		      		        else
              		      		            current_frame inside {[8'h0 : 8'h0F]};
              		      	   }
              		      	   else 
              		      		         current_frame == 8'hFF;
                     	}
                     	


               if (rst_n==0)
               	REG_3_CONFIG==8'h81;
               else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
                  REG_3_CONFIG==past1_frame;
               else
                  REG_3_CONFIG==past_REG_3_CONFIG;
                     	
           }

           constraint RX_cons {
                     if(counter_bits==0)
                     	RX_IN==0;
                     else if(counter_bits==9){
                     	if(past_REG_3_CONFIG[0]==1){
                     		if(past_REG_3_CONFIG[1]==0)
                     	      RX_IN==^current_frame;
                     	   else
                     	   	RX_IN==(~^current_frame);
                        }
                        else
                        	RX_IN==1'b1;
                     }
                     else if(counter_bits==10)
                     	RX_IN==1;
                     else
                     	RX_IN==current_frame[counter_bits-1];           	
           }

           constraint current_F {
            if (rst_n==0)
               	REG_3_CONFIG==8'h81;
            else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
                  REG_3_CONFIG==past1_frame;
            else
                  REG_3_CONFIG==past_REG_3_CONFIG;


            if(counter_bits!=10)
            	current_frame==past1_frame;
            else{
            	if(past1_frame==8'hAA){
              		       current_frame inside {[8'h0 : 8'h0F]};
              		       current_frame dist {8'h02:/10, 8'h03:/15, [8'h00:8'h01]:/5, [8'h04 : 8'h0F]:/70};
              		       }
              		       else if(past1_frame==8'hBB)
              		      	       current_frame inside {[8'h0 : 8'h0F]};
              		       else if(past1_frame==8'hCC)
              		      		current_frame inside {[8'h0 : 8'hFF]};
              		       else 
              		      		current_frame inside {[8'h0 : 8'h0F]};
            }
            }
              

           constraint c_fifo_full {
             if (rst_n==0)
               	REG_3_CONFIG==8'h81;
             else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
                  REG_3_CONFIG==past1_frame;
             else
                  REG_3_CONFIG==past_REG_3_CONFIG;


           	 if(counter_bits!=10)
            	current_frame==past1_frame;
             else{
           	   if(counter_frames==0)
           	   	current_frame==8'hBB;
           	   else if(counter_frames==1)
           	   	current_frame inside {[8'h00 : 8'h0F]};
           	   else
           	   	current_frame==8'hFF;
             }
           }

           constraint c_ALU_OP{
             if (rst_n==0)
               	REG_3_CONFIG==8'h81;
             else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
                  REG_3_CONFIG==past1_frame;
             else
                  REG_3_CONFIG==past_REG_3_CONFIG;


           	 if(counter_bits!=10)
            	current_frame==past1_frame;
             else{
           	   if(counter_frames==0)
           	   	current_frame==8'hCC;
           	   else if(counter_frames==1)
           	   	current_frame inside {[8'h00 : 8'hFF]};
           	   else if(counter_frames==2)
           	   	current_frame != 8'h00;
           	   else
           	   	current_frame inside {[8'h00 : 8'h0F]};
             }
           }

            constraint c_ALU_NO_OP{
             if (rst_n==0)
               	REG_3_CONFIG==8'h81;
             else if(counter_frames==3 && past3_frame==8'hAA && past2_frame==8'h02 && counter_bits==10)
                  REG_3_CONFIG==past1_frame;
             else
                  REG_3_CONFIG==past_REG_3_CONFIG;


           	 if(counter_bits!=10)
            	current_frame==past1_frame;
             else{
           	   if(counter_frames==0)
           	   	current_frame==8'hDD;
           	   else if(counter_frames==1){
           	   	current_frame inside {[8'h00 : 8'h0F]};
           	      current_frame != 8'h03;
           	   }
           	   else
           	   	current_frame==8'hFF;
             }
           }



	    
	endclass : SYS_SEQ_ITEM_C
endpackage : SYS_SEQ_ITEM