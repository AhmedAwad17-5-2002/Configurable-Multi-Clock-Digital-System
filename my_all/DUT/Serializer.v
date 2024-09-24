module TX_Serializer #(parameter DATA_WIDTH=8 , COUNTER_WIDTH=$clog2(DATA_WIDTH)) (
	input clk,    // Clock
	input ARSTn,  // Asynchronous reset active low
	input [DATA_WIDTH-1:0] DATA,
	input ser_en,
	output ser_done,
	output wire ser_data	
);

reg [COUNTER_WIDTH-1:0] counter;

assign ser_done =(counter==3'b111)? 1: 0 ;
assign ser_data =DATA[counter];

always @(posedge clk or negedge ARSTn) begin 
	if(~ARSTn) begin
		// ser_data <= 0; 
		counter  <= 7; 
	end 
	else begin
		if(ser_en==1'b1) begin
			if(counter == 7) begin
			 // ser_data <= DATA[counter];
			 counter <=0;
			end
			else  begin
			 // ser_data <= DATA[counter];
			 counter <= counter+1;
			end
		end
		else begin
			counter  <= 7;
			// ser_data <= 0;
		end

	end
end


endmodule
