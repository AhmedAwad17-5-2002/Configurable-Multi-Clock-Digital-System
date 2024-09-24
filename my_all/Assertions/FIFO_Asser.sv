module FIFO_ASSER (SYS_IF.FIFO_assertions F_IF);

	always_comb begin : proc_reset1
		if(!F_IF.W_RST)
			assert final (F_IF.W_PTR==0) else $display("ERROR_1  %0t",$time);
	end

    always_comb begin : proc_fifo_read
   	   assert final  ((F_IF.RD_DATA == F_IF.FIFO_RAM[F_IF.R_ADDR]));  
    end

	always_comb begin : proc_reset2
		if(!F_IF.R_RST)
			assert final (F_IF.R_PTR==0) else $display("ERROR_2  %0t",$time);
	end

   property prop_1;
        @(posedge F_IF.W_CLK) disable iff(!F_IF.W_RST) ((F_IF.W_INC==1'b1 && F_IF.FULL==1'b0) |=> (F_IF.FIFO_RAM[$past(F_IF.W_ADDR)] == $past(F_IF.WR_DATA)));  
    endproperty
   assert_prop1_F:assert property(prop_1) else $display("ERROR_3  %0t",$time);

   property prop_2;
        @(posedge F_IF.W_CLK) disable iff(!F_IF.W_RST) ((F_IF.W_INC==1'b1 && F_IF.FULL==1'b0) |=> (F_IF.W_PTR == $past(F_IF.W_PTR)+1'b1));  
    endproperty
   assert_prop2_F:assert property(prop_2) else $display("ERROR_4  %0t",$time);

   property prop_3;
        @(posedge F_IF.R_CLK) disable iff(!F_IF.R_RST) ((F_IF.R_INC==1'b1 && F_IF.EMPTY==1'b0) |=> (F_IF.R_PTR == $past(F_IF.R_PTR)+1'b1));  
    endproperty
   assert_prop3_F:assert property(prop_3) else $display("ERROR_4  %0t",$time);



cvr_prop1_F:cover property(prop_1);
cvr_prop2_F:cover property(prop_2);
cvr_prop3_F:cover property(prop_3);


endmodule : FIFO_ASSER