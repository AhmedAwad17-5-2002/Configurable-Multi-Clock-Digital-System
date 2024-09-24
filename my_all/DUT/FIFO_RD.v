module FIFO_RD #( 

 parameter MEM_DEPTH  = 8,
           PTR_SIZE   = $clog2(MEM_DEPTH)+1,
           ADDR_WIDTH = $clog2(MEM_DEPTH)
) (
    input                         R_EN,
    input                         R_RST_n,
    input                         R_CLK,
    input      [PTR_SIZE-1 : 0]   RQ2_W_PTR,

    output                        R_EMPTY,
    output reg [PTR_SIZE-1 : 0]   R_PTR,
    output     [ADDR_WIDTH-1 : 0] R_ADDR
);

reg [PTR_SIZE-1 : 0] R_PTR_TEMP;



assign R_ADDR  = R_PTR_TEMP [PTR_SIZE-2 : 0];
assign R_EMPTY = (R_PTR == RQ2_W_PTR)? 1 : 0;


always @(posedge R_CLK or negedge R_RST_n) begin 
	if(~R_RST_n) begin
		R_PTR_TEMP <= 0;
	end else if (~R_EMPTY && R_EN) begin
		R_PTR_TEMP <= R_PTR_TEMP+1;
	end
end


always @(*) begin
	if(~R_RST_n)
		R_PTR=0;
	else begin
        R_PTR={R_PTR_TEMP[3], R_PTR_TEMP[3]^R_PTR_TEMP[2], R_PTR_TEMP[2]^R_PTR_TEMP[1], R_PTR_TEMP[1]^R_PTR_TEMP[0]};
	end
	
end
endmodule 