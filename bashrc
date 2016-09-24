export LC_ALL=
export LC_COLLATE="C"
export VISUAL="vim"
export PYTHONPATH=$PYTHONPATH:/home/beavers/Documents/python/modules

set -o vi
#if [[ $DISPLAY == ":0" ]]; then 
#	[[ $TERM != "screen" ]] && exec tmux
#fi


alias cnsi='ssh -X jkbeavers@knot.cnsi.ucsb.edu'
alias grep='grep --color=auto'
alias ls='ls --color=always'
alias nplot='python /home/beavers/Documents/nguyen-lab/simulations/nplot.py'
alias gisc='python /home/beavers/Documents/python/modules/getIsc.py'
alias gvoc='python /home/beavers/Documents/python/modules/getVoc.py'
alias jfreq='python /home/beavers/Documents/python/modules/satFreq.py'
alias explot='python /home/beavers/Documents/python/modules/excelPlotter.py'
alias bat='acpi -b | grep Battery'

export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/beavers/.vimpkg/bin
