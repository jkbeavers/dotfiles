import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import itertools
import sortData

'''
Plots n data files in current directory
'''

dataS = sortData.importD()

marker = itertools.cycle(['+', '.', '2', 'o', '*', '^', '3', '<', '4', '>', 'v', '8', 'p', 'h', 'x', 'D', '_', 's', '1'])

#Picks axis/title labels and make any data specific changes depending on data
if "output" in dataS[0][3]:
    plt.xlabel('Drain Voltage [V]')
    plt.ylabel('Drain Current [A]')
elif "JvsAmpl" in dataS[0][3]:
    plt.xlabel('Gate Amplitude [V]')
    plt.ylabel('Drain Current [A]')
elif "J-V" in dataS[0][3]:
    plt.xlabel('Drain Voltage [V]')
    plt.ylabel('Drain Current [A]')
elif "JvsFreq" in str(dataS[0][3]):
    for set in dataS:
        set[2] = np.abs(set[2])
    plt.xscale('log')
    plt.yscale('log')
# rm .matplotlib/fontList.cache if log scale doesn't work
    plt.xlabel('Gate Frequency [log(Hz)]')
    plt.ylabel('Drain Current [log(-A)]')
elif "transfer" in dataS[0][3]:
    plt.xlabel('Gate Voltage [V]')
    plt.ylabel('Drain Current [A]')
elif "JvsT" in dataS[0][3]:
    plt.xlabel('Temperature [K]')
    plt.ylabel('Drain Current [A]')
	
for set in dataS:
    descr = set[0] + " " + str('%.2e' % set[1])
    d = set[2]
    plt.plot(d[:,0], d[:,1], label=descr, marker=next(marker))

tmptit = dataS[0][0]
tit = ""
if "mu" in tmptit:
    tit = "Hole Mobility"
elif "Freq" in tmptit:
    tit = "Gate Frequency"
elif "Vg" in tmptit:
    tit = "Gate Voltage"
elif "Vd" in tmptit:
    tit = "Drain Voltage"
elif "Ampl" in tmptit:
    tit = "Amplitude"

plt.legend(bbox_to_anchor=(1,1), loc='best', ncol=1).draggable()
plt.title("Varying " + tit)
plt.show()
