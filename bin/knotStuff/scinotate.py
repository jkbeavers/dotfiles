import sys

args = sys.argv

if ( float(args[1]) == 0 ):
	print('%.2e' % float(args[2]))
else:
	print format(float(args[2]), 'f')



