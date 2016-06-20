export LC_ALL=
export LC_COLLATE="C"
export VISUAL="vim"

set -o vi
#if [[ $DISPLAY == ":0" ]]; then 
#	[[ $TERM != "screen" ]] && exec tmux
#fi

notes

alias cnsi='ssh -X jkbeavers@knot.cnsi.ucsb.edu'
alias grep='grep --color=auto'
alias ls='ls --color=always'
