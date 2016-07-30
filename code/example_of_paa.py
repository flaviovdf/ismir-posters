#-*- coding: utf8

def get_probability_a_to_a(pa_z, a):
    '''
    Get's the probability of a to artist all other on given environment.

    Arguments
    ---------
    pa_z: numpy array of n_artists
    a: the artist of interest (a integer)

    Returns
    -------
    P[other | a, z] as a vector
    '''
    probs = pa_z[a] * pa_z
    probs[a] = 0
    probs = probs / probs.sum()
    return probs
