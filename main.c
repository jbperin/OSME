
void AdvancedPrint(char x_pos,char y_pos,const char *ptr_message);


extern unsigned char 	kernel_cs;
extern unsigned char 	kernel_s;

extern unsigned char 	kernel_fraction;
extern unsigned char 	kernel_beat;
extern unsigned char 	kernel_tempo;


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

void main()
{
	int ii;
	char k;

	kernelInit();
	ayInit();

	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
        else if (k == '+') setTempo(getTempo()+1);
        else if (k == '-') setTempo(getTempo()-1);
		else if (k != 0) printf("%c %d \n",k,( unsigned char ) k);
		sprintf(message, "%d  ", ii);
		AdvancedPrint(2,0,message);
		sprintf(message, "%d.%d   ", kernel_s, kernel_cs);
		AdvancedPrint(10,0,message);
		sprintf(message, "%d.%d   ",kernel_beat,  kernel_fraction);
		AdvancedPrint(20,0,message);
		sprintf(message, "%d    ",getTempo());
		AdvancedPrint(30,0,message);
	}

	kernelEnd();

}
