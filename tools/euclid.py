##for (each step) {
##    bucket = bucket + numberOfPulses
##
##    if (bucket >= totalSteps) {
##        bucket = bucket - totalSteps
##        thisStep = containsPulse
##    }
##
##    else if (bucket < totalSteps) thisStep = noPulse
##}

## algorithme de Bjorklund

class Eucl:
    def __init__(self, steps, pulses, offset):
        self.steps = steps
        self.pulses = pulses
        self.offset = offset
        self.bucket =0
        self.first = True
        #yield "Pulse"
    def pulse (self):
        if (self.first):
           self.first = False
           return "Pulse"
        self.bucket = self.bucket + self.steps
        if self.bucket >= self.pulses:
            self.bucket = self.bucket - self.pulses
            return "Pulse"
        else:
            return "NoPulse"
        
if __name__ == '__main__':
    eucl = Eucl(3,8,0)

    for i in range (12):
        print (i, eucl.pulse())
