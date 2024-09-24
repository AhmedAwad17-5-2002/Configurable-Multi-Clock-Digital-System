module SYS_TOP #(parameter ALU_OPERAND_WIDTH=8,
	                       ALU_FUNCT_WIDTH=4,
	                       DATA_SYNC_NUM_STAGES=2,
	                       DATA_SYNC_BUS_WIDTH=8,
	                       FIFO_DATA_WIDTH = 8,
                           FIFO_MEM_DEPTH  = 8,
                           REGFILE_DATA_WIDTH=8,
	                       REGFILE_ADDR_WIDTH=4,
	                       RST_SYNC_NUM_STAGES=2,
	                       UART_DATA_WIDTH=8
)(
  SYS_IF.DUT DUT_IF
);

logic [3:0] REGFILE_ADDRESS;
logic [ALU_FUNCT_WIDTH-1 : 0] ALU_FUN;
logic [REGFILE_DATA_WIDTH-1 : 0] REGFILE_WrData, REGFILE_RdData, REG0, REG1, REG2, REG3;
logic [2*ALU_OPERAND_WIDTH-1 :0] ALU_OUT;
logic [FIFO_DATA_WIDTH-1 : 0] FIFO_P_DATA,FIFO_RD_DATA, sync_bus;
logic [7:0] DIV_RX;
logic [UART_DATA_WIDTH-1 : 0] RX_P_DATA;


UART #(.DATA_WIDTH(UART_DATA_WIDTH)) U0 (
	.TX_clk(TX_clk), 
	.RX_clk(RX_clk),
	.TX_ARSTn(UART_SYNC_RST), 
	.RX_ARSTn(UART_SYNC_RST),
    .RX_P_DATA(RX_P_DATA), 
    .TX_PAR_EN(REG2[0]),
    .TX_PAR_TYP(REG2[1]), 
    .TX_P_DATA(FIFO_RD_DATA), 
    .TXDATA_VALID(~FIFO_EMPTY),
    .TX_S_DATA(DUT_IF.TX_OUT), 
    .TX_BUSY(TX_BUSY), 
    .RX_Prescale(REG2[7:2]), 
    .RX_PAR_EN(REG2[0]), 
    .RX_PAR_TYP(REG2[1]),
    .RX_IN(DUT_IF.RX_IN), 
    .RX_DATA_VLD(RX_DATA_VLD), 
    .RX_PAR_ERR(DUT_IF.RX_PAR_ERR), 
    .RX_STP_ERR(DUT_IF.RX_STP_ERR)
);



