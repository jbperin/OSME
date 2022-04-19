#include "config.h"

void AdvancedPrint(char x_pos,char y_pos,const char *ptr_message);


extern unsigned char 	kernel_cs;
extern unsigned char 	kernel_s;

extern unsigned char 	kernel_fraction;
extern unsigned char 	kernel_beat;
extern unsigned char 	kernel_tempo;
extern unsigned char 	nbE_keybuf;

extern unsigned char 	ayReg0 ; 
extern unsigned char 	ayReg1 ; 
extern unsigned char 	ayReg2 ; 
extern unsigned char 	ayReg3 ; 
extern unsigned char 	ayReg4 ; 
extern unsigned char 	ayReg5 ; 
extern unsigned char 	ayReg6 ; 
extern unsigned char 	ayReg7 ; 
extern unsigned char 	ayReg10 ; 
extern unsigned char 	ayReg11 ; 
extern unsigned char 	ayReg12; 
extern unsigned char 	ayReg13; 
extern unsigned char 	ayReg14; 
extern unsigned char 	ayReg15; 


extern unsigned char *ptr_Write_Reg0 ;
extern unsigned char *ptr_Write_Reg1 ;
extern unsigned char *ptr_Write_Reg2 ;
extern unsigned char *ptr_Write_Reg3 ;
extern unsigned char *ptr_Write_Reg4 ;
extern unsigned char *ptr_Write_Reg5 ;
extern unsigned char *ptr_Write_Reg6 ;
extern unsigned char *ptr_Write_Reg7 ;
extern unsigned char *ptr_Write_Reg10;
extern unsigned char *ptr_Write_Reg11;
extern unsigned char *ptr_Write_Reg12;
extern unsigned char *ptr_Write_Reg13;
extern unsigned char *ptr_Write_Reg14;
extern unsigned char *ptr_Write_Reg15;

extern unsigned char current_frame_write;
extern unsigned char current_group_write;
extern unsigned char current_idx_write;

char message [50];

unsigned char getTempo();
void setTempo(unsigned char tempo);
void jbOups();

extern char ReadKey();
extern char ReadKeyNoBounce() ;

extern char KeyBank[8];

// void addSample() {
// 	current_idx_write = (current_idx_write + 1) % NB_SAMPLE;
// 	if (current_idx_write == 0) {
// 		current_group_write = (current_group_write + 1) % NB_GROUP;
// 		if 
// 		ptr_Write_Reg0			+= 256;

// 	}
// }

void keyPressed(unsigned char c){
	printf ("kp: %x, ", c);
}

void keyReleased(unsigned char c){
	printf ("kr: %x, ", c);

}

void lsys(){
	unsigned char c;
	while (nbE_keybuf != 0) {
		c=get_keyevent();
		if (c & 0x80){
			keyReleased (c & 0x7F);
		} else {
			keyPressed (c);
		}
	}
}

/* Routine to dump the matrix into screen */
void dump_matrix()
{
    char * start;
    char i,j;
    char mask=1;
     
    start=(char *)(0xbfe0-350);
    for (j=0;j<8;j++)
    {
        for(i=0;i<8;i++)
            {
                *start = (KeyBank[j] & mask ? '1' : '0');
                start--;
                mask=mask<<1;
            }
        
        mask=1;
        start+=(48);
    }
}

