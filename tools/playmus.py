import winsound
import threading
import time
import music
import random
import euclid
from timeloop import Timeloop
from datetime import timedelta

NB_INT_PER_MINUTE = 6000


tonality = "C"
currScale = music.scales[tonality]
print (f"{currScale}")

numCadence = random.randrange(len(music.cadences))
cadence = music.cadences[numCadence]
print (f"cadence {numCadence} = {str(cadence)}")
for numChord in cadence:
    print (music.chords[numChord])

eucl = euclid.Eucl(6,8,0)
idxInCadence = 0
##def playSound(freq_in_hz, duration_in_ms):
##    if (eucl.pulse() == "Pulse"):
##        winsound.Beep(freq_in_hz, duration_in_ms)

def sound(freq_in_hz, duration_in_ms):
        threading.Thread(target=winsound.Beep, name="beeper", args=(freq_in_hz, duration_in_ms)).start()

    

class OSME:
    def __init__(self,):
        self.kernel_fraction    = 0
        self.kernel_beat        = 0

        self.kernel_cs          = 0
        self.kernel_s           = 0

        self.kernel_tempo       = 100

        self.kernel_bfpm        = self.kernel_tempo * 12
        self.kernel_tempo_err   = NB_INT_PER_MINUTE
        self.FlipFlop50hz       = 0
        
    def _task_beat(self,):
        global idxInCadence, currScale
        if (eucl.pulse() == "Pulse"):
            
            currChord = music.chords[cadence[idxInCadence]]
            idxNote = currChord[random.randrange (len(currChord))]
            note = currScale[idxNote]
            print (f"beat = {self.kernel_beat}, measure = {self.kernel_beat//4}, current chord = {str(currChord)}, note = {note}")
            freq = music.notefrequency[note]
            sound(int(freq), 400)
        self.kernel_beat        += 1
        if (self.kernel_beat%4 == 0):
            # sound(440, 40)
            idxInCadence = (idxInCadence +1)%len(cadence)

    def _task_fraction(self,):
        self.kernel_fraction += 1
        if (self.kernel_fraction == 12):
            self.kernel_fraction = 0
            self._task_beat()

    def _task_1Hz(self,):
        # print ("second")
        pass

    def _task_50Hz(self,):
        pass
    def _task_25Hz(self,):
        pass

    def setTempo (self,tempo_bpm):
        self.kernel_tempo = tempo_bpm
        self.kernel_bfpm = tempo_bpm * 12

    def getTempo (self,):
        return self.kernel_tempo

    def pulse (self,):
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

theOSME = OSME()
theOSME.setTempo(200)

tl = Timeloop()


@tl.job(interval=timedelta(milliseconds=10))
def sample_job_every_100ms():
    theOSME.pulse100ms()

#winsound.PlaySound("SystemExit", winsound.SND_ALIAS)

tl.start(block=True)


##tl.start()
##
##while True:
##  try:
##    time.sleep(1)
##  except KeyboardInterrupt:
##    tl.stop()
##    break
