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

vcfg=${1}
cfg=$(grep -A1 "^# configuration file" $vcfg | tail -1)


# Create $cfg.bak so that we can copy it to $cfg in case another run needs it
# ------------------------------------------------------------------------------------------
if [ "$cfg" != "experiment.cfg" ] 
then
	cp $cfg ${cfg}.bak
	printf "Created ${cfg}.bak\n" 
fi


# Get experiment input 
# ------------------------------------------------------------------------------------------
enumb=$(grep -A1 "^# experiment" ${vcfg} | tail -1)											# gets experiment number

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

sed -i "/^experiment_type/c\experiment_type = $enumb" $cfg									# changes experiment number in $cfg

vars=$(grep "^e$enumb" $cfg | cut -f1 -d"=")												# reads in possible variable names 
varyParam=$(grep -A1 "^# variable" ${vcfg} | tail -1)										# gets parameter to vary (can be a substring of full name)

for param1 in $vars;																		# loops through possible variables to pick exact name for varyParam 
do
	if [[ "$param1" == *"$varyParam"* ]];													# check if $param1 is a substring of $varyParam
	then 
		param=$(echo "$param1" | sed 's/.*-//')												# removes $enum- preceeding parameter name for readability
	fi
done

fullparam="e${enumb}-${param}"																# save full variable name $enum-$param for writing to $cfg later

inH=$(grep -A1 "^# initial" ${vcfg} | tail -1) 												# human readable initial parameter
fiH=$(grep -A1 "^# final" ${vcfg} | tail -1)												# human readable final parameter
stepNum=$(grep -A1 "^# number of steps" ${vcfg} | tail -1) 									# number of steps between initial and final
scale=$(grep -A1 "^# log scale" ${vcfg} | tail -1)											# log(6) scale or linear(0) scale of steps

floatBool=1																					# parameter for scinotate.py 1->converts 1e2 to 100
sciBool=0																					# parameter for scinotate.py 0->converts 100 to 1e2

initial=$(python scinotate.py ${floatBool} ${inH})											# convert from scientific notation to float
final=$(python scinotate.py ${floatBool} ${fiH})											# convert from scientific notation to float

hourLim=$(grep -A1 "^# hour limit" ${vcfg} | tail -1)
zeroCur=$(grep -A1 "^# zero current limit" ${vcfg} | tail -1)
smallCur=$(grep -A1 "^# small current limit" ${vcfg} | tail -1)

# setup directory naming schemes and make changes to $cfg
# ------------------------------------------------------------------------------------------
execN=$(grep -A1 "^# executable" ${vcfg} | tail -1) 										# naming for executable
paramsN=$(grep -A1 "^# other parameters" ${vcfg} | tail -1)									# naming for constant params
geom=$(grep "^geometry" $cfg | grep -o "..um\...nm")										# gets geometry from $cfg

dir="/home/jkbeavers/data/ChargeTransport/${ename}/vary_${param}_${inH}to${fiH}_${execN}-${paramsN}.${geom}"
mkdir $dir																					# makes folder that will hold all experiment subfolders
sed -i "/outputFolder/c\outputFolder = \"$dir\"" $cfg										# changes output folder in $cfg accordingly

subdir="${param}_$(python scinotate.py ${sciBool} ${initial})"								# name for first experiment folder
sed -i "/subfolder/c\subfolder = ${subdir}" $cfg											# changes subfolder ind $cfg accordingly

current=${initial}																			# parameter value to iterate over
sed -i "/${fullparam}/c\\${fullparam} = ${current}" $cfg 									# set initial parameter value in $cfg
step=$(python loop.py $scale $final $initial $stepNum)										# depending on $scale, loop.py will find 
																							# ($f - $i)/$sN or (log($f) - log($i))/$sN 
# print all parameters to log file
# ------------------------------------------------------------------------------------------
scaleN="linear"
if (( $scale == 6 ))																		# Set name of step scale for run.log
then 
	scaleN="log"
fi

printf "$(date)\n" &>> ${dir}/run.log
printf "Parent directory is ${dir}\nGeometry: $geom\n" &>> ${dir}/run.log
printf ".cfg = $vcfg\n$(cat $vcfg)\nExperiment ${enumb}: $ename\n" &>> ${dir}/run.log
printf "Varying ${param} from ${inH} to ${fiH} ($initial to $final)\n" &>> ${dir}/run.log
printf "Using $stepNum steps and $scaleN scale\nStep size: $step\n" &>> ${dir}/run.log
printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" &>> ${dir}/run.log

printf "$(date)\n${ename}/$(echo $dir | sed 's/\(.*\)\///')\n~~~~~~~~~~~~~~~~~~~~~~\n" &>> /home/jkbeavers/data/ChargeTransport/VARY.log


# loop through parameter values and change parameter/subfolder in cfg$
# ------------------------------------------------------------------------------------------
while (( $(python loop.py 1 $current $final) ))												# loop.py will return the value of ($current < $final) == 1
do
	printf "$subdir\n" &>> ${dir}/run.log
	python CT-launcher.py $cfg 1 &>> ${dir}/CT.log											# run CT simulation with current params
	current=$(python loop.py $(($scale + 2)) $current $step)								# loop.py will return $current + $step
	subdir=${param}_$(python scinotate.py $sciBool ${current})								# rename directory of simulation folder
	sed -i "/subfolder/c\subfolder = ${subdir}" $cfg										# update subfolder in $cfg
	sed -i "/${fullparam}/c\\${fullparam} = ${current}" $cfg 								# update parameter value in $cfg
done

echo "All jobs in queue. $(date +%H:%M)" &>> ${dir}/run.log


# loop to kill jobs that are a waste of time
# ------------------------------------------------------------------------------------------
# improve this
echo "Killing jobs every ten minutes" &>> ${dir}/run.log
./killBadJobs.sh $hourLim $zeroCur $smallCur &>> ${dir}/run.log
echo "Done killing jobs. There should be zero running/queue jobs. $(date +%H:%M)" &>> ${dir}/run.log

	
# Run script to compile and organie data in $dir/data
# ------------------------------------------------------------------------------------------
./getData.sh $dir $ename &>> ${dir}/run.log							
echo "Data folder generated $(date +%H:%M)" &>> ${dir}/run.log



# Copy default $cfg to experiment.cfg
# ------------------------------------------------------------------------------------------
cp ${cfg}.bak $cfg
printf "${cfg}.bak is copied\nDONE" &>> ${dir}/run.log



## TODO: improve loop for killing
