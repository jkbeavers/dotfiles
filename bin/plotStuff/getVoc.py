import os
import numpy as np
import re
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit, fsolve
import sortData

'''
This program will loop thorugh all files in current directory 
(they should all be J-V data) and does a linear approximation 
near y = 0 to find Voc. This is then plotted against the ind.
variable (in each filename).
'''


def gm (x1, y1, x2, y2):                                                                    # return slope of line connecting two points
    return (y2 - y1) / (x2 - x1)
def gb (x1, y1, m1):                                                                        # returns y-int of line connecting two points
    return y1 - (m1 * x1)


class vocP:                                                                                 # Holds pairs of points closest to x = zero for calculating Voc
    def __init__(self, P1, P2, P3):
        self.p1 = P1                                                                        # two points closest to zero ( in order of increasing distance to zero )
        self.p2 = P2                                                                        # second closest pair of points to zero
        self.p3 = P3                                                                        # third closest pair of points to zero
        self.m = [ gm(*P1), gm(*P2), gm(*P3) ]                                              # calculates slopes of lines between each pair of points 
        self.b = [ gb(P1[0], P1[1], self.m[0]), \
                    gb(P2[0], P2[1], self.m[1]), \
                    gb(P3[0], P3[1], self.m[2]) ]                                            # calculates y-int of lines between each pair of points

        self.xint = [ (-self.b[0]/self.m[0]), (-self.b[1]/self.m[1]), \
                    (-self.b[2]/self.m[2])]                                                 # calculates x-int (Voc) for different pairs of points
        self.avg = ( self.xint[0] + self.xint[1]  + \
                    self.xint[2]) / 3                                                       # calculates average of x-int (Voc)
        self.stdv = np.sqrt((self.avg - self.xint[0])**2 + (self.avg - self.xint[1])**2 + (self.avg - self.xint[2])**2) 


dataS = sortData.importD()                                                                  # array containing x-var, value, data points, experiment type
                                                                                            #   sorted by value

points = []
fits = []
for i in range(0,len(dataS)):
    xvar = dataS[i][1]                                                                      # value of x-var (pmu, freq, ...)
    d = dataS[i][2]                                                                         # array of J-V data points
    s = len(dataS[i][2]) 
    # Linear fitting of end points
    if ( s > 3 ):
        temp = vocP([*d[s - 1], *d[s - 2]], [*d[s - 1], *d[s - 3]], [*d[s - 1], *d[s - 4]])
        points.append([xvar, temp.avg, temp.stdv])

#d = dataS[4][2]
#plt.plot(d[:,0],d[:,1], 'ro')
#x = np.linspace(4, 7, 100)
#temp = vocP([*d[s - 1], *d[s - 2]], [*d[s - 1], *d[s - 3]], [*d[s - 1], *d[s - 4]])
#y = temp.avg * x + (temp.b[0] + temp.b[1] + temp.b[2])/3
#plt.plot(x,y)


path = os.getcwd() + "/intercepts"
if not os.path.exists(path):
    os.makedirs(path)
filename = path + "/" + dataS[0][0] + "Voc"

with open(filename, "w") as out:
    for point in points:
       out.write(str(point[0]) + "\t" + str(point[1]) + "\t" + str(point[2]) + "\n")

if ( "mu" in dataS[0][0] ):
    xlab = "Hole Mobility"
elif ( "Freq" in dataS[0][0] ):
    xlab = "Frequency [Hz]"
else:
    xlab = "Dunno"

pin = np.loadtxt(filename)

plt.errorbar(pin[:,0], pin[:,1], yerr=pin[:,2], fmt='ro') 
plt.xlabel(xlab)
plt.ylabel("Open Circuit Voltage [A]")
plt.show()
      


