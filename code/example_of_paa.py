#-*- coding: utf8

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
    #Example for the pop paper
    test_fpath = 'data/poster-listening-trajs/ProbO_Given_Z.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    #17 is actuallty gene 18 on the paper
    pa = get_probability_a_to_a(df.iloc[17], 'Britney Spears')
    print(pa.sort_values()[::-1])
    
    #Example for the jazz paper
    test_fpath = 'data/poster-jazz-trajs/ProbO_Given_Z.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    pa = get_probability_a_to_a(df.iloc[29], 'Miles Davis')
    print(pa.sort_values()[::-1])

if __name__ == '__main__':
    main()
