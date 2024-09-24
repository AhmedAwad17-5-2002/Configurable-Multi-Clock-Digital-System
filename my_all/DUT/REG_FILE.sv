module REG_FILE #(parameter DATA_WIDTH=8,
	                        ADDR_WIDTH=4
)(
	input CLK,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [ADDR_WIDTH-1 : 0] ADDRESS,
	input WrEn,RdEn,
	input [DATA_WIDTH-1 : 0] WrData,
    
    output logic RdData_Valid,
	output logic [DATA_WIDTH-1 : 0] RdData,
	output logic [DATA_WIDTH-1 : 0] REG0,
	output logic [DATA_WIDTH-1 : 0] REG1,
	output logic [DATA_WIDTH-1 : 0] REG2,
	output logic [DATA_WIDTH-1 : 0] REG3
);

reg [7:0] RegFile [15:0];

always_ff @(posedge CLK or negedge rst_n) begin : proc_RegFile_Write
	if(~rst_n) begin
		RdData_Valid <= 0;
		for (int i = 0; i < 16; i++) begin
			if (i==2)
				RegFile[i]<=8'b100000_0_1;
			else if (i==3)
				RegFile[i]<=8'b00100000;
			else 
			    RegFile[i]<=i; 
		end
	end 
	else begin
		if (WrEn && !RdEn)
			RegFile[ADDRESS]<=WrData;

		if (RdEn && !WrEn) begin
			RdData_Valid<=1;
		    RdData = RegFile[ADDRESS];
		end
		else
			RdData_Valid<=0;

	end
end

always_comb begin  : proc_RegFile_Read


    REG0 = RegFile[0];
    REG1 = RegFile[1];
    REG2 = RegFile[2]; 
    REG3 = RegFile[3];
end

endmodule : REG_FILE