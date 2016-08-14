#!/bin/bash

for a in *
do 
	if [ ! -d $a ]
	then
		b=$(cat $a | wc -l)
	   	if (( $b < 4 ))
	   	then 
			printf "${a}\n" 
	   	fi
	fi
done
