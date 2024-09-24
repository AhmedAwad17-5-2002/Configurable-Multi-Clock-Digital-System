module FIFO_TOP #( 
 parameter DATA_WIDTH = 8,
           MEM_DEPTH  = 8,
           ADDR_WIDTH = $clog2(MEM_DEPTH),
           PTR_SIZE   = $clog2(MEM_DEPTH)+1  
) (
	input                         W_CLK,    // write_clock
	input                         W_RST,
	input                         W_INC,

	input                         R_CLK,    // read_clock
	input                         R_RST,   
	input                         R_INC,

	input      [DATA_WIDTH-1 : 0] WR_DATA,

	output                        FULL,
	output                        EMPTY,
	output     [DATA_WIDTH-1 : 0] RD_DATA
);

wire [PTR_SIZE-1 : 0]   R_PTR , W_PTR ,RQ2_W_PTR ,WQ2_R_PTR;

wire      [ADDR_WIDTH-1 : 0] W_ADDR;
wire      [ADDR_WIDTH-1 : 0] R_ADDR;


FIFO_RD M0 (.R_EN(R_INC),
            .R_RST_n(R_RST),
            .R_CLK(R_CLK),
            .RQ2_W_PTR(RQ2_W_PTR),
            .R_EMPTY(EMPTY),
            .R_PTR(R_PTR),
            .R_ADDR(R_ADDR));


SYNC M1_R (.CLK(W_CLK), // takes output from FIFO_RD
	       .IN (R_PTR),
	       .RST(W_RST),
	       .OUT(WQ2_R_PTR));

SYNC M2_W (.CLK(R_CLK),
	       .IN (W_PTR),
	       .RST(R_RST),
	       .OUT(RQ2_W_PTR));

FIFO_WR M3 (.W_CLK(W_CLK),
	        .W_PTR(W_PTR),
	        .W_EN(W_INC), 
	        .W_RST_n(W_RST),
	        .WQ2_R_PTR(WQ2_R_PTR),
	        .W_FULL(FULL),
	        .W_ADDR(W_ADDR));


FIFO_RAM M4 (.W_CLK(W_CLK),
	         .R_ADDR(R_ADDR),
	         .W_ADDR(W_ADDR), 
	         .W_RST_n(W_RST),
	         .W_CLK_EN((!FULL & W_INC)), 
	         .W_DATA(WR_DATA), 
	         .R_DATA(RD_DATA)); 


endmodule 