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



////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

interface SYS_IF #(parameter DATA_WIDTH=8,
	                         RAM_ADDR_WIDTH=4,
	                         MEM_DEPTH  = 8,
                            FIFO_ADDR_WIDTH = $clog2(MEM_DEPTH),
                            PTR_SIZE   = $clog2(MEM_DEPTH)+1  
) (
	 input logic REF_CLK,    // Clock_1
	 input logic UART_CLK,   // Clock_2
	 input logic [7:0] DIV_RATIO,
	 input logic [5:0] prescale,
	 input logic [3:0] REGFILE_ADDRESS,
    input logic [3:0] ALU_FUN
);  
    ///////////reg_file////////////////
	 logic [RAM_ADDR_WIDTH-1 : 0] ADDRESS;
	 logic WrEn,RdEn;
	 logic [DATA_WIDTH-1 : 0] WrData;
    logic RdData_Valid;
	 logic [DATA_WIDTH-1 : 0] RdData;
	 logic [DATA_WIDTH-1 : 0] REG0;
	 logic [DATA_WIDTH-1 : 0] REG1;
	 logic [DATA_WIDTH-1 : 0] REG2;
	 logic [DATA_WIDTH-1 : 0] REG3;
	 logic  [7:0] RegFile [15:0] ;

	 //////////////////////////////////////////////FIFO//////////////////////////////////////////
    logic                         W_CLK;    // write_clock
	 logic                         W_RST;
	 logic                         W_INC;

	 logic                         R_CLK;    // read_clock
	 logic                         R_RST;   
	 logic                         R_INC;

	 logic      [DATA_WIDTH-1 : 0] WR_DATA;

	 logic                         FULL;
	 logic                         EMPTY;
	 logic      [DATA_WIDTH-1 : 0] RD_DATA;
    logic      [PTR_SIZE-1 : 0]   R_PTR , W_PTR ,RQ2_W_PTR ,WQ2_R_PTR;

    logic      [FIFO_ADDR_WIDTH-1 : 0] W_ADDR;
    logic      [FIFO_ADDR_WIDTH-1 : 0] R_ADDR;
    logic      [DATA_WIDTH-1 : 0] FIFO_RAM [MEM_DEPTH-1 : 0];
   ////////////////////////////////////////////////////////////////////////////////////////////



   //////////////////////////////////////////UART//////////////////////////////////////////////
    logic TX_clk;
	 logic RX_clk;    // Clock
	 logic TX_ARSTn; // Asynchronous reset active low
	 logic RX_ARSTn;
    //TX_PORTS
	 logic        TX_PAR_EN;
	 logic        TX_PAR_TYP;
	 logic  [DATA_WIDTH-1:0] TX_P_DATA;
	 logic        TXDATA_VALID;
	 logic       TX_S_DATA;
	 logic       TX_BUSY;
    //RX_PORTS
    logic   [5:0] RX_Prescale;
	 logic         RX_PAR_EN;
	 logic         RX_PAR_TYP;
	 logic  [DATA_WIDTH-1:0] RX_P_DATA;
	 logic        RX_DATA_VLD;
   /////////////////////////////////////////////////////////////////////////////////////////////


   ////////////////////////////////////// CTRL /////////////////////////////////////////////////

    logic [DATA_WIDTH-1:0]   REGFILE_RdData; //from_RegFile
    logic                    REGFILE_RdData_VLD; //from_RegFile
    logic [DATA_WIDTH*2-1:0] ALU_OUT; //from_ALU
    logic                    ALU_OUT_VLD; //from_ALU 
    logic [DATA_WIDTH-1:0]   RX_P_DATA_CTRL; //from_RX 
    logic                    RX_D_VLD; //from_RX
    logic                    FIFO_FULL; //from_FIFO

    logic                    ALU_EN; //to_ALU
    logic                    CLK_GATE_EN;  //to_CLK_GATE_ALU
    logic                    CLKDIV_EN; //Always = 1
    logic                    REGFILE_WrEn; //to_RegFile 
    logic                    REGFILE_RdEn; //to_RegFile 
    logic [3:0]              ALU_FUN_CTRL; //to_ALU 
    logic [RAM_ADDR_WIDTH-1:0]   REGFILE_ADDRESS_CTRL; //to_RegFile 
    logic [DATA_WIDTH-1:0]   REGFILE_WrData; //to_RegFile 
    logic [DATA_WIDTH-1:0]   FIFO_P_DATA; //to_FIFO 
    logic                    FIFO_WR_INC;  //to_FIFO 
    logic [3:0] cs,ns;

    logic [DATA_WIDTH-1 : 0] OP1_TEMP, OP2_TEMP;
    logic [RAM_ADDR_WIDTH-1 : 0] REGFILE_ADDR_TEMP;
    logic [2*DATA_WIDTH-1 : 0] ALU_OUT_TEMP;
    logic REGFILE_ADDR_TEMP_EN, ALU_OUT_TEMP_EN;
