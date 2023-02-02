DIMENSION = 16

def transfert(x, y): return round((2**((x-15)/2) + 2**((y-15)/2))*255/2)
#def transfert(x, y): return round(2**x + 2**y)

tabModel = [[transfert(x, y) for x in range (DIMENSION)] for y in range(DIMENSION)]
leModel = tabModel

def extractValueSet(model):
    allval = []
    for li in model:
        allval.extend(li)
    return (list(set(allval)))

tabCombination = extractValueSet([[(i , j) for j in range(DIMENSION)] for i in range(DIMENSION)])

def findCombination4Value(model, value):
    # valset = extractValueSet(model)
    # coordset = extractValueSet(list([[(i , j) for j in range(DIMENSION)] for i in range(DIMENSION)]))
    return [(x, y) for (x, y) in tabCombination if model[x][y] == value]

def findClosestCombination4Value(model, value):
    closest_distance = min([abs(model[x][y]-value) for (x, y) in tabCombination])
    res = [(x, y) for (x, y) in tabCombination if ((abs(model[x][y] - value) == closest_distance))]
    return res

def findClosestPossibleCombination4Value(state, model, value):
    (xs, ys) = state
    closest_distance = min([abs(model[x][y]-value) for (x, y) in tabCombination if ((x >= xs) and (y >= ys)) or ((x <= xs) and (y <= ys))])
    res = [(x, y) for (x, y) in tabCombination if ((abs(model[x][y] - value) == closest_distance))]
    return res

import math 
lesSamples = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
etatActuel = (0,0)
meilleure_distance = math.inf
meilleur_chemin = []
def recur (niveau_actuel, nb_niveau, distance_actuelle, chemin):
    global lesSamples, etatActuel, meilleure_distance, meilleur_chemin
    #print ("".join(["\t"]*niveau_actuel) + " %d %s"%(distance_actuelle, str(chemin)))
    prochain_echantillon = lesSamples[niveau_actuel]
    # liste_possibilites = findClosestCombination4Value(leModel, lesSamples[niveau_actuel])
    liste_possibilites = findClosestPossibleCombination4Value(etatActuel, leModel, lesSamples[niveau_actuel])
    val_plus_proche = leModel[liste_possibilites[0][0]][liste_possibilites[0][1]]
    nouvelle_distance = distance_actuelle + abs(prochain_echantillon-val_plus_proche)
    nouveau_chemin = chemin + [etatActuel]
    if (niveau_actuel == nb_niveau):
        if (nouvelle_distance < meilleure_distance):
            meilleur_chemin = nouveau_chemin + [liste_possibilites[0]]
            meilleure_distance = nouvelle_distance
    else:
        for etat_suivant in liste_possibilites:
            etatActuel = etat_suivant
            recur (niveau_actuel+1, nb_niveau, nouvelle_distance, nouveau_chemin)
    
def init_recherche ():
    global lesSamples, etatActuel, meilleure_distance, meilleur_chemin
    print ("\n".join(list(map (str, tabModel))))
    lesSamples = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] # 0, 1, 2, 3, 
    nbEchantillon = 6
    startIdx, endIdx = 0, nbEchantillon
    # etatActuel = (0,0)
    meilleure_distance = math.inf
    meilleur_chemin = []
    startPossibilities = [(x,y) for (x,y) in findClosestCombination4Value(leModel, lesSamples[0]) if x<=y]
    print (startPossibilities)
    distance_actuelle = abs(lesSamples[0] - leModel[startPossibilities[0][0]][startPossibilities[0][1]])
    print (lesSamples[0],leModel[startPossibilities[0][0]][startPossibilities[0][1]], distance_actuelle ) 
    for stPos in startPossibilities:
        chemin = []
        etatActuel = stPos
        recur (1, nbEchantillon, distance_actuelle, chemin)
    print (meilleur_chemin)
    print ([leModel[x][y] for (x,y) in meilleur_chemin])
    print (lesSamples[0:nbEchantillon+1])

def encodeSampleSequence(model, samples):
    print (samples)
    print("finding closest values from first sample "+str(samples[0]))

    startPossibilities = [(x,y) for (x,y) in findClosestCombination4Value(model, samples[0]) if x<=y]
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



        targetValue = samples[level]
        closestDistanceOnX = min([abs(targetValue-value) for value in listX])
        closestDistanceOnY = min([abs(targetValue-value) for value in listY])

        listIndexOfClosestValueOnX = [i for i in range(DIMENSION) if abs(targetValue-listX[i]) == closestDistanceOnX]
        listIndexOfClosestValueOnY = [i for i in range(DIMENSION) if abs(targetValue-listY[i]) == closestDistanceOnY]
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



def main():

    print ("coucou")
    # print (transfert(1,3))
    
    # print ("\n".join(list(map (str, tabModel))))
    # print (tabCombination)
    # samples = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    # encodeSampleSequence(tabModel, samples)

    init_recherche ()


if __name__ == '__main__':
    main()