CLK_DIV U1_TX (
    .i_ref_clk(DUT_IF.UART_CLK), 
    .i_clk_en(1'b1), 
    .i_rst_n(DUT_IF.rst_n), 
    .i_div_ratio(REG3), 
    .o_div_clk(TX_clk)
);

CLK_DIV U2_RX (.i_ref_clk(DUT_IF.UART_CLK), 
    .i_clk_en(1'b1), 
    .i_rst_n(DUT_IF.rst_n), 
    .i_div_ratio(DIV_RX), 
    .o_div_clk(RX_clk)
);

DATA_SYNC #(.NUM_STAGES(DATA_SYNC_NUM_STAGES), .BUS_WIDTH(DATA_SYNC_BUS_WIDTH)) U3 (
    .rst_n(REF_SYNC_RST),
    .clk(DUT_IF.REF_CLK),
    .bus_enable(RX_DATA_VLD), 
    .Unsync_bus(RX_P_DATA), 
    .sync_bus(sync_bus), 
    .enable_pulse(enable_pulse)
);


SYS_CONTROL U4 (
    .rst_n(REF_SYNC_RST), 
    .CLK(DUT_IF.REF_CLK), 
    .REGFILE_RdData(REGFILE_RdData), 
    .REGFILE_RdData_VLD(REGFILE_RdData_VLD),      
    .ALU_OUT(ALU_OUT), 
    .ALU_OUT_VLD(ALU_OUT_VLD), 
    .RX_P_DATA(sync_bus),  
    .RX_D_VLD(enable_pulse),                  
    .FIFO_FULL(FIFO_FULL),
    .ALU_EN(ALU_EN), 
    .CLK_GATE_EN(CLK_GATE_EN), 
    .CLKDIV_EN(CLKDIV_EN),
    .REGFILE_WrEn(REGFILE_WrEn), 
    .REGFILE_RdEn(REGFILE_RdEn), 
    .ALU_FUN(ALU_FUN), 
    .REGFILE_ADDRESS(REGFILE_ADDRESS),
    .REGFILE_WrData(REGFILE_WrData), 
    .FIFO_P_DATA(FIFO_P_DATA), 
    .FIFO_WR_INC(FIFO_WR_INC)
);

REG_FILE U5 (
    .rst_n(REF_SYNC_RST), 
    .CLK(DUT_IF.REF_CLK), 
    .ADDRESS(REGFILE_ADDRESS), 
    .WrEn(REGFILE_WrEn), 
    .RdEn(REGFILE_RdEn),
    .WrData(REGFILE_WrData),
    .RdData_Valid(REGFILE_RdData_VLD),
    .RdData(REGFILE_RdData),
    .REG0(REG0),
    .REG1(REG1),
    .REG2(REG2),
    .REG3(REG3)
);

RST_SYNC #(.NUM_STAGES(RST_SYNC_NUM_STAGES)) U6 (
	.clk(DUT_IF.REF_CLK),
	.RST(DUT_IF.rst_n),
	.SYNC_RST(REF_SYNC_RST)
);

ALU U7 (
    .rst_n(REF_SYNC_RST), 
    .CLK(GATED_CLK), 
    .ALU_FUN(ALU_FUN), 
    .ALU_OUT(ALU_OUT), 
    .ENABLE(ALU_EN), 
    .A(REG0), 
    .B(REG1),
    .OUT_VALID(ALU_OUT_VLD)
);



CLK_GATE U8 (
    .CLK(DUT_IF.REF_CLK), 
    .CLK_EN(CLK_GATE_EN), 
    .GATED_CLK(GATED_CLK)
);

RST_SYNC #(.NUM_STAGES(RST_SYNC_NUM_STAGES)) U9 (
	.clk(DUT_IF.UART_CLK),
	.RST(DUT_IF.rst_n),
	.SYNC_RST(UART_SYNC_RST)
);

PULSE_GEN  U10 (
	.rst_n (UART_SYNC_RST),
	.clk   (TX_clk),
	.enable(TX_BUSY),
	.pulse (BUSY_PULSE)
);

FIFO_TOP #(.DATA_WIDTH(FIFO_DATA_WIDTH), .MEM_DEPTH(FIFO_MEM_DEPTH)) U11 (
	.W_CLK  (DUT_IF.REF_CLK),
	.W_RST  (REF_SYNC_RST),
	.W_INC  (FIFO_WR_INC),
	.R_CLK  (TX_clk),
	.R_RST  (UART_SYNC_RST),
	.R_INC  (BUSY_PULSE),
	.WR_DATA(FIFO_P_DATA),
	.FULL   (FIFO_FULL),
	.EMPTY  (FIFO_EMPTY),
	.RD_DATA(FIFO_RD_DATA)
);




///////////////////////////////////////////////////////////////////////////////////////////////////
always @(*)
  begin
	case(REG2[7:2]) 
	6'd32 :  DIV_RX = 8'd1 ;
	6'd16 :  DIV_RX = 8'd2 ;	
	6'd8  :  DIV_RX = 8'd4 ;	
	6'd4  :  DIV_RX = 8'd8 ;
	default   :  DIV_RX = 8'd1 ;					
	endcase
  end

endmodule : SYS_TOP