#!/bin/bash
################################################################################################################
#### launches '/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/scripts/backupMain.sh'	####
#### or /home/wayne/scriptsB/backupMain.#!/bin/#!/bin/#!/bin/backupMain.sh									####
################################################################################################################
# not really sure why i have this here..
cd /home/wayne
# doesn't seem to work unless it's  already failed once
tmux kill-session -t backupTmux 2>/dev/null
tmux new-session -d -s backupTmux 'bash --init-file /home/wayne/scriptsB/backingUp/backupMain.sh'
