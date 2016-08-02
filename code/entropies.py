#-*- coding: utf8

import numpy as np 
import sys
import pandas as pd

def get_probability_a_to_a(pa_z, a):
    '''
    Get's the probability of a to artist all other on given environment.

    Arguments
    ---------
    pa_z: numpy array of n_artists or panda series
    a: the artist of interest (a integer or panda index)

    Returns
    -------
    P[other | a, z] as a vector
    '''
    probs = pa_z[a] * pa_z
    probs[a] = 0
    probs = probs / probs.sum()
    return probs

def main():
    test_fpath = 'data/poster-jazz-trajs/ProbO_Given_Z.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    entropies = (np.log2(df) * -df).sum(axis=1)
    entropies = pd.DataFrame(entropies, columns=['entropy'])
    entropies.to_csv('data/poster-jazz-trajs/EntropyAZ.dat', sep='\t')
    
if __name__ == '__main__':
    main()
