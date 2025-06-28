#!/usr/bin/env nu
niri msg --json outputs
| from json 
| reject eDP-1 
| columns 
| first 
| wl-mirror --fullscreen-output $in eDP-1
