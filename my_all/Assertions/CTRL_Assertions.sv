`define CMD_WIDTH 8
typedef enum logic [`CMD_WIDTH-1 :0] {REGFILE_WRITE_CMD= 'hAA, 
                                      REGFILE_READ_CMD='hBB, 
                                      ALU_OPER_CMD= 'hCC, 
                                      ALU_NO_OPER_CMD='hDD} e_CMD;

module CTRL_Assertions (SYS_IF.CTRL_assertions C_IF);
    parameter IDEL=4'd0, 
              WRITE_ADDRESS=4'd1, 
              WRITE_DATA=4'd2, 
              READ_ADDRESS=4'd3, 
              GET_REGFILE_DATA=4'd4, 
              FIFO_STAGE_1ST_BYTE=4'd5, 
              FIFO_STAGE_2ND_BYTE=4'd6, 
              WRITE_OP_A=4'd7, 
              WRITE_OP_B=4'd8, 
              ALU_ENABLE_FUNC=4'd9, 
              GET_ALU_OUTPUT=4'd10,
              ADDR_WIDTH=4;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin : proc_reset_RX
        if(!C_IF.rst_n)
            assert final((C_IF.cs===IDEL) && (C_IF.ns===IDEL) && (C_IF.ALU_FUN_CTRL==='b0) && (C_IF.CLK_GATE_EN==='b0) &&
                         (C_IF.CLKDIV_EN==='b1)&&(C_IF.REGFILE_WrEn=='b0)&&(C_IF.REGFILE_RdEn==='b0) &&(C_IF.ALU_FUN_CTRL==='b0)
                         && (C_IF.REGFILE_ADDRESS_CTRL==='b0) && (C_IF.REGFILE_WrData==='b0) && (C_IF.FIFO_P_DATA==='b0) && 
                         (C_IF.FIFO_WR_INC==='b0) && (C_IF.REGFILE_ADDR_TEMP_EN==='b0) && (C_IF.ALU_OUT_TEMP_EN==='b0))
                          else $display("ERROR_C  %0t",$time);
    end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_1_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.RX_P_DATA_CTRL==REGFILE_WRITE_CMD) && (C_IF.cs==IDEL))
         |-> C_IF.ns==WRITE_ADDRESS );  
    endproperty
    assert_prop1_C:assert property(prop_1_C) else $display("ERROR_C1 %0t",$time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_2_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.RX_P_DATA_CTRL==REGFILE_READ_CMD) && (C_IF.cs==IDEL))
         |-> C_IF.ns==READ_ADDRESS );  
    endproperty
    assert_prop2_C:assert property(prop_2_C) else $display("ERROR_C2 %0t",$time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_3_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.RX_P_DATA_CTRL==ALU_OPER_CMD) && (C_IF.cs==IDEL))
         |-> C_IF.ns==WRITE_OP_A );  
    endproperty
    assert_prop3_C:assert property(prop_3_C) else $display("ERROR_C3 %0t",$time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_4_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.RX_P_DATA_CTRL==ALU_NO_OPER_CMD) && (C_IF.cs==IDEL))
         |-> C_IF.ns==ALU_ENABLE_FUNC );  
    endproperty
    assert_prop4_C:assert property(prop_4_C) else $display("ERROR_C4 %0t",$time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_5_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==WRITE_ADDRESS))
         |-> (C_IF.ns==WRITE_DATA && C_IF.REGFILE_ADDR_TEMP_EN==1'b1) );  
    endproperty
    assert_prop5_C:assert property(prop_5_C) else $display("ERROR_C5 %0t",$time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_6_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==WRITE_DATA))
         |-> (C_IF.ns==IDEL && C_IF.REGFILE_WrEn==1'b1 && C_IF.REGFILE_ADDRESS_CTRL==C_IF.REGFILE_ADDR_TEMP[3:0] && C_IF.REGFILE_WrData==C_IF.RX_P_DATA_CTRL));  
    endproperty
    assert_prop6_C:assert property(prop_6_C) else $display("ERROR_C6 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_7_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==READ_ADDRESS))
         |-> (C_IF.ns==GET_REGFILE_DATA && C_IF.REGFILE_RdEn==1'b1 && C_IF.REGFILE_ADDRESS_CTRL == C_IF.RX_P_DATA_CTRL[ADDR_WIDTH-1:0]));  
    endproperty
    assert_prop7_C:assert property(prop_7_C) else $display("ERROR_C7 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_8_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.REGFILE_RdData_VLD) && (C_IF.cs==GET_REGFILE_DATA) && (C_IF.FIFO_FULL==1'b0))
         |-> (C_IF.ns==IDEL && C_IF.FIFO_P_DATA==C_IF.REGFILE_RdData && C_IF.FIFO_WR_INC==1'b1));  
    endproperty
    assert_prop8_C:assert property(prop_8_C) else $display("ERROR_C8 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_9_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==WRITE_OP_A))
         |-> (C_IF.ns==WRITE_OP_B && C_IF.REGFILE_WrEn==1'b1 && C_IF.REGFILE_ADDRESS_CTRL==1'b0 && C_IF.REGFILE_WrData==C_IF.RX_P_DATA_CTRL));  
    endproperty
    assert_prop9_C:assert property(prop_9_C) else $display("ERROR_C9 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    property prop_10_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==WRITE_OP_B))
         |-> (C_IF.ns==ALU_ENABLE_FUNC  && C_IF.REGFILE_WrEn==1'b1 && C_IF.REGFILE_ADDRESS_CTRL==1'b1 && C_IF.REGFILE_WrData==C_IF.RX_P_DATA_CTRL));  
    endproperty
    assert_prop10_C:assert property(prop_10_C) else $display("ERROR_C10 %0t",$time);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

    property prop_11_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.RX_D_VLD) && (C_IF.cs==ALU_ENABLE_FUNC))
         |-> (C_IF.ns==GET_ALU_OUTPUT && C_IF.CLK_GATE_EN==1'b1 && C_IF.ALU_EN==1'b1 && C_IF.ALU_FUN_CTRL==C_IF.RX_P_DATA_CTRL[3:0]) );  
    endproperty
    assert_prop11_C:assert property(prop_11_C) else $display("ERROR_C11 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    property prop_12_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (($rose(C_IF.ALU_OUT_VLD) && (C_IF.cs==GET_ALU_OUTPUT))
         |-> (C_IF.ns==FIFO_STAGE_1ST_BYTE && C_IF.CLK_GATE_EN==1'b1 && C_IF.ALU_OUT_TEMP_EN==1'b1) );  
    endproperty
    assert_prop12_C:assert property(prop_12_C) else $display("ERROR_C12 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    property prop_13_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (((C_IF.cs==FIFO_STAGE_1ST_BYTE) && (!C_IF.FIFO_FULL))
         |-> (C_IF.ns==FIFO_STAGE_2ND_BYTE && C_IF.FIFO_WR_INC==1'b1 && C_IF.FIFO_P_DATA==C_IF.ALU_OUT_TEMP[7:0]));  
    endproperty
    assert_prop13_C:assert property(prop_13_C) else $display("ERROR_C13 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    property prop_14_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) (((C_IF.cs==FIFO_STAGE_2ND_BYTE) && (!C_IF.FIFO_FULL))
         |-> (C_IF.ns==IDEL && C_IF.FIFO_WR_INC==1'b1 && C_IF.FIFO_P_DATA==C_IF.ALU_OUT_TEMP[15:8]));  
    endproperty
    assert_prop14_C:assert property(prop_14_C) else $display("ERROR_C14 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    property prop_15_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) ((C_IF.ALU_OUT_TEMP_EN==1'b1)
         |=> (C_IF.ALU_OUT_TEMP == $past(C_IF.ALU_OUT)));  
    endproperty
    assert_prop15_C:assert property(prop_15_C) else $display("ERROR_C15 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    property prop_16_C;
        @(posedge C_IF.REF_CLK) disable iff(!C_IF.rst_n) ((C_IF.REGFILE_ADDR_TEMP_EN==1'b1)
         |=> (C_IF.REGFILE_ADDR_TEMP == $past(C_IF.RX_P_DATA_CTRL)));  
    endproperty
    assert_prop16_C:assert property(prop_16_C) else $display("ERROR_C16 %0t",$time);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

    cvr_prop1_C:cover property(prop_1_C);
    cvr_prop2_C:cover property(prop_2_C);
    cvr_prop3_C:cover property(prop_3_C);
    cvr_prop4_C:cover property(prop_4_C);
    cvr_prop5_C:cover property(prop_5_C);
    cvr_prop6_C:cover property(prop_6_C);
    cvr_prop7_C:cover property(prop_7_C);
    cvr_prop8_C:cover property(prop_8_C);
    cvr_prop9_C:cover property(prop_9_C);
    cvr_prop10_U:cover property(prop_10_C);
    cvr_prop11_C:cover property(prop_11_C);
    cvr_prop12_C:cover property(prop_12_C);
    cvr_prop13_C:cover property(prop_13_C);
    cvr_prop14_C:cover property(prop_14_C);
    cvr_prop15_C:cover property(prop_15_C);
    cvr_prop16_C:cover property(prop_16_C);
endmodule : CTRL_Assertions