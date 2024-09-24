`define CMD_WIDTH 8

`define state_width 4
typedef enum logic [`state_width-1:0] {IDEL=0, 
                          WRITE_ADDRESS, 
                          WRITE_DATA, 
                          READ_ADDRESS, 
                          GET_REGFILE_DATA, 
                          FIFO_STAGE_1ST_BYTE, 
                          FIFO_STAGE_2ND_BYTE, 
                          WRITE_OP_A, 
                          WRITE_OP_B, 
                          ALU_ENABLE_FUNC, 
                          GET_ALU_OUTPUT} e_states;

typedef enum logic [`CMD_WIDTH-1 :0] {REGFILE_WRITE_CMD= 'hAA, 
                                      REGFILE_READ_CMD='hBB, 
                                      ALU_OPER_CMD= 'hCC, 
                                      ALU_NO_OPER_CMD='hDD} e_CMD;


module SYS_CONTROL #(parameter DATA_WIDTH = 8,
                               ADDR_WIDTH = 4
)(
input  logic                    CLK,
input  logic                    rst_n,
input  logic [DATA_WIDTH-1:0]   REGFILE_RdData, //from_RegFile
input  logic                    REGFILE_RdData_VLD, //from_RegFile
input  logic [DATA_WIDTH*2-1:0] ALU_OUT, //from_ALU
input  logic                    ALU_OUT_VLD, //from_ALU 
input  logic [DATA_WIDTH-1:0]   RX_P_DATA, //from_RX 
input  logic                    RX_D_VLD, //from_RX
input  logic                    FIFO_FULL, //from_FIFO

output logic                    ALU_EN, //to_ALU
output logic                    CLK_GATE_EN,  //to_CLK_GATE_ALU
output logic                    CLKDIV_EN, //Always = 1
output logic                    REGFILE_WrEn, //to_RegFile 
output logic                    REGFILE_RdEn, //to_RegFile 
output logic [3:0]              ALU_FUN, //to_ALU 
output logic [ADDR_WIDTH-1:0]   REGFILE_ADDRESS, //to_RegFile 
output logic [DATA_WIDTH-1:0]   REGFILE_WrData, //to_RegFile 
output logic [DATA_WIDTH-1:0]   FIFO_P_DATA, //to_FIFO 
output logic                    FIFO_WR_INC  //to_FIFO 
);

e_states cs,ns;

logic [DATA_WIDTH-1 : 0] OP1_TEMP, OP2_TEMP;
logic [ADDR_WIDTH-1 : 0] REGFILE_ADDR_TEMP;
logic [2*DATA_WIDTH-1 : 0] ALU_OUT_TEMP;
logic REGFILE_ADDR_TEMP_EN, ALU_OUT_TEMP_EN;



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge CLK or negedge rst_n) begin : proc_current_state
    if(~rst_n) begin
        cs <= IDEL;
    end else begin
        cs <= ns;
    end
end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always_comb begin : proc_next_state
    case (cs)
        IDEL : begin
            if(RX_D_VLD) begin
                case (RX_P_DATA)
                    REGFILE_WRITE_CMD : ns=WRITE_ADDRESS;
                    REGFILE_READ_CMD  : ns=READ_ADDRESS;
                    ALU_OPER_CMD      : ns=WRITE_OP_A;
                    ALU_NO_OPER_CMD   : ns=ALU_ENABLE_FUNC;
                    default : ns=IDEL;
                endcase
            end
            else 
                ns=IDEL;
        end
/////////////////////////////////// for CMD 8'hAA --> REGFILE_WRITE_CMD //////////////////////////////
        WRITE_ADDRESS : if(RX_D_VLD)
                            ns=WRITE_DATA;
                        else 
                            ns=WRITE_ADDRESS;


        WRITE_DATA : if(RX_D_VLD)
                        ns=IDEL;
                     else 
                        ns=WRITE_DATA; 

/////////////////////////////////// for CMD 8'hBB --> REGFILE_READ_CMD to TX //////////////////////////  
        READ_ADDRESS :  if(RX_D_VLD)
                            ns=GET_REGFILE_DATA;
                        else 
                            ns=READ_ADDRESS;


        GET_REGFILE_DATA :  if(REGFILE_RdData_VLD)
                                ns=IDEL;
                            else 
                                ns=GET_REGFILE_DATA;

