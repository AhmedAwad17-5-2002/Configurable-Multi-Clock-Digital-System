module UART_Assertions (SYS_IF.UART_assertions U_IF);

 //////////////////////////////////////// RX_ASSERTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////
	always_comb begin : proc_reset_RX
        if(!U_IF.RX_ARSTn)
            assert final((U_IF.RX_PAR_ERR===1'b0) && (U_IF.RX_STP_ERR===1'b0) && (U_IF.RX_P_DATA===8'b0)) else $display("ERROR_U1  %0t",$time);
    end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_1;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b1) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( U_IF.RX_P_DATA[0]==$past(U_IF.RX_IN, 304)) );  
    endproperty
    assert_prop1_U:assert property(prop_1) else $display("ERROR_U2 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_2;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b1) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( U_IF.RX_P_DATA[7]==$past(U_IF.RX_IN, 80)) );  
    endproperty
    assert_prop2_U:assert property(prop_2) else $display("ERROR_U3 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_3;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b1) && (U_IF.RX_PAR_TYP==1'b0) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( (^(U_IF.RX_P_DATA))==$past(U_IF.RX_IN, 48)) );  
    endproperty
    assert_prop3_U:assert property(prop_3) else $display("ERROR_U4 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_4;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b0) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( U_IF.RX_P_DATA[0]==$past(U_IF.RX_IN, 272)) );  
    endproperty
    assert_prop4_U:assert property(prop_4) else $display("ERROR_U5 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_5;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b0) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( U_IF.RX_P_DATA[7]==$past(U_IF.RX_IN, 48)) );  
    endproperty
    assert_prop5_U:assert property(prop_5) else $display("ERROR_U6 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_6;
        @(posedge U_IF.RX_clk) disable iff(!U_IF.RX_ARSTn) (($rose(U_IF.RX_DATA_VLD) && ((U_IF.RX_PAR_EN==$past(U_IF.RX_PAR_EN,32)) && (U_IF.RX_PAR_EN==1'b1) && (U_IF.RX_PAR_TYP==1'b1) && (U_IF.RX_PAR_TYP==$past(U_IF.RX_PAR_TYP,32)))) |-> ( (~^(U_IF.RX_P_DATA))==$past(U_IF.RX_IN, 48)) );  
    endproperty
    assert_prop6_U:assert property(prop_6) else $display("ERROR_U7 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
//////////////////////////////////////// TX_ASSERTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always_comb begin : proc_reset_TX
        if(!U_IF.TX_ARSTn)
            assert final((U_IF.TX_BUSY===1'b0) && (U_IF.TX_S_DATA===1'b1)) else $display("ERROR_U8  %0t",$time);
    end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_7;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> (U_IF.TX_S_DATA==1'b0) ); 
    endproperty
    assert_prop7_U:assert property(prop_7) else $display("ERROR_U8 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_8;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##1 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[0])) ); 
    endproperty
    assert_prop8_U:assert property(prop_8) else $display("ERROR_U9 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_9;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##2 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[1],2)) ); 
    endproperty
    assert_prop9_U:assert property(prop_9) else $display("ERROR_U10 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_10;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##3 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[2],3)) ); 
    endproperty
    assert_prop10_U:assert property(prop_10) else $display("ERROR_U11 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_11;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##4 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[3],4)) ); 
    endproperty
    assert_prop11_U:assert property(prop_11) else $display("ERROR_U12 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_12;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##5 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[4],5)) ); 
    endproperty
    assert_prop12_U:assert property(prop_12) else $display("ERROR_U13 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_13;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##6 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[5],6)) ); 
    endproperty
    assert_prop13_U:assert property(prop_13) else $display("ERROR_U14 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_14;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##7 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[6],7)) ); 
    endproperty
    assert_prop14_U:assert property(prop_14) else $display("ERROR_U15 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_15;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY))) |-> ##8 (U_IF.TX_S_DATA==$past(U_IF.TX_P_DATA[7],8)) ); 
    endproperty
    assert_prop15_U:assert property(prop_15) else $display("ERROR_U16 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_16;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY)) && (U_IF.TX_PAR_TYP==1'b0) && (U_IF.RX_PAR_EN==1'b1)) |-> ##9 (U_IF.TX_S_DATA==(^($past(U_IF.TX_P_DATA,9)))) ); 
    endproperty
    assert_prop16_U:assert property(prop_16) else $display("ERROR_U17 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_17;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY)) && (U_IF.TX_PAR_TYP==1'b1) && (U_IF.RX_PAR_EN==1'b1)) |-> ##9 (U_IF.TX_S_DATA==(~^($past(U_IF.TX_P_DATA,9)))) ); 
    endproperty
    assert_prop17_U:assert property(prop_17) else $display("ERROR_U18 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_18;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY)) && (U_IF.RX_PAR_EN==1'b0)) |-> ##9 (U_IF.TX_S_DATA==1'b1)); 
    endproperty
    assert_prop18_U:assert property(prop_18) else $display("ERROR_U19 %0t",$time);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_19;
        @(posedge U_IF.TX_clk) disable iff(!U_IF.TX_ARSTn) ( (U_IF.TXDATA_VALID==1'b1) && ((U_IF.TX_PAR_EN==$past(U_IF.TX_PAR_EN, U_IF.DIV_RATIO)) && (U_IF.TX_PAR_TYP==$past(U_IF.TX_PAR_TYP, U_IF.DIV_RATIO)) && ($rose(U_IF.TX_BUSY)) && (U_IF.RX_PAR_EN==1'b1)) |-> ##10 (U_IF.TX_S_DATA==1'b1)); 
    endproperty
    assert_prop19_U:assert property(prop_19) else $display("ERROR_U20 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    cvr_prop1_U:cover property(prop_1);
    cvr_prop2_U:cover property(prop_2);
    cvr_prop3_U:cover property(prop_3);
    cvr_prop4_U:cover property(prop_4);
    cvr_prop5_U:cover property(prop_5);
    cvr_prop6_U:cover property(prop_6);
    cvr_prop7_U:cover property(prop_7);
    cvr_prop8_U:cover property(prop_8);
    cvr_prop9_U:cover property(prop_9);
    cvr_prop10_U:cover property(prop_10);
    cvr_prop11_U:cover property(prop_11);
    cvr_prop12_U:cover property(prop_12);
    cvr_prop13_U:cover property(prop_13);
    cvr_prop14_U:cover property(prop_14);
    cvr_prop15_U:cover property(prop_15);
    cvr_prop16_U:cover property(prop_16);
    cvr_prop17_U:cover property(prop_17);
    cvr_prop18_U:cover property(prop_18);
    cvr_prop19_U:cover property(prop_19);
    
endmodule : UART_Assertions