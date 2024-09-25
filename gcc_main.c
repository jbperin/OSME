#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "config.h"
unsigned char current_frame_write;
unsigned char current_frame_read;
unsigned char current_end_write;
unsigned char ay_score[NB_REGISTER*NB_SAMPLE];     // 1 second = 50 frames/sec * 14 register/frame

unsigned char *ptr_Write_Reg0 ;
unsigned char *ptr_Write_Reg1 ;
unsigned char *ptr_Write_Reg2 ;
unsigned char *ptr_Write_Reg3 ;
unsigned char *ptr_Write_Reg4 ;
unsigned char *ptr_Write_Reg5 ;
unsigned char *ptr_Write_Reg6 ;
unsigned char *ptr_Write_Reg7 ;
unsigned char *ptr_Write_Reg10;
unsigned char *ptr_Write_Reg11;
unsigned char *ptr_Write_Reg12;
unsigned char *ptr_Write_Reg13;
unsigned char *ptr_Write_Reg14;
unsigned char *ptr_Write_Reg15;

unsigned char *ptr_Read__Reg0 ;
unsigned char *ptr_Read__Reg1 ;
unsigned char *ptr_Read__Reg2 ;
unsigned char *ptr_Read__Reg3 ;
unsigned char *ptr_Read__Reg4 ;
unsigned char *ptr_Read__Reg5 ;
unsigned char *ptr_Read__Reg6 ;
unsigned char *ptr_Read__Reg7 ;
unsigned char *ptr_Read__Reg10;
unsigned char *ptr_Read__Reg11;
unsigned char *ptr_Read__Reg12;
unsigned char *ptr_Read__Reg13;
unsigned char *ptr_Read__Reg14;
unsigned char *ptr_Read__Reg15;


void initAyScore(void) {
    current_frame_read = 0;     //    .dsb 1
    current_frame_write = 0;        //   .dsb 1
    // current_frame_read = 0;       //  .dsb 1
    // current_frame_write = 0;      // .dsb 1
    // current_group_write = 0;

    ptr_Read__Reg0 = ay_score+ 0 * NB_SAMPLE;
    ptr_Read__Reg1 = ay_score+ 1 * NB_SAMPLE;
    ptr_Read__Reg2 = ay_score+ 2 * NB_SAMPLE;
    ptr_Read__Reg3 = ay_score+ 3 * NB_SAMPLE;
    ptr_Read__Reg4 = ay_score+ 4 * NB_SAMPLE;
    ptr_Read__Reg5 = ay_score+ 5 * NB_SAMPLE;
    ptr_Read__Reg6 = ay_score+ 6 * NB_SAMPLE;
    ptr_Read__Reg7 = ay_score+ 7 * NB_SAMPLE;
    ptr_Read__Reg10 = ay_score+ 8 * NB_SAMPLE;
    ptr_Read__Reg11 = ay_score+ 9 * NB_SAMPLE;
    ptr_Read__Reg12 = ay_score+ 10* NB_SAMPLE;
    ptr_Read__Reg13 = ay_score+ 11* NB_SAMPLE;
    ptr_Read__Reg14 = ay_score+ 12* NB_SAMPLE;
    ptr_Read__Reg15 = ay_score+ 13* NB_SAMPLE;

    ptr_Write_Reg0 = ay_score+ 0 * NB_SAMPLE;
    ptr_Write_Reg1 = ay_score+ 1 * NB_SAMPLE;
    ptr_Write_Reg2 = ay_score+ 2 * NB_SAMPLE;
    ptr_Write_Reg3 = ay_score+ 3 * NB_SAMPLE;
    ptr_Write_Reg4 = ay_score+ 4 * NB_SAMPLE;
    ptr_Write_Reg5 = ay_score+ 5 * NB_SAMPLE;
    ptr_Write_Reg6 = ay_score+ 6 * NB_SAMPLE;
    ptr_Write_Reg7 = ay_score+ 7 * NB_SAMPLE;
    ptr_Write_Reg10 = ay_score+ 8 * NB_SAMPLE;
    ptr_Write_Reg11 = ay_score+ 9 * NB_SAMPLE;
    ptr_Write_Reg12 = ay_score+ 10* NB_SAMPLE;
    ptr_Write_Reg13 = ay_score+ 11* NB_SAMPLE;
    ptr_Write_Reg14 = ay_score+ 12* NB_SAMPLE;
    ptr_Write_Reg15 = ay_score+ 13* NB_SAMPLE;

}