void note (){
// ;                        R0   R1   R2   R3   R4   R5   R6   R7   R10  R11  R12  R13  R14  R15   
// OUPS_DATA	.byt        $46, $00, $00, $00, $00, $00, $00, $3E, $0F, $00, $00, $BD, $28, $02
// printf ("note, ");
// ayReg0  = 0x18 ;  // 0x18 ;  // 0x46 ; // ; R0  : Chan A Tone Period Fine (LSB)
// ayReg1  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R1  : Chan A Tone Period Coarse (HSB)
// ayReg2  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R2  : Chan B Tone Period Fine (LSB)
// ayReg3  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R3  : Chan B Tone Period Coarse (HSB)
// ayReg4  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R4  : Chan C Tone Period Fine (LSB)
// ayReg5  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R5  : Chan C Tone Period Coarse (HSB)
// ayReg6  = 0x1F ;  // 0x00 ;  // 0x00 ; // ; R6  : Noise Period 
// ayReg7  = 0x3E ;  // 0x3E ;  // 0x3E ; // ; R7  : Mixer 
// ayReg10  = 0x0F ;  // 0x10 ;  // 0x00 ; // ; R8  : Chan A Amplitude 
// ayReg11  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R9  : Chan B Amplitude
// ayReg12 = 0x00 ;  // 0x00 ;  // 0x0F ; // ; R10 : Chan C Amplitude
// ayReg13 = 0x00 ;  // 0x00 ;  // 0xBD ; // ; R11 : Envelope Period Fine 
// ayReg14 = 0x00 ;  // 0x0F ;  // 0x28 ; // ; R12 : Envelope Period Coarse 
// ayReg15 = 0x00 ;  // 0x00 ;  // 0x02 ; // ; R13 : Envelope Shape / Cycle 
// ayUpdate();
// jbOups();

*(ptr_Write_Reg0 +current_frame_write)= 0x18 ;  // 0x18 ;  // 0x46 ; // ; R0  : Chan A Tone Period Fine (LSB)
*(ptr_Write_Reg1 +current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R1  : Chan A Tone Period Coarse (HSB)
*(ptr_Write_Reg2 +current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R2  : Chan B Tone Period Fine (LSB)
*(ptr_Write_Reg3 +current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R3  : Chan B Tone Period Coarse (HSB)
*(ptr_Write_Reg4 +current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R4  : Chan C Tone Period Fine (LSB)
*(ptr_Write_Reg5 +current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R5  : Chan C Tone Period Coarse (HSB)
*(ptr_Write_Reg6 +current_frame_write)= 0x1F ;  // 0x00 ;  // 0x00 ; // ; R6  : Noise Period 
*(ptr_Write_Reg7 +current_frame_write)= 0x3E ;  // 0x3E ;  // 0x3E ; // ; R7  : Mixer 
*(ptr_Write_Reg10+current_frame_write)= 0x0F ;  // 0x10 ;  // 0x00 ; // ; R8  : Chan A Amplitude 
*(ptr_Write_Reg11+current_frame_write)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R9  : Chan B Amplitude
*(ptr_Write_Reg12+current_frame_write)= 0x00 ;  // 0x00 ;  // 0x0F ; // ; R10 : Chan C Amplitude
*(ptr_Write_Reg13+current_frame_write)= 0x00 ;  // 0x00 ;  // 0xBD ; // ; R11 : Envelope Period Fine 
*(ptr_Write_Reg14+current_frame_write)= 0x00 ;  // 0x0F ;  // 0x28 ; // ; R12 : Envelope Period Coarse 
*(ptr_Write_Reg15+current_frame_write)= 0x00 ;  // 0x00 ;  // 0x02 ; // ; R13 : Envelope Shape / Cycle 
current_frame_write += 1;

}

void playScore() {

}
void main()
{
	int ii;
	char k;
	unsigned char tps = 0 ;



	kernelInit();
	osmeInit();
	ayInit();
	initAyScore();

	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
        else if (k == '+') setTempo(getTempo()+1);
        else if (k == '-') setTempo(getTempo()-1);
		else if (k == 'N') note();
		else if (k == 'P') playScore();
		else if (k != 0) printf("%c %d \n",k,( unsigned char ) k);
		if (tps != kernel_s) {
			// note ();
			tps = kernel_s;
		}

		lsys();

		// if (ayReg10 != 0) {
		// 	ayReg10--;
		// 	ayUpdate();
		// }

		sprintf(message, "%d  ", ii);
		AdvancedPrint(2,0,message);
		sprintf(message, "%d.%d   ", kernel_s, kernel_cs);
		AdvancedPrint(10,0,message);
		sprintf(message, "%d.%d   ",kernel_beat,  kernel_fraction);
		AdvancedPrint(20,0,message);
		sprintf(message, "%d  %d  ",getTempo(), nbE_keybuf);
		AdvancedPrint(30,0,message);

		dump_matrix();

	}

	kernelEnd();

}
