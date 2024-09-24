module RX_TOP (
	input         CLK,    // Clock
	input         RST,  // Asynchronous reset active low
	input   [5:0] Prescale,
	input         PAR_EN,
	input         PAR_TYP,
	input         RX_IN,
	output  [7:0] P_DATA,
	output        Data_valid,
	output        PAR_ERR,
	output        STP_ERR
);
wire sampled_bit,deser_en,enable,strt_glitch,dat_samp_en, stp_chk_en,strt_chk_en,par_chk_en,PAR_STALL;
wire [4:0] edge_cnt;
wire [3:0] bit_cnt;


RX_data_sampling M0 (
 CLK,    
 RST,  
 dat_samp_en,
 edge_cnt,
 RX_IN,
 Prescale,
 sampled_bit	
);


RX_deserializer M1 (
 CLK,    
 RST,  
 deser_en,
 sampled_bit,
 edge_cnt,
 Prescale,
 P_DATA
);


RX_edge_counter M2 (
 CLK,    // Clock
 RST,  // Asynchronous reset active low
 enable,
 PAR_EN,
 Prescale,
 edge_cnt,	
 bit_cnt
);


RX_FSM M3 (
 CLK,
 RST,
 RX_IN,
 PAR_EN,
 PAR_ERR,
 strt_glitch,
 STP_ERR,
 bit_cnt,
 edge_cnt,
 Prescale,
 dat_samp_en,
 enable,
 deser_en,
 Data_valid,
 stp_chk_en,
 strt_chk_en,
 par_chk_en,
 PAR_STALL
);


RX_parity_check M4 (
 par_chk_en,
 sampled_bit,
 PAR_TYP,
 P_DATA,
 CLK,
 RST,
 edge_cnt,
 Prescale,
 PAR_STALL,
 PAR_ERR
);


RX_stop_chk M5 (
 stp_chk_en,
 sampled_bit,
 edge_cnt,
 Prescale,
 CLK,
 RST,
 STP_ERR
);


RX_start_chk M6 (
 sampled_bit,
 strt_chk_en,
 edge_cnt,
 Prescale,
 RST,
 CLK,
 strt_glitch
);



endmodule
