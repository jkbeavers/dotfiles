#!/bin/bash

## Justin Beavers
## 6/29/2016

####################################################
## This will be called upon by varyParam.sh to 
## organize data after all jobs have been completed.
## combine-results.sh is called to generate data 
## files and then they are copied over to the parent
## directories data folder with a descriptive name.
####################################################

path=$1														# path to parent dir (contains experiment subdirs)
ename=$2													# name of experiment

cd $path
mkdir data

for dir in */												# loop through directories in parent experiment folder
do
	if [ "$dir" != "data/" ]
	then	
    	cd "$dir"
    	label=$(pwd | sed 's/\(.*\)\///')						# make label for data (experiment subfolder and 
    	combine-results.sh &>> /dev/null
		if (( $(ls | grep .txt | wc -l) == 2 ))
		then
			datadir=$(ls -t | head -1)
    		cp ${datadir} ../data/${label}_${ename}.txt	
			printf "Copying ${label}_${ename}.txt to data/\n" &>> "$path/run.log"
		fi
    	cd ../
	fi
done


