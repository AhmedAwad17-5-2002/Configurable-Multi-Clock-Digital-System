package SYS_SCOREBOARD;
	import uvm_pkg::*;
    import SYS_SEQ_ITEM::*;
	import "DPI-C" function int transaction_golden_result (input int rst_n, input int current_frame, input int past_1_frame,
                                                           input int past_2_frame, input int past_3_frame, input int past_4_frame,
                                                           input int past_5_frame, input int CMD, input int bit_counter, 
                                                           input int frame_counter); 
    `include "uvm_macros.svh"

    class SYS_SCOREBOARD_C extends uvm_scoreboard;
    	`uvm_component_utils(SYS_SCOREBOARD_C);

    	SYS_SEQ_ITEM_C SB_SEQ_ITEM;
        uvm_analysis_export #(SYS_SEQ_ITEM_C) SB_EXPORT;
        uvm_tlm_analysis_fifo #(SYS_SEQ_ITEM_C) SB_FIFO;

        int correct, error;
        logic [15:0] REF_Result=0;
        int prev_RAM [15:0];

        function new(string name = "SYS_SB", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new



		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			SB_FIFO=new("sb_fifo", this);
			SB_EXPORT=new("sb_export", this);
		endfunction : build_phase



		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			SB_EXPORT.connect(SB_FIFO.analysis_export);
		endfunction : connect_phase



		task run_phase(uvm_phase phase);
			super.run_phase(phase);
           
			forever begin
				SB_FIFO.get(SB_SEQ_ITEM);
			    
				if(SB_SEQ_ITEM.rst_n==1 && SB_SEQ_ITEM.ref_mode==1) begin

   						if(SB_SEQ_ITEM.past5_frame==8'hAA)begin
   							if(SB_SEQ_ITEM.counter_frames==1 && SB_SEQ_ITEM.counter_bits==1) begin
						        REF_Result=transaction_golden_result(SB_SEQ_ITEM.rst_n, SB_SEQ_ITEM.current_frame, SB_SEQ_ITEM.past1_frame,
						          SB_SEQ_ITEM.past2_frame, SB_SEQ_ITEM.past3_frame, SB_SEQ_ITEM.past4_frame, SB_SEQ_ITEM.past5_frame, 
						           SB_SEQ_ITEM.CMD, SB_SEQ_ITEM.counter_bits, SB_SEQ_ITEM.counter_frames);
                            CHK(REF_Result, SB_SEQ_ITEM.reg_file[SB_SEQ_ITEM.past4_frame]);
                            // `uvm_info("report_phase",$sformatf(" REF = %0h  DUT1 = %0h", REF_Result,SB_SEQ_ITEM.reg_file[SB_SEQ_ITEM.past4_frame]), UVM_NONE)
                        end
                        end
                        else if(SB_SEQ_ITEM.past5_frame==8'hBB)begin
                        	if(SB_SEQ_ITEM.counter_frames==1 && SB_SEQ_ITEM.counter_bits==1) begin
						        REF_Result=transaction_golden_result(SB_SEQ_ITEM.rst_n, SB_SEQ_ITEM.current_frame, SB_SEQ_ITEM.past1_frame,
						          SB_SEQ_ITEM.past2_frame, SB_SEQ_ITEM.past3_frame, SB_SEQ_ITEM.past4_frame, SB_SEQ_ITEM.past5_frame, 
						           SB_SEQ_ITEM.CMD, SB_SEQ_ITEM.counter_bits, SB_SEQ_ITEM.counter_frames);
                        	CHK(REF_Result, SB_SEQ_ITEM.reg_file_data_out);
                            // `uvm_info("report_phase",$sformatf(" REF = %0h  DUT2 = %0h", REF_Result,SB_SEQ_ITEM.reg_file_data_out), UVM_NONE)
                        end
                        end
                        else if(SB_SEQ_ITEM.past5_frame==8'hCC)begin
                        	if(SB_SEQ_ITEM.counter_frames==1 && SB_SEQ_ITEM.counter_bits==1) begin
						        REF_Result=transaction_golden_result(SB_SEQ_ITEM.rst_n, SB_SEQ_ITEM.current_frame, SB_SEQ_ITEM.past1_frame,
						          SB_SEQ_ITEM.past2_frame, SB_SEQ_ITEM.past3_frame, SB_SEQ_ITEM.past4_frame, SB_SEQ_ITEM.past5_frame, 
						           SB_SEQ_ITEM.CMD, SB_SEQ_ITEM.counter_bits, SB_SEQ_ITEM.counter_frames);
                        	CHK(REF_Result, SB_SEQ_ITEM.ALU_Result);
                            // `uvm_info("report_phase",$sformatf(" REF = %0h  DUT3 = %0h", REF_Result,SB_SEQ_ITEM.ALU_Result), UVM_NONE)
                        end
                        end

                        else if(SB_SEQ_ITEM.past5_frame==8'hDD)begin
                        	if(SB_SEQ_ITEM.counter_frames==1 && SB_SEQ_ITEM.counter_bits==1) begin
						        REF_Result=transaction_golden_result(SB_SEQ_ITEM.rst_n, SB_SEQ_ITEM.current_frame, SB_SEQ_ITEM.past1_frame,
						          SB_SEQ_ITEM.past2_frame, SB_SEQ_ITEM.past3_frame, SB_SEQ_ITEM.past4_frame, SB_SEQ_ITEM.past5_frame, 
						           SB_SEQ_ITEM.CMD, SB_SEQ_ITEM.counter_bits, SB_SEQ_ITEM.counter_frames);
                        	CHK(REF_Result, SB_SEQ_ITEM.ALU_Result);
                            // `uvm_info("report_phase",$sformatf(" REF = %0h  DUT4 = %0h", REF_Result,SB_SEQ_ITEM.ALU_Result), UVM_NONE)
                        end
                        end                    				
				end
			end
		endtask : run_phase



		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf(" \nCORRECT = %0d \nERROR = %0d", correct,error), UVM_NONE)
		endfunction : report_phase



		task CHK(input int result1=0, input int result2=0);
			if(result1===result2)begin
				correct++;
				// $display("time=%0t",$time());
			end
				
			else begin
				error++;
				$display("time=%0t",$time());
			end
		endtask : CHK
    endclass : SYS_SCOREBOARD_C
endpackage : SYS_SCOREBOARD
