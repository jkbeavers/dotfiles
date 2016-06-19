#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
exec i3 -V >> /home/beavers/.i3/logs/i3log-$(date +'%F-%k-%M-%S') 2>&1


