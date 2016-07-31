#-*- coding: utf8

import sys
import pandas as pd

def main():
    # [ToNaza] This is point 4 from Slack
    #Example for the pop paper
    test_fpath = 'data/poster-listening-trajs/ZtoZMatColToRow.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    
    #One hint is to look only at probabilities above uniform random chance.
    df[df < 1.0 / len(df)] = 0
    print(df)

    #Example for the jazz paper
    test_fpath = 'data/poster-jazz-trajs/ZtoZMatColToRow.dat'
    df = pd.read_csv(test_fpath, sep='\t', index_col=0, header=0)
    
    #One hint is to look only at probabilities above uniform random chance.
    df[df < 1.0 / len(df)] = 0
    print(df)

if __name__ == '__main__':
    main()
