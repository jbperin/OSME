import random

import osme
import music 
import euclid
import ym

Tempo = 120

class MusicGenerator ():

    def __init__(self,):
        self.curr_frame = {
            'r0'  : 0 , # "ToneAFine",
            'r1'  : 0 , # "ToneACoarse",
            'r2'  : 0 , # "ToneBFine",
            'r3'  : 0 , # "ToneBCoarse",
            'r4'  : 0 , # "ToneCFine",
            'r5'  : 0 , # "ToneCCoarse",
            'r6'  : 0 , # "NoiseGenerator",
            'r7'  : 0x3F, # "Mixer",
            'r10' : 0 , # "AmplitudeA",
            'r11' : 0 , # "AmplitudeB",
            'r12' : 0 , # "AmplitudeC",
            'r13' : 0 , # "EnvelopeFine",
            'r14' : 0 , # "EnvelopeCoarse",
            'r15' : 0 , # "EnvelopeShapeCycle",
            'r16' : 0 , # "IOA",
            'r17' : 0 # "IOB",
        }
        self.currTonality = None
        self.currScale = None
        self.currCadence = None
        self.currIdxInCadence = 0
        self.currChord = None
        self.eucl = None
        self.__prepareMusic()

    def applyChange(self, change):
        for ke in change.keys():
            self.curr_frame[ke] = change[ke]

    def freq2register(self, frequency_in_Hz):
        TP=int(1000000/(16*frequency_in_Hz))
        return [TP//256, TP%256]

    def __prepareMusic(self,):

        self.currTonality = list(music.scales.keys())[random.randrange(len(music.scales.keys()))]
        self.currScale = music.scales[self.currTonality]

        print (f"tonality = {self.currTonality}, current scale = {self.currScale}")

        numCadence = random.randrange(len(music.cadences))
        self.currCadence = music.cadences[numCadence]
        print (f"current cadence {numCadence} = {str(self.currCadence)}")
        print ("chords are : ")
        for numChord in self.currCadence:
            print (music.chords[numChord])
        self.currIdxInCadence = 0
        self.currChord = music.chords[self.currCadence[self.currIdxInCadence]]

    def getFrame (self,):
        return self.curr_frame

    def beat(self, idxBeat):        
        pass

    def fraction(elf, idxBeat, idxFraction):    
        pass

    def t50hz(self, idxBeat, idxFraction):
        pass 

class BasicGenerator(MusicGenerator):
    def __init__(self,):
        super().__init__()
        nbNoteInBar = random.randrange(2, 7)
        self.eucl = euclid.Eucl(nbNoteInBar,8,0)

    def beat(self, idxBeat):
        if ((idxBeat != 0) and (idxBeat%4 == 0)):
            self.currIdxInCadence = (self.currIdxInCadence + 1)%4
            self.currChord = music.chords[self.currCadence[self.currIdxInCadence]]
        if (idxBeat%4 == 0):
            [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
            self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
            nbNoteInBar = random.randrange(2, 7)
            self.eucl = euclid.Eucl(nbNoteInBar,8,0)

        #  0x9C = 1000000//(400*16)
        #list_frame.append({'r0': 0x9C, 'r1': 0, 'r7': 0xFE, 'r10':16, 'r13':0xE4, 'r14':0x18, 'r15':0})
        self.applyChange({'r7': 0xF8, 'r10':16, 'r13':0x42, 'r14':0x0f, 'r15':0xFF})

    def fraction(self,idxBeat, idxFraction):

        if (idxFraction%6 == 0):
            if (self.eucl.pulse() == "Pulse"):
                # Only play note of the chord on main tempo
                if (idxFraction == 0):
                    idxNote = self.currChord[random.randrange (len(self.currChord))]
                    currNote = self.currScale[idxNote]
                else:
                    currNote = self.currScale[random.randrange(len(self.currScale))]
                [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
                
                self.applyChange({'r4': fin, 'r5': coar, 'r12':15})
            else:
                self.applyChange({'r12':max(0,self.curr_frame['r12']-1)})

    def t50hz(self, idxBeat, idxFraction):
        # print (f"t50 {idxBeat}.{idxFraction}")
        # On last fraction before new beat, we silence sound using envoloppe to prepare next note
        if (idxFraction == 11):
            self.applyChange({'r10':0, 'r15':0x01})
        else:
            # alternate note on each IT 50Hz 
            if ((idxFraction%3) == 0):
                [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]])
            elif ((idxFraction%3) == 1):
                [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[1]]])
            else:
                [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[2]]])
            self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})

