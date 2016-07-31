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
    # [ToNaza] This is point 3 from Slack
    #Example for the pop paper
    print('Looking at probablity of transitions in a latent space, users')
    test_fpath = 'data/poster-listening-trajs/ProbO_Given_Z.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    #17 is actuallty gene 18 on the paper
    pa = get_probability_a_to_a(df.iloc[17], 'Britney Spears')
    print(pa.sort_values()[::-1])
    
    # [ToNaza] This is point 3 from Slack again
    #Example for the jazz paper
    print('Looking at probablity of transitions in a latent space, jazz')
    test_fpath = 'data/poster-jazz-trajs/ProbO_Given_Z.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    pa = get_probability_a_to_a(df.iloc[29], 'Miles Davis')
    print(pa.sort_values()[::-1])

    #One hint is to look only at probabilities above uniform random chance.
    pa = pa[pa > 1.0 / len(pa)]
    print(pa.sort_values()[::-1])
    
    # [ToNaza] This is point 1 from Slack
    #We can also look at probs for a given user
    print('Looking at probablity of transitions to collaborators given artist')
    test_user_fpath = 'data/poster-jazz-trajs/ProbZ_Given_U.dat'
    df_az = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    df_zu = pd.read_csv(test_user_fpath, sep='\t', index_col=0, header=0)
    p_zu = df_zu.loc['Miles Davis'] #chick corea row
    p_au = p_zu.dot(df_az)
    print(p_au.sort_values()[::-1])
    

if __name__ == '__main__':
    main()
