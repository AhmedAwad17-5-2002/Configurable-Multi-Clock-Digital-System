`timescale 1ns/1ns
`define state_width 4
typedef enum logic [`state_width-1:0] {IDEL=0, 
                          WRITE_ADDRESS, 
                          WRITE_DATA, 
                          READ_ADDRESS, 
                          GET_REGFILE_DATA, 
                          FIFO_STAGE_1ST_BYTE, 
                          FIFO_STAGE_2ND_BYTE, 
                          WRITE_OP_A, 
                          WRITE_OP_B, 
                          ALU_ENABLE_FUNC, 
                          GET_ALU_OUTPUT} e_states_2;
module SYS_UVM_TOP ();
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import SYS_TEST::*;
	parameter REF_CLK_PERIOD = 20,
              UART_CLK_PERIOD = 271;

	bit REF_CLK;
    bit UART_CLK;
    wire [2:0] cs_RX;
    wire RX_RX_IN;
    wire [5:0] prescale;
    wire [3:0] bit_cnt;
    wire [2:0] edge_cnt;
    wire [7:0] my_mem [15:0];
    wire [7:0] DIV_ratio;

        assign MY_IF.ADDRESS      = DUT_M.U5.ADDRESS;
        assign MY_IF.WrEn         = DUT_M.U5.WrEn;
        assign MY_IF.RdEn         = DUT_M.U5.RdEn;
        assign MY_IF.WrData       = DUT_M.U5.WrData;
        assign MY_IF.RdData_Valid = DUT_M.U5.RdData_Valid;
        assign MY_IF.RdData       = DUT_M.U5.RdData;
        assign MY_IF.REG0         = DUT_M.U5.REG0;
        assign MY_IF.REG1         = DUT_M.U5.REG1;
        assign MY_IF.REG2         = DUT_M.U5.REG2;
        assign MY_IF.REG3         = DUT_M.U5.REG3;
        assign MY_IF.RegFile      = DUT_M.U5.RegFile;

//////////////////////////////////////////////////////////////
     assign MY_IF.W_CLK = DUT_M.U11.W_CLK;    // write_clock
     assign MY_IF.W_RST = DUT_M.U11.W_RST;
     assign MY_IF.W_INC = DUT_M.U11.W_INC;

     assign MY_IF.R_CLK = DUT_M.U11.R_CLK;    // read_clock
     assign MY_IF.R_RST = DUT_M.U11.R_RST;   
     assign MY_IF.R_INC = DUT_M.U11.R_INC;

     assign MY_IF.WR_DATA = DUT_M.U11.WR_DATA;

     assign MY_IF.FULL = DUT_M.U11.FULL;
     assign MY_IF.EMPTY = DUT_M.U11.EMPTY;
     assign MY_IF.RD_DATA = DUT_M.U11.RD_DATA;
     assign MY_IF.R_PTR = DUT_M.U11.M0.R_PTR_TEMP;
     assign MY_IF.W_PTR = DUT_M.U11.M3.W_PTR_TEMP;
     assign MY_IF.RQ2_W_PTR = DUT_M.U11.RQ2_W_PTR;
     assign MY_IF.WQ2_R_PTR = DUT_M.U11.WQ2_R_PTR;

     assign MY_IF.W_ADDR = DUT_M.U11.W_ADDR;
     assign MY_IF.R_ADDR = DUT_M.U11.R_ADDR;
     assign MY_IF.FIFO_RAM = DUT_M.U11.M4.MEM;
////////////////////////////////////////////////////////////////

     assign MY_IF.TX_clk=DUT_M.U0.TX_clk;
     assign MY_IF.RX_clk=DUT_M.U0.RX_clk;    // Clock
     assign MY_IF.TX_ARSTn=DUT_M.U0.TX_ARSTn; // Asynchronous reset active low
     assign MY_IF.RX_ARSTn=DUT_M.U0.RX_ARSTn;
    //TX_PORTS
     assign MY_IF.TX_PAR_EN=DUT_M.U0.TX_PAR_EN;
     assign MY_IF.TX_PAR_TYP=DUT_M.U0.TX_PAR_TYP;
     assign MY_IF.TX_P_DATA=DUT_M.U0.TX_P_DATA;
     assign MY_IF.TXDATA_VALID=DUT_M.U0.TXDATA_VALID;
     assign MY_IF.TX_S_DATA=DUT_M.U0.TX_S_DATA;
     assign MY_IF.TX_BUSY=DUT_M.U0.TX_BUSY;
    //RX_PORTS
     assign MY_IF.RX_Prescale=DUT_M.U0.RX_Prescale;
     assign MY_IF.RX_PAR_EN=DUT_M.U0.RX_PAR_EN;
     assign MY_IF.RX_PAR_TYP=DUT_M.U0.RX_PAR_TYP;
     assign MY_IF.RX_P_DATA=DUT_M.U0.RX_P_DATA;
     assign MY_IF.RX_DATA_VLD=DUT_M.U0.RX_DATA_VLD;


   /////////////////////////////////////////////////////////////////


    assign MY_IF.REGFILE_RdData=DUT_M.U4.REGFILE_RdData;
    assign MY_IF.REGFILE_RdData_VLD=DUT_M.U4.REGFILE_RdData_VLD;
    assign MY_IF.ALU_OUT=DUT_M.U4.ALU_OUT;
    assign MY_IF.ALU_OUT_VLD=DUT_M.U4.ALU_OUT_VLD;
    assign MY_IF.RX_P_DATA_CTRL=DUT_M.U4.RX_P_DATA;
    assign MY_IF.RX_D_VLD=DUT_M.U4.RX_D_VLD;
    assign MY_IF.FIFO_FULL=DUT_M.U4.FIFO_FULL;
    assign MY_IF.ALU_EN=DUT_M.U4.ALU_EN;
    assign MY_IF.CLK_GATE_EN=DUT_M.U4.CLK_GATE_EN;
    assign MY_IF.CLKDIV_EN=DUT_M.U4.CLKDIV_EN;
    assign MY_IF.REGFILE_WrEn=DUT_M.U4.REGFILE_WrEn;
    assign MY_IF.REGFILE_RdEn=DUT_M.U4.REGFILE_RdEn;
    assign MY_IF.ALU_FUN_CTRL=DUT_M.U4.ALU_FUN;
    assign MY_IF.REGFILE_ADDRESS_CTRL=DUT_M.U4.REGFILE_ADDRESS;
    assign MY_IF.REGFILE_WrData=DUT_M.U4.REGFILE_WrData;
    assign MY_IF.FIFO_P_DATA=DUT_M.U4.FIFO_P_DATA;
    assign MY_IF.FIFO_WR_INC=DUT_M.U4.FIFO_WR_INC;
    assign MY_IF.cs=DUT_M.U4.cs;
    assign MY_IF.ns=DUT_M.U4.ns;
    assign MY_IF.OP1_TEMP=DUT_M.U4.OP1_TEMP;
    assign MY_IF.OP2_TEMP=DUT_M.U4.OP2_TEMP;
    assign MY_IF.REGFILE_ADDR_TEMP=DUT_M.U4.REGFILE_ADDR_TEMP;
    assign MY_IF.ALU_OUT_TEMP=DUT_M.U4.ALU_OUT_TEMP;
    assign MY_IF.REGFILE_ADDR_TEMP_EN=DUT_M.U4.REGFILE_ADDR_TEMP_EN;
    assign MY_IF.ALU_OUT_TEMP_EN=DUT_M.U4.ALU_OUT_TEMP_EN;

    //////////////////////////////////////////////////////////////////

    always #(UART_CLK_PERIOD/2) UART_CLK=~UART_CLK;
    always #(REF_CLK_PERIOD/2)  REF_CLK=~REF_CLK;

    SYS_IF MY_IF (
        .REF_CLK(REF_CLK),
        .UART_CLK(UART_CLK),
        .prescale(DUT_M.U0.RX.Prescale),
        .DIV_RATIO(DUT_M.REG3), 
        .REGFILE_ADDRESS(DUT_M.REGFILE_ADDRESS), 
        .ALU_FUN (DUT_M.ALU_FUN)
        );


    
    SYS_TOP DUT_M (MY_IF);

    assign cs_RX=DUT_M.U0.RX.M3.cs;
    assign RX_RX_IN=DUT_M.U0.RX.RX_IN;
    assign prescale=DUT_M.U0.RX.Prescale;
    assign bit_cnt=DUT_M.U0.RX.bit_cnt;
    assign edge_cnt=DUT_M.U0.TX.V4.counter;
    assign S_BIT = DUT_M.U0.RX.sampled_bit;
    assign my_mem = DUT_M.U5.RegFile;
    assign DIV_ratio = DUT_M.REG3;
   
    bind SYS_TOP SYS_Assertions ASSERTIONS (MY_IF.DUT);
    bind REG_FILE REG_FILE_Asser RF_Asser (MY_IF.REG_FILE_asser);
    bind FIFO_TOP FIFO_ASSER Fifo_ASSER (MY_IF.FIFO_assertions);
    bind UART UART_Assertions UART_ASSERTIONS (MY_IF.UART_assertions);
    bind SYS_CONTROL CTRL_Assertions CTRL_Asser (MY_IF.CTRL_assertions);

    initial begin
    	uvm_config_db #(virtual SYS_IF)::set(null,"*","SYS_INTERFACE_1",MY_IF);
        run_test("SYS_TEST_C");
    end
endmodule : SYS_UVM_TOP
