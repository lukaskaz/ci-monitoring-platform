#!/bin/bash

export DISPLAY=:0
WEBBROWSER="Firefox"
WEBSITENAME="GitBoard.io"
WEBSITEREGEX="$WEBSITENAME.*$WEBBROWSER"
ACTION="Ctrl+F5"

echo "Running: DISPLAY=$DISPLAY xdotool search --onlyvisible \
--name $WEBSITEREGEX windowactivate key $ACTION"

WINDOW=$(xdotool search --onlyvisible --name "$WEBSITEREGEX")
if [ -n "$WINDOW" ]; then
	xdotool windowactivate "$WINDOW"
	xdotool key "$ACTION"
	exit $?
fi

exit 1

