#!/usr/bin/env python2.7
import glob
import os
for filename in glob.glob('./sum/*'):
    os.remove(filename)
for filename in glob.glob('./results/*_*.csv'):
    s = 0
    with open(filename, 'r') as file:
        for line in file.readlines():
            s += float(line.split(' ')[1])
    wfilename = './sum/' + os.path.basename(filename).split('_')[0]
    old_s = 0
    if os.path.exists(wfilename):
        with open(wfilename, 'r') as file:
            line = file.readline()
            if line:
                old_s = float(line.split('\n')[0])
    with open(wfilename, 'w') as file:
        file.write(str(s + old_s))
