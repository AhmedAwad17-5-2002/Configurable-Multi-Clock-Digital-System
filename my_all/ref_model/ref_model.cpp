#include<iostream>
#include<cmath>
#include<string>
#include<stdio.h>
#include"svdpi.h"

using namespace std;


 extern "C" int transaction_golden_result (int rst_n ,int current_frame, int past_1_frame,  int past_2_frame,
                                           int past_3_frame, int past_4_frame, int past_5_frame, int CMD,
                                           int bit_counter, int frame_counter){
    static int RAM [16]={0,1,129,32,4,5,6,7,8,9,10,11,12,13,14,15};
    int ALU_result=0;
// cout <<current_frame<<"  "<<past_1_frame<<"  "<<past_2_frame<<"  "<<past_3_frame<<"  "<<past_4_frame<<"  "<<past_5_frame<<"  "<<CMD<<"  "<<bit_counter<<"  "<<frame_counter<<"\n";
// cout <<"RAM={"<< RAM[0]<<", "<< RAM[1]<<", "<< RAM[2]<<", "<< RAM[3]<<", "<< RAM[4]<<", "<< RAM[5]<<", "<< RAM[6]<<", "<< RAM[7]<<", "<<RAM[8]<<", "<< RAM[9]<<", "<< RAM[10]<<", "<< RAM[11]<<", "<< RAM[12]<<", "<< RAM[13]<<", "<< RAM[14]<<", "<< RAM[15]<<"}"<<"\n";
    if(frame_counter==1  && bit_counter==1 && past_5_frame==170){
        RAM [past_4_frame]=past_3_frame;
        // cout<<"reg_file Write DONE :):):):):):):) " << RAM [past_4_frame]<<"\n";
        return (RAM[past_4_frame]);
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    else if(frame_counter==1 && bit_counter==1 && past_5_frame==187){
        // cout<<"reg_file read DONE :):):):):):):)  result= "<< RAM[past_4_frame]<<"\n";
        return (RAM[past_4_frame]);
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    else if(frame_counter==1 && bit_counter==1 && past_5_frame==204){    
        // cout<<"ALU_with_OP DONE :):):):):):):) "<<"\n";   
        RAM[0]=past_4_frame;
        RAM[1]=past_3_frame;
        // cout <<"RAM={"<< RAM[0]<<", "<< RAM[1]<<", "<< RAM[2]<<", "<< RAM[3]<<", "<< RAM[4]<<", "<< RAM[5]<<", "<< RAM[6]<<", "<< RAM[7]<<", "<<RAM[8]<<", "<< RAM[9]<<", "<< RAM[10]<<", "<< RAM[11]<<", "<< RAM[12]<<", "<< RAM[13]<<", "<< RAM[14]<<", "<< RAM[15]<<"}"<<"\n";
        switch (past_2_frame)
        {
        case 0: ALU_result=past_4_frame + past_3_frame;
         break;   
        
        case 1: ALU_result=past_4_frame - past_3_frame;
         break;   

        case 2: ALU_result=past_4_frame * past_3_frame;
         break;   

        case 3: ALU_result=past_4_frame / past_3_frame;
         break;   

        case 4: ALU_result=past_4_frame & past_3_frame;
         break;   

        case 5: ALU_result=past_4_frame | past_3_frame;
         break;   

        case 6: ALU_result=~(past_4_frame & past_3_frame);
         break;  

        case 7: ALU_result=~(past_4_frame | past_3_frame);
         break;   

        case 8: ALU_result=past_4_frame ^ past_3_frame;
         break;   
        
        case 9: ALU_result=~(past_4_frame^past_3_frame);
         break;   

        case 10:
            if(past_4_frame == past_3_frame)
                ALU_result=1;
            else
                ALU_result=0;
         break;   

        case 11:
            if(past_4_frame > past_3_frame)
                ALU_result=2;
            else
                ALU_result=0;
            
         break;
        case 12:
            if(past_4_frame < past_3_frame)
                ALU_result=3;
            else
                ALU_result=0;
            
         break;
        case 13: ALU_result=(past_4_frame >> 1);
            
         break;
        case 14: ALU_result=(past_4_frame << 1);
            
         break;
        default: ALU_result=0;
            break;
        }
        // cout<<"ALU_with_OP DONE :):):):):):)  result= "<< ALU_result<<"\n";
        
        return ALU_result;       
    }
//////////////////////////////////////////////////////////////////////

    else if (frame_counter==1 && bit_counter==1 && past_5_frame==221){
        // cout<<"ALU_NO_OP DONE :) "<<"\n";

        switch (past_4_frame)
        {
        case 0: ALU_result=RAM[0] + RAM[1];
                break;
        
        case 1: ALU_result=RAM[0] - RAM[1];
            break;

        case 2: ALU_result=RAM[0] * RAM[1];
            break;

        case 3: ALU_result=RAM[0] / RAM[1];
            break;

        case 4: ALU_result=RAM[0] & RAM[1];
            break;

        case 5: ALU_result=RAM[0] | RAM[1];
            break;

        case 6: ALU_result=~(RAM[0] & RAM[1]);
            break;

        case 7: ALU_result=~(RAM[0] | RAM[1]);
            break;

        case 8: ALU_result=RAM[0] ^ RAM[1];
            break;
        
        case 9: ALU_result=~(RAM[0]^RAM[1]);
            break;

        case 10:
            if(RAM[0] == RAM[1])
                ALU_result=1;
            else
                ALU_result=0;
            break;

        case 11:
            if(RAM[0] > RAM[1])
                ALU_result=2;
            else
                ALU_result=0;
            break;

        case 12:
            if(RAM[0] < RAM[1])
                ALU_result=3;
            else
                ALU_result=0;
             break; 
            

        case 13: ALU_result=(RAM[0] >> 1);
            break;

        case 14: ALU_result=(RAM[0] << 1);
            break;

        default: ALU_result=0;
            break;
        }
        // cout <<"RAM={"<< RAM[0]<<", "<< RAM[1]<<", "<< RAM[2]<<", "<< RAM[3]<<", "<< RAM[4]<<", "<< RAM[5]<<", "<< RAM[6]<<", "<< RAM[7]<<", "<<RAM[8]<<", "<< RAM[9]<<", "<< RAM[10]<<", "<< RAM[11]<<", "<< RAM[12]<<", "<< RAM[13]<<", "<< RAM[14]<<", "<< RAM[15]<<"}"<<"\n";

        // cout<<"ALU_NO_OP DONE :):):):):):):)  result= "<< ALU_result<<"\n";
        return ALU_result;
    }
    else {
        cout<<"FUCK !!!!!!!!!"<<"\n";
        return 0;
    } 
  }
