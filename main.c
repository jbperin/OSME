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
extern unsigned char current_frame_read;
// extern unsigned char current_idx_write;

char message [50];

unsigned char getTempo();
void setTempo(unsigned char tempo);
void jbOups();

extern char ReadKey();
extern char ReadKeyNoBounce() ;

extern void initRand(unsigned int seed);
extern unsigned char getRand(void);

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
	// printf ("kp: %x, ", c);
}

void keyReleased(unsigned char c){
	// printf ("kr: %x, ", c);

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
	unsigned char ii;
	unsigned char jj;
	unsigned char randValue;
	// initAyScore();
	
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

	for (ii = (current_frame_write+1)%NB_SAMPLE, jj=1;jj <50 ; ii++, jj++){
		*(ptr_Write_Reg0 +ii)= 0x18 ;  // 0x18 ;  // 0x46 ; // ; R0  : Chan A Tone Period Fine (LSB)
		*(ptr_Write_Reg1 +ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R1  : Chan A Tone Period Coarse (HSB)
		*(ptr_Write_Reg2 +ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R2  : Chan B Tone Period Fine (LSB)
		*(ptr_Write_Reg3 +ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R3  : Chan B Tone Period Coarse (HSB)
		*(ptr_Write_Reg4 +ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R4  : Chan C Tone Period Fine (LSB)
		*(ptr_Write_Reg5 +ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R5  : Chan C Tone Period Coarse (HSB)
		*(ptr_Write_Reg6 +ii)= 0x1F ;  // 0x00 ;  // 0x00 ; // ; R6  : Noise Period 
		*(ptr_Write_Reg7 +ii)= 0x3E ;  // 0x3E ;  // 0x3E ; // ; R7  : Mixer 
		*(ptr_Write_Reg10+ii)=(*(ptr_Write_Reg10+ii) != 0)?(*(ptr_Write_Reg10+ii) -1):0; // = 0x0F ;  // 0x10 ;  // 0x00 ; // ; R8  : Chan A Amplitude 
		*(ptr_Write_Reg11+ii)= 0x00 ;  // 0x00 ;  // 0x00 ; // ; R9  : Chan B Amplitude
		*(ptr_Write_Reg12+ii)= 0x00 ;  // 0x00 ;  // 0x0F ; // ; R10 : Chan C Amplitude
		*(ptr_Write_Reg13+ii)= 0x00 ;  // 0x00 ;  // 0xBD ; // ; R11 : Envelope Period Fine 
		*(ptr_Write_Reg14+ii)= 0x00 ;  // 0x0F ;  // 0x28 ; // ; R12 : Envelope Period Coarse 
		*(ptr_Write_Reg15+ii)= 0x00 ;  // 0x00 ;  // 0x02 ; // ; R13 : Envelope Shape / Cycle 
	}
	current_frame_write = (current_frame_write+jj)%NB_SAMPLE;
	
	randValue = getRand();

	printf("wr: %d",randValue);
	
}


#include "music.c"

#include "simu_it.c"

#include "score.c"

#include "euclid.c"



unsigned char    currTonality       = 0;
unsigned char    *currScale         = 0; // NULL;
unsigned char    *currCadence       = 0; // ULL;
unsigned char    currIdxInCadence   = 0;
unsigned char    *currChord         = 0; // NULL;
unsigned char   nbNoteInBar         = 0;

unsigned char   fin                 = 0;
unsigned char   coar                = 0;
unsigned char   octave              = 3;
unsigned char   idxNote             = 0;
unsigned char   currNote            = 0;


unsigned char randrange(unsigned char rmin, unsigned char rmax );


void initMusic(void) {
    currTonality        = 0;
    currScale           = scales[currTonality];
    currCadence         = theCadence;
    currIdxInCadence    = 0;
    currChord           = chords[currCadence[currIdxInCadence]];

}
void myIt50Hz (void) {
        // if (idxFraction == 11):
        //     self.applyChange({'r10':0, 'r15':0x01})
        // else:
        //     # alternate note on each IT 50Hz 
        //     if ((idxFraction%3) == 0):
        //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]])
        //     elif ((idxFraction%3) == 1):
        //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[1]]])
        //     else:
        //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[2]]])
        //     self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})


        if (tmp_kernel_fraction == 11){
            // self.applyChange({'r10':0, 'r15':0x01});
            curr_frame[R10]     = 0;        // "AmplitudeA",
            curr_frame[R15]     = 0x01;     // "EnvelopeShapeCycle",
        } else {
            // alternate note on each IT 50Hz 
            if ((tmp_kernel_fraction%3) == 0){
                // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]])
                coar            = notePeriodCoarse[currScale[currChord[0]]+octave*12];
                fin             = notePeriodFine[currScale[currChord[0]]+octave*12];

            } else if ((tmp_kernel_fraction%3) == 1){
                // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[1]]])
                coar            = notePeriodCoarse[currScale[currChord[1]]+octave*12];
                fin             = notePeriodFine[currScale[currChord[1]]+octave*12];
            } else {
                // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[2]]])
                coar            = notePeriodCoarse[currScale[currChord[2]]+octave*12];
                fin             = notePeriodFine[currScale[currChord[2]]+octave*12];
            }
            // self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})
            curr_frame[R0]      = fin; // "ToneAFine",
            curr_frame[R1]      = coar; // "ToneACoarse",
            curr_frame[R10]     = 16;        // "AmplitudeA",
            curr_frame[R15]     = 0xFF;     // "EnvelopeShapeCycle",
        }
}
void myFraction (void) {
    // if (tmp_kernel_fraction%6 == 0):
    //     if (self.eucl.pulse() == "Pulse"):
    //         // Only play note of the chord on main tempo
    //         if (idxFraction == 0):
    //             idxNote = self.currChord[random.randrange (len(self.currChord))]
    //             currNote = self.currScale[idxNote]
    //         else:
    //             currNote = self.currScale[random.randrange(len(self.currScale))]
    //         [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
            
    //         self.applyChange({'r4': fin, 'r5': coar, 'r12':15})
    //     else:
    //         self.applyChange({'r12':max(0,self.curr_frame['r12']-1)})

    if (tmp_kernel_fraction%6 == 0){
        if (pulseEuclid1() != 0){
            // Only play note of the chord on main tempo
            if (tmp_kernel_fraction == 0){
                // idxNote = self.currChord[random.randrange (len(self.currChord))]
                // currNote = self.currScale[idxNote]
                idxNote     = currChord[randrange (0,2)];
                currNote    = currScale[idxNote];
            } else {
                // currNote = self.currScale[random.randrange(len(self.currScale))]
                currNote    = currScale[randrange (0,6)];
            }
            // [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
            coar            = notePeriodCoarse[currScale[currChord[0]]+octave*12];
            fin             = notePeriodFine[currScale[currChord[0]]+octave*12];
            
            // applyChange({'r4': fin, 'r5': coar, 'r12':15})
            curr_frame[R4]      = fin; // "ToneCFine",
            curr_frame[R5]      = coar; // "ToneCCoarse",
            curr_frame[R12]     = 15; // "AmplitudeC",
        } else {
            // applyChange({'r12':max(0,self.curr_frame['r12']-1)})
            curr_frame[R12]     = (curr_frame[R12] != 0)?curr_frame[R12]-1:0; // "AmplitudeC",
        }
    }


}
void myBeat (void) {
        // if ((idxBeat != 0) and (idxBeat%4 == 0)):
        //     self.currIdxInCadence = (self.currIdxInCadence + 1)%4
        //     self.currChord = music.chords[self.currCadence[self.currIdxInCadence]]
        // if (idxBeat%4 == 0):
        //     [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
        //     self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
        //     nbNoteInBar = random.randrange(2, 7)
        //     self.eucl = euclid.Eucl(nbNoteInBar,8,0)

        // #  0x9C = 1000000//(400*16)
        // #list_frame.append({'r0': 0x9C, 'r1': 0, 'r7': 0xFE, 'r10':16, 'r13':0xE4, 'r14':0x18, 'r15':0})
        // self.applyChange({'r7': 0xF8, 'r10':16, 'r13':0x42, 'r14':0x0f, 'r15':0xFF})

        if ((tmp_kernel_beat != 0) && (tmp_kernel_beat%4 == 0)){
            currIdxInCadence = (currIdxInCadence + 1)%4;
            currChord = chords[currCadence[currIdxInCadence]];
        }

        if (tmp_kernel_beat%4 == 0){

            // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
            coar            = notePeriodCoarse[currScale[currChord[0]]+octave*12];
            fin             = notePeriodFine[currScale[currChord[0]]+octave*12];

            // self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
            curr_frame[R2]      = fin;      // "ToneBFine",
            curr_frame[R3]      = coar;     // "ToneBCoarse",
            curr_frame[R11]     = 0x0E;     // "AmplitudeB",

            // TODO  nbNoteInBar = random.randrange(2, 7)
            // self.eucl = euclid.Eucl(nbNoteInBar,8,0)
            nbNoteInBar = randrange(2, 7);
            initEuclid1(nbNoteInBar,8,0);
        }
        // self.applyChange({'r7': 0xF8, 'r10':16, 'r13':0x42, 'r14':0x0f, 'r15':0xFF})
        curr_frame[R7]      = (unsigned char)0xF8; // "Mixer",
        curr_frame[R10]     = 16;// "AmplitudeA",
        // curr_frame[R11]     = 0;// "AmplitudeB",
        // curr_frame[R12]     = 0; // "AmplitudeC",
        curr_frame[R13]     = 0x42; // "EnvelopeFine",
        curr_frame[R14]     = 0x0f;// "EnvelopeCoarse",
        curr_frame[R15]     = 0;// "EnvelopeShapeCycle",

}

unsigned char randrange(unsigned char rmin, unsigned char rmax ){
    return (unsigned char) (getRand() % (rmax - rmin + 1))+rmin;
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
	initRand(deek(0x276));
	for (ii=0; ii< 2000; ii++){
		if ((k = key()) == 'Q') break;
        else if (k == '+') setTempo(getTempo()+1);
        else if (k == '-') setTempo(getTempo()-1);
		else if (k == 'N') note();
		else if (k == 'P') {
			simuSetTempo(getTempo());
			playScore();
		} else if (k != 0) printf("%c %d \n",k,( unsigned char ) k);
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
		// sprintf(message, "%d  %d  ",getTempo(), nbE_keybuf);
		sprintf(message, "%d  %d  ",current_frame_read, current_frame_write);
		AdvancedPrint(30,0,message);

		// dump_matrix();

	}

	kernelEnd();

}
