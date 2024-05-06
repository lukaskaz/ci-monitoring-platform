#!/bin/bash

export DISPLAY=:0
DESKTOPFILE=~/Desktop/gitboard.desktop
WEBBROWSER="Firefox"
WEBSITENAME="GitBoard.io"
WEBSITEREGEX="$WEBSITENAME.*$WEBBROWSER"
ACTION="Alt+F4"

echo "Running: DISPLAY=$DISPLAY xdotool search --onlyvisible \
--name $WEBSITEREGEX windowactivate key $ACTION"

WINDOW=$(xdotool search --onlyvisible --name "$WEBSITEREGEX")
if [ -n "$WINDOW" ]; then
	xdotool windowactivate "$WINDOW"
	xdotool key "$ACTION"
fi

echo "Running: DISPLAY=$DISPLAY gio launch $DESKTOPFILE"
gio launch $DESKTOPFILE

exit $?

