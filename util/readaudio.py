import soundfile as sf
import matplotlib.pyplot as plt
import numpy as np


def getModel():
    # Make data.
    X = np.arange(0, 16, 1)
    Y = np.arange(0, 16, 1)
    X, Y = np.meshgrid(X, Y)
    # np.exp2(-((15-x)/2))
    R = np.exp2(-((15-X)/2)) + np.exp2(-((15-Y)/2))
    Z = np.around(R*255/2)
    return (Z.astype(int))

def extractValueSet(model):
    allval = []
    for li in model:
        allval.extend(li)
    return (list(set(allval)))

def findCombination4Value(model, value):
    valset = extractValueSet(model)
    coordset = extractValueSet(list([[(i , j) for j in range(16)] for i in range(16)]))
    return [(x, y) for (x, y) in coordset if model[x][y] == value]

def findClosestCombination4Value(model, value):
    valset = extractValueSet(model)
    coordset = extractValueSet(list([[(i , j) for j in range(16)] for i in range(16)]))
    closest_distance = min([abs(model[x][y]-value) for (x, y) in coordset])
    # print (closest_distance)

    return [(x, y) for (x, y) in coordset if ((abs(model[x][y] - value) == closest_distance))]

def encodeSampleSequence(model, samples):
    encoded_sig = []
    for samp in samples: 
        # print("finding closest values for sample "+str(samp))
        (x, y) = findClosestCombination4Value(model, samp)[0]
        # print(x, y, model[x][y])
        encoded_sig.append(model[x][y])
    return encoded_sig

def encodeSampleSequence2(model, samples):
    print (samples)
    print("finding closest values from first sample "+str(samples[0]))

    startPossibilities = [(x,y) for (x,y) in findClosestCombination4Value(model, samples[0]) if x<y]
    print (startPossibilities)
    print ([model[x][y] for (x,y) in startPossibilities])

    dfirst = abs(samples[0] - model[startPossibilities[0][0]][startPossibilities[0][1]])
    print("distance on first sample "+str(dfirst))

    level=1

    print("finding closest values of next sample "+str(samples[level]))
    bestNextPossibilities = findClosestCombination4Value(model, samples[level])
    print (bestNextPossibilities)
    #print ([model[x][y] for (x,y) in bestNextPossibilities])


    print("Running through all start possibilities")

    for stPos in startPossibilities:

        print ("Exploring " + str (stPos))

        (cx, cy) = stPos
        listX = model[cx][:]
        listY = model[:][cy]
        #print (listX, listY)

        #minDistOnX = min ([ abs(model[cx][cy]) - for v in listX])
        targetValue = samples[level]
        closestDistanceOnX = min([abs(targetValue-value) for value in listX])
        closestDistanceOnY = min([abs(targetValue-value) for value in listY])
        #print (closestDistanceOnX, closestDistanceOnY)
        listIndexOfClosestValueOnX = [i for i in range(16) if abs(targetValue-listX[i]) == closestDistanceOnX]
        listIndexOfClosestValueOnY = [i for i in range(16) if abs(targetValue-listY[i]) == closestDistanceOnY]
        print (listIndexOfClosestValueOnX, listIndexOfClosestValueOnY)
        nextYStep = [(x, cy) for x in listIndexOfClosestValueOnY]
        nextXStep = [(cx, y) for y in listIndexOfClosestValueOnX]
        print (nextXStep, nextYStep)

        bestNextXStep = []
        for (x, y) in bestNextPossibilities:
            for (xx,yy) in nextYStep:
                if (yy==y)or (xx==x):
                    bestNextXStep.append ((x, y))
            for (xx,yy) in nextXStep:
                if (xx==x) or (yy==y):
                    bestNextXStep.append ((x, y))
        bestNextXStep = list(set(bestNextXStep))
        print (bestNextXStep)

        #dnext = abs(samples[level] - model[startPossibilities[level][0]][startPossibilities[level][1]])
        #print("distance on next sample "+str(dnext))


def main():

    print ("coucou")

    theModel = getModel()

    print (theModel)
    # print (extractValueSet(theModel))
    # coordset = extractValueSet(list([[(i , j) for j in range(16)] for i in range(16)]))
    # print (len(coordset))
    # print (findClosestCombination4Value(theModel, 57))
    # print (findClosestCombination4Value(theModel, 25))
    # print ([theModel[x][y] for (x,y) in findClosestCombination4Value(theModel, 25)])

   



    data, samplerate = sf.read('util/loop_SW.wav',dtype='int16')

    #print (data, samplerate)
    #print (min(data),max(data))

    sample_signal = list(map(lambda x: round((x/512)+64),data[175:205]))

    encodeSampleSequence2(theModel, sample_signal)

    # approx_signal = encodeSampleSequence(theModel, sample_signal)
    # print (sample_signal)
    # print (approx_signal)
    # print (min(sample_signal),max(sample_signal))


    # plt.figure(1)
    # plt.title("loop")
    
    # plt.plot(sample_signal)
    # plt.plot(approx_signal)
    # # plt.figure(2)
    # # plt.plot(np.fromiter(sample_signal, dtype='int16')-np.fromiter(approx_signal, dtype='int16') )
    # plt.show()

if __name__ == '__main__':
    main()
