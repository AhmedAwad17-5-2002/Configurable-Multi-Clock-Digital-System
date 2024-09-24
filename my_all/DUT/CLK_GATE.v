module CLK_GATE (
	input  CLK,           // Clock
	input  CLK_EN,        // Clock Enable	
	output reg GATED_CLK
);
reg en_latch;

always @(*) begin
    if(~CLK) begin
		en_latch <= CLK_EN;
	end
end

always @(*) begin 
	GATED_CLK = CLK & en_latch;
end

// TLATNCAX12M U0_TLATNCAX12M (
// .E(CLK_EN),
// .CK(CLK),
// .ECK(GATED_CLK)
// );
endmodule
