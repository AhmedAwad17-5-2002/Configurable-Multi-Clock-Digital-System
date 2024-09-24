package SYS_SEQUENCE;
	//import ALL_PKG::*;
		`include "uvm_macros.svh"

	import uvm_pkg::*;
	import SYS_SEQ_ITEM::*;
	
	class RST_SEQ extends uvm_sequence #(SYS_SEQ_ITEM_C);
		`uvm_object_utils(RST_SEQ);
		SYS_SEQ_ITEM_C MY_Seq_item;

		function  new(string name="my_seq");
			super.new(name);
		endfunction : new

		task body();
			MY_Seq_item= SYS_SEQ_ITEM_C :: type_id :: create("seq_item0");
			
			start_item(MY_Seq_item);
			   MY_Seq_item.rst_n=0;
			   MY_Seq_item.RX_IN=1;
			   MY_Seq_item.ref_mode=1'b0;
			finish_item(MY_Seq_item);

		endtask : body
	endclass : RST_SEQ

///////////////////////////////////////////////////////////////////////////////////////////////////////////

	class SEQ_1 extends uvm_sequence #(SYS_SEQ_ITEM_C);
		`uvm_object_utils(SEQ_1);
		SYS_SEQ_ITEM_C MY_Seq_item;
        SYS_SEQ_ITEM_C PRE_MY_Seq_item;
        virtual SYS_IF seq_if;
		function  new(string name="my_seq");
			super.new(name);
		endfunction : new

		task body();
			MY_Seq_item= SYS_SEQ_ITEM_C :: type_id :: create("seq_item1");

			repeat(100000)begin
			start_item(MY_Seq_item);
			  MY_Seq_item.rst_cons.constraint_mode(1);
			   MY_Seq_item.rst2_cons.constraint_mode(0);
			   MY_Seq_item.rst3_cons.constraint_mode(0);
			   MY_Seq_item.CMD_cons.constraint_mode(1);
			   MY_Seq_item.frame_sent_cons.constraint_mode(1);
			   MY_Seq_item.RX_cons.constraint_mode(1);
			   MY_Seq_item.current_F.constraint_mode(0);
			   MY_Seq_item.c_fifo_full.constraint_mode(0);
			   MY_Seq_item.c_ALU_NO_OP.constraint_mode(0);
			   MY_Seq_item.c_ALU_OP.constraint_mode(0);
			   MY_Seq_item.ref_mode=1'b1;		   
			   assert(MY_Seq_item.randomize());			   
			finish_item(MY_Seq_item);
            end


		endtask : body
	endclass : SEQ_1		


class SEQ_2 extends uvm_sequence #(SYS_SEQ_ITEM_C);
		`uvm_object_utils(SEQ_2);
		SYS_SEQ_ITEM_C MY_Seq_item;
        SYS_SEQ_ITEM_C PRE_MY_Seq_item;
        virtual SYS_IF seq_if;
		function  new(string name="my_seq");
			super.new(name);
		endfunction : new

		task body();
			MY_Seq_item= SYS_SEQ_ITEM_C :: type_id :: create("seq_item1");
			repeat(100)begin
			start_item(MY_Seq_item);
			   MY_Seq_item.rst_cons.constraint_mode(0);
			   MY_Seq_item.rst2_cons.constraint_mode(1);
			   MY_Seq_item.rst3_cons.constraint_mode(0);
			   MY_Seq_item.CMD_cons.constraint_mode(0);
			   MY_Seq_item.frame_sent_cons.constraint_mode(0);
			   MY_Seq_item.RX_cons.constraint_mode(1);
			   MY_Seq_item.current_F.constraint_mode(1);
			   MY_Seq_item.c_fifo_full.constraint_mode(0);
			   MY_Seq_item.c_ALU_NO_OP.constraint_mode(0);
			   MY_Seq_item.c_ALU_OP.constraint_mode(0);	
			   MY_Seq_item.ref_mode=1'b0;		   				   
			   assert(MY_Seq_item.randomize());			   
			finish_item(MY_Seq_item);
		    end

			repeat(100)begin
			start_item(MY_Seq_item);
			   MY_Seq_item.rst_cons.constraint_mode(0);
			   MY_Seq_item.rst2_cons.constraint_mode(0);
			   MY_Seq_item.rst3_cons.constraint_mode(1);
			   MY_Seq_item.CMD_cons.constraint_mode(0);
			   MY_Seq_item.frame_sent_cons.constraint_mode(0);
			   MY_Seq_item.RX_cons.constraint_mode(1);
			   MY_Seq_item.current_F.constraint_mode(0);
			   MY_Seq_item.c_fifo_full.constraint_mode(1);
			   MY_Seq_item.c_ALU_NO_OP.constraint_mode(0);
			   MY_Seq_item.c_ALU_OP.constraint_mode(0);
			   MY_Seq_item.ref_mode=1'b0;			   				   
			   assert(MY_Seq_item.randomize());	 
			finish_item(MY_Seq_item);
		    end

		    repeat(100)begin
			start_item(MY_Seq_item);
			   MY_Seq_item.rst_cons.constraint_mode(0);
			   MY_Seq_item.rst2_cons.constraint_mode(0);
			   MY_Seq_item.rst3_cons.constraint_mode(1);
			   MY_Seq_item.CMD_cons.constraint_mode(0);
			   MY_Seq_item.frame_sent_cons.constraint_mode(0);
			   MY_Seq_item.RX_cons.constraint_mode(1);
			   MY_Seq_item.current_F.constraint_mode(0);
			   MY_Seq_item.c_fifo_full.constraint_mode(0);
			   MY_Seq_item.c_ALU_NO_OP.constraint_mode(1);
			   MY_Seq_item.c_ALU_OP.constraint_mode(0);
			   MY_Seq_item.ref_mode=1'b0;			   				   
			   assert(MY_Seq_item.randomize());	 
			finish_item(MY_Seq_item);
		    end

		    repeat(100)begin
			start_item(MY_Seq_item);
			   MY_Seq_item.rst_cons.constraint_mode(0);
			   MY_Seq_item.rst2_cons.constraint_mode(0);
			   MY_Seq_item.rst3_cons.constraint_mode(1);
			   MY_Seq_item.CMD_cons.constraint_mode(0);
			   MY_Seq_item.frame_sent_cons.constraint_mode(0);
			   MY_Seq_item.RX_cons.constraint_mode(1);
			   MY_Seq_item.current_F.constraint_mode(0);
			   MY_Seq_item.c_fifo_full.constraint_mode(0);
			   MY_Seq_item.c_ALU_NO_OP.constraint_mode(0);
			   MY_Seq_item.c_ALU_OP.constraint_mode(1);
			   MY_Seq_item.ref_mode=1'b0;			   				   
			   assert(MY_Seq_item.randomize());	 
			finish_item(MY_Seq_item);
		    end
     endtask : body
	endclass : SEQ_2
endpackage : SYS_SEQUENCE		