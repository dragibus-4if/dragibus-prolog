#!/usr/bin/env python2.7

import os
import sys
import argparse
import itertools as it
import multiprocessing as mp
import subprocess as sp

ais = ['iaDebile', 'iaEleve', 'iaStats', 'iaIvre']

# combinations for different matches
nb_ais = len(ais)
choices = [[int(i == j) for j in xrange(nb_ais)] for i in xrange(nb_ais)]
ai_coefs = map(lambda x: x[0], it.combinations_with_replacement(choices, 1))

# script params
parser = argparse.ArgumentParser()
parser.add_argument('nb_games', metavar='NB', type=int,
        help='Number of games for each match')
parser.add_argument('size_filter', metavar='FILTER', type=int,
        help='Size filter used for the low pass filter')
ref_name = 'John'
parsed_args = parser.parse_args()

# shortcuts for command-line args
nb_games = parsed_args.nb_games
size_filter = parsed_args.size_filter

def measure_matchup(coefs_both):
    coefs_a, coefs_b = coefs_both
    ratios = it.imap(str, it.chain(coefs_a, coefs_b))
    sp_args = 'swipl -q -s game -t'.split()
    sp_args.append('go(%s, %s)' % (', '.join(ratios), nb_games))

    # get win/loss for given player
    output = sp.check_output(sp_args, stderr=sp.PIPE)
    output_lines = filter(None, output.split('\n'))
    players = list(set(output_lines))
    wins = map(lambda x: float(x == ref_name), output_lines)

    # low pass filter
    results = []
    t = 0
    ls = [0.0] * size_filter
    for val in wins:
        ls = ls[1:] + [val]
        t += 1
        if t >= size_filter:
            results.append((t, sum(ls)/size_filter))

    # save results
    this_dir = os.path.dirname(os.path.realpath(__file__))
    fname = 'results/%s_%s.csv' % ('-'.join(map(str, coefs_a)),
            '-'.join(map(str, coefs_b)))
    with open(os.path.join(this_dir, fname), 'w') as fp:
        fp.writelines(it.imap(lambda x: ' '.join(x), results))
    print 'Match %s vs %s, results: "%s"' % (coefs_a, coefs_b, fname)

# run
pool = mp.Pool()
pool.map(measure_matchup, ((a, b) for a in ai_coefs for b in ai_coefs))