#include "music.c"

#include "simu_it.c"

#include "score.c"

#include "euclid.c"

unsigned char randrange(unsigned char rmin, unsigned char rmax );
unsigned char randrange(unsigned char rmin, unsigned char rmax ){
    return (unsigned char) (rand() % (rmax - rmin + 1))+rmin;
}

#include "compose.c"



// void initMusic(void) {
//     currTonality        = 0;
//     currScale           = scales[currTonality];
//     currCadence         = theCadence;
//     currIdxInCadence    = 0;
//     currChord           = chords[currCadence[currIdxInCadence]];

// }
// void myIt50Hz (void) {
//         // if (idxFraction == 11):
//         //     self.applyChange({'r10':0, 'r15':0x01})
//         // else:
//         //     # alternate note on each IT 50Hz 
//         //     if ((idxFraction%3) == 0):
//         //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]])
//         //     elif ((idxFraction%3) == 1):
//         //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[1]]])
//         //     else:
//         //         [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[2]]])
//         //     self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})


//         if (tmp_kernel_fraction == 11){
//             // self.applyChange({'r10':0, 'r15':0x01});
//             curr_frame[R10]     = 0;        // "AmplitudeA",
//             curr_frame[R15]     = 0x01;     // "EnvelopeShapeCycle",
//         } else {
//             // alternate note on each IT 50Hz 
//             if ((tmp_kernel_fraction%3) == 0){
//                 // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]])
//                 coar            = notePeriodCoarse[currScale[currChord[0]]+octave*12];
//                 fin             = notePeriodFine[currScale[currChord[0]]+octave*12];

//             } else if ((tmp_kernel_fraction%3) == 1){
//                 // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[1]]])
//                 coar            = notePeriodCoarse[currScale[currChord[1]]+octave*12];
//                 fin             = notePeriodFine[currScale[currChord[1]]+octave*12];
//             } else {
//                 // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[2]]])
//                 coar            = notePeriodCoarse[currScale[currChord[2]]+octave*12];
//                 fin             = notePeriodFine[currScale[currChord[2]]+octave*12];
//             }
//             // self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})
//             curr_frame[R0]      = fin; // "ToneAFine",
//             curr_frame[R1]      = coar; // "ToneACoarse",
//             curr_frame[R10]     = 16;        // "AmplitudeA",
//             curr_frame[R15]     = 0xFF;     // "EnvelopeShapeCycle",
//         }
// }
// void myFraction (void) {
//     // if (tmp_kernel_fraction%6 == 0):
//     //     if (self.eucl.pulse() == "Pulse"):
//     //         // Only play note of the chord on main tempo
//     //         if (idxFraction == 0):
//     //             idxNote = self.currChord[random.randrange (len(self.currChord))]
//     //             currNote = self.currScale[idxNote]
//     //         else:
//     //             currNote = self.currScale[random.randrange(len(self.currScale))]
//     //         [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
            
//     //         self.applyChange({'r4': fin, 'r5': coar, 'r12':15})
//     //     else:
//     //         self.applyChange({'r12':max(0,self.curr_frame['r12']-1)})

//     if (tmp_kernel_fraction%6 == 0){
//         if (pulseEuclid1() != 0){
//             // Only play note of the chord on main tempo
//             if (tmp_kernel_fraction == 0){
//                 // idxNote = self.currChord[random.randrange (len(self.currChord))]
//                 // currNote = self.currScale[idxNote]
//                 idxNote     = currChord[randrange (0,2)];
//                 currNote    = currScale[idxNote];
//             } else {
//                 // currNote = self.currScale[random.randrange(len(self.currScale))]
//                 currNote    = currScale[randrange (0,6)];
//             }
//             // [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
//             coar            = notePeriodCoarse[currScale[currNote]+(octave+1)*12];
//             fin             = notePeriodFine[currScale[currNote]+(octave+1)*12];
            