////////////////////////////// for CMD 8'hCC --> ALU Operation command with operand////////////////////
        WRITE_OP_A :  if(RX_D_VLD)
                        ns=WRITE_OP_B;
                      else 
                        ns=WRITE_OP_A;

        WRITE_OP_B : if(RX_D_VLD)
                        ns=ALU_ENABLE_FUNC;
                     else 
                        ns=WRITE_OP_B;

        ALU_ENABLE_FUNC : if(RX_D_VLD)
                            ns=GET_ALU_OUTPUT;
                          else 
                            ns=ALU_ENABLE_FUNC; 

        GET_ALU_OUTPUT : if(ALU_OUT_VLD)
                            ns=FIFO_STAGE_1ST_BYTE;
                         else 
                            ns=GET_ALU_OUTPUT;

        FIFO_STAGE_1ST_BYTE : 
                                ns=FIFO_STAGE_2ND_BYTE;
                             

        // FIFO_STAGE_2ND_BYTE : 
        //                         ns=IDEL;
                              

        default : ns=IDEL;
    endcase  
end



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always_comb  begin : proc_output
    ALU_EN=0;
    CLK_GATE_EN=0;
    CLKDIV_EN=1;
    REGFILE_WrEn=0;
    REGFILE_RdEn=0;
    ALU_FUN=0;
    REGFILE_ADDRESS=0;
    REGFILE_WrData=0;
    FIFO_P_DATA=0;
    FIFO_WR_INC=0;
    REGFILE_ADDR_TEMP_EN=0;
    ALU_OUT_TEMP_EN=0;


    case (cs)
/////////////////////////////////// for CMD 8'hAA --> REGFILE_WRITE_CMD //////////////////////////////
        WRITE_ADDRESS : if(RX_D_VLD)
                            REGFILE_ADDR_TEMP_EN=1;

        WRITE_DATA : if(RX_D_VLD) begin
                        REGFILE_WrEn = 1;
                        REGFILE_ADDRESS = REGFILE_ADDR_TEMP[ADDR_WIDTH-1 : 0];
                        REGFILE_WrData = RX_P_DATA;
                     end


/////////////////////////////////// for CMD 8'hBB --> REGFILE_READ_CMD to TX //////////////////////////  
        READ_ADDRESS : if(RX_D_VLD) begin
                        REGFILE_RdEn = 1;
                        REGFILE_ADDRESS = RX_P_DATA[ADDR_WIDTH-1 : 0];
                       end


        GET_REGFILE_DATA : if(!FIFO_FULL && REGFILE_RdData_VLD) begin
                                  // REGFILE_RdEn=1;
                                  FIFO_P_DATA = REGFILE_RdData;
                                  FIFO_WR_INC = 1;
                            end

////////////////////////////// for CMD 8'hCC --> ALU Operation command with operand////////////////////
        WRITE_OP_A : if (RX_D_VLD) begin
                       REGFILE_WrEn = 1;
                       REGFILE_ADDRESS = 0;
                       REGFILE_WrData = RX_P_DATA;
                     end

        WRITE_OP_B : if(RX_D_VLD) begin
                       REGFILE_WrEn = 1;
                       REGFILE_ADDRESS = 1;
                       REGFILE_WrData = RX_P_DATA;
                     end


        ALU_ENABLE_FUNC : begin
                            CLK_GATE_EN=1;
                            if(RX_D_VLD) begin
                                ALU_EN=1;
                                ALU_FUN=RX_P_DATA[3:0];
                            end
                          end


        GET_ALU_OUTPUT : begin
                            CLK_GATE_EN=1;
                            ALU_OUT_TEMP_EN=1;
                          end

        FIFO_STAGE_1ST_BYTE : if(!FIFO_FULL)begin
                                 FIFO_WR_INC=1;
                                 FIFO_P_DATA = ALU_OUT_TEMP [DATA_WIDTH-1 : 0];

                              end



        FIFO_STAGE_2ND_BYTE : if(!FIFO_FULL)begin
                                 FIFO_WR_INC=1;
                                 FIFO_P_DATA = ALU_OUT_TEMP [2*DATA_WIDTH-1 : DATA_WIDTH];
                              end   

    endcase  
end



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge CLK or negedge rst_n) begin : proc_TEMP_REGS
    if(~rst_n) begin
        ALU_OUT_TEMP <= 0;
        REGFILE_ADDR_TEMP <= 0;
    end else begin
        if(ALU_OUT_TEMP_EN)
            ALU_OUT_TEMP <= ALU_OUT;

        if(REGFILE_ADDR_TEMP_EN)
            REGFILE_ADDR_TEMP <= RX_P_DATA;
    end
end

endmodule