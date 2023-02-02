import numpy as np

def viterbi(obs, transition, emission, init=None):
    """
    Return the MAP estimate of state trajectory of Hidden Markov Model.

    Parameters
    ----------
    y : array (T,)
        Observation state sequence. int dtype.

    transition : array (K, K)
        State transition matrix. See HiddenMarkovModel.state_transition for
        details.

    emission : array (K,)
        Emission matrix. See HiddenMarkovModel.emission for details.

    init: optional, (K,)
        Initial state probabilities: Pi[i] is the probability x[0] == i. If
        None, uniform initial distribution is assumed (Pi[:] == 1/K).

    Returns
    -------
    x : array (T,)
        Maximum a posteriori probability estimate of hidden state trajectory,
        conditioned on observation sequence y under the model parameters.

    T1: array (K, T)
        the probability of the most likely path so far

    T2: array (K, T)
        the x_j-1 of the most likely path so far
    """
    # Cardinality of the state space
    K = transition.shape[0]

    emission = np.repeat(emission[np.newaxis, :], K, axis=0)

    # Initialize the priors with default (uniform dist) if not given by caller
    init = init if init is not None else np.full(K, 1 / K)
    T = len(obs)
    T1 = np.empty((K, T), 'd')
    T2 = np.empty((K, T), 'B')

    # Initilaize the tracking tables from first observation
    T1[:, 0] = init * emission[:, obs[0]]
    T2[:, 0] = 0

    # Iterate throught the observations updating the tracking tables
    for i in range(1, T):
        T1[:, i] = np.max(T1[:, i - 1] * transition.T * emission[np.newaxis, :, obs[i]].T, 1)
        T2[:, i] = np.argmax(T1[:, i - 1] * transition.T, 1)

    # Build the output, optimal model trajectory
    x = np.empty(T, 'B')
    x[-1] = np.argmax(T1[:, T - 1])
    for i in reversed(range(1, T)):
        x[i - 1] = T2[x[i], i]

    return x, T1, T2


def main():

    print ("coucou")
    obs = [2, 2, 3, 4, 5]
    transition = {(0, 1): {(0, 1): 0.14285714285714285, (1, 2): 0.14285714285714285, (2, 1): 0.14285714285714285, (0, 0): 0.14285714285714285, (1, 1): 0.14285714285714285, (2, 0): 0.0, (0, 2): 0.14285714285714285, (2, 2): 0.14285714285714285, (1, 0): 0.0}, (1, 2): {(0, 1): 0.14285714285714285, (1, 2): 0.14285714285714285, (2, 1): 0.0, (0, 0): 0.14285714285714285, (1, 1): 0.14285714285714285, (2, 0): 0.0, (0, 2): 0.14285714285714285, (2, 2): 0.14285714285714285, (1, 0): 0.14285714285714285}, (2, 1): {(0, 1): 0.14285714285714285, (1, 2): 0.0, (2, 1): 0.14285714285714285, (0, 0): 0.14285714285714285, (1, 1): 0.14285714285714285, (2, 0): 0.14285714285714285, (0, 2): 0.0, (2, 2): 0.14285714285714285, (1, 0): 0.14285714285714285}, (0, 0): {(0, 1): 0.1111111111111111, (1, 2): 0.1111111111111111, (2, 1): 0.1111111111111111, (0, 0): 0.1111111111111111, (1, 1): 0.1111111111111111, (2, 0): 0.1111111111111111, (0, 2): 0.1111111111111111, (2, 2): 0.1111111111111111, (1, 0): 0.1111111111111111}, (1, 1): {(0, 1): 0.14285714285714285, (1, 2): 0.14285714285714285, (2, 1): 0.14285714285714285, (0, 0): 0.14285714285714285, (1, 1): 0.14285714285714285, (2, 0): 0.0, (0, 2): 0.0, (2, 2): 0.14285714285714285, (1, 0): 0.14285714285714285}, (2, 0): {(0, 1): 0.0, (1, 2): 0.0, (2, 1): 0.2, (0, 0): 0.2, (1, 1): 0.0, (2, 0): 0.2, (0, 2): 0.0, (2, 2): 0.2, (1, 0): 0.2}, (0, 2): {(0, 1): 0.2, (1, 2): 0.2, (2, 1): 0.0, (0, 0): 0.2, (1, 1): 0.0, (2, 0): 0.0, (0, 2): 0.2, (2, 2): 0.2, (1, 0): 0.0}, (2, 2): {(0, 1): 0.1111111111111111, (1, 2): 0.1111111111111111, (2, 1): 0.1111111111111111, (0, 0): 0.1111111111111111, (1, 1): 0.1111111111111111, (2, 0): 0.1111111111111111, (0, 2): 0.1111111111111111, (2, 2): 0.1111111111111111, (1, 0): 0.1111111111111111}, (1, 0): {(0, 1): 0.0, (1, 2): 0.14285714285714285, (2, 1): 0.14285714285714285, (0, 0): 0.14285714285714285, (1, 1): 0.14285714285714285, (2, 0): 0.14285714285714285, (0, 2): 0.0, (2, 2): 0.14285714285714285, (1, 0): 0.14285714285714285}}
    emission = {(0, 1): {2: 0.0, 3: 1.0, 4: 0.0, 5: 0.0, 6: 0.0, 8: 0.0}, (1, 2): {2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 8: 0.0}, (2, 1): {2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 1.0, 8: 0.0}, (0, 0): {2: 1.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 0.0, 8: 0.0}, (1, 1): {2: 0.0, 3: 0.0, 4: 1.0, 5: 0.0, 6: 0.0, 8: 0.0}, (2, 0): {2: 0.0, 3: 0.0, 4: 0.0, 5: 1.0, 6: 0.0, 8: 0.0}, (0, 2): {2: 0.0, 3: 0.0, 4: 0.0, 5: 1.0, 6: 0.0, 8: 0.0}, (2, 2): {2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 0.0, 8: 1.0}, (1, 0): {2: 0.0, 3: 1.0, 4: 0.0, 5: 0.0, 6: 0.0, 8: 0.0}}
    init =  {(0, 1): 0.0, (1, 2): 0.0, (2, 1): 0.0, (0, 0): 1.0, (1, 1): 0.0, (2, 0): 0.0, (0, 2): 0.0, (2, 2): 0.0, (1, 0): 0.0}
    x, T1, T2 = viterbi(obs, transition, emission, init)


if __name__ == '__main__':
    main()