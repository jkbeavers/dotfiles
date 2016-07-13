import os
import numpy as np
import re
import matplotlib.pyplot as plt
import sortData

'''
This program will loop through all files in the current directory
(they should all hold J-V curve data) and performs a linear approximation
about x = 0 to find the short circuit current. The extracted Isc values are 
then plotted against the independant variable (in the file names).
'''


class iscP:                                                                                 # Holds pairs of points about y = zero for calculating Isc
    def __init__(self, P1, P2, P3):                                                         # e.g. P1 = [ x1, y1, x2, y2]
        self.p1 = P1                                                                        # two points (neg. first) closest to zero
        self.p2 = P2                                                                        # second closest pair of points to zero
        self.p3 = P3                                                                        # third closest pair of points to zero
        self.m = [ ( P1[3] - P1[1]) / ( P1[2] - P1[0] ) , \
                    ( P2[3] - P2[1]) / ( P2[2] - P2[0] ), \
                    ( P3[3] - P3[1]) / ( P3[2] - P3[0] ) ]                                  # calculates slopes of lines between each pair of points 
        self.b = [ P1[3] - (self.m[0] * P1[2]), \
                    P2[3] - (self.m[1] * P2[2]), \
                    P3[3] - (self.m[2] * P3[2]) ]                                           # calculates y-int (Isc) of lines between each pair of points
        self.avg = (self.b[0] + self.b[1] + self.b[2]) / 3                                  # calculates average of y-int (Isc)
        self.stdv = np.sqrt((self.avg - self.b[0])**2 + (self.avg - self.b[1])**2 + (self.avg - self.b[2])**2) 

dataS = sortData.importD()                                                                   # sorted data (by xval): x-varname, xval, JV data, experiment type


points = []
for i in range(0,len(dataS)):
    xvar = dataS[i][1]                                                                      # value of x-var (pmu, freq, ...)
    d = dataS[i][2]                                                                         # array of J-V data points
    for j in range(0,len(d)):                                                               # loop through x (voltage) values
        if ( d[j][0] > 0  and d[j-1][0] < 0 ):                                              
            temp = iscP([*d[j - 1], *d[j]], [*d[j - 2,], *d[j + 1]], [*d[j - 3], *d[j + 2]])
            points.append([xvar, temp.avg, temp.stdv])
            break

path = os.getcwd() + "/intercepts"
if not os.path.exists(path):
    os.makedirs(path)
filename = path + "/" + dataS[0][0] + "Isc"

with open(filename, "w") as out:
    for point in points:
        out.write(str(point[0]) + "\t" + str(point[1]) + "\t" + str(point[2]) + "\n")

if ( "mu" in dataS[0][0] ):
    xlab = "Hole Mobility"
elif ( "Freq" in dataS[0][0] ):
    xlab = "Frequency [Hz]"

pin = np.loadtxt(filename)

plt.errorbar(pin[:,0], pin[:,1], yerr=pin[:,2], fmt='ro') 
plt.xlabel(xlab)
plt.ylabel("Short Circuit Current [A]")
plt.show()
      


