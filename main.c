
void AdvancedPrint(char x_pos,char y_pos,const char *ptr_message);


extern unsigned char 	kernel_cs;
extern unsigned char 	kernel_s;

char message [50];

void main()
{
	int ii;
	char k;

	kernelInit();

	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
		else if (k != 0) printf("%c\n",k);
		sprintf(message, "%d %d.%d", ii, kernel_s, kernel_cs);
		AdvancedPrint(2,0,message);
	}

	kernelEnd();

}