/////////////////////////////////////////////////////////////////////////////////////////////

	 logic rst_n;      // Asynchronous reset active low
	 logic RX_IN;

	 logic TX_OUT;
	 logic RX_PAR_ERR;
	 logic RX_STP_ERR;

	 logic TX_OUT_G;
	 logic RX_PAR_ERR_G;
	 logic RX_STP_ERR_G;

	 logic [1:0] CMD, PAST_CMD;
     integer counter1,counter2;
     logic [7:0] GO, past1_GO, past2_GO, past3_GO, past4_GO,past5_GO, REG_3_CONFIG, past_REG_3_CONFIG;
     logic  past1_rst_n, past2_rst_n, past3_rst_n, past4_rst_n, past5_rst_n;
     logic ref_mode;

     modport DUT (
     	input REF_CLK, UART_CLK, rst_n, RX_IN, prescale, DIV_RATIO, REGFILE_ADDRESS, ALU_FUN,
     	output TX_OUT, RX_PAR_ERR, RX_STP_ERR
     	);

     modport REG_FILE_asser (
        input REF_CLK, rst_n, ADDRESS, WrEn, RdEn, WrData, RegFile,
        output RdData_Valid, RdData, REG0, REG1, REG2, REG3
        );
     modport FIFO_assertions (
     	input  W_CLK, W_RST, W_INC, R_CLK, R_RST, R_INC, WR_DATA, R_PTR , W_PTR, RQ2_W_PTR ,WQ2_R_PTR, W_ADDR, R_ADDR, FIFO_RAM,
     	output FULL, EMPTY, RD_DATA
     	);

     modport UART_assertions (
      input  TX_clk, RX_clk, TX_ARSTn, RX_ARSTn, TX_PAR_EN, TX_PAR_TYP, TX_P_DATA, TXDATA_VALID, RX_Prescale, DIV_RATIO,
             RX_PAR_EN, RX_PAR_TYP, RX_IN,
      output RX_P_DATA, RX_DATA_VLD, RX_PAR_ERR, RX_STP_ERR, TX_S_DATA, TX_BUSY
     	);

     modport CTRL_assertions (
     	input  REF_CLK, rst_n, REGFILE_RdData, REGFILE_RdData_VLD, ALU_OUT, ALU_OUT_VLD, RX_P_DATA_CTRL, RX_D_VLD, FIFO_FULL, cs, ns, OP1_TEMP, OP2_TEMP,
     	       REGFILE_ADDR_TEMP, ALU_OUT_TEMP, REGFILE_ADDR_TEMP_EN, ALU_OUT_TEMP_EN,
     	output ALU_EN, CLK_GATE_EN, CLKDIV_EN, REGFILE_WrEn, REGFILE_RdEn, ALU_FUN_CTRL, REGFILE_ADDRESS_CTRL, REGFILE_WrData, FIFO_P_DATA, FIFO_WR_INC
     	);
     
endinterface : SYS_IF