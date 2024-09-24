module SYNC #( 
	parameter MEM_DEPTH  = 8,
              PTR_SIZE   = $clog2(MEM_DEPTH)+1
) (
   input                   CLK,
   input  [PTR_SIZE-1 : 0] IN,
   input                   RST,

   output [PTR_SIZE-1 : 0] OUT
);

reg [PTR_SIZE-1 : 0] T1;
reg [PTR_SIZE-1 : 0] T2;

assign OUT = T2;

always @(posedge CLK or negedge RST) begin
	if(~RST) begin
		T1 <= 0;
		T2 <= 0;
	end else begin
		T1 <= IN;
		T2 <= T1;
	end
end

endmodule 