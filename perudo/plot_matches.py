#!/usr/bin/env python2.7

import sys
import subprocess as sp
import itertools as it

ais = ['iaDebile', 'iaEleve', 'iaStats', 'iaIvre']

# combinations for different matches
nb_ais = len(ais)
choices = [[int(i == j) for j in xrange(nb_ais)] for i in xrange(nb_ais)]
combinations = list(it.combinations(choices, 2))

# subprocess call
nb_games = 100
for a, b in combinations:
    ratios = map(str, it.chain(a, b))
    sp_args = 'swipl -q -s game -t'.split()
    sp_args.append('go(%s, %s)' % (', '.join(ratios), nb_games))
    print sp.check_output(sp_args, stderr=sp.PIPE)
