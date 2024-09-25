// #define NB_SAMPLE 50
#define NB_REGISTER 14

extern unsigned char *ptr_Read__Reg0; // Chan A Tone Period Fine (LSB)
extern unsigned char *ptr_Read__Reg1; // Chan A Tone Period Coarse (HSB)
extern unsigned char *ptr_Read__Reg2; // Chan B Tone Period Fine (LSB)
extern unsigned char *ptr_Read__Reg3; // Chan B Tone Period Coarse (HSB)
extern unsigned char *ptr_Read__Reg4; // Chan C Tone Period Fine (LSB)
extern unsigned char *ptr_Read__Reg5; // Chan C Tone Period Coarse (HSB)
extern unsigned char *ptr_Read__Reg6; // Noise Period 
extern unsigned char *ptr_Read__Reg7; // Mixer 
extern unsigned char *ptr_Read__Reg10; //Chan A Amplitude 
extern unsigned char *ptr_Read__Reg11; //Chan B Amplitude
extern unsigned char *ptr_Read__Reg12; //Chan C Amplitude
extern unsigned char *ptr_Read__Reg13; //Envelope Period Fine 
extern unsigned char *ptr_Read__Reg14; //Envelope Period Coarse 
extern unsigned char *ptr_Read__Reg15; //Envelope Shape / Cycle 


extern unsigned char *ptr_Write_Reg0; // Chan A Tone Period Fine (LSB)
extern unsigned char *ptr_Write_Reg1; // Chan A Tone Period Coarse (HSB)
extern unsigned char *ptr_Write_Reg2; // Chan B Tone Period Fine (LSB)
extern unsigned char *ptr_Write_Reg3; // Chan B Tone Period Coarse (HSB)
extern unsigned char *ptr_Write_Reg4; // Chan C Tone Period Fine (LSB)
extern unsigned char *ptr_Write_Reg5; // Chan C Tone Period Coarse (HSB)
extern unsigned char *ptr_Write_Reg6; // Noise Period 
extern unsigned char *ptr_Write_Reg7; // Mixer 
extern unsigned char *ptr_Write_Reg10; // Chan A Amplitude 
extern unsigned char *ptr_Write_Reg11; // Chan B Amplitude
extern unsigned char *ptr_Write_Reg12; // Chan C Amplitude
extern unsigned char *ptr_Write_Reg13; // Envelope Period Fine 
extern unsigned char *ptr_Write_Reg14; // Envelope Period Coarse 
extern unsigned char *ptr_Write_Reg15; // Envelope Shape / Cycle 


extern unsigned char ay_score[NB_REGISTER*NB_SAMPLE];     // 1 second = 50 frames/sec * 14 register/frame
// extern unsigned char current_idx_read;     //    .dsb 1
// extern unsigned char current_idx_write;        //   .dsb 1
// unsigned char current_frame_read;       //  .dsb 1
// unsigned char current_frame_write;      // .dsb 1
// unsigned char current_group_write;      // .dsb 1
extern void initAyScore(void);
// void initAyScore(void) {
//     current_frame_read = 0;     //    .dsb 1
//     current_frame_write = 0;        //   .dsb 1
//     // current_frame_read = 0;       //  .dsb 1
//     // current_frame_write = 0;      // .dsb 1
//     // current_group_write = 0;

//     ptr_Read__Reg0 = ay_score+ 0 * NB_SAMPLE;
//     ptr_Read__Reg1 = ay_score+ 1 * NB_SAMPLE;
//     ptr_Read__Reg2 = ay_score+ 2 * NB_SAMPLE;
//     ptr_Read__Reg3 = ay_score+ 3 * NB_SAMPLE;
//     ptr_Read__Reg4 = ay_score+ 4 * NB_SAMPLE;
//     ptr_Read__Reg5 = ay_score+ 5 * NB_SAMPLE;
//     ptr_Read__Reg6 = ay_score+ 6 * NB_SAMPLE;
//     ptr_Read__Reg7 = ay_score+ 7 * NB_SAMPLE;
//     ptr_Read__Reg10 = ay_score+ 8 * NB_SAMPLE;
//     ptr_Read__Reg11 = ay_score+ 9 * NB_SAMPLE;
//     ptr_Read__Reg12 = ay_score+ 10* NB_SAMPLE;
//     ptr_Read__Reg13 = ay_score+ 11* NB_SAMPLE;
//     ptr_Read__Reg14 = ay_score+ 12* NB_SAMPLE;
//     ptr_Read__Reg15 = ay_score+ 13* NB_SAMPLE;

//     ptr_Write_Reg0 = ay_score+ 0 * NB_SAMPLE;
//     ptr_Write_Reg1 = ay_score+ 1 * NB_SAMPLE;
//     ptr_Write_Reg2 = ay_score+ 2 * NB_SAMPLE;
//     ptr_Write_Reg3 = ay_score+ 3 * NB_SAMPLE;
//     ptr_Write_Reg4 = ay_score+ 4 * NB_SAMPLE;
//     ptr_Write_Reg5 = ay_score+ 5 * NB_SAMPLE;
//     ptr_Write_Reg6 = ay_score+ 6 * NB_SAMPLE;
//     ptr_Write_Reg7 = ay_score+ 7 * NB_SAMPLE;
//     ptr_Write_Reg10 = ay_score+ 8 * NB_SAMPLE;
//     ptr_Write_Reg11 = ay_score+ 9 * NB_SAMPLE;
//     ptr_Write_Reg12 = ay_score+ 10* NB_SAMPLE;
//     ptr_Write_Reg13 = ay_score+ 11* NB_SAMPLE;
//     ptr_Write_Reg14 = ay_score+ 12* NB_SAMPLE;
//     ptr_Write_Reg15 = ay_score+ 13* NB_SAMPLE;

// }


void stepWriteScore () {
    // printf ("0x%02x%02x %02d, 0x%02x%02x %02d, 0x%02x%02x %02d, 0x%02x%02x %02d %02x %02d",
    //     curr_frame[R1],curr_frame[R0],curr_frame[R10],
    //     curr_frame[R3],curr_frame[R2],curr_frame[R11],
    //     curr_frame[R5],curr_frame[R4],curr_frame[R12],
    //     curr_frame[R13],curr_frame[R14], curr_frame[R6],curr_frame[R7],curr_frame[R15]
    // );
    ptr_Write_Reg0[current_frame_write] = curr_frame[R0];
    ptr_Write_Reg1[current_frame_write] = curr_frame[R1];
    ptr_Write_Reg2[current_frame_write] = curr_frame[R2];
    ptr_Write_Reg3[current_frame_write] = curr_frame[R3];
    ptr_Write_Reg4[current_frame_write] = curr_frame[R4];
    ptr_Write_Reg5[current_frame_write] = curr_frame[R5];
    ptr_Write_Reg6[current_frame_write] = curr_frame[R6];
    ptr_Write_Reg7[current_frame_write] = curr_frame[R7];
    ptr_Write_Reg10[current_frame_write] = curr_frame[R10];
    ptr_Write_Reg11[current_frame_write] = curr_frame[R11];
    ptr_Write_Reg12[current_frame_write] = curr_frame[R12];
    ptr_Write_Reg13[current_frame_write] = curr_frame[R13];
    ptr_Write_Reg14[current_frame_write] = curr_frame[R14];
    ptr_Write_Reg15[current_frame_write] = curr_frame[R15];
    current_frame_write     = (current_frame_write+1)%NB_SAMPLE;
    // current_frame_read = (current_frame_read + 1) % NB_FRAME;
}
