import os
import numpy as np
import re

'''
Makes a dictionary of file names and J-V data. This
is then used to create a list with all relevant info
from data (J-V) files that is sorted by independant 
variable (in file name).
'''

def getKey(item):
    return item[1]

def importD ():
    data={}
    for dataf in os.listdir("."):                                                               # loops through list of files in ./
        if not os.path.isdir(dataf):                                                            # skips directories
            data[dataf]=np.loadtxt(dataf)                                                       # adds data set (from text file) to dict with key as filename
    
    dataS=[]
    for k in list(data):                                                                        # loops through the keys (as a list)
        temp = re.split("_", k)                                                                 # splits up filenames at each _
                                                                                                #   results in list with variable name, value, experiment type
        if (temp[0] == 'p'):                                                                    # accounts for extra _ in pmu filenames
            dataS.append([temp[0] + temp[1], float(temp[2]), data[k], temp[3]])
        else:
            dataS.append([temp[0], float(temp[1]), data[k], temp[2]])                           # adds list member to list containing
                                                                                                #   variable name, variable value, data set, experiment type
    
    dataS = sorted(dataS, key=getKey)                                                           # array containing x-var, value, data points, experiment type
                                                                                                #   sorted by value
    return dataS

                                  
