

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
            coar            = notePeriodCoarse[currNote+octave*12];
            fin             = notePeriodFine[currNote+octave*12];
            
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
