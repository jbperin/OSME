
//#include "lib.h"

// Declare the assembly code function
void AdvancedPrint(char x_pos,char y_pos,const char *ptr_message);

// char strinfo [40];

// void dispinfo () {
// 	sprintf (strinfo, "%d %d %d           ", mesure, temps, fraction);
// 	AdvancedPrint(2,0,strinfo);
// }

extern unsigned int 	kernel_ms;
extern unsigned char 	kernel_s;

// extern unsigned char 	kernel_tempo;
// extern unsigned char 	kernel_fraction;
// extern unsigned char 	kernel_beat;

char message [50];


void main()
{
	int ii;
	char k;

	kernelInit();


	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
		else printf("%c",k);
		sprintf(message, "%d %d.%d", ii, kernel_s, kernel_ms);
		AdvancedPrint(2,0,message);
	}

	kernelEnd();

}
