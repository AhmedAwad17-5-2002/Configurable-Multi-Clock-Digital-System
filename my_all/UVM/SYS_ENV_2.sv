package SYS_ENV_2;
	
    import uvm_pkg::*;
    // import SYS_SCOREBOARD::*;
    import SYS_AGT::*;
    import SYS_COV_COLLECTOR::*;
    
`include "uvm_macros.svh"
    class SYS_ENV_2_C extends uvm_env;
    	`uvm_component_utils(SYS_ENV_2_C);

    	SYS_AGENT_C MY_AGT;
        SYS_COV_COLLECTOR_C MY_COV_COLLECTOR;
    	// SYS_SCOREBOARD_C MY_SB;
        // logic ref_model=0;

    	function new(string name = "SYS_ENV", uvm_component parent = null);
			super.new(name, parent);
		endfunction : new



		function void build_phase(uvm_phase phase);
           super.build_phase(phase);
           MY_AGT = SYS_AGENT_C :: type_id :: create("MY_AGT",this);
           // MY_SB = SYS_SCOREBOARD_C :: type_id :: create("MY_SB",this);
           // MY_SB.ref_model=ref_model;
           MY_COV_COLLECTOR = SYS_COV_COLLECTOR_C :: type_id :: create("MY_COV_COLLECTOR",this);
		endfunction : build_phase



		function void connect_phase(uvm_phase phase);
           // MY_AGT.AGT_PORT.connect(MY_SB.SB_EXPORT);
           MY_AGT.AGT_PORT.connect(MY_COV_COLLECTOR.COV_EXPORT);
		endfunction : connect_phase
    endclass : SYS_ENV_2_C
endpackage : SYS_ENV_2