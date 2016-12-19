#!/bin/bash
while [ true ] 
do

	bat=`battery.sh` 
	
	wifi=" `nmcli | head -1 | awk '{print $4}'`"
	ip=`nmcli | grep inet4 | awk '{gsub("/..","",$2);print $2}'`
	
	light=" `printf "%.*f" 0 $(xbacklight -get)`"
	
	sound=" `amixer | grep Playback | tail -1 | awk '{gsub(/\[|\]/,"" $5);print $5}'`"
	
	str="%{l}$wifi $ip %{c}$sound $light %{r}$bat"
	echo $str
	sleep 1s

done	
