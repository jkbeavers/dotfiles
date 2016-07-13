#!/bin/bash
## Justin Beavers

###############################################
## This script checks the output of git status 
## and prints the number of new files and 
## untracked file to the right bar in tmux.
###############################################

repo1=/home/beavers/Documents/cpp/giordanocpp/												# cpp computational physics repo
repo2=/home/beavers/dotfiles/																# dotfiles repo

# returns push string if git push is needed
function pushout ()																			
{
	local pushit=$(git log origin/master..master)											# non-empty/empty if remote does/doesn't have commits that are on local 

	if [ -n "$pushit" ] 
	then
	    local out='PUSH!'
	else 
	    local out=""
	fi
	echo "$out"
}

# returns numbers of files/changes to be added to stage/commited and untracked files ($1-$2)
function fileNums ()																		
{
	local changes=$(git status | grep "new file:" | wc -l)									# print number of new files not commited	
	local modified=$(git status | grep "modified:" | wc -l)									# print number of files not staged for commit:	
	local untracked=$(git status | grep -A100 Untracked | tail -n +4 | head -n -2  | wc -l)	# print number of files not tracked
	
	echo "$(($changes + $modified))-"$untracked"" 
}

cd "$repo1"
pushit1=$(pushout)
files1=$(fileNums)

cd "$repo2"
pushit2=$(pushout)
files2=$(fileNums)

tmuxOut=" $pushit1 cpp $files1 $pushit2 dot $files2"
echo $tmuxOut
