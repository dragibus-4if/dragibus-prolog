#!/usr/bin/env python2.7

import sys
import subprocess as sp
import itertools as it
import argparse

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

# subprocess call
nb_games = parsed_args.nb_games
size_filter = parsed_args.size_filter
for coefs_a, coefs_b in ((a, b) for a in ai_coefs for b in ai_coefs):
    ratios = it.imap(str, it.chain(coefs_a, coefs_b))
    sp_args = 'swipl -q -s game -t'.split()
    sp_args.append('go(%s, %s)' % (', '.join(ratios), nb_games))
    output = sp.check_output(sp_args, stderr=sp.PIPE)
    lines = filter(None, output.split('\n'))
    players = list(set(lines))
    wins = map(lambda x: float(x == ref_name), lines)

    # low pass filter
    ls = [0.0] * size_filter
    t = 0
    for w in wins:
        ls = ls[1:] + [w]
        t += 1
        if t >= size_filter:
            print t, sum(ls) / size_filter
