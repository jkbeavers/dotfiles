import sys
from numpy import e, log

args = sys.argv
if (float(args[1]) == 0):
	out = (float(args[2]) - float(args[3])) / (float(args[4]))
elif (float(args[1]) == 6):
	out = (log(float(args[2])) - log(float(args[3]))) / (float(args[4]))
elif (float(args[1]) == 8):
	out = e**(log(float(args[2])) + float(args[3]))

elif (float(args[1]) == 1):
	if (float(args[2]) < float(args[3])):
		out = 1
	else:
		out = 0
else:
	out = float(args[2]) + float(args[3])

print(out)




