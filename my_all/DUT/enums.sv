package enums;

typedef enum logic [1:0] {Register_File_Write_command,
	                          Register_File_Read_command,
	                          ALU_Operation_command_with_operand, 
	                          ALU_Operation_command_with_No_operand
	                          } e_command_types;
	                          
typedef enum logic [7:0] {RF_Wr_CMD=8'hAA,
	                          RF_Rd_CMD=8'hBB,
	                          ALU_OPER_W_OP_CMD=8'hCC, 
	                          ALU_OPER_W_NOP_CMD=8'hDD
	                          } e_frame0_type;

typedef enum logic [1:0] {RF_Wr_Addr,
	                          RF_Rd_Addr,
	                          Operand_A, 
	                          ALU_FUN_f1
	                          } e_frame1_type;

typedef enum logic  [1:0] {RF_Wr_Data,
	                           Operand_B,
	                           NA_f2
	                           } e_frame2_type;

typedef enum logic        {ALU_FUN_f3,
	                           NA_f3
	                           } e_frame3_type;

typedef enum logic [1:0] {frame0_s,
	                          frame1_s,
	                          frame2_s,
	                          frame3_s
	                          } e_seq;
	
endpackage : enums