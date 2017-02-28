#!/bin/bash

# Necessary to only run this every 5 seconds or so because the computer struggles to pick a battery to charge for a sec

bats=`acpi -b`
bat0=`echo "$bats" | head -1`
bat1=`echo "$bats" | tail -1`


batteryOutput ()
{
	bat="bat$1"
	batp=`echo ${!bat} | awk '{gsub("[,|%]","",$4);print $4}'`
	batstat=`echo ${!bat} | awk '{gsub(",","", $3);print $3}'`
	timel=`echo ${!bat} | awk '{print $5}'| head -c -4`

	if [ "$batstat" = "Charging" ] ; then
		out=""
	elif [ $batp -ge 95 ] ; then
		out=""
	elif [ $batp -ge 75 ] ; then
		out=""
	elif [ $batp -ge 50 ] ; then
		out=""
	elif [ $batp -ge 25 ] ; then
		out=""
	elif [ $batp -ge 15 ] ; then
		out="%{F#8b0000}%{F}"			# coloring (red) set for lemonbar's format
	elif [ $batp -ge 5 ] ; then
		out="%{F#8b0000}%{F}"
	fi

	echo "$out $timel"
}

if [ -z `echo $bat1 | awk '{print $5}'` ]; then
	echo "%{c}`batteryOutput 0`" | notify_bar
else
	echo "%{c}`batteryOutput 1`" | notify_bar
fi
#echo `batteryOutput 0 ;batteryOutput 1` | lemonbar -d -g 200x200+50+150 -f "FontAwesome:size=15" -f "monospace" -B "#000000" -p 
