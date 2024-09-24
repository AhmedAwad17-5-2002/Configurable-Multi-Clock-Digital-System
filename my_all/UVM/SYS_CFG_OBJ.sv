package SYS_CFG_OBJ;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	
	class SYS_CFG_OBJ_C extends uvm_object;
		`uvm_object_utils(SYS_CFG_OBJ_C);
        virtual SYS_IF SYS_VIF;
		function new(string name = "SYS_CFG_OBJ");
			super.new(name);
		endfunction : new
	endclass : SYS_CFG_OBJ_C
endpackage : SYS_CFG_OBJ