package SYS_AGT;
	import uvm_pkg::*;
    import SYS_SEQ_ITEM::*;
    import SYS_MONITOR::*;
    import SYS_SEQUENCER::*;
    import SYS_DRIVER::*;
    import SYS_CFG_OBJ::*;
     
    `include "uvm_macros.svh"

    class SYS_AGENT_C extends uvm_agent;
    	`uvm_component_utils(SYS_AGENT_C);

    	uvm_analysis_port #(SYS_SEQ_ITEM_C) AGT_PORT;
    	SYS_MONITOR_C MY_MONITOR;
    	SYS_SEQUENCER_C MY_SEQUENCER;
    	SYS_DRIVER_C MY_DRIVER;
    	SYS_CFG_OBJ_C MY_CFG_OBJ;

    	function new (string name="SYS_AGENT",uvm_component parent=null);
  		    super.new(name, parent);
  	    endfunction 

  	    function void build_phase(uvm_phase phase);
  	    	super.build_phase(phase);

  	    	if (!uvm_config_db#(SYS_CFG_OBJ_C)::get(this,"","CFG", MY_CFG_OBJ))// uvm_report_fatal("build_phase", "unable to get the interface");
			`uvm_fatal("build_phase","unable to get the interface")
            AGT_PORT = new("AGENT_PORT", this);
  	    	MY_MONITOR = SYS_MONITOR_C :: type_id :: create ("MY_MONITOR",this);
  	    	MY_DRIVER = SYS_DRIVER_C :: type_id :: create("MY_DRIVER",this);
  	    	MY_SEQUENCER = SYS_SEQUENCER_C :: type_id :: create("MY_SEQUENCER",this);

  	    	
  	    endfunction : build_phase

  	    function void connect_phase(uvm_phase phase);

            if (MY_DRIVER == null || MY_MONITOR == null || MY_SEQUENCER == null || AGT_PORT == null)
                    `uvm_fatal("connect_phase", "One of the components is null")

  	    	MY_DRIVER.DR_VIF= MY_CFG_OBJ.SYS_VIF;
            `uvm_info("AGT","Inside1",UVM_NONE);
  	    	MY_DRIVER.seq_item_port.connect(MY_SEQUENCER.seq_item_export);
            `uvm_info("AGT","Inside2",UVM_NONE);
  	    	MY_MONITOR.MO_VIF= MY_CFG_OBJ.SYS_VIF;
            `uvm_info("AGT","Inside3",UVM_NONE);
  	    	MY_MONITOR.MON_PORT.connect(AGT_PORT);
            `uvm_info("AGT","Inside4",UVM_NONE);
  	    endfunction : connect_phase
    endclass : SYS_AGENT_C
endpackage : SYS_AGT