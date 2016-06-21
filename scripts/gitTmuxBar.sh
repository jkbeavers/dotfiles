#!/bin/bash

###############################################
## This script checks the output of git status 
## and prints the number of new files and 
## untracked file to the right bar in tmux.
###############################################

repo1=/home/beavers/Documents/cpp/giordanocpp/								# cpp computational physics repo
repo2=/home/beavers/dotfiles/												# dotfiles repo

function pushout ()								# assigns values to push variable if push is needed
{
	if [ -n "$1" ] 
	then
	    local out='PUSH!'
	else 
	    local out=""
	fi
echo "$out"
}

cd "$repo1"
changes1=$(git status | grep "new file:" | wc -l)								# print number of new file not commited

modified1=$(git status | grep "modified:" | wc -l)								# print number of files not staged for commit:

untracked1=$(git status | grep -A1000 Untracked | tail -n +4 | sed \$d | wc -l)	# print number of files not tracked

pushit1=$(git log origin/master..master) 					# null if remote does not have commits that are on local 
pushit1=$(pushout "$pushit1")


cd "$repo2"
changes2=$(git status | grep "new file:" | wc -l)								# print number of new file not commited

modified2=$(git status | grep "modified:" | wc -l)								# print number of files not staged for commit:

untracked2=$(git status | grep -A1000 Untracked | tail -n +4 | sed \$d | wc -l)	# print number of files not tracked

pushit2=$(git log origin/master..master) 					# null if remote does not have commits that are on local 
pushit2=$(pushout "$pushit2")


tmuxOut=" $pushit1 cpp $modified1-$changes1-$untracked1 $pushit2 dot $modified2-$changes2-$untracked2"
echo $tmuxOut
