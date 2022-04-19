import matplotlib.pyplot as plt
import logging

format = "%(asctime)s: %(message)s"
logging.basicConfig(format=format, level=logging.INFO,
                    datefmt="%H:%M:%S")


START_CHAN_A    = 12 # 9
START_CHAN_B    = 12 # 12
START_CHAN_C    = 12 # 15

#FILENAME = 'util/shrtsmp_u8_4k.wav' # 'util/loop_mono_8k_u8pcm.wav' # 
#OUTPUT_FILENAME = "util/OutVal3.py"

#FILENAME = 'util/one-step_4k_u8pcm.wav' # 'util/loop_mono_8k_u8pcm.wav' # 
#OUTPUT_FILENAME = "util/OneStep.py"

#FILENAME = 'util/Welcome_8k_u8pcm.wav'
#OUTPUT_FILENAME = "util/Welcome.py"

#FILENAME = 'util/LetItWhip_8k_u8pcm.wav'
#OUTPUT_FILENAME = "util/LetItWhip.py"

#FILENAME = 'util/SuperFreak_8k_u8pcm.wav'
#OUTPUT_FILENAME = "util/SuperFreak.py"

#FILENAME = 'util/one-step_4k_u8pcm.wav'
#OUTPUT_FILENAME = "util/OneStep.py"

FILENAME = 'util/TheLargeMemory_8k_u8pcm.wav'
OUTPUT_FILENAME = "util/TheLargeMemory.py"

# Your new sampling rate
new_rate = 4000 # 8000 #

FREQUENCE_PROCESSEUR = 1000000

NB_CYCLE_01 = 2
NB_CYCLE_02 = 51
NB_CYCLE_03 = 51

DELAY_01 = NB_CYCLE_02/FREQUENCE_PROCESSEUR 
DELAY_02 = NB_CYCLE_03/FREQUENCE_PROCESSEUR 

MAX_LEVEL = 2.225
NB_VAL = 16

def extractValueSet2(model):
    allval = []
    for li in model:
        allval.extend(li)
    return (list(set(allval)))

def extractValueSet3(model):
    allval = []
    for li in model:
        for li2 in li:
            allval.extend(li2)
    return allval


tab2 = [[ (j, i) for i in range(j, NB_VAL)] for j in range (NB_VAL)]
S2 = extractValueSet2(tab2)
S2.sort(key=lambda val: val[0]*NB_VAL+val[1])
# print (S2)
I2 = [NB_VAL*i+j for (i,j) in S2]


tab3 = [[[ (k, j, i) for i in range(j, NB_VAL)] for j in range (k, NB_VAL)] for k in range (NB_VAL)]
S3 = extractValueSet3(tab3)
S3.sort(key=lambda val: val[0]*NB_VAL*NB_VAL+val[1]*NB_VAL+val[2])
#print (S3)
I3 = [NB_VAL*NB_VAL*i+NB_VAL*j+k for (i,j,k) in S3]
#print (I3)

nxtS3 = []
for ii in range(len(S3)):
    nxtS3.append([0]*3*16)
    (a, b, c) = S3[ii]
    for inp in range (NB_VAL):
        ltmp = sorted([inp, b, c])
        ins = NB_VAL*NB_VAL*ltmp[0] + NB_VAL*ltmp[1] + ltmp[2]
        nxtS3[-1][inp] = I3.index(ins)

        ltmp = sorted([a, inp, c])
        ins = NB_VAL*NB_VAL*ltmp[0] + NB_VAL*ltmp[1] + ltmp[2]
        nxtS3[-1][inp+16] = I3.index(ins)

        ltmp = sorted([a, b, inp])
        ins = NB_VAL*NB_VAL*ltmp[0] + NB_VAL*ltmp[1] + ltmp[2]
        nxtS3[-1][inp+32] = I3.index(ins)

vol = [2**((x-15)/2) for x in range (NB_VAL)]
vol [0] = 0

curV3 = []
for i in range(len(S3)):
    curV3.append([0]*3*16)
    for inp in range (NB_VAL):
        curV3[-1][inp]      = sum([vol [v] for v in list(S3[nxtS3[i][inp]])])
        curV3[-1][inp+16]   = sum([vol [v] for v in list(S3[nxtS3[i][inp+16]])])
        curV3[-1][inp+32]   = sum([vol [v] for v in list(S3[nxtS3[i][inp+32]])])
# print (len(nxtS3), len(curV3[0]))

import soundfile as sf
from scipy import signal, interpolate
import numpy as np

logging.info  ("READ SOUND FILE")

data, samplerate = sf.read(FILENAME) #,dtype='int16'

nb_sample = len(data)
period = 1.0/samplerate
duration = nb_sample*period
# print (samplerate, nb_sample, duration)
# print (min(data), max(data))
data = (data-min(data))/(max(data)-min(data)) * MAX_LEVEL;

logging.info  ("RESAMPLE SOUND")

# Resample data
new_number_of_samples = round(nb_sample * float(new_rate) / samplerate)
new_data = signal.resample(data, new_number_of_samples)

