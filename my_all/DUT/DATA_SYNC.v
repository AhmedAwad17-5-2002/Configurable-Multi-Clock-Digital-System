module DATA_SYNC #(parameter NUM_STAGES=2,
	                         BUS_WIDTH=8
)(
	input clk,    // Clock
	input bus_enable, // bus Enable
	input rst_n,  // Asynchronous reset active low
	input [BUS_WIDTH-1:0] Unsync_bus,
	output  [BUS_WIDTH-1:0] sync_bus,
	output  enable_pulse	
);

wire [NUM_STAGES-1:0] stages_out;
wire [BUS_WIDTH-1:0] MUX_OUT;
wire pulse;

genvar i;
generate 
	for (i = 0; i < NUM_STAGES; i=i+1) begin
		if(i==0)
		    DFF U0 (.clk(clk), .rst_n(rst_n), .D(bus_enable), .Q(stages_out[i]));
		else 
			DFF U0 (.clk(clk), .rst_n(rst_n), .D(stages_out[i-1]), .Q(stages_out[i]));
	end
endgenerate

PULSE_GEN U1 (.clk(clk), .rst_n(rst_n), .enable(stages_out[NUM_STAGES-1]), .pulse(pulse));

DFF U2 (.clk(clk), .rst_n(rst_n), .D(pulse), .Q(enable_pulse));

DFF #(.BUS_WIDTH(BUS_WIDTH)) U3 (.clk(clk), .rst_n(rst_n), .D(MUX_OUT), .Q(sync_bus));

assign MUX_OUT=(pulse)? Unsync_bus : sync_bus;
endmodule

