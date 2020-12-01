
void AdvancedPrint(char x_pos,char y_pos,const char *ptr_message);


extern unsigned char 	kernel_cs;
extern unsigned char 	kernel_s;
extern unsigned char 	kernel_fraction;
extern unsigned char 	kernel_beat;
extern unsigned char 	kernel_tempo;
char message [50];

unsigned char getTempo();
void setTempo(unsigned char tempo);

void main()
{
	int ii;
	char k;

	kernelInit();

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
