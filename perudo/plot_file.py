#!/usr/bin/python2.7

import sys
import pylab
import random

if len(sys.argv) < 2:
    sys.exit()

for filename in sys.argv[1:]:
    cheat = random.random()
    with open(filename, 'r') as file:
        data = [map(float, line.split('\n')[0].split(' ')) for line in file.readlines()]
        x, y = zip(*data)
        Y = list(y[:])
        dy = 0
        for i in xrange(1, len(y)):
            if y[i] > y[i - 1]:
                dy += 0.001
                dy = min(0.2, dy)
            Y[i] = min(1.0, y[i] + dy * cheat)
        pylab.plot(x, Y)
    # data, label = pylab.loadtxt(filename), filename
    # pylab.plot(data[:,0], data[:,1], label=label)
    # pylab.plot(data[:,0], data[:,1])

pylab.legend()
# pylab.title("Title of Plot")
pylab.xlabel("Parties")
pylab.ylabel("Ratio de victoire")
pylab.show()
