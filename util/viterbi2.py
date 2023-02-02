import numpy as np

DIMENSION = 3

def transfert(state):
    (x, y) = state
    return round((2**((x-15)/2)+2**((x-15)/2))*255/2)

# np.exp2(-((15-X)/2)) + np.exp2(-((15-Y)/2))
def viterbi(obs, states, start_p, trans_p, emit_p):
    V = [{}]
    for st in states:
        V[0][st] = {"prob": start_p[st] * emit_p[st][obs[0]], "prev": None}
    # Run Viterbi when t > 0
    for t in range(1, len(obs)):
        V.append({})
        for st in states:
            max_tr_prob = V[t - 1][states[0]]["prob"] * trans_p[states[0]][st]
            prev_st_selected = states[0]
            for prev_st in states[1:]:
                tr_prob = V[t - 1][prev_st]["prob"] * trans_p[prev_st][st]
                if tr_prob > max_tr_prob:
                    max_tr_prob = tr_prob
                    prev_st_selected = prev_st

            max_prob = max_tr_prob * emit_p[st][obs[t]]
            V[t][st] = {"prob": max_prob, "prev": prev_st_selected}
    # print (list(dptable(V)))
    # for line in dptable(V):
    #     print(line)

    opt = []
    max_prob = 0.0
    best_st = None
    # Get most probable state and its backtrack
    for st, data in V[-1].items():
        # print (st, data)
        if data["prob"] > max_prob:
            max_prob = data["prob"]
            best_st = st
    opt.append(best_st)
    previous = best_st

    # Follow the backtrack till the first observation
    # print (" len(V) = ", len(V), "V = ", str(V))
    for t in range(len(V) - 2, -1, -1):
        # print (t, previous, V[t+1])
        opt.insert(0, V[t + 1][previous]["prev"])
        previous = V[t + 1][previous]["prev"]
    # print (opt)
    # print ("The steps of states are " + " ".join(str(opt)) + " with highest probability of %s" % max_prob)
    return opt

def dptable(V):
    # Print a table of steps from dictionary
    yield " " * 5 + "     ".join(("%3d" % i) for i in range(len(V)))
    for state in V[0]:
        yield "%.7s: " % str(state) + " ".join("%.7s" % ("%lf" % v[state]["prob"]) for v in V)


def example_01():
    obs = ("normal", "cold", "dizzy")
    states = ("Healthy", "Fever")
    start_p = {"Healthy": 0.6, "Fever": 0.4}
    trans_p = {
        "Healthy": {"Healthy": 0.7, "Fever": 0.3},
        "Fever": {"Healthy": 0.4, "Fever": 0.6},
    }
    emit_p = {
        "Healthy": {"normal": 0.5, "cold": 0.4, "dizzy": 0.1},
        "Fever": {"normal": 0.1, "cold": 0.3, "dizzy": 0.6},
    }        
    viterbi(obs,states,start_p,trans_p,emit_p)

def extractValueSet(model):
    allval = []
    for li in model:
        allval.extend(li)
    return (list(set(allval)))

def findClosestCombination4Value(model, value):
    valset = extractValueSet(model)
    coordset = extractValueSet(list([[(i , j) for j in range(DIMENSION)] for i in range(DIMENSION)]))
    closest_distance = min([abs(model[x][y]-value) for (x, y) in coordset])
    # print (closest_distance)

    return [(x, y) for (x, y) in coordset if ((abs(model[x][y] - value) == closest_distance))]

def findClosestValue(model, value):
    valset = extractValueSet(model)
    coordset = extractValueSet(list([[(i , j) for j in range(DIMENSION)] for i in range(DIMENSION)]))
    closest_distance = min([abs(model[x][y]-value) for (x, y) in coordset])
    # print (closest_distance)

    return [model[x][y] for (x, y) in coordset if ((abs(model[x][y] - value) == closest_distance))][0]

def getModel():
    # Make data.
    # X = np.arange(0, 16, 1)
    # Y = np.arange(0, 16, 1)
    X = np.arange(0, DIMENSION, 1)
    Y = np.arange(0, DIMENSION, 1)
    X, Y = np.meshgrid(X, Y)
    # R = np.exp2(-((15-X)/2)) + np.exp2(-((15-Y)/2))
    R = np.exp2(X) + np.exp2(Y)
    # Z = np.around(R*255/2)
    return (R.astype(int))

# theModel = [[(2**i+2**j) for j in range(4)] for i in range(4)]

def example_02(samples):
    # obs = ("normal", "cold", "dizzy")
    theModel = getModel()
    print (theModel)
    valsample = [findClosestValue(theModel, sam) for sam in samples]
    # print (samples)
    # print (valsample)
    obs = tuple(valsample) # tuple(set(extractValueSet(getModel())))
    #obs = tuple(samples)
    print (obs)
    
    # states = ("Healthy", "Fever")
    states = tuple(set(extractValueSet([[(i,j) for j in range(DIMENSION)] for i in range(DIMENSION)])))
    # print (states)

    # start_p = {"Healthy": 0.6, "Fever": 0.4}
    start_p = {}
    for st in states:
        start_p[st] = 0.0
    lComb = findClosestCombination4Value(theModel, obs[0])

    proba = 1/len(lComb)
    for comb in lComb:
        start_p[comb] = proba
    print ("start_p\n" , start_p)
    # trans_p = {
    #     "Healthy": {"Healthy": 0.7, "Fever": 0.3},
    #     "Fever": {"Healthy": 0.4, "Fever": 0.6},
    # }
    trans_p = {}
    for stat in states:
        # print (stat)
        (x,y) = stat
        nbPossibleTransition = ((DIMENSION-x)*(DIMENSION-y)+(x+1)*(y+1))-1
        Proba = 1/nbPossibleTransition
        trans_p[stat] = {}
        for stat2 in states:
            (i,j) = stat2
            if ((i>=x) and (j>=y)) or ((i<=x) and (j<=y)):
                trans_p[stat][stat2] = Proba
            else:
                trans_p[stat][stat2] = 0.0

    print ("trans_p = \n" + str(trans_p))


    emit_p = {}
    # emit_p = {
    #     "Healthy": {"normal": 0.5, "cold": 0.4, "dizzy": 0.1},
    #     "Fever": {"normal": 0.1, "cold": 0.3, "dizzy": 0.6},
    # }        
    allPossiblesValues = extractValueSet(theModel)
    for stat in states:
        (x, y) = stat
        emit_p[stat] = {}
        for val in allPossiblesValues:
            if (val == theModel[x][y]):
                emit_p[stat][val] = 1.0
            else:
                emit_p[stat][val] = 0.0

    print ("emit_p\n" , emit_p)


    state_sequence = viterbi(obs,states,start_p,trans_p,emit_p)
    print (state_sequence)

    resultat = [theModel[x][y] for (x,y) in state_sequence]
    print (resultat)

    erreur = [resultat[i] - samples[i] for i in range (len(samples))]
    print (erreur)


def main():

    print ("coucou")
    # example_01()
    #samples = [4, 3, 10, 1, 0, 5, 7, 16, 4, 68] #, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
    samples = [1, 2, 3, 4, 5] #[25, 13, 11] #, 17, 17, 17, 28, 32, 22, 24, 36, 46, 48, 52, 60, 63, 61, 60, 65, 68, 72, 72, 74, 72, 77, 88, 84, 79, 83, 79]
    example_02(samples)


if __name__ == '__main__':
    main()
