#!/usr/bin/python2.7
import sys
import pylab
data = map(lambda x: [float(e) for e in x.split('\n')[0].split(' ')], sys.stdin.readlines())
d = zip(*data)
pylab.plot(d[0], d[1], label='Taux de victoire')
pylab.legend()
pylab.title("Title of Plot")
pylab.xlabel("X Axis Label")
pylab.ylabel("Y Axis Label")
pylab.show()
