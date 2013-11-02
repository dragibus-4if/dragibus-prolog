#!/usr/bin/python2.7

import sys
import pylab

if len(sys.argv) < 2:
    sys.exit()

for filename in sys.argv[1:]:
    data, label = pylab.loadtxt(filename), 'test'#filename
    pylab.plot(data[:,0], data[:,1], label=label)

pylab.legend()
pylab.title("Title of Plot")
pylab.xlabel("X Axis Label")
pylab.ylabel("Y Axis Label")
pylab.show()
