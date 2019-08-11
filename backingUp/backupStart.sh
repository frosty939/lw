#!/bin/bash
################################################################################################################
#### launches '/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/scripts/backupMain.sh'	####
#### or /home/wayne/scriptsB/backupMain.#!/bin/#!/bin/#!/bin/backupMain.sh									####
################################################################################################################

cd /home/wayne
tmux kill-session -t backupTmux || \
tmux new-session -d -s backupTmux 'bash --init-file /home/wayne/scriptsB/backingUp/backupMain.sh'
