#!/bin/bash
## Justin Beavers
## 6/28/2016

####################################################
## This script is meant to systematically vary 
## a single parameter for charge transport 
## simulations. This file will edit experiment.cfg
## run CT-launcher.py multiple times. The data will 
## then be organized in a subfolder containing each
## experiments subfolder. Data will be then be 
## collected in a single folder and further analysis 
## will be done. If a job is taking too long it will
## be deleted if no progress is being made.
####################################################

cfg=experiment.cfg


# Get experiment input 
# ------------------------------------------------------------------------------------------
printf "Enter experiment number:\n11: J-V\n15: JvsT\n20: transfer\n30: output\n40: JvsFreq\n50: JvsAmpl\n"
read enumb																					# get experiment number

case "$enumb" in																			# gets appropriate experiment name and check if enumb is valid
	11) ename="J-V"
	;;
	15) ename="JvsT"
	;;
	20) ename="transfer"
	;;
	30) ename="output"
	;;
	40) ename="JvsFreq"
	;;
	50) ename="JvsAmpl"
	;;
	*) echo "Not a valid experiment\nQuiting..."
	exit 1
	;;
esac

echo "Make sure to set appropriate parameters for experiment $enumb first!"

vars=$(grep "^e$enumb" $cfg | cut -f1 -d"=")												# reads in possible variable names 
echo "Pick a parameter to vary:"; echo "$(echo "$vars" | sed 's/.*-//')"					# prints variable names only
read varyParam																				# gets parameter to vary

# need to check if valid parameter

for param1 in $vars;																		# loops through possible variables to pick exact name for varyParam 
do
	if [[ "$param1" == *"$varyParam"* ]];													# check if $param1 is a substring of $varyParam
	then 
		param=$(echo "$param1" | sed 's/.*-//')												# removes $enum- preceeding parameter name for readability
	fi
done

fullparam="e${enumb}-${param}"																# save full variable name $enum-$param for writing to $cfg later
echo "Current value of $param is $(grep "${fullparam}" $cfg | sed 's/.*=//')"

echo "Enter initial value for $param:"
read inH
echo "Enter final value for $param:"
read fiH
echo "Enter number of datapoints:"
read stepNum 

initial=$(python scinotate.py $inH 1)
final=$(python scinotate.py $fiH 1)


# setup directory naming schemes and make changes to $cfg
# ------------------------------------------------------------------------------------------
echo "Enter some naming info regarding the executable:" 
echo "$(grep "^ChargeTransport" $cfg)"
read execN
echo "Enter some naming info regarding the other parameters:"
echo "$(grep "^e$enumb" $cfg)" 
read paramsN

geom=$(grep "^geometry" $cfg | grep -o "..um\...nm")
dir="/home/jkbeavers/data/ChargeTransport/${ename}/vary_${param}_${inH}to${fiH}_${execN}-${paramsN}.${geom}"
mkdir $dir																					# makes folder that will hold all experiment subfolders
sed -i "/outputFolder/c\outputFolder = \"$dir\"" $cfg										# changes output folder in $cfg accordingly
subdir="${param}_$(python scinotate.py ${initial} 0)"										# name for first experiment folder
sed -i "/subfolder/c\subfolder = ${subdir}" $cfg											# changes subfolder ind $cfg accordingly

current=${initial}																			# parameter value to iterate over
#step=$(echo "scale=;(${final} - ${initial})/${stepNum}" | bc)								# calculate step to have $stepNum data points b/t $final and $initial
step=$(python loop.py 0 $final $initial $stepNum)

# loop through parameter values and change parameter/subfolder in cfg$
# ------------------------------------------------------------------------------------------
#while (( $(echo "${current} < ${final}" | bc) == 1 )) 
while (( $(python loop.py 1 $current $final) ))
do
	python CT-launcher.py
	#current=$(echo "scale=$s;${current} + ${step}" | bc)
	current=$(python loop.py 2 $current $step)
	subdir=${param}_$(python scinotate.py $current 0)
	sed -i "/subfolder/c\subfolder = ${subdir}" $cfg										# update subfolder in $cfg
	sed -i "/${fullparam}/c\\${fullparam} = ${current}" $cfg 								# update parameter value in $cfg
done

echo All jobs in queue.


# loop to kill jobs that are a waste of time
# ------------------------------------------------------------------------------------------
# improve this
./killBadJobs.sh

	
# Run script to compile and organie data in $dir/data
# ------------------------------------------------------------------------------------------
./getData.sh $dir $ename							
echo "Data folder generated $(date +%H:%M)"

# Copy default $cfg to experiment.cfg
# ------------------------------------------------------------------------------------------
cp experiment.cfg.bak experiment.cfg
echo "Original experiment.cfg is copied\nDONE"

## TODO: improve loop for killing
## what is saving data folder in data?