class ArpeggioGenerator(MusicGenerator):
    def __init__(self,):
        super().__init__()
        nbNoteInBar = random.randrange(2, 7)
        self.eucl = euclid.Eucl(nbNoteInBar,8,0)
        self.listIdx = [0, 1, 2, 1]
        self.idxInIdxList = 0
        self.listIdx[self.idxInIdxList]

    def beat(self, idxBeat):
        if ((idxBeat != 0) and (idxBeat%4 == 0)):
            self.currIdxInCadence = (self.currIdxInCadence + 1)%4
            self.currChord = music.chords[self.currCadence[self.currIdxInCadence]]
        if (idxBeat%4 == 0):
            [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[0]]]//2)
            self.applyChange({'r2': fin, 'r3': coar, 'r11':14})
            nbNoteInBar = random.randrange(2, 7)
            self.eucl = euclid.Eucl(nbNoteInBar,8,0)

        #  0x9C = 1000000//(400*16)
        #list_frame.append({'r0': 0x9C, 'r1': 0, 'r7': 0xFE, 'r10':16, 'r13':0xE4, 'r14':0x18, 'r15':0})
        self.applyChange({'r7': 0xF8, 'r13':0x42, 'r14':0x0f})

    def fraction(self,idxBeat, idxFraction):

        if (idxFraction%6 == 0):
            if (self.eucl.pulse() == "Pulse"):
                # Only play note of the chord on main tempo
                if (idxFraction == 0):
                    idxNote = self.currChord[random.randrange (len(self.currChord))]
                    currNote = self.currScale[idxNote]
                else:
                    currNote = self.currScale[random.randrange(len(self.currScale))]
                [coar, fin] = self.freq2register(music.notefrequency[currNote]*2)
                
                self.applyChange({'r4': fin, 'r5': coar, 'r12':15})
            else:
                self.applyChange({'r12':max(0,self.curr_frame['r12']-1)})
            # alternate note on each half time
            [coar, fin] = self.freq2register(music.notefrequency[self.currScale[self.currChord[self.listIdx[self.idxInIdxList]]]])
            self.idxInIdxList = (self.idxInIdxList+1) % 4
            self.applyChange({'r0': fin, 'r1': coar, 'r10':16,'r15':0xFF})
        elif (idxFraction in [5, 11]):
            self.applyChange({'r10':0, 'r15':0x01})
    def t50hz(self, idxBeat, idxFraction):
        # print (f"t50 {idxBeat}.{idxFraction}")
        # On last fraction before new beat, we silence sound using envoloppe to prepare next note
        if (idxFraction == 11):
            #self.applyChange({'r10':0, 'r15':0x01})
            pass
        else:
            pass

def main ():

    aYM = ym.YM()

    theOSME = osme.OSME()
    theOSME.setTempo(Tempo)

    aYM.header['songTitle'] = "RoyaltyFreeMusic03"
    aYM.header['authorName'] = "Jean-Baptiste PERIN"
    aYM.header['songComment'] = "Music generated by OSME"

    mGenerator = ArpeggioGenerator() # BasicGenerator()

    theOSME.regBeatCallback(mGenerator.beat)
    theOSME.regFractionCallback(mGenerator.fraction)
    theOSME.regT50HzCallback(mGenerator.t50hz)

    #8 bars * 4 beat/bar * 60/TEMPO(bpm) * 100 pulse/sec
    for i in range(int(16*4*(60/Tempo)*100)):
        theOSME.pulse100ms()
        if (i%2 == 0): aYM.addFrame(mGenerator.getFrame())

    aYM.export('C:\\Perso\\myCode\\OSME\\tools\\output.ym')

if __name__ == '__main__':
    main()
