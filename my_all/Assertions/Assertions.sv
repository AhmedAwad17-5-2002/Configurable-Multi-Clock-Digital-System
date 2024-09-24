module SYS_Assertions (SYS_IF.DUT A_IF);
	always_comb begin
        if(!A_IF.rst_n)
            assert final((A_IF.TX_OUT==1));
    end

    // property prop_1;
    //     @(posedge A_IF.REF_CLK) disable iff(!A_IF.rst_n) (A_IF.);  
    // endproperty
endmodule : SYS_Assertions