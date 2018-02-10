#!/bin/bash

# Script to speed up the revealing animation of the docker
# in osx 10.7 and above.

usage() {
	cat <<EOM
usage: sh $(basename $0) [--fast] [-f] [--reset] [-r]
	[--delay delay] [-d delay] [--speed speed] [-s speed] [-h] [--help]
EOM
	exit 0
}

# Sets the speed and delay of the dock
# $1 : delay
# $2 : speed
set_speed() {
	if [ -n $1 ]; then
		defaults write com.apple.dock autohide-delay -float "$1"
	fi
	if [ -n $2 ]; then
		defaults write com.apple.dock autohide-time-modifier -float "$2"
	fi
	killall Dock
}

if [ "$#" -eq 0 ]; then usage
fi

if [ "$1" = "--fast" ] || [ "$1" = "-f" ]; then
	defaults write com.apple.dock autohide-delay -int 0
	defaults write com.apple.dock autohide-time-modifier -float 0.6
	killall Dock
elif [ "$1" = "--reset" ] || [ "$1" = "-r" ]; then
	defaults delete com.apple.dock autohide-delay
	defaults delete com.apple.dock autohide-time-modifier
	killall Dock
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then usage
else
	current_parameter=""
	delay=""
	speed=""
	for var in "$@"; do
		if [ "$var" = "--delay" ] || [ "$var" = "-d" ]; then
			current_parameter="delay"
		elif [ "$var" = "--speed" ] || [ "$var" = "-s" ]; then
			current_parameter="speed"
		elif [ "$current_parameter" = "delay" ]; then
			delay=$var
		elif [ "$current_parameter" = "speed" ]; then
			speed=$var
		fi
	done

	set_speed "$delay" "$speed"
fi
