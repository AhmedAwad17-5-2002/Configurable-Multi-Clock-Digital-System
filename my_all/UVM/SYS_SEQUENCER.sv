package SYS_SEQUENCER;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
    import SYS_SEQ_ITEM::*;

    class SYS_SEQUENCER_C extends uvm_sequencer #(SYS_SEQ_ITEM_C);
    	`uvm_component_utils(SYS_SEQUENCER_C);

    	function new(string name="SYS_SEQUENCER", uvm_component parent = null);
    		super.new(name, parent);
    	endfunction : new
    endclass : SYS_SEQUENCER_C
endpackage : SYS_SEQUENCER