//             // applyChange({'r4': fin, 'r5': coar, 'r12':15})
//             curr_frame[R4]      = fin; // "ToneCFine",
//             curr_frame[R5]      = coar; // "ToneCCoarse",
//             curr_frame[R12]     = 15; // "AmplitudeC",
//         } else {
//             // applyChange({'r12':max(0,self.curr_frame['r12']-1)})
//             curr_frame[R12]     = (curr_frame[R12] != 0)?curr_frame[R12]-1:0; // "AmplitudeC",
//         }
//     }


// }
// void myBeat (void) {
//         // if ((idxBeat != 0) and (idxBeat%4 == 0)):
//         //     self.currIdxInCadence = (self.currIdxInCadence + 1)%4
//         //     self.currChord = music.chords[self.currCadence[self.currIdxInCadence]]
//         // if (idxBeat%4 == 0):
//         //     [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
//         //     self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
//         //     nbNoteInBar = random.randrange(2, 7)
//         //     self.eucl = euclid.Eucl(nbNoteInBar,8,0)

//         // #  0x9C = 1000000//(400*16)
//         // #list_frame.append({'r0': 0x9C, 'r1': 0, 'r7': 0xFE, 'r10':16, 'r13':0xE4, 'r14':0x18, 'r15':0})
//         // self.applyChange({'r7': 0xF8, 'r10':16, 'r13':0x42, 'r14':0x0f, 'r15':0xFF})

//         if ((tmp_kernel_beat != 0) && (tmp_kernel_beat%4 == 0)){
//             currIdxInCadence = (currIdxInCadence + 1)%4;
//             currChord = chords[currCadence[currIdxInCadence]];
//         }

//         if (tmp_kernel_beat%4 == 0){

//             // [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
//             coar            = notePeriodCoarse[currScale[currChord[0]]+(octave-1)*12];
//             fin             = notePeriodFine[currScale[currChord[0]]+(octave-1)*12];

//             // self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
//             curr_frame[R2]      = fin;      // "ToneBFine",
//             curr_frame[R3]      = coar;     // "ToneBCoarse",
//             curr_frame[R11]     = 0x0E;     // "AmplitudeB",

//             // TODO  nbNoteInBar = random.randrange(2, 7)
//             // self.eucl = euclid.Eucl(nbNoteInBar,8,0)
//             nbNoteInBar = randrange(2, 7);
//             initEuclid1(nbNoteInBar,8,0);
//         }
//         // self.applyChange({'r7': 0xF8, 'r10':16, 'r13':0x42, 'r14':0x0f, 'r15':0xFF})
//         curr_frame[R7]      = (unsigned char)0xF8; // "Mixer",
//         curr_frame[R10]     = 16;// "AmplitudeA",
//         // curr_frame[R11]     = 0;// "AmplitudeB",
//         // curr_frame[R12]     = 0; // "AmplitudeC",
//         curr_frame[R13]     = 0x42; // "EnvelopeFine",
//         curr_frame[R14]     = 0x0f;// "EnvelopeCoarse",
//         curr_frame[R15]     = 0;// "EnvelopeShapeCycle",

// }


int  main (int argc, char *argv[]){
    unsigned char ii;
    unsigned char nbNoteInBar;
    printf ("coucou\n");
    srand( time( NULL ) );
    simuInit();
    simuSetTempo(120);

    for (ii=0; ii< 10; ii++){
        nbNoteInBar = randrange(2, 7);

        printf ("rand = %d\n",nbNoteInBar);
    }
    fraction_callback       = myFraction;
    beat_callback           = myBeat;
    t50hz_callback          = myIt50Hz;

    initCurrentFrame();
    initAyScore    ();
    initMusic  ();
    
    for (ii = 0; ii < 100; ii++) {
        if (ii % 2 == 0) {
            printf ("\n%d %d %d %d ",tmp_kernel_s, tmp_kernel_cs, tmp_kernel_beat, tmp_kernel_fraction);
            stepWriteScore();
        }
        pulse100ms();
    }
    // initEuclid1 (3,8,0);
    // for (ii = 0; ii < 12; ii++) {
    //     printf ("\ntick %d %d", ii, pulseEuclid1 ());
    // }
}