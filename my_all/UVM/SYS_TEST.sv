package SYS_TEST;
	// import ALL_PKG::*;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
    import SYS_CFG_OBJ::*;
	import SYS_SEQUENCE::*;
    import SYS_SEQ_ITEM::*;
    import SYS_ENV::*;
    import SYS_ENV_2::*;
    

	class SYS_TEST_C extends uvm_test;
		`uvm_component_utils(SYS_TEST_C);
		SYS_ENV_C MY_ENV1;
		SYS_ENV_2_C MY_ENV2;
		SYS_CFG_OBJ_C MY_CFG_OBJ;
		RST_SEQ MY_SEQUENCE_RST;
		SEQ_1 MY_SEQUENCE_1;
		SEQ_2 MY_SEQUENCE_2;


		virtual SYS_IF MY_VIF;

		function new(string name = "SYS_TEST", uvm_component parent= null);
			super.new(name,parent);
			`uvm_info("TEST","Inside the SYSTEM",UVM_HIGH);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			`uvm_info("b","Inside the SYSTEM",UVM_NONE);
			
			MY_ENV1 = SYS_ENV_C :: type_id :: create("SYS_ENV1",this);						
			MY_ENV2 = SYS_ENV_2_C :: type_id :: create("SYS_ENV2",this);
			MY_CFG_OBJ = SYS_CFG_OBJ_C :: type_id :: create("SYS_CFG_OBJ",this);
			MY_SEQUENCE_RST = RST_SEQ :: type_id :: create("MY_SEQUENCE_RST",this);
			MY_SEQUENCE_1 = SEQ_1 :: type_id :: create("MY_SEQUENCE_1",this);
			MY_SEQUENCE_2 = SEQ_2 :: type_id :: create("MY_SEQUENCE_2",this);
            `uvm_info("TEST","Inside the SYSTEM",UVM_NONE);
            if(!uvm_config_db#(virtual SYS_IF)::get(this,"","SYS_INTERFACE_1",MY_CFG_OBJ.SYS_VIF))
            `uvm_fatal("build_phase","fatal_error couldn't fined CFG");
            `uvm_info("TEST","Inside the SYSTEM",UVM_HIGH);
            uvm_config_db#(SYS_CFG_OBJ_C)::set(this,"*","CFG",MY_CFG_OBJ);
		endfunction : build_phase


	   task run_phase(uvm_phase phase);
	   	`uvm_info("TEST","Inside the SYSTEM",UVM_NONE);

            super.run_phase(phase);
           `uvm_info("TEST","Inside the SYSTEM",UVM_NONE);
            phase.raise_objection(this);           
              `uvm_info("TEST","Inside the SYSTEM1",UVM_NONE);
              MY_SEQUENCE_RST.start(MY_ENV1.MY_AGT.MY_SEQUENCER);
              MY_SEQUENCE_1.start(MY_ENV1.MY_AGT.MY_SEQUENCER);           
            phase.drop_objection(this);

            phase.raise_objection(this);            
             `uvm_info("TEST","Inside the SYSTEM2",UVM_NONE);
              MY_SEQUENCE_RST.start(MY_ENV2.MY_AGT.MY_SEQUENCER);
              MY_SEQUENCE_1.start(MY_ENV2.MY_AGT.MY_SEQUENCER); 
              MY_SEQUENCE_2.start(MY_ENV2.MY_AGT.MY_SEQUENCER);
            phase.drop_objection(this);
    endtask
	endclass : SYS_TEST_C
endpackage : SYS_TEST