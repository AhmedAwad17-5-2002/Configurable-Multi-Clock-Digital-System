module ALU #(parameter OPERAND_WIDTH=8,
	                   FUNCT_WIDTH=4
)(
	input  wire                        CLK,    // Clock
	input  wire                        rst_n,
	input  wire                        ENABLE,
    input  wire   [OPERAND_WIDTH-1:0]  A,
    input  wire   [OPERAND_WIDTH-1:0]  B,
    input  wire   [FUNCT_WIDTH-1:0]    ALU_FUN,


    output reg    [2*OPERAND_WIDTH-1:0]  ALU_OUT,
    output reg                           OUT_VALID	
);

reg    [2*OPERAND_WIDTH-1:0]  ALU_OUT_TEMP;
reg    OUT_VALID_TEMP;



always@(*)begin
    ALU_OUT_TEMP=0;
	if(ENABLE) begin
	  OUT_VALID_TEMP=1;
	  case (ALU_FUN)
	    4'b0000 : ALU_OUT_TEMP=A+B;
	    4'b0001 : ALU_OUT_TEMP=A-B;
	    4'b0010 : ALU_OUT_TEMP=A*B;
	    4'b0011 : ALU_OUT_TEMP=A/B;


//*********************************************************

	    4'b0100 : ALU_OUT_TEMP=  A & B;
	    4'b0101 : ALU_OUT_TEMP=  A | B;
	    4'b0110 : ALU_OUT_TEMP=~(A & B);
	    4'b0111 : ALU_OUT_TEMP=~(A | B);
	    4'b1000 : ALU_OUT_TEMP= A ^ B;
	    4'b1001 : ALU_OUT_TEMP= ~(A ^ B); 


//*********************************************************

        
	    4'b1010 : if(A==B) 
	               ALU_OUT_TEMP=16'b1;
	              else 
	               ALU_OUT_TEMP=16'b0; 

	    4'b1011 : if(A>B) 
	               ALU_OUT_TEMP=16'd2;
	              else
	               ALU_OUT_TEMP=16'b0; 

	    4'b1100 : if(A<B) 
	               ALU_OUT_TEMP=16'd3;
	              else
	               ALU_OUT_TEMP=16'b0;   


//*********************************************************


	    4'b1101 : ALU_OUT_TEMP= A>>1;
	    4'b1110 : ALU_OUT_TEMP= A<<1;                  


//*********************************************************


		default : ALU_OUT_TEMP=16'd0;
	endcase
   end
   else begin
   	ALU_OUT_TEMP=0;
   	OUT_VALID_TEMP=0;
   end

end

always @(posedge CLK or negedge rst_n) begin
	if(~rst_n) begin
		OUT_VALID <= 0;
		ALU_OUT <= 0;
	end else begin
		if(ENABLE) begin
		OUT_VALID <= OUT_VALID_TEMP;
		ALU_OUT <= ALU_OUT_TEMP;
	end
	else begin
		OUT_VALID <= 0;
		ALU_OUT <= 0;
	end
end
end

endmodule