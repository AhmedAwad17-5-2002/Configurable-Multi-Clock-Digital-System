package SYS_DRIVER;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
    import SYS_SEQ_ITEM::*;


	class SYS_DRIVER_C extends uvm_driver #(SYS_SEQ_ITEM_C);
		`uvm_component_utils(SYS_DRIVER_C);

		virtual SYS_IF DR_VIF;
		SYS_SEQ_ITEM_C DR_SEQ_ITEM;

		function new(string name = "SYS_DRIVER", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new
        

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			DR_SEQ_ITEM = SYS_SEQ_ITEM_C :: type_id :: create("DR_SEQ_ITEM");
			forever begin
				
				seq_item_port.get_next_item(DR_SEQ_ITEM);								                                  				
           DR_VIF.rst_n = DR_SEQ_ITEM.rst_n;
           DR_VIF.past1_rst_n = DR_SEQ_ITEM.past1_rst_n;
           DR_VIF.past2_rst_n = DR_SEQ_ITEM.past2_rst_n;
           DR_VIF.past3_rst_n = DR_SEQ_ITEM.past3_rst_n;
           DR_VIF.past4_rst_n = DR_SEQ_ITEM.past4_rst_n;
           DR_VIF.past5_rst_n = DR_SEQ_ITEM.past5_rst_n;
				   DR_VIF.RX_IN = DR_SEQ_ITEM.RX_IN;
				   DR_VIF.CMD = DR_SEQ_ITEM.current_cmd;
				   DR_VIF.GO= DR_SEQ_ITEM.current_frame;
				   DR_VIF.past1_GO = DR_SEQ_ITEM.past1_frame;
				   DR_VIF.past2_GO = DR_SEQ_ITEM.past2_frame;
				   DR_VIF.past3_GO = DR_SEQ_ITEM.past3_frame;
				   DR_VIF.past4_GO = DR_SEQ_ITEM.past4_frame;
				   DR_VIF.past5_GO = DR_SEQ_ITEM.past5_frame;
				   DR_VIF.counter1 =DR_SEQ_ITEM.counter_bits;
				   DR_VIF.counter2= DR_SEQ_ITEM.counter_frames;
				   DR_VIF.PAST_CMD = DR_SEQ_ITEM.past_cmd;
				   DR_VIF.REG_3_CONFIG=DR_SEQ_ITEM.REG_3_CONFIG;
				   DR_VIF.past_REG_3_CONFIG=DR_SEQ_ITEM.past_REG_3_CONFIG;
				   DR_VIF.ref_mode=DR_SEQ_ITEM.ref_mode;

                   if(!DR_VIF.rst_n)     	
                   	 #(271*32);    	 
                   else 
                     #(271*(DR_VIF.prescale));  

                seq_item_port.item_done();

                `uvm_info("run_phase", DR_SEQ_ITEM.convert2string_stimulus(), UVM_HIGH)
			end
		endtask : run_phase
	endclass : SYS_DRIVER_C
endpackage : SYS_DRIVER