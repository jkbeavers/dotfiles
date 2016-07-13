#!/bin/bash

## Justin Beavers
## 6/28/2016

####################################################
## This will be called upon by varyParam.sh to kill 
## any jobs that have been running for a while and
## are not making any progress. 
####################################################

hourlim=$1
zerocurlim=$2
smallcurlim=$3

function killem () 
{
	echo "killed $job - $(echo ${ppath} | sed 's/.*\///')'/'${bdir}" &>> "${pppath}/kill.log"					# prints killed jobs to kill.log in parent directory
	/usr/local/bin/qdel ${job} &>> "${pppath}/kill.log" 														# kill job
	echo "cuz ${1} $(date +%H:%M)" &>> "${pppath}/kill.log"
}
				
IFS=$'\n'																										# ensures for loop only interates over new lines
while (( $(qstat -r -u $USER | tail -n +6 | wc -l) > 0 ))														# loops until no more running jobs 
do
	running=$(qstat -r -u $USER | tail -n +6)																	# list of running jobs

	for line in $running																						# loop over running jobs
	do
		job=$(echo ${line%.node*})																				# get job number for each line	

		path=$(qstat -f $job | grep -A 1 "Output_Path" | sed 's/.*://' | tr -d '[[:space:]]' | sed 's/....$//')	# returns full path to #.out
		# /blah/.../var_$varname.../$varname_$varvalue.../$number
		ppath=$(echo ${path%/*}) 																				# gives path to simulation folder 
		# /blah/.../var_$varname_.../$varname_$varvalue...
		pppath=$(echo ${ppath%/*}) 																				# path to varyParam simulations parent dir
		# /blah/.../vary_$varname_...																		
		bdir=$(echo $path | sed 's/\(.*\)\///') 																# gives bottom directory 
		# $number (for job folder)

		# sed 's/\(.*\)\/.*/\1/' removes all text after last / same effect as the variable expansion in $ppath and $pppath
		# sed 's/\(.*\)\///' removes all text before last / 

		if (( $(grep '^Current = 0.000000e+00' "${path}/logfile.txt" | wc -l) >= $zerocurlim )) 				# check if 0 current has been found $zerocurlim times
		then
			killem "current has been zero more than $zerocurlim times"
			continue
		fi

		if (( $(grep '^Current is too small.' "${path}/logfile.txt" | wc -l) >= $smallcurlim )) 				# check if current is too small >= $zerocurlim times
		then
			killem "current has been too small more than $smallcurlim times"
			continue
		fi


		time=$(echo $line | awk '{print $11}')																	# time job has been running for

		hourmin=$(echo ${time%:*})																				# time w/o seconds
		hour=${hourmin%:*}																						# time w/o minutes, seconds

		
		if (( $(echo "$hour > $hourlim " | bc) ))																# check if job has been running for a long time ( > $hourlim)
		then
			killem  "job has ran for $hour, which is greater than $hourlim"
			continue
		fi

	
	
	done
	sleep 10m
done
	

