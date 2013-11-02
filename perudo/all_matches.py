#!/usr/bin/env python2.7

import os
import sys
import argparse
import itertools as it
import multiprocessing as mp
import subprocess as sp

ais = ['iaDebile', 'iaEleve', 'iaStats', 'iaIvre']

# script params
parser = argparse.ArgumentParser()
parser.add_argument('nb_games', metavar='NB_GAMES', type=int,
        help='Number of games for each match')
parser.add_argument('size_filter', metavar='FILTER', type=int,
        help='Size filter used for the low pass filter')
parser.add_argument('nb_div', metavar='NB_SUBDIVS', type=int,
        help='Number of subdivision done')
ref_name = 'John'
parsed_args = parser.parse_args()

# shortcuts for command-line args
size_filter = parsed_args.size_filter
nb_games = parsed_args.nb_games
nb_div = parsed_args.nb_div

def measure_matchup(coefs_both):
    coefs_a, coefs_b = coefs_both
    fname = 'results/%s_%s.csv' % ('-'.join(map(str, coefs_a)),
            '-'.join(map(str, coefs_b)))

    if os.path.exists(fname):
        print 'Match %s vs %s ignored' % (coefs_a, coefs_b)
        return

    ratios = map(str, it.chain(coefs_a, coefs_b))
    # sp_args = 'swipl -q -s game -t'.split()
    # sp_args.append('go(%s, %s)' % (', '.join(ratios), nb_games))
    sp_args = './game.exe -- '.split() + ratios + [str(nb_games)]

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
    with open(os.path.join(this_dir, fname), 'w') as fp:
        fp.writelines(it.imap(lambda x: ' '.join(map(str, x)) + '\n', results))
    print 'Match %s vs %s, results: "%s"' % (coefs_a, coefs_b, fname)

# combinations for different matches
# - discrete
nb_ais = len(ais)
choices = [[int(i == j) for j in xrange(nb_ais)] for i in xrange(nb_ais)]
ai_coefs = map(lambda x: x[0], it.combinations_with_replacement(choices, 1))
# - continuous
N = nb_div
ls = []
for d in xrange(N + 1):
    for e in xrange(N + 1):
        for s in xrange(N + 1):
            if d == 0 and e == 0 and s == 0:
                continue
            _sum = d + e + s + 0.0
            d /= _sum
            e /= _sum
            s /= _sum
            if not (d, e, s, 0) in ls:
                ls += [(d, e, s, 0)]
                ls += [(d, e, s, 0.5)]
                ls += [(d, e, s, 1)]
ai_coefs = ls

# run (via multiprocessing)
pool = mp.Pool(8)
pool.map(measure_matchup, ((a, b) for a in ai_coefs for b in ai_coefs))
