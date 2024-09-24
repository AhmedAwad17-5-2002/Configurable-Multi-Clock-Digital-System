module FIFO_RAM #( 
 parameter DATA_WIDTH = 8,
           MEM_DEPTH  = 8,
           ADDR_WIDTH = $clog2(MEM_DEPTH) 
) (
    input                         W_CLK,
    input                         W_CLK_EN,
    input                         W_RST_n,
    input      [DATA_WIDTH-1 : 0] W_DATA,
    input      [ADDR_WIDTH-1 : 0] W_ADDR,
    input      [ADDR_WIDTH-1 : 0] R_ADDR,

    output reg [DATA_WIDTH-1 : 0] R_DATA
);

reg [DATA_WIDTH-1 : 0] MEM [MEM_DEPTH-1 : 0];
reg [MEM_DEPTH-1 : 0] i;

always @(posedge W_CLK or negedge W_RST_n) begin : proc_Write
	if(~W_RST_n) begin
		for(i=0 ; i<MEM_DEPTH ; i=i+1)
		    MEM[i] <= 0;
	end else if(W_CLK_EN) begin
		    MEM[W_ADDR] <= W_DATA;
		    i=i+1;
	end
end

always @(*) begin : proc_read
	R_DATA = MEM[R_ADDR];
end

endmodule





// module FIFO_RAM_tb;

// // Parameters
// parameter DATA_WIDTH = 8;
// parameter MEM_DEPTH  = 64;
// parameter ADDR_WIDTH = $clog2(MEM_DEPTH);

// // Signals
// reg                      W_CLK;
// reg                      W_CLK_EN;
// reg                      W_RST_n;
// reg  [DATA_WIDTH-1 : 0]  W_DATA;
// reg  [ADDR_WIDTH-1 : 0]  W_ADDR;
// reg  [ADDR_WIDTH-1 : 0]  R_ADDR;
// wire [DATA_WIDTH-1 : 0]  R_DATA;

// // Instantiate the FIFO_RAM module
// FIFO_RAM #( 
//     .DATA_WIDTH(DATA_WIDTH),
//     .MEM_DEPTH(MEM_DEPTH),
//     .ADDR_WIDTH(ADDR_WIDTH)
// ) uut (
//     .W_CLK(W_CLK),
//     .W_CLK_EN(W_CLK_EN),
//     .W_RST_n(W_RST_n),
//     .W_DATA(W_DATA),
//     .W_ADDR(W_ADDR),
//     .R_ADDR(R_ADDR),
//     .R_DATA(R_DATA)
// );

// // Clock generation
// initial begin
//     W_CLK = 0;
//     forever #5 W_CLK = ~W_CLK; // 10ns period clock
// end

// // Test sequence
// initial begin
//     // Initialize inputs
//     W_RST_n = 0;
//     W_CLK_EN = 0;
//     W_DATA = 0;
//     W_ADDR = 0;
//     R_ADDR = 0;

//     // Apply reset
//     #10 W_RST_n = 1;

//     // Test write and read operations
//     #10 W_CLK_EN = 1; W_DATA = 8'hA5; W_ADDR = 0;
//     #10 W_CLK_EN = 1; W_DATA = 8'h5A; W_ADDR = 1;
//     #10 W_CLK_EN = 0;

//     // Read back values
//     #10 R_ADDR = 0;
//     #10 R_ADDR = 1;

//     // Finish simulation
//     #50 $stop;
// end

// endmodule
