module TX_TOP #(parameter DATA_WIDTH=8) (
	input CLK,                      // Clock
	input RST,                      // Asynchronous reset active low
	input PAR_EN,
	input PAR_TYP,
	input [DATA_WIDTH-1:0] P_DATA,
	input DATA_VALID,

	// input   scan_clk,
	// input   scan_rst,
	// input   test_mode,
	// input   SE,
	// input   SI,

	// output  SO,

	output  S_DATA,
	output  BUSY
);
// reg S_DATA_t1;
// wire S_DATA_t1;
// wire BUSY_t;

wire [1:0] mux_sel; 
wire serial_done,serial_en,parity,data_s;
wire CLOCK,RESET;
wire [2:0] cs;

reg [DATA_WIDTH-1:0] TEMPO;

always@(posedge CLK, negedge RST) begin
    if(~RST) begin
    	TEMPO<=0;
    	// S_DATA<=1;
    end
      
    else begin
    	  // S_DATA_t2 <= S_DATA_t3;
    	  // S_DATA_t1 <= S_DATA_t2;
    	  // S_DATA <= S_DATA_t1;
        if(DATA_VALID && cs==0)
          TEMPO<=P_DATA;
        else
          TEMPO<=TEMPO;
    end
      
end

// mux clk_mux (.in0(CLK), .in1(scan_clk), .sel(test_mode), .out(CLOCK));
// mux rst_mux (.in0(RST), .in1(scan_rst), .sel(test_mode), .out(RESET));

TX_FSM V1 (.clk(CLK),.ARSTn(RST),.DATA_VALID(DATA_VALID),.PAR_EN(PAR_EN),.serial_done(serial_done),.mux_sel(mux_sel),.busy(BUSY),.serial_en(serial_en), .cs_out(cs));
TX_mux V2 (1'b1,1'b0,parity,data_s,mux_sel,S_DATA);
TX_PARITY V3(TEMPO,PAR_TYP,DATA_VALID,PAR_EN,parity);
TX_Serializer V4(CLK,RST,TEMPO,serial_en,serial_done,data_s);


// always @(posedge CLOCK or negedge RESET) begin
// 		S_DATA <= TX_TOP_t;
// 	end
endmodule 