package SYS_COV_COLLECTOR;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import SYS_SEQ_ITEM::*;
	
	class SYS_COV_COLLECTOR_C extends uvm_component;
		`uvm_component_utils(SYS_COV_COLLECTOR_C);

		uvm_analysis_export #(SYS_SEQ_ITEM_C) COV_EXPORT;
		uvm_tlm_analysis_fifo #(SYS_SEQ_ITEM_C) COV_FIFO;
		SYS_SEQ_ITEM_C COV_SEQ_ITEM;

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        covergroup COV_GP;
        	CP_1 : coverpoint COV_SEQ_ITEM.RX_IN {
                bins A1[] = {[0:1]};
            }

            CP_2 : coverpoint COV_SEQ_ITEM.rst_n {
                bins B1[] = {[0:1]};
            }

            CP_3 : coverpoint COV_SEQ_ITEM.DIV_RATIO{
                bins C1[] = {8'h20 , 8'h10, 8'h08, 8'h04};
                bins C2= {8'h20 , 8'h10, 8'h08, 8'h04};
            }

            CP_4 : coverpoint COV_SEQ_ITEM.REGFILE_ADDRESS{
                bins D1[] = {[8'h00 : 8'h0F]};
            }

            CP_5 : coverpoint COV_SEQ_ITEM.current_frame{
                bins E1[] = {8'hAA, 8'hBB, 8'hCC, 8'hCC};
                bins E2 = {8'hAA, 8'hBB, 8'hCC, 8'hCC};
            }

            CP_6 : coverpoint COV_SEQ_ITEM.ALU_FUN{
                bins F1[] = {[0:15]};
                bins F2 = {[0:15]};
            }

            //////////////////////////

            cross1 : cross CP_3, CP_5
            {
                bins CRO_1 = binsof(CP_3.C2) && binsof(CP_5.E2);
                option.cross_auto_bin_max=0;  
            }

            cross2 : cross CP_3, CP_6
            {
                bins CRO_1 = binsof(CP_3.C2) && binsof(CP_6.F2);
                option.cross_auto_bin_max=0;  
            }
        endgroup : COV_GP

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        function new(string name="SYS_COV_COLLECTOR", uvm_component parent = null);
        	super.new(name,parent);
        	COV_GP=new();
        endfunction : new
        ////////////////////////////////////////////////////////////////////////////
        function void build_phase(uvm_phase phase);
        	super.build_phase(phase);
        	COV_EXPORT=new("COV_EXPORT",this);
        	COV_FIFO=new("COV_FIFO",this);
        endfunction : build_phase
        ////////////////////////////////////////////////////////////////////////////
        function void connect_phase(uvm_phase phase);
        	super.connect_phase(phase);
        	COV_EXPORT.connect(COV_FIFO.analysis_export);
        endfunction : connect_phase
        ////////////////////////////////////////////////////////////////////////////
        task run_phase(uvm_phase phase);
        	super.run_phase(phase);
        	forever begin
        		COV_FIFO.get(COV_SEQ_ITEM);
        		COV_GP.sample();
        	end
        endtask : run_phase
        ////////////////////////////////////////////////////////////////////////////
	endclass : SYS_COV_COLLECTOR_C
endpackage : SYS_COV_COLLECTOR