#export LC_ALL=
#export LC_COLLATE="C"
export PATH=$PATH:~/dotfiles/bin
export VISUAL="vim"

set -o vi
# Auto-start i3
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec startx
fi


#alias cnsi='ssh -X jkbeavers@knot.cnsi.ucsb.edu'
#alias grep='grep --color=auto'
#alias ls='ls --color=always'
#alias nplot='python /home/beavers/Documents/nguyen-lab/simulations/nplot.py'
#alias gisc='python /home/beavers/Documents/python/modules/getIsc.py'
#alias gvoc='python /home/beavers/Documents/python/modules/getVoc.py'
#alias jfreq='python /home/beavers/Documents/python/modules/satFreq.py'
#alias explot='python /home/beavers/Documents/python/modules/excelPlotter.py'
alias bat='acpi -b | grep Battery'
