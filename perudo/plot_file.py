#!/usr/bin/python2.7

import sys
import pylab

if len(sys.argv) < 2:
    sys.exit()

for filename in sys.argv[1:]:
    data, label = pylab.loadtxt(filename), filename
    # pylab.plot(data[:,0], data[:,1], label=label)
    pylab.plot(data[:,0], data[:,1])

pylab.legend()
# pylab.title("Title of Plot")
pylab.xlabel("Parties")
pylab.ylabel("Ratio de victoire")
pylab.show()
