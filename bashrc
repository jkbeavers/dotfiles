PS1="\[\033[1;37m\]\u\[\033[0m\] \[\033[0;35m\]>>\[\033[0m\] "
#export LC_ALL=
#export LC_COLLATE="C"
export PATH=$PATH:~/dotfiles/bin
export VISUAL="vim"

set -o vi
# Auto-start i3
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec startx
fi

if [[ -z "$TMUX" ]] 
then
	ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
	if [[ -z "$ID" ]] ;then # if not available create a new one
		tmux new-session
	else
		tmux attach-session -t "$ID" # if available attach to it
	fi
fi

nguyen='/home/taro/Documents/nguyen-lab/simulations/'
alias cnsi='ssh jkbeavers@knot.cnsi.ucsb.edu'
alias grep='grep --color=auto'
alias ls='ls --color=always'

alias nplot="python ${nguyen}nplot.py"
alias gisc="python ${nguyen}getIsc.py"
alias gvoc="python ${nguyen}getVoc.py"
alias jfreq="python ${nguyen}satFreq.py"
alias explot="python ${nguyen}excelPlotter.py"
alias mkFrames="python ${nguyen}createFrames.py"

alias bat='acpi -b | grep Battery'
