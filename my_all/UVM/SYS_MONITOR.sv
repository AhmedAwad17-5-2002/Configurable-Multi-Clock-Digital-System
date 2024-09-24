    package SYS_MONITOR;
	typedef enum logic [1:0] {Register_File_Write_command,
	                          Register_File_Read_command,
	                          ALU_Operation_command_with_operand, 
	                          ALU_Operation_command_with_No_operand
	                          } e_command_types;
	import uvm_pkg::*;
    import SYS_SEQ_ITEM::*;
    `include "uvm_macros.svh"

    class SYS_MONITOR_C extends uvm_monitor;
    	`uvm_component_utils(SYS_MONITOR_C);
        uvm_analysis_port #(SYS_SEQ_ITEM_C) MON_PORT;
        SYS_SEQ_ITEM_C MON_SEQ_ITEM;
    	virtual SYS_IF MO_VIF;
    	

    	function new(string name = "SYS_MONITOR", uvm_component parent = null);
    		super.new(name, parent);
    	endfunction : new


    	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		MON_PORT=new("mon_ap",this);
    	endfunction : build_phase

    	task run_phase(uvm_phase phase);
    		super.run_phase(phase);
    		forever begin

    			MON_SEQ_ITEM = SYS_SEQ_ITEM_C :: type_id :: create("MON_SEQ_ITEM");

    			MON_SEQ_ITEM.rst_n = MO_VIF.rst_n;
				MON_SEQ_ITEM.RX_IN = MO_VIF.RX_IN;
				MON_SEQ_ITEM.DIV_RATIO=MO_VIF.DIV_RATIO;
				MON_SEQ_ITEM.ALU_FUN = MO_VIF.ALU_FUN;
				MON_SEQ_ITEM.REGFILE_ADDRESS = MO_VIF.REGFILE_ADDRESS;
				MON_SEQ_ITEM.TX_OUT = MO_VIF.TX_OUT;
				MON_SEQ_ITEM.RX_PAR_ERR = MO_VIF.RX_PAR_ERR;
				MON_SEQ_ITEM.RX_STP_ERR = MO_VIF.RX_STP_ERR;
				MON_SEQ_ITEM.past1_frame= MO_VIF.past1_GO;
                MON_SEQ_ITEM.past2_frame= MO_VIF.past2_GO;
                MON_SEQ_ITEM.past3_frame= MO_VIF.past3_GO;
                MON_SEQ_ITEM.past4_frame= MO_VIF.past4_GO;
                MON_SEQ_ITEM.past5_frame= MO_VIF.past5_GO;

                MON_SEQ_ITEM.past1_rst_n = MO_VIF.past1_rst_n;
                MON_SEQ_ITEM.past2_rst_n = MO_VIF.past2_rst_n;
                MON_SEQ_ITEM.past3_rst_n = MO_VIF.past3_rst_n;
                MON_SEQ_ITEM.past4_rst_n = MO_VIF.past4_rst_n;
                MON_SEQ_ITEM.past5_rst_n = MO_VIF.past5_rst_n;
                  
				MON_SEQ_ITEM.current_frame = MO_VIF.GO;
				MON_SEQ_ITEM.CMD=MO_VIF.CMD;
				MON_SEQ_ITEM.counter_bits=MO_VIF.counter1;
				MON_SEQ_ITEM.counter_frames=MO_VIF.counter2;
				MON_SEQ_ITEM.ref_mode=MO_VIF.ref_mode;

    			@(negedge MO_VIF.REF_CLK);

    			MON_SEQ_ITEM.reg_file=MO_VIF.RegFile;
    			MON_SEQ_ITEM.ALU_Result = MO_VIF.ALU_OUT_TEMP;
    			MON_SEQ_ITEM.reg_file_data_out=MO_VIF.REGFILE_RdData; 

    			MON_PORT.write(MON_SEQ_ITEM);
    		end
    	endtask : run_phase
    endclass : SYS_MONITOR_C
endpackage : SYS_MONITOR