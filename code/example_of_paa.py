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
    test_fpath = 'data/poster-listening-trajs/z_vecs.tsv'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    #17 is actuallty gene 18 on the paper
    pa = get_probability_a_to_a(df.loc[17], 'Britney Spears')
    print(pa.sort_values()[::-1])

if __name__ == '__main__':
    main()
