module REG_FILE_Asser (SYS_IF.REG_FILE_asser RF);
	always_comb begin : proc_reset
		if(!RF.rst_n)
			assert final ((RF.REG0==32'b0) && (RF.REG1==32'b1) && (RF.REG2==8'b100000_0_1) && (RF.REG3==8'd32)) else $display("ERROR_1  %0t",$time);
	end

	property prop_1;
        @(posedge RF.REF_CLK) disable iff(!RF.rst_n) ((RF.WrEn==1'b1 && RF.RdEn==1'b0) |=> (RF.RegFile[$past(RF.ADDRESS)]==$past(RF.WrData)));  
    endproperty
   assert_prop1_R:assert property(prop_1) else $display("ERROR_2  %0t",$time);

	property prop_2;
        @(posedge RF.REF_CLK) disable iff(!RF.rst_n) ((RF.WrEn==1'b0 && RF.RdEn==1'b1) |=> ((RF.RdData==RF.RegFile[$past(RF.ADDRESS)]) && (RF.RdData_Valid==1'b1)));  
    endproperty
   assert_prop2_R:assert property(prop_2) else $display("ERROR_3  %0t",$time);

    always_comb begin
		assert final ((RF.REG0===RF.RegFile[0]) && (RF.REG1===RF.RegFile[1]) && (RF.REG2===RF.RegFile[2]) && (RF.REG3===RF.RegFile[3])) else $display("ERROR_4  %0t",$time);
	end

cvr_prop1_R:cover property(prop_1);
cvr_prop2_R:cover property(prop_2);
endmodule : REG_FILE_Asser