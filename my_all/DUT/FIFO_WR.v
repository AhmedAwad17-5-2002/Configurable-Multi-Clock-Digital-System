module FIFO_WR #( 

 parameter MEM_DEPTH  = 8,
           PTR_SIZE   = $clog2(MEM_DEPTH)+1,
           ADDR_WIDTH = $clog2(MEM_DEPTH)
) (
    input                          W_EN,
    input                          W_RST_n,
    input                          W_CLK,
    input       [PTR_SIZE-1 : 0]   WQ2_R_PTR,

    output reg                     W_FULL,
    output reg  [PTR_SIZE-1 : 0]   W_PTR,
    output reg  [ADDR_WIDTH-1 : 0] W_ADDR
);

reg [PTR_SIZE-1 : 0] W_PTR_TEMP;




always @(*) begin 
	if((W_PTR [PTR_SIZE-3:0] == WQ2_R_PTR [PTR_SIZE-3:0]) && (W_PTR[ADDR_WIDTH] != WQ2_R_PTR[ADDR_WIDTH]) && (W_PTR[ADDR_WIDTH-1] != WQ2_R_PTR[ADDR_WIDTH-1]) )
		W_FULL=1;
	else 
		W_FULL=0;

	W_ADDR  = W_PTR_TEMP [PTR_SIZE-2 : 0];
end

always @(posedge W_CLK or negedge W_RST_n) begin 
	if(~W_RST_n) begin
		W_PTR_TEMP <= 0;
	end else if (~W_FULL && W_EN) begin
		W_PTR_TEMP <= W_PTR_TEMP+1;
	end
end


always @(*) begin
        W_PTR={W_PTR_TEMP[3], W_PTR_TEMP[3]^W_PTR_TEMP[2], W_PTR_TEMP[2]^W_PTR_TEMP[1], W_PTR_TEMP[1]^W_PTR_TEMP[0]};
	end
	
endmodule 
