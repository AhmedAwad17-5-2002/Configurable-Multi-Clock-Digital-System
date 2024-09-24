`timescale 1ns/1fs
module SYS_TB ();
  parameter UART_CLK_PERIOD = 20,
            REF_CLK_PERIOD = 271.2674,
            START_BIT = 1'b0,
            STOP_BIT= 1'b1;


	logic rst_n,RX_IN;
	bit   REF_CLK,UART_CLK;
    logic STP_ERR;
    logic RX_PAR_ERR;
    logic TX_OUT;
    logic TX_DATA_VALID;
    logic [10:0] FRAME;
    logic [7:0] OP1,OP2;
    logic DATA_OUT;

    logic [7:0] DATA_TEST;
    logic PAR_TYP,PAR_EN;


//////////////////////////////////////////////////////////////////////////////////////////////////

    SYS_TOP DUT_TB (
    	.REF_CLK(REF_CLK), 
    	.RX_IN(RX_IN), 
    	.UART_CLK(UART_CLK), 
    	.TX_OUT(TX_OUT), 
    	.rst_n(rst_n), 
    	.RX_PAR_ERR(RX_PAR_ERR), 
    	.RX_STP_ERR(STP_ERR)
    );

///////////////////////////////////////////////////////////////////////////////////////////////////

always #(UART_CLK_PERIOD/2) UART_CLK=~UART_CLK;
always #(REF_CLK_PERIOD/2) REF_CLK=~REF_CLK;

///////////////////////////////////////////////////////////////////////////////////////////////////
task initialization;
	RX_IN=1;
	DATA_TEST=0;
	PAR_TYP=0;
	PAR_EN=1;
endtask : initialization


task send_frame(input [7:0] data, input parity_enable, input parity_type);
	logic par;
	
	@(negedge  DUT_TB.U0.TX_clk);
	RX_IN=START_BIT;
	

	for(int i=0; i<8; i++) begin
		@(negedge  DUT_TB.U0.TX_clk);
		RX_IN=data[i];
		
	end

	@(negedge  DUT_TB.U0.TX_clk);
	if(parity_enable)begin
		if(parity_type==0)begin
			RX_IN=^data;
			par=^data;
		end
		else begin
			RX_IN= ~(^data);
			par=~(^data);
		end
		

		@(negedge  DUT_TB.U0.TX_clk);
		RX_IN=1;
		
	end

	else begin
		@(negedge  DUT_TB.U0.TX_clk);	
		RX_IN=1;
	end
@(negedge  DUT_TB.U0.TX_clk);
FRAME = {{(parity_enable)?{STOP_BIT,par} : STOP_BIT}, data, START_BIT};
	

endtask : send_frame

initial begin
	initialization();
	rst_n=0;
	@(negedge UART_CLK);
	@(negedge UART_CLK);
	rst_n=1;
	

	$display("*********************** Default Configrations*************************");
	$display("**********************************************************************");
    //////////////////////////write TEST///////////////////////////////////
    DATA_TEST=8'haa;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'h00 , 1 , 0);
	send_frame (8'hFF, 1, 0);
    @(negedge  DUT_TB.U4.RX_D_VLD);
	if(DUT_TB.U5.RegFile[0]==8'hFF)
		$display("WRITE TEST ---> DONE");
	else
		$display("ERROR %t", $time);



	////////////////////////WRITE TEST////////////////////////////////////////
    DATA_TEST=8'hAA;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'h01 , 1 , 0);
	send_frame (8'hFF, 1, 0);
    @(negedge  DUT_TB.U4.RX_D_VLD);
	if(DUT_TB.U5.RegFile[1]==8'hFF)
		$display("WRITE TEST ---> DONE");
	else
		$display("ERROR %t", $time);

    ///////////////////////READ TEST//////////////////////////////////////////
    DATA_TEST=8'hBB;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'h00 , 1 , 0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==DUT_TB.U5.RegFile[0])
		$display("READ TEST ---> DONE");
	else
		$display("ERROR %t", $time);
    
    ///////////////////////ALU WITH NO OPERANS /////////////////////////////////
    //(ADD)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'b0 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] + DUT_TB.U5.RegFile[1]))
		$display("ADD WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(SUB)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'b1 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] - DUT_TB.U5.RegFile[1]))
		$display("SUB WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(MUL)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd2 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] * DUT_TB.U5.RegFile[1]))
		$display("MUL WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(DIV)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd3 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] / DUT_TB.U5.RegFile[1]))
		$display("DIV WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);


///////////////////////ALU WITH EXTERNAL OPERANS /////////////////////////////////
    //(ADD)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd10 , 1'b1, 1'b0);
	send_frame (8'd11 , 1'b1, 1'b0);
	send_frame (8'b0 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(10 + 11))
		$display("ADD WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(SUB)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd15 , 1'b1, 1'b0);
	send_frame (8'd11 , 1'b1, 1'b0);
	send_frame (8'b1 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(15 - 11))
		$display("SUB WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(MUL)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd10 , 1'b1, 1'b0);
	send_frame (8'd11 , 1'b1, 1'b0);
	send_frame (8'd2 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(10 * 11))
		$display("MUL WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(DIV)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'd110 , 1'b1, 1'b0);
	send_frame (8'd11 , 1'b1, 1'b0);
	send_frame (8'd3 , 1'b1, 1'b0);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(110 / 11))
		$display("DIV WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$display("*********************** CHANGED Configrations*************************");
$display("**********************************************************************");
    
    DATA_TEST=8'haa;
	send_frame (DATA_TEST , 1'b1, 1'b0);
	send_frame (8'h02 , 1 , 0);
	send_frame (8'b010000_1_1, 1, 0); // EVEN PARITY , PRESCALE=16
    @(negedge  DUT_TB.U4.RX_D_VLD);
	if(DUT_TB.U5.RegFile[2]==8'b010000_1_1)
		$display("-----RECONFIG TEST ---> DONE");
	else
		$display("ERROR %t", $time);


    //////////////////////////write TEST///////////////////////////////////
    DATA_TEST=8'haa;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'h00 , 1 , 1);
	send_frame (8'hFF, 1, 1);
    @(negedge  DUT_TB.U4.RX_D_VLD);
	if(DUT_TB.U5.RegFile[0]==8'hFF)
		$display("WRITE TEST ---> DONE");
	else
		$display("ERROR %t", $time);



	////////////////////////WRITE TEST////////////////////////////////////////
    DATA_TEST=8'hAA;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'h01 , 1 , 1);
	send_frame (8'hFF, 1, 1);
    @(negedge  DUT_TB.U4.RX_D_VLD);
	if(DUT_TB.U5.RegFile[1]==8'hFF)
		$display("WRITE TEST ---> DONE");
	else
		$display("ERROR %t", $time);

    ///////////////////////READ TEST//////////////////////////////////////////
    DATA_TEST=8'hBB;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'h00 , 1 , 1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==DUT_TB.U5.RegFile[0])
		$display("READ TEST ---> DONE");
	else
		$display("ERROR %t", $time);
    
    ///////////////////////ALU WITH NO OPERANS /////////////////////////////////
    //(ADD)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'b0 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] + DUT_TB.U5.RegFile[1]))
		$display("ADD WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(SUB)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'b1 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] - DUT_TB.U5.RegFile[1]))
		$display("SUB WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(MUL)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd2 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] * DUT_TB.U5.RegFile[1]))
		$display("MUL WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(DIV)
    DATA_TEST=8'hDD;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd3 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(DUT_TB.U5.RegFile[0] / DUT_TB.U5.RegFile[1]))
		$display("DIV WITH NO OPERANS---> DONE");
	else
		$display("ERROR %t", $time);


///////////////////////ALU WITH EXTERNAL OPERANS /////////////////////////////////
    //(ADD)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd10 , 1'b1, 1'b1);
	send_frame (8'd11 , 1'b1, 1'b1);
	send_frame (8'b0 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(10 + 11))
		$display("ADD WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(SUB)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd15 , 1'b1, 1'b1);
	send_frame (8'd11 , 1'b1, 1'b1);
	send_frame (8'b1 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(15 - 11))
		$display("SUB WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(MUL)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd10 , 1'b1, 1'b1);
	send_frame (8'd11 , 1'b1, 1'b1);
	send_frame (8'd2 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(10 * 11))
		$display("MUL WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

	 //(DIV)
    DATA_TEST=8'hCC;
	send_frame (DATA_TEST , 1'b1, 1'b1);
	send_frame (8'd110 , 1'b1, 1'b1);
	send_frame (8'd11 , 1'b1, 1'b1);
	send_frame (8'd3 , 1'b1, 1'b1);
    @(negedge DUT_TB.U11.EMPTY);
	if(DUT_TB.U11.RD_DATA==(110 / 11))
		$display("DIV WITH EXTERNAL OPERANDS---> DONE");
	else
		$display("ERROR %t", $time);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$display("******************SIMULATION END ---> DONE :) s:)***************************");
	$stop;
end

endmodule : SYS_TB