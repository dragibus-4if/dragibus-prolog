#!/bin/env python2.7

import sys

for t, line in enumerate(sys.stdin.readlines()):
    print t, line.split('\n')[0]
