#!/usr/bin/env python2.7

import sys
import subprocess as sp
import itertools as it

ais = ['iaDebile', 'iaEleve', 'iaStats', 'iaIvre']

# combinations for different matches
nb_ais = len(ais)
choices = [[int(i == j) for j in xrange(nb_ais)] for i in xrange(nb_ais)]
ai_coefs = map(lambda x: x[0], it.combinations(choices, 1))

# subprocess call
nb_games = 10
for coefs_a, coefs_b in ((a, b) for a in ai_coefs for b in ai_coefs):
    ratios = it.imap(str, it.chain(coefs_a, coefs_b))
    sp_args = 'swipl -q -s game -t'.split()
    sp_args.append('go(%s, %s)' % (', '.join(ratios), nb_games))
    print sp_args
    lines = filter(None, sp.check_output(sp_args, stderr=sp.PIPE).split('\n'))
    print lines
