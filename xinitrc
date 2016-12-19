#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
exec i3 -V >> ~/.logs/i3/i3log-$(date +'%F-%k-%M-%S') 2>&1


