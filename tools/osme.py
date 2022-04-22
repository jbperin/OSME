NB_INT_PER_MINUTE = 6000

class OSME:
    def __init__(self,):
        self.kernel_fraction    = 0
        self.kernel_beat        = 0

        self.kernel_cs          = 0
        self.kernel_s           = 0

        self.kernel_tempo       = 100
        self.first              = True
        self.kernel_bfpm        = self.kernel_tempo * 12
        self.kernel_tempo_err   = NB_INT_PER_MINUTE
        self.FlipFlop50hz       = 0
        self.fraction_callback  = None
        self.beat_callback      = None
        self.t50hz_callback     = None

    def regFractionCallback(self,fraction_callback):
        self.fraction_callback = fraction_callback
    def regBeatCallback(self,beat_callback):
        self.beat_callback = beat_callback
    def regT50HzCallback(self,t50hz_callback):
        self.t50hz_callback = t50hz_callback

    def _task_beat(self,):
        if (self.beat_callback): self.beat_callback(self.kernel_beat)
        self.kernel_beat        += 1

    def _task_fraction(self,):
        if (self.fraction_callback): self.fraction_callback(self.kernel_beat, self.kernel_fraction)
        self.kernel_fraction += 1
        if (self.kernel_fraction == 12):
            self.kernel_fraction = 0
            self._task_beat()

    def _task_1Hz(self,):
        pass

    def _task_50Hz(self,):
        if (self.t50hz_callback): self.t50hz_callback(self.kernel_beat, self.kernel_fraction)

    def _task_25Hz(self,):
        pass

    def setTempo (self,tempo_bpm):
        self.kernel_tempo = tempo_bpm
        self.kernel_bfpm = tempo_bpm * 12

    def getTempo (self,):
        return self.kernel_tempo

    def pulse (self,):
        if (self.first):
            self._task_fraction()
            self._task_beat()
            self.first = False
        self.kernel_tempo_err -= self.kernel_bfpm
        if (2*self.kernel_tempo_err < self.kernel_bfpm):
            self.kernel_tempo_err += NB_INT_PER_MINUTE
            self._task_fraction()
            
    def pulse100ms(self,):
        self.pulse()
        self.kernel_cs += 1
        if(self.kernel_cs == 100):
            self.kernel_cs = 0
            self._task_1Hz()
            self._task_50Hz()
            self._task_25Hz()
        else:
            self.FlipFlop50hz = (self.FlipFlop50hz + 1)%2
            if (self.FlipFlop50hz != 0):
                self._task_50Hz()
                self._task_25Hz()
            else:
                if (self.kernel_cs % 4 == 0):
                    self._task_25Hz()

def main ():

    theOSME = OSME()
    theOSME.setTempo(240)

    def beat(idxBeat):
        print (f"beat {idxBeat}")

    def fraction(idxBeat, idxFraction):
        print (f"fraction {idxBeat}.{idxFraction}")

    def t50hz(idxBeat, idxFraction):
        print (f"t50 {idxBeat}.{idxFraction}")

    theOSME.regBeatCallback(beat)
    theOSME.regFractionCallback(fraction)
    theOSME.regT50HzCallback(t50hz)

    for i in range(200):
        print (i)
        theOSME.pulse100ms()

if __name__ == '__main__':
    main()
