export LC_ALL=
export LC_COLLATE="C"
export VISUAL="vim"
export PYTHONPATH=$PYTHONPATH:/home/beavers/Documents/python/modules

set -o vi
#if [[ $DISPLAY == ":0" ]]; then 
#	[[ $TERM != "screen" ]] && exec tmux
#fi

notes

alias cnsi='ssh -X jkbeavers@knot.cnsi.ucsb.edu'
alias grep='grep --color=auto'
alias ls='ls --color=always'
alias nplot='python /home/beavers/Documents/nguyen-lab/simulations/nplot.py'
alias gisc='python /home/beavers/Documents/python/modules/getIsc.py'
alias gvoc='python /home/beavers/Documents/python/modules/getVoc.py'
