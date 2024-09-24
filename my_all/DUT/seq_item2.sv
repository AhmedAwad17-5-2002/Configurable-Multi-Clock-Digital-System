package SYS_SEQ_ITEM;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	typedef enum logic [1:0] {Register_File_Write_command,
	                          Register_File_Read_command,
	                          ALU_Operation_command_with_operand, 
	                          ALU_Operation_command_with_No_operand
	                          } e_command_types;
	
	typedef enum logic [7:0] {RF_Wr_CMD=8'hAA,
	                          RF_Rd_CMD=8'hBB,
	                          ALU_OPER_W_OP_CMD=8'hCC, 
	                          ALU_OPER_W_NOP_CMD=8'hDD
	                          } e_frame0_type;

	typedef enum logic [1:0] {RF_Wr_Addr,
	                          RF_Rd_Addr,
	                          Operand_A, 
	                          ALU_FUN_f1
	                          } e_frame1_type;

	typedef enum logic  [1:0] {RF_Wr_Data,
	                           Operand_B,
	                           NA_f2
	                           } e_frame2_type;

	typedef enum logic        {ALU_FUN_f3,
	                           NA_f3
	                           } e_frame3_type;

	typedef enum logic [1:0] {frame0_s,
	                          frame1_s,
	                          frame2_s,
	                          frame3_s
	                          } e_seq;
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	class SYS_SEQ_ITEM_C extends uvm_sequence_item;
		`uvm_object_utils(SYS_SEQ_ITEM_C);

		rand logic rst_n;      // Asynchronous reset active low
	     rand logic RX_IN;
           // virtual SYS_IF me_if;
           logic UART_CLK;
	    logic TX_OUT;
	    logic RX_PAR_ERR;
	    logic RX_STP_ERR;

	    logic TX_OUT_G;
	    logic RX_PAR_ERR_G;
	    logic RX_STP_ERR_G;

	    logic [7:0] TEMP_1; // with parity
	    logic [9:0] TEMP_2; // without parity

	    logic [7:0] addr_temp;
	    logic [7:0] data_temp;

	    rand logic [7:0] f0, f1, f2, f3;
	    logic [7:0] f0_past=0, f1_past=0, f2_past=0, f3_past=0;

	    e_command_types past_cmd=Register_File_Write_command;
	    e_seq current_seq=frame0_s;

	    logic end_cmd=0,end_frame=0;

	    int counter1=10, counter2;

	    rand logic [10:0] GO_frame;
	    logic [10:0] GO_PAST={1'b1,1'b1,8'hCD,1'b0};
           e_frame0_type frame0_p=RF_Wr_CMD;
           e_frame1_type frame1_p=RF_Rd_Addr;
           e_frame2_type frame2_p=RF_Wr_Data;
           e_frame3_type frame3_p=ALU_FUN_f3;
	    rand e_command_types cmd_type;
	    rand e_frame0_type frame0;
	    rand e_frame1_type frame1;
	    rand e_frame2_type frame2;
	    rand e_frame3_type frame3;

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
           if(((counter2==1 && (cmd_type==ALU_Operation_command_with_No_operand || cmd_type==Register_File_Read_command))
                     || (counter2==2 && cmd_type==ALU_Operation_command_with_No_operand==Register_File_Write_command) || (counter2==3 && cmd_type==ALU_Operation_command_with_operand)) && counter1==10)
            	 counter2=0;
            else
               counter2=counter2+1;

            if(counter1==10)
        		counter1=0;
            else
                     counter1=counter1+1;
        
            // if(((frame0==RF_Wr_CMD && current_seq==frame2) ||(frame0==RF_Rd_CMD && current_seq==frame1_s) || 
        // 	  (frame0==ALU_OPER_W_OP_CMD && current_seq==frame3_s) || (frame3==ALU_FUN_f3 && current_seq==frame1_s)) && counter1==10)
        // 	   end_cmd=1;
        // 	else
            //    end_cmd=0;
           /////////////////////////////////////////////////
            // if(!rst_n)
            // 	end_frame=1;
           

        	
              // `uvm_info("g",$sformatf("counter=%0d, past_cmd=%0h, cmd=%0h,\n f0_past=%0h, f1_past=%0h, f2_past=%0h, f3_past=%0h, end_cmd=%0h, end_frame=%0h",counter1, past_cmd , cmd_type, f0_past, f1_past, f2_past, f3_past, end_cmd, end_frame),UVM_NONE);

              // `uvm_info("g",$sformatf("f0=%0h, f1=%0h, f2=%0h, f3=%0h \n current_seq=%0h, TEMP_1=%0b RX_IN=%0b",f0, f1, f2, f3, current_seq, TEMP_1, RX_IN),UVM_NONE);

              // `uvm_info("g",$sformatf("frame0=%0h, frame1=%0h, frame2=%0h, frame3=%0h",frame0, frame1, frame2, frame3),UVM_NONE);
        	
        	// `uvm_info("g",$sformatf("f0=%0h, f1=%0h, f2=%0h, f3=%0h \n current_seq=%0h, TEMP_1=%0b RX_IN=%0b",f0, f1, f2, f3, current_seq, TEMP_1, RX_IN),UVM_NONE);
        	
        	//////////////////////////////////////////////////////////
        	// if(!rst_n)
        	// 	end_cmd=1;
        		
     
        endfunction 

        function void post_randomize();
            
            if(((counter2==1 && (cmd_type==ALU_Operation_command_with_No_operand || cmd_type==Register_File_Read_command))
                     || (counter2==2 && cmd_type==ALU_Operation_command_with_No_operand==Register_File_Write_command) || (counter2==3 && cmd_type==ALU_Operation_command_with_operand)) && counter1==10)
            	  end_cmd=1;
            else
               end_cmd=0;

        	if(counter1==10)
        	   end_frame=1;
        	else 
        	   end_frame=0;        
            if(counter1==0) begin         	       		
        	    if((current_seq==0))
        	    	current_seq=current_seq.next();
        	    else if((current_seq==frame1_s) && ((cmd_type!=Register_File_Read_command) || (cmd_type!=ALU_Operation_command_with_No_operand)) && end_frame)
        	    	current_seq=current_seq.next();
        	    else if((current_seq==frame2_s) && (cmd_type!=Register_File_Write_command) && end_frame)
        	    	current_seq=current_seq.next();
        	    // else
        	    // 	current_seq=frame0_s;
        	    end
            past_cmd=cmd_type;
            GO_PAST=GO_frame;

            
            // if(counter2==3)
            // 	  counter2=0;
            // else
            //     counter2=counter2+1;
             

              frame0_p=frame0;
        	frame1_p=frame1;
        	frame2_p=frame2;
        	frame3_p=frame3;

        	
        	f0_past=f0;
        	f1_past=f1;
        	f2_past=f2;
        	f3_past=f3;

        	RX_IN=GO_frame[counter1];
           // `uvm_info("post",$sformatf("counter=%0d, past_cmd=%0h, cmd=%0h,\n f0_past=%0h, f1_past=%0h, f2_past=%0h, f3_past=%0h, end_cmd=%0h, end_frame=%0h",counter1, past_cmd , cmd_type, f0_past, f1_past, f2_past, f3_past, end_cmd, end_frame),UVM_NONE);
           //    `uvm_info("post",$sformatf("f0=%0h, f1=%0h, f2=%0h, f3=%0h \n current_seq=%0h, TEMP_1=%0b RX_IN=%0b",f0, f1, f2, f3, current_seq, TEMP_1, RX_IN),UVM_NONE);
           //    `uvm_info("post",$sformatf("frame0=%0h, frame1=%0h, frame2=%0h, frame3=%0h",frame0, frame1, frame2, frame3),UVM_NONE);
        endfunction
// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	    constraint C0_rst {
	    	rst_n == 1'b1;
	    }

	    constraint C1_CMD {
	    	if(!end_cmd)
	    	    cmd_type==past_cmd;	    	
	    }

	    constraint C2_frame0 {
	    	if(cmd_type==Register_File_Write_command && counter2==0)
	    		frame0==RF_Wr_CMD;
	    	else if(cmd_type==Register_File_Read_command && counter2==0)
	    		frame0==RF_Rd_CMD;
	    	else if(cmd_type==ALU_Operation_command_with_No_operand && counter2==0)
	    		frame0==ALU_OPER_W_NOP_CMD;
	    	else if(cmd_type==ALU_Operation_command_with_operand && counter2==0)
	    		frame0==ALU_OPER_W_OP_CMD;
	    	else
	    		frame0==frame0_p;
	    }

	    constraint C2_frame1 {
	    	if(cmd_type==Register_File_Write_command && counter2==0)
	    		frame1==RF_Wr_Addr;
	    	else if(cmd_type==Register_File_Read_command && counter2==0)
	    		frame1==RF_Rd_Addr;
	    	else if(cmd_type==ALU_Operation_command_with_No_operand && counter2==0)
	    		frame1==Operand_A;
	    	else if(cmd_type==ALU_Operation_command_with_operand && counter2==0)
	    		frame1==ALU_FUN_f1;
	    	else
	    		frame1==frame1_p;
	    }

	    constraint C2_frame2 {
	    	if(cmd_type==Register_File_Write_command && counter2==0)
	    		frame2==RF_Wr_Data;
	    	else if((cmd_type==Register_File_Read_command || cmd_type==ALU_Operation_command_with_No_operand) && counter2==0)
	    		frame2==NA_f2;
	    	else if(cmd_type==ALU_Operation_command_with_operand && counter2==0)
	    		frame2==Operand_B;
	    	else
	    		frame2==frame2_p;
	    }

	    constraint C2_frame3 {
	    	if(cmd_type==ALU_Operation_command_with_operand && counter2==0)
	    		frame3==ALU_FUN_f3;
		else
	    		frame3==NA_f3;
	    }
 
	    constraint c_frames {

	    	if(end_frame==1 && end_cmd==1){
	              f0 == int'(frame0);
                     if((cmd_type==Register_File_Read_command || cmd_type==ALU_Operation_command_with_No_operand))
                     	f2==8'b0;
                     if(!(cmd_type==ALU_Operation_command_with_operand))
                     	f3==8'h0;
 	       }
	       else{
	              f0==f0_past;
	              f1==f1_past;
	              f2==f2_past;
	              f3==f3_past;	    		  	  
	       }
	      
	    }

	    constraint GO {
	    	if(current_seq==frame0_s && end_frame)
           	GO_frame=={1'b1,^f0,f0,1'b0};

           else if(current_seq==frame1_s && end_frame)
           	GO_frame=={1'b1,^f1,f1,1'b0};

           else if(current_seq==frame2_s && end_frame)
           	GO_frame=={1'b1,^f2,f2,1'b0};

           else if(current_seq==frame3_s && end_frame)
           	GO_frame=={1'b1,^f3,f3,1'b0};

           else if(!end_frame)
           	GO_frame==GO_PAST;

           else
           	GO_frame=={1'b1,8'h1,1'b1,1'b1};
           // if(end_frame){
           // GO_frame[0]==1'b0;
           // GO_frame[10]==1'b1;
           // (GO_frame[9:1] == 8'hAA) || (GO_frame[9:1] == 8'hBB) || (GO_frame[9:1] == 8'hCC) || (GO_frame[9:1] == 8'hDD);
           // }
           // else
           	
	    }

	    // constraint In {
	    	
	    // }
	endclass : SYS_SEQ_ITEM_C
endpackage : SYS_SEQ_ITEM