
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
extern unsigned char 	ayReg8 ; 
extern unsigned char 	ayReg9 ; 
extern unsigned char 	ayReg10; 
extern unsigned char 	ayReg11; 
extern unsigned char 	ayReg12; 
extern unsigned char 	ayReg13; 



char message [50];

unsigned char getTempo();
void setTempo(unsigned char tempo);
void jbOups();

extern char ReadKey();
extern char ReadKeyNoBounce() ;

extern char KeyBank[8];

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
ayReg0  = 0x18 ;  // 0x18 ;  // 0x46 ; // ; R0  : Chan A Tone Period Fine (LSB)
ayReg1  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R1  : Chan A Tone Period Coarse (HSB)
ayReg2  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R2  : Chan B Tone Period Fine (LSB)
ayReg3  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R3  : Chan B Tone Period Coarse (HSB)
ayReg4  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R4  : Chan C Tone Period Fine (LSB)
ayReg5  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R5  : Chan C Tone Period Coarse (HSB)
ayReg6  = 0x1F ;  // 0x00 ;  // 0x00 ; // ; R6  : Noise Period 
ayReg7  = 0x3E ;  // 0x3E ;  // 0x3E ; // ; R7  : Mixer 
ayReg8  = 0x0F ;  // 0x10 ;  // 0x00 ; // ; R8  : Chan A Amplitude 
ayReg9  = 0x00 ;  // 0x00 ;  // 0x00 ; // ; R9  : Chan B Amplitude
ayReg10 = 0x00 ;  // 0x00 ;  // 0x0F ; // ; R10 : Chan C Amplitude
ayReg11 = 0x00 ;  // 0x00 ;  // 0xBD ; // ; R11 : Envelope Period Fine 
ayReg12 = 0x00 ;  // 0x0F ;  // 0x28 ; // ; R12 : Envelope Period Coarse 
ayReg13 = 0x00 ;  // 0x00 ;  // 0x02 ; // ; R13 : Envelope Shape / Cycle 
ayUpdate();
// jbOups();
}
void main()
{
	int ii;
	char k;
	unsigned char tps = 0 ;



	kernelInit();
	osmeInit();
	ayInit();

	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
        else if (k == '+') setTempo(getTempo()+1);
        else if (k == '-') setTempo(getTempo()-1);
		else if (k == 'N') note();
		else if (k != 0) printf("%c %d \n",k,( unsigned char ) k);
		if (tps != kernel_s) {
			// note ();
			tps = kernel_s;
		}

		lsys();

		// if (ayReg8 != 0) {
		// 	ayReg8--;
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
