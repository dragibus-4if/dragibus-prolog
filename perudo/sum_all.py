#!/usr/bin/env python2.7

import os
import glob
import itertools as it
import multiprocessing as mp

this_dir = os.path.dirname(os.path.realpath(__file__))
results = glob.glob(os.path.join(this_dir, 'data/results/*_*.csv'))

def calculate_sum(fname):
    target = os.path.basename(fname).split('_')[0]
    with open(fname, 'r') as fp:
        sum_ = sum(it.imap(lambda x: float(x.split(' ')[1]), fp.readlines()))
    return target, sum_

# run calculations
pool = mp.Pool()
results_sums = {}
for target, sum_ in pool.imap(calculate_sum, results):
    results_sums[target] = sum_ + results_sums.get(target, 0.)

# output results
for target, sum_ in results_sums.iteritems():
    print target, sum_