origtimes = np.linspace(0, duration, new_number_of_samples, endpoint=True)
#print (len(origtimes), origtimes)
#print (len(new_data))

sound_interpolate = interpolate.interp1d(origtimes, new_data)

#print (data)

logging.info  ("INTERPOLATE SOUND SAMPLE")

new_times=[0]
for tim in origtimes[1:]:
    new_times.append (tim - DELAY_01 - DELAY_02)
    new_times.append (tim - DELAY_01)
    new_times.append (tim)

tp = FREQUENCE_PROCESSEUR / new_rate # 447;   #   3 PSG transitions per sample: put here the tp of your replayer 
dt1 = (NB_CYCLE_02+NB_CYCLE_01+NB_CYCLE_03)/tp;
dt2 = (NB_CYCLE_02+NB_CYCLE_03)/tp;
dt3 = 1-dt1-dt2;
dt = [dt1, dt2, dt3];

np_new_times = np.array(new_times)

# print (np_new_times)
# print (len(new_times))

new_sig_data = sound_interpolate(np_new_times)
# print (len(new_sig_data))



logging.info  ("VITERBI ENCODE SOUND")


L  = [0] * len(S3);
# St = uint16(ones(Ns,1));
# It = uint8(ones(Ns,1));
St = [1] * len(S3)
It = [1] * len(S3)
Stt = [[0] * len(np_new_times) for i in range (len(S3))] # uint16(zeros(Ns,N));
Itt = [[0] * len(np_new_times) for i in range (len(S3))] # uint8(zeros(Ns,N));

logging.info  ("FORWARD ")
import math
for t in range(len(np_new_times)):
    Ln = [math.inf]*len(S3);
    for cs in range (len(S3)):
        for In in range (len(curV3[0])):
            # cv = curV(cs+1,in+1);
            currV = curV3[cs][In]
            # ns = double(nxtS(cs+1,in+1));
            ns = nxtS3[cs][In]
            # Ltst = L(cs+1)+dt(mod(t-1,3)+1)*abs(x(t)-cv)^2;
            Ltst = L[cs]+dt[t%3]*abs(new_sig_data[t]-currV)**2;

            # if  Ln(ns+1) >= Ltst
            #     Ln(ns+1) = Ltst;
            #     St(ns+1) = cs;
            #     It(ns+1) = in;
            # end
            #print (currV, ns, Ltst)
            if Ln[ns] >= Ltst:
                Ln[ns] = Ltst
                St[ns] = cs
                It[ns] = In
    L = Ln.copy();
    for ii in range (len (St)):
        Stt[ii][t] = St[ii];
        Itt[ii][t] = It[ii];


# print ("L =" , L)



logging.info  ("BACKWARD ")

# P = uint16(zeros(1,N));
# I = uint8(zeros(1,N));
P = [1] * len(np_new_times)
I = [1] * len(np_new_times)

import operator
i, l = min(enumerate(L), key=operator.itemgetter(1))
# print (i, l)
P[len(np_new_times)-1] = Stt[i][len(np_new_times)-1]
I[len(np_new_times)-1] = Itt[i][len(np_new_times)-1]


# for t = (N-1):-1:1
#    P(t) = Stt(double(P(t+1))+1,t);
#    I(t) = Itt(double(P(t+1))+1,t);
# end

for t in range (len(np_new_times)-2,0, -1):
    P[t] = Stt[P[t+1]][t]#Stt[2][t] #
    I[t] = Itt[P[t+1]][t]#Itt[2][t] #


logging.info  ("GENERATING OUTPUT")

# V = zeros(1,N);
# for t = 1:N
#     V(t) = curV(double(P(t))+1,double(I(t))+1); 
# end

V = [0] * len(np_new_times)
for t in range (len(np_new_times)):
    V[t] = curV3[P[t]][I[t]] 

# print (V)

Out = [(0,0)] * len(I)
S=[START_CHAN_A, START_CHAN_B, START_CHAN_C]
for t in range (len(np_new_times)):
    idxs = [i[0] for i in sorted(enumerate(S), key=lambda x:x[1])]
    if (I[t] <= 15):
        idx = idxs[0]
        S[idx] = I[t]
        Out[t] = (idx, S[idx])
    elif (I[t] <= 31):
        idx = idxs[1]
        S[idx] = I[t]-16
        Out[t] = (idx, S[idx])
    else:
        idx = idxs[2]
        S[idx] = I[t]-32
        Out[t] = (idx, S[idx])

if (1 == 1):
        
    logging.info ("PLOT RESULT")

    plt.figure(1)
    plt.title("loop")
    plt.plot(data, '-o')

    plt.figure(2)
    plt.plot(origtimes, new_data, '-o')

    plt.figure(3)
    plt.plot(new_times, new_sig_data, '-o' )

    plt.figure(4)
    plt.plot(new_times, V, '-o' )
    plt.show()


logging.info ("SAVE OUPUT")

with open (OUTPUT_FILENAME, "w") as f:
    f.write("Out = " + str(Out))


print ("END